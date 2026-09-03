[GlobalParams]
  gravity = '0 -9.8 0'        # m/s^2
  initial_pressure = 100000.0  # Pa
  initial_temperature = 908.15 # K
  initial_velocity = 0.001     # m/s
  # Engineering assumption: single-phase, incompressible-like behavior handled by SAM EOS/fluids with provided property correlations.
[]

[Functions]
  # Fuel salt properties (Table 1)
  [./fuel_salt_rho]
    type = ParsedFunction
    expression = '2553.3 - 0.562*T'  # kg/m^3, valid 750-1200 K
  [../]
  [./fuel_salt_mu]
    type = ParsedFunction
    expression = '8.4e-5*exp(2390/T)' # Pa*s, valid 750-1200 K
  [../]

  # Coolant salt (LiF-BeF2 0.66-0.34) properties (Table 2)
  [./coolant_salt_rho]
    type = ParsedFunction
    expression = '2146.3 - 0.488*T'   # kg/m^3
  [../]
  [./coolant_salt_mu]
    type = ParsedFunction
    expression = '1.16e-4*exp(3755/T)' # Pa*s
  [../]
[]

[EOS]
  # NOTE: Exact SAM EOS class names/required parameters are application/version-dependent.
  # MISSING: exact EOS type(s) and required parameterization for molten salts.

  [./fuel_salt_eos]
    type = # MISSING: EOS type for fuel salt
    # MISSING: EOS parameters required by selected type
  [../]

  [./coolant_salt_eos]
    type = # MISSING: EOS type for coolant salt
    # MISSING: EOS parameters required by selected type
  [../]
[]

[MaterialProperties]
  # NOTE: Exact SAM material property blocks are version-dependent.
  # Provide correlations/values as auditable inputs; connect via names where supported.

  [./fuel_salt]
    type = # MISSING: MaterialProperties type for fluid with T-dependent rho/mu and constant k/cp
    eos = fuel_salt_eos
    rho_function = fuel_salt_rho
    mu_function  = fuel_salt_mu
    k = 1.0            # W/(m*K)
    cp = 2009.66       # J/(kg*K)
    # Engineering assumption: thermal conductivity and cp are constant per Table 1.
  [../]

  [./coolant_salt_hx]
    type = # MISSING: MaterialProperties type for fluid with T-dependent rho/mu and constant k/cp
    eos = coolant_salt_eos
    rho_function = coolant_salt_rho
    mu_function  = coolant_salt_mu
    k = 1.1            # W/(m*K)
    cp = 2390.0        # J/(kg*K)
    # Engineering assumption: thermal conductivity and cp are constant per Table 2.
  [../]

  [./hx_wall_alloy]
    type = # MISSING: MaterialProperties type for solid (Hastelloy N)
    rho = 8860         # kg/m^3
    k   = 23.6         # W/(m*K)
    cp  = 578          # J/(kg*K)
  [../]
[]

