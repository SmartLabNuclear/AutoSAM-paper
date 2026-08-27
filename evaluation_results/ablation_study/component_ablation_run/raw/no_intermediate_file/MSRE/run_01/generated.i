[GlobalParams]
  gravity = '0 -9.8 0'          # m/s^2 (pdf_extracted.initial_conditions.global.gravity)
  initial_P = 100000.0          # Pa (pdf_extracted.initial_conditions.global.pressure)
  initial_T = 908.15            # K  (pdf_extracted.initial_conditions.global.temperature)
  initial_v = 0.001             # m/s (pdf_extracted.initial_conditions.global.velocity)
[]

[Functions]
  # Fuel salt (primary) properties (Table 1)
  fuel_rho_fn]
    type = ParsedFunction
    expression = '2553.3 - 0.562*T'      # kg/m^3, valid 750-1200 K
  []
  fuel_mu_fn]
    type = ParsedFunction
    expression = '8.4e-5*exp(2390/T)'    # Pa*s, valid 750-1200 K
  []

  # Coolant salt (secondary) properties (Table 2): LiF-BeF2 (0.66-0.34)
  cool_rho_fn]
    type = ParsedFunction
    expression = '2146.3 - 0.488*T'      # kg/m^3
  []
  cool_mu_fn]
    type = ParsedFunction
    expression = '1.16e-4*exp(3755/T)'   # Pa*s
  []
[]

[EOS]
  # ASSUMPTION: Use SAM "SimpleFluidEOS" for incompressible liquids with user cp/k and rho(T), mu(T).
  # If your SAM build uses different EOS class names, replace accordingly.
  eos_fuel]
    type = SimpleFluidEOS
    rho = fuel_rho_fn
    mu = fuel_mu_fn
    cp = 2009.66             # J/(kg*K) (Table 1)
    k  = 1.0                 # W/(m*K)   (Table 1)
  []
  eos_coolant]
    type = SimpleFluidEOS
    rho = cool_rho_fn
    mu = cool_mu_fn
    cp = 2390.0              # J/(kg*K) (Table 2)
    k  = 1.1                 # W/(m*K)   (Table 2)
  []
[]

[MaterialProperties]
  # Heat exchanger wall alloy: Hastelloy N (Table 3)
  hx_wall_alloy]
    type = SolidMaterial
    rho = 8860               # kg/m^3
    cp  = 578                # J/(kg*K)
    k   = 23.6               # W/(m*K)
  []
[]