[Components]
  # -------------------------
  # PRIMARY LOOP (fuel salt)
  # Flow path per topology:
  # inlet_plenum -> core -> upper_plenum -> pipe1 -> pipe2 -> pump -> pipe3 -> HX -> (tee) -> pipe4 -> pipe5 -> downcomer -> inlet_plenum
  # plus a reference leg: HX -> pipe_ref -> ReferenceBoundary (pipe_ref BC)
  # -------------------------

  [./inlet_plenum]
    type = PBOneDFluidComponent
    fluid_property = fuel_salt
    eos = fuel_salt_eos
    A  = 0.3932
    Dh = 0.6997
    length = 0.7366
    orientation = '1 0 0'
    # MISSING: n_elems (or equivalent discretization control)
    # Engineering assumption: straight 1D segment between provided endpoints.
  [../]

  [./core]
    type = PBOneDFluidComponent
    fluid_property = fuel_salt
    eos = fuel_salt_eos
    A  = 0.3512
    Dh = 0.6687
    length = 1.7272
    orientation = '0 1 0'
    # MISSING: n_elems
    # Engineering assumption: no neutronic/volumetric power specified; core is treated as adiabatic hydraulic component in this deck.
    # MISSING: any heat source / power coupling if required for MSRE "case".
  [../]

  [./upper_plenum]
    type = PBOneDFluidComponent
    fluid_property = fuel_salt
    eos = fuel_salt_eos
    A  = 0.3932
    Dh = 0.6997
    length = 0.4346
    orientation = '0 1 0'
    # MISSING: n_elems
  [../]

  [./pipe1]
    type = PBOneDFluidComponent
    fluid_property = fuel_salt
    eos = fuel_salt_eos
    A  = 0.01267
    Dh = 0.127
    length = 1.8288
    orientation = '1 0 0'
    # MISSING: n_elems
  [../]

  [./pipe2]
    type = PBOneDFluidComponent
    fluid_property = fuel_salt
    eos = fuel_salt_eos
    A  = 0.01267
    Dh = 0.127
    length = 0.8128
    orientation = '0 1 0'
    # MISSING: n_elems
  [../]

  [./pump]
    type = PBPump
    fluid_property = fuel_salt
    eos = fuel_salt_eos
    # Pump specification from spreadsheet
    head = 43909.58          # Pa
    K = '0.15 0.1'
    initial_pressure = 110000.0 # Pa (internal)
    # MISSING: pump model options required by SAM (e.g., control, speed, head curve form)
    # Engineering assumption: constant head pump using provided head value.
  [../]

  [./pipe3]
    type = PBOneDFluidComponent
    fluid_property = fuel_salt
    eos = fuel_salt_eos
    A  = 0.01267
    Dh = 0.127
    length = 1.0668
    orientation = '-1 0 0'
    # MISSING: n_elems
  [../]

  # Heat exchanger (primary and secondary sides + wall)
  [./HX]
    type = PBHeatExchanger

    # Primary side geometry (spreadsheet "HX primary side")
    primary_fluid_property = fuel_salt
    primary_eos = fuel_salt_eos
    primary_A  = 0.10183
    primary_Dh = 0.020945
    primary_length = 2.5298
    primary_orientation = '-1 0 0'
    # MISSING: primary n_elems

    # Secondary side geometry (spreadsheet "HX secondary side")
    secondary_fluid_property = coolant_salt_hx
    secondary_eos = coolant_salt_eos
    secondary_A  = 0.027885
    secondary_Dh = 0.010566
    secondary_length = 2.5298
    secondary_orientation = '-1 0 0'
    # MISSING: secondary n_elems

    # Wall / heat structure (Hastelloy N)
    wall_material = hx_wall_alloy
    wall_geometry_type = Cylinder
    wall_thickness = 0.0010668   # m
    wall_radius_i  = 0.0052832   # m
    HT_surface_area_density = 1000 # 1/m
    # Engineering assumption: same axial length for both sides and wall equals 2.5298 m from layout.
    # MISSING: heat transfer correlations / friction correlations selection if required by SAM.
  [../]

  [./pipe4]
    type = PBOneDFluidComponent
    fluid_property = fuel_salt
    eos = fuel_salt_eos
    A  = 0.01267
    Dh = 0.127
    length = 1.2474
    orientation = '0 -1 0'
    # MISSING: n_elems
  [../]

  [./pipe5]
    type = PBOneDFluidComponent
    fluid_property = fuel_salt
    eos = fuel_salt_eos
    A  = 0.01267
    Dh = 0.127
    length = 1.0312
    orientation = '1 0 0'
    # MISSING: n_elems
  [../]

  [./downcomer]
    type = PBOneDFluidComponent
    fluid_property = fuel_salt
    eos = fuel_salt_eos
    A  = 0.1589
    Dh = 0.0508
    length = 1.7272
    orientation = '0 -1 0'
    # MISSING: n_elems
    # NOTE: Spreadsheet misspells as "deowncomer"; canonical component name preserved as "downcomer" per image/topology.
  [../]

  [./pipe_ref]
    type = PBOneDFluidComponent
    fluid_property = fuel_salt
    eos = fuel_salt_eos
    A  = 0.01267
    Dh = 0.127
    length = 0.5
    orientation = '-1 0 0'
    # MISSING: n_elems
    # Engineering assumption: pipe_ref is a short stub to a reference boundary at point I.
  [../]

  # -------------------------
  # JUNCTIONS / BRANCHES
  # Use areas given in spreadsheet branch table.
  # -------------------------

  [./downcomer_to_inlet_plenum]
    type = PBSingleJunction
    area = 0.1155
    from = downcomer:out
    to   = inlet_plenum:in
    # MISSING: junction loss coefficients if required
  [../]

  [./inlet_plenum_to_core]
    type = PBSingleJunction
    area = 0.1155
    from = inlet_plenum:out
    to   = core:in
  [../]

  [./core_to_upper_plenum]
    type = PBSingleJunction
    area = 0.1155
    from = core:out
    to   = upper_plenum:in
  [../]

  [./upper_plenum_to_pipe1]
    type = PBSingleJunction
    area = 0.1155
    from = upper_plenum:out
    to   = pipe1:in
  [../]

  [./pipe1_to_pipe2]
    type = PBSingleJunction
    area = 0.01292
    from = pipe1:out
    to   = pipe2:in
  [../]

  [./pipe2_to_pipe3]
    type = PBSingleJunction
    area = 0.01292  # (pump)
    from = pipe2:out
    to   = pump:in
  [../]

  [./pump_to_pipe3]
    type = PBSingleJunction
    # Engineering assumption: same flow area as pipe2_to_pipe3 branch since pump is in-line.
    area = 0.01292
    from = pump:out
    to   = pipe3:in
  [../]

  [./pipe3_to_HX_primary]
    type = PBSingleJunction
    area = 0.01267
    from = pipe3:out
    to   = HX:primary_in
  [../]

  # Tee at H: connects HX primary outlet to pipe4 and pipe_ref
  [./HX_primary_to_pipe_ref_and_pipe4]
    type = PBBranch
    area = 0.01267
    in = HX:primary_out
    out1 = pipe4:in
    out2 = pipe_ref:in
    # Engineering assumption: equal branch nominal area; no split fraction specified (determined by network / reference BC).
    # MISSING: branch loss coefficients and/or initial flow split if required
  [../]

  [./pipe4_to_pipe5]
    type = PBSingleJunction
    area = 0.01267
    from = pipe4:out
    to   = pipe5:in
  [../]

  [./pipe5_to_downcomer]
    type = PBSingleJunction
    area = 0.01267
    from = pipe5:out
    to   = downcomer:in
  [../]

  # -------------------------
  # BOUNDARY CONDITIONS
  # Ensure every open port is connected.
  # -------------------------

  [./pipe_ref_boundary]
    type = ReferenceBoundary
    input = pipe_ref:out
    pressure = 123335.1   # Pa
    temperature = 908.15  # K
    name = pipe_ref        # canonical BC name per facts
    # Engineering assumption: ReferenceBoundary fixes system reference pressure/temperature at pipe_ref outlet.
  [../]

  # Secondary loop inlet at HX secondary inlet
  [./hx_s_in]
    type = InletBoundary
    input = HX:secondary_in
    velocity = 1.6           # m/s
    temperature = 824.8167   # K
    # MISSING: inlet pressure (if required by InletBoundary type)
  [../]

  # Secondary loop outlet at HX secondary outlet
  [./hx_s_out]
    type = OutletBoundary
    input = HX:secondary_out
    pressure = 100000.0      # Pa
    temperature = 866.4833   # K
    # Engineering assumption: outlet temperature is prescribed as a boundary condition as provided.
    # MISSING: outlet boundary options required by SAM (e.g., whether temperature is used/ignored)
  [../]
[]

[Preconditioning]
  type = SMP
  # MISSING: preconditioning parameters appropriate for this case (petsc options, etc.)
[]

[Postprocessors]
  # MISSING: desired MSRE-specific outputs (core deltaP, HX heat rate, pump flow, etc.)
[]

[Executioner]
  type = Transient
  # MISSING: start_time, end_time, dt, solver settings
  # Engineering assumption: user will supply appropriate transient controls for the intended MSRE case scenario.
[]

[Outputs]
  console = true
  file_base = msre_case
  exodus = true
  csv = true
[]