[Components]
  #-------------------------
  # Primary loop components
  #-------------------------

  inlet_plenum]
    type = PBOneDFluidComponent
    eos = eos_fuel
    A = 0.3932
    Dh = 0.6997
    length = 0.7366
    orientation = '1.0 0.0 0.0'
    position = '-0.7366 0.0 0.0'
    n_elems = 1   # ASSUMPTION: 1 axial element per component (no discretization guidance provided)
  []

  core]
    type = PBOneDFluidComponent
    eos = eos_fuel
    A = 0.3512
    Dh = 0.6687
    length = 1.7272
    orientation = '0.0 1.0 0.0'
    position = '0.0 0.0 0.0'
    n_elems = 1   # ASSUMPTION
  []

  upper_plenum]
    type = PBOneDFluidComponent
    eos = eos_fuel
    A = 0.3932
    Dh = 0.6997
    length = 0.4346
    orientation = '0.0 1.0 0.0'
    position = '0.0 1.7272 0.0'
    n_elems = 1   # ASSUMPTION
  []

  pipe1]
    type = PBOneDFluidComponent
    eos = eos_fuel
    A = 0.01267
    Dh = 0.127
    length = 1.8288
    orientation = '1.0 0.0 0.0'
    position = '0.0 2.1618 0.0'
    n_elems = 1   # ASSUMPTION
  []

  pipe2]
    type = PBOneDFluidComponent
    eos = eos_fuel
    A = 0.01267
    Dh = 0.127
    length = 0.8128
    orientation = '0.0 1.0 0.0'
    position = '1.8288 2.1618 0.0'
    n_elems = 1   # ASSUMPTION
  []

  pump]
    type = PBPump
    eos = eos_fuel
    head = 43909.58          # Pa (spreadsheet_extracted.pump.Head)
    K = '0.15 0.1'           # (spreadsheet_extracted.pump.K)
    initial_P = 110000.0     # Pa (pdf/spreadsheet)
    # Ports connected via junctions below
  []

  pipe3]
    type = PBOneDFluidComponent
    eos = eos_fuel
    A = 0.01267
    Dh = 0.127
    length = 1.0668
    orientation = '-1.0 0.0 0.0'
    position = '1.8288 2.9746 0.0'
    n_elems = 1   # ASSUMPTION
  []

  HX]
    type = PBHeatExchanger
    primary_eos = eos_fuel
    secondary_eos = eos_coolant

    # Primary side geometry (from spreadsheet "HX primary side")
    A_primary = 0.10183
    Dh_primary = 0.020945
    length_primary = 2.5298
    orientation_primary = '-1.0 0.0 0.0'
    position_primary = '0.762 2.9746 0.0'
    n_elems_primary = 1   # ASSUMPTION

    # Secondary side geometry (from spreadsheet "HX secondary side")
    A_secondary = 0.027885
    Dh_secondary = 0.010566
    length_secondary = 2.5298
    orientation_secondary = '-1.0 0.0 0.0'
    position_secondary = '0.762 2.9746 0.0'
    n_elems_secondary = 1   # ASSUMPTION

    # Heat transfer / wall model (spreadsheet_extracted.hx_wall.*)
    wall_material = hx_wall_alloy
    wall_geometry_type = Cylinder
    wall_thickness = 0.0010668
    wall_radius_i = 0.0052832
    HT_surface_area_density = 1000      # 1/m

    # Initial wall / tube temperature notes:
    # pdf_extracted.initial_conditions.secondary_side_initial_tube_temperature applies to hx_tube1/2/3,
    # but those components are not present in the supplied canonical component list.
    # ASSUMPTION: Apply secondary initial temperature to HX wall/secondary fluid via global initial_T
    # and boundary condition at hx_s_in.
  []

  pipe_ref]
    type = PBOneDFluidComponent
    eos = eos_fuel
    A = 0.01267
    Dh = 0.127
    length = 0.5
    orientation = '-1.0 0.0 0.0'
    position = '-1.7678 2.9746 0.0'
    n_elems = 1   # ASSUMPTION
  []

  pipe4]
    type = PBOneDFluidComponent
    eos = eos_fuel
    A = 0.01267
    Dh = 0.127
    length = 1.2474
    orientation = '0.0 -1.0 0.0'
    position = '-1.7678 2.9746 0.0'
    n_elems = 1   # ASSUMPTION
  []

  pipe5]
    type = PBOneDFluidComponent
    eos = eos_fuel
    A = 0.01267
    Dh = 0.127
    length = 1.0312
    orientation = '1.0 0.0 0.0'
    position = '-1.7678 1.7272 0.0'
    n_elems = 1   # ASSUMPTION
  []

  downcomer]
    type = PBOneDFluidComponent
    eos = eos_fuel
    A = 0.1589
    Dh = 0.0508
    length = 1.7272
    orientation = '0.0 -1.0 0.0'
    position = '-0.7366 1.7272 0.0'
    n_elems = 1   # ASSUMPTION
  []

  #-------------------------
  # Secondary loop boundaries (applied to HX secondary side)
  #-------------------------

  hx_s_in]
    type = VelocityTemperatureBoundary
    eos = eos_coolant
    velocity = 1.6            # m/s (pdf_extracted.boundary_conditions.secondary_loop_inlet.velocity)
    T = 824.8167              # K   (pdf_extracted.boundary_conditions.secondary_loop_inlet.temperature)
    # Connected to HX secondary inlet via junction below
  []

  hx_s_out]
    type = PressureTemperatureBoundary
    eos = eos_coolant
    P = 100000.0              # Pa (pdf_extracted.boundary_conditions.secondary_loop_outlet.pressure)
    T = 866.4833              # K  (pdf_extracted.boundary_conditions.secondary_loop_outlet.temperature)
    # Connected to HX secondary outlet via junction below
  []

  # Primary loop reference boundary (at end of pipe_ref)
  pipe_ref_bc]
    type = ReferenceBoundary
    eos = eos_fuel
    P = 123335.1              # Pa (pdf_extracted.boundary_conditions.primary_loop_reference.pressure)
    T = 908.15                # K  (pdf_extracted.boundary_conditions.primary_loop_reference.temperature)
  []

  #-------------------------
  # Junctions / connectivity
  #-------------------------

  downcomer_to_inlet_plenum]
    type = PBSingleJunction
    A = 0.1155
    in = downcomer:out
    out = inlet_plenum:in
  []

  inlet_plenum_to_core]
    type = PBSingleJunction
    A = 0.1155
    in = inlet_plenum:out
    out = core:in
  []

  core_to_upper_plenum]
    type = PBSingleJunction
    A = 0.1155
    in = core:out
    out = upper_plenum:in
  []

  upper_plenum_to_pipe1]
    type = PBSingleJunction
    A = 0.1155
    in = upper_plenum:out
    out = pipe1:in
  []

  pipe1_to_pipe2]
    type = PBSingleJunction
    A = 0.01292
    in = pipe1:out
    out = pipe2:in
  []

  pipe2_to_pump]
    type = PBSingleJunction
    A = 0.01292        # branch indicates "(pump)" at this connection
    in = pipe2:out
    out = pump:in
  []

  pump_to_pipe3]
    type = PBSingleJunction
    A = 0.01267
    in = pump:out
    out = pipe3:in
  []

  pipe3_to_HX_primary]
    type = PBSingleJunction
    A = 0.01267
    in = pipe3:out
    out = HX:primary_in
  []

  # Tee at H: connects HX primary outlet to pipe4 and pipe_ref
  HX_primary_to_pipe_ref_and_pipe4]
    type = PBBranch
    A = 0.01267
    in = HX:primary_out
    out1 = pipe_ref:in
    out2 = pipe4:in
    # ASSUMPTION: flow split determined by network solution; no specified split fractions provided.
  []

  pipe4_to_pipe5]
    type = PBSingleJunction
    A = 0.01267
    in = pipe4:out
    out = pipe5:in
  []

  pipe5_to_downcomer]
    type = PBSingleJunction
    A = 0.01267
    in = pipe5:out
    out = downcomer:in
  []

  # Reference boundary connection at end of pipe_ref
  pipe_ref_to_ref_bc]
    type = PBSingleJunction
    A = 0.01267
    in = pipe_ref:out
    out = pipe_ref_bc:in
  []

  # Secondary side boundary connections
  hx_s_in_to_HX_secondary]
    type = PBSingleJunction
    # MISSING: Area for secondary boundary-to-HX connection (not provided)
    # ASSUMPTION: Use HX secondary flow area as junction area.
    A = 0.027885
    in = hx_s_in:out
    out = HX:secondary_in
  []

  HX_secondary_to_hx_s_out]
    type = PBSingleJunction
    # MISSING: Area for secondary HX-to-boundary connection (not provided)
    # ASSUMPTION: Use HX secondary flow area as junction area.
    A = 0.027885
    in = HX:secondary_out
    out = hx_s_out:in
  []
[]

[Preconditioning]
  # ASSUMPTION: default preconditioning
  active = true
[]

[Postprocessors]
  # Primary loop monitoring
  primary_inlet_plenum_T_in]
    type = SAMComponentBoundaryValue
    component = inlet_plenum
    boundary = in
    variable = T
  []
  primary_core_T_out]
    type = SAMComponentBoundaryValue
    component = core
    boundary = out
    variable = T
  []
  primary_HX_primary_T_in]
    type = SAMComponentBoundaryValue
    component = HX
    boundary = primary_in
    variable = T
  []
  primary_HX_primary_T_out]
    type = SAMComponentBoundaryValue
    component = HX
    boundary = primary_out
    variable = T
  []
  primary_ref_pressure]
    type = SAMComponentBoundaryValue
    component = pipe_ref_bc
    boundary = in
    variable = P
  []

  # Secondary loop monitoring
  secondary_inlet_T]
    type = SAMComponentBoundaryValue
    component = hx_s_in
    boundary = out
    variable = T
  []
  secondary_outlet_T]
    type = SAMComponentBoundaryValue
    component = hx_s_out
    boundary = in
    variable = T
  []
[]

[Executioner]
  type = Transient
  # MISSING: end_time
  # MISSING: dt
  # ASSUMPTION: Use conservative defaults if user supplies; otherwise deck requires these fields.
  end_time = # MISSING: end_time
  dt = # MISSING: dt
  solve_type = NEWTON
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-10
  l_tol = 1e-6
  l_max_its = 200
[]

[Outputs]
  file_base = MSRE_case
  exodus = false
  csv = true
  print_linear_residuals = false
[]
