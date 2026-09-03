[GlobalParams]
  gravity = '0 -9.8 0'                       # m/s^2 (pdf_extracted.initial_conditions.global.gravity)
  initial_pressure = 100000.0                # Pa (pdf_extracted.initial_conditions.global.pressure)
  initial_temperature = 908.15               # K (pdf_extracted.initial_conditions.global.temperature)
  initial_velocity = 0.001                   # m/s (pdf_extracted.initial_conditions.global.velocity)

  # Engineering assumption: single-phase, incompressible/weakly-compressible liquid treatment via SAM PB models.
  # Engineering assumption: no noncondensable gas, no void, no two-phase physics.
  # Engineering assumption: friction/HT correlations left as SAM defaults unless explicitly provided.
[]

[Functions]
  # Fuel salt properties (Table 1)
  [./fuel_salt_rho]
    type = ParsedFunction
    expression = '2553.3 - 0.562*T'          # kg/m^3 ; valid 750-1200 K
  [../]
  [./fuel_salt_mu]
    type = ParsedFunction
    expression = '8.4e-5*exp(2390/T)'        # Pa*s ; valid 750-1200 K
  [../]

  # Coolant salt (HX secondary) properties (Table 2) for LiF-BeF2 0.66-0.34
  [./coolant_salt_rho]
    type = ParsedFunction
    expression = '2146.3 - 0.488*T'          # kg/m^3
  [../]
  [./coolant_salt_mu]
    type = ParsedFunction
    expression = '1.16e-4*exp(3755/T)'       # Pa*s
  [../]
[]

[EOS]
  # Engineering assumption: Use SAM liquid EOS interface with user-defined property functions.
  # MISSING: exact SAM EOS class name for function-based liquid properties in this installation.
  #
  # Placeholder blocks kept auditable; update `type` if your SAM build uses a different name.
  [./fuel_salt_eos]
    type = # MISSING: EOS type supporting rho(T), mu(T), cp, k for liquid salt
    density_function = fuel_salt_rho
    viscosity_function = fuel_salt_mu
    specific_heat = 2009.66                  # J/(kg*K) (Table 1)
    thermal_conductivity = 1.0               # W/(m*K) (Table 1)
    # Engineering assumption: cp and k constant over the operating range.
  [../]

  [./coolant_salt_eos]
    type = # MISSING: EOS type supporting rho(T), mu(T), cp, k for liquid salt
    density_function = coolant_salt_rho
    viscosity_function = coolant_salt_mu
    specific_heat = 2390.0                   # J/(kg*K) (Table 2)
    thermal_conductivity = 1.1               # W/(m*K) (Table 2)
    # Engineering assumption: cp and k constant over the operating range.
  [../]
[]

[MaterialProperties]
  # Heat exchanger wall alloy: Hastelloy N (Table 3)
  [./hx_wall_alloy]
    type = SolidMaterialProperties
    density = 8860                           # kg/m^3
    specific_heat = 578                      # J/(kg*K)
    thermal_conductivity = 23.6              # W/(m*K)
  [../]
[]

[Components]
  # -------------------------
  # PRIMARY LOOP (fuel salt)
  # -------------------------

  [./inlet_plenum]
    type = PBOneDFluidComponent
    eos = fuel_salt_eos
    A = 0.3932
    Dh = 0.6997
    length = 0.7366
    orientation = '1 0 0'
    # Connections via junctions:
    inlet = j_downcomer_to_inlet_plenum:out
    outlet = j_inlet_plenum_to_core:in
  [../]

  [./core]
    type = PBOneDFluidComponent
    eos = fuel_salt_eos
    A = 0.3512
    Dh = 0.6687
    length = 1.7272
    orientation = '0 1 0'
    inlet = j_inlet_plenum_to_core:out
    outlet = j_core_to_upper_plenum:in
    # Engineering assumption: no explicit power/heat source provided for core in supplied facts.
    # MISSING: core power / heat deposition model (if needed for this case)
  [../]

  [./upper_plenum]
    type = PBOneDFluidComponent
    eos = fuel_salt_eos
    A = 0.3932
    Dh = 0.6997
    length = 0.4346
    orientation = '0 1 0'
    inlet = j_core_to_upper_plenum:out
    outlet = j_upper_plenum_to_pipe1:in
  [../]

  [./pipe1]
    type = PBOneDFluidComponent
    eos = fuel_salt_eos
    A = 0.01267
    Dh = 0.127
    length = 1.8288
    orientation = '1 0 0'
    inlet = j_upper_plenum_to_pipe1:out
    outlet = j_pipe1_to_pipe2:in
  [../]

  [./pipe2]
    type = PBOneDFluidComponent
    eos = fuel_salt_eos
    A = 0.01267
    Dh = 0.127
    length = 0.8128
    orientation = '0 1 0'
    inlet = j_pipe1_to_pipe2:out
    outlet = j_pipe2_to_pump:in
  [../]

  [./pump]
    type = PBPump
    eos = fuel_salt_eos
    inlet = j_pipe2_to_pump:out
    outlet = j_pump_to_pipe3:in
    head = 43909.58                          # Pa (spreadsheet_extracted.pump.Head)
    K = '0.15 0.1'                           # (spreadsheet_extracted.pump.K)
    initial_pressure = 110000.0              # Pa (pdf/spreadsheet initial)
    # Engineering assumption: pump is steady head source; speed/transient control not provided.
    # MISSING: pump characteristic curve / speed control parameters (if required by this PBPump model)
  [../]

  [./pipe3]
    type = PBOneDFluidComponent
    eos = fuel_salt_eos
    A = 0.01267
    Dh = 0.127
    length = 1.0668
    orientation = '-1 0 0'
    inlet = j_pump_to_pipe3:out
    outlet = j_pipe3_to_HX_primary:in
  [../]

  [./HX]
    type = PBHeatExchanger
    # Engineering assumption: HX component includes primary and secondary 1-D channels plus wall heat structure.
    # MISSING: exact SAM PBHeatExchanger parameter names for primary/secondary geometry and wall specification.
    #
    # Primary side geometry (spreadsheet_extracted.components.HX primary side.*)
    primary_eos = fuel_salt_eos
    primary_A = 0.10183
    primary_Dh = 0.020945
    primary_length = 2.5298
    primary_orientation = '-1 0 0'

    # Secondary side geometry (spreadsheet_extracted.components.HX secondary side.*)
    secondary_eos = coolant_salt_eos
    secondary_A = 0.027885
    secondary_Dh = 0.010566
    secondary_length = 2.5298
    secondary_orientation = '-1 0 0'

    # Wall/heat structure (spreadsheet_extracted.hx_wall.* and Table 3 alloy props)
    wall_material = hx_wall_alloy
    wall_geometry_type = Cylinder
    wall_thickness = 0.0010668               # m
    wall_radius_i = 0.0052832                # m
    HT_surface_area_density = 1000           # 1/m

    # Primary ports
    primary_inlet = j_pipe3_to_HX_primary:out
    primary_outlet = j_HX_primary_to_tee_H:in

    # Secondary ports (external BCs)
    secondary_inlet = hx_s_in:out
    secondary_outlet = hx_s_out:in

    # Initial condition override on secondary tubes (pdf_extracted.initial_conditions.secondary_side_initial_tube_temperature)
    # MISSING: exact SAM parameter to set initial tube/wall temperature for HX; provided value:
    #   T_init_tube = 824.8167 K for hx_tube1, hx_tube2, hx_tube3
  [../]

  [./pipe_ref]
    type = PBOneDFluidComponent
    eos = fuel_salt_eos
    A = 0.01267
    Dh = 0.127
    length = 0.5
    orientation = '-1 0 0'
    inlet = tee_H:branch2
    outlet = pipe_ref_bc:in
  [../]

  [./pipe4]
    type = PBOneDFluidComponent
    eos = fuel_salt_eos
    A = 0.01267
    Dh = 0.127
    length = 1.2474
    orientation = '0 -1 0'
    inlet = tee_H:branch1
    outlet = j_pipe4_to_pipe5:in
  [../]

  [./pipe5]
    type = PBOneDFluidComponent
    eos = fuel_salt_eos
    A = 0.01267
    Dh = 0.127
    length = 1.0312
    orientation = '1 0 0'
    inlet = j_pipe4_to_pipe5:out
    outlet = j_pipe5_to_downcomer:in
  [../]

  [./downcomer]
    type = PBOneDFluidComponent
    eos = fuel_salt_eos
    A = 0.1589
    Dh = 0.0508
    length = 1.7272
    orientation = '0 -1 0'
    inlet = j_pipe5_to_downcomer:out
    outlet = j_downcomer_to_inlet_plenum:in
  [../]

  # -------------------------
  # JUNCTIONS / BRANCHES
  # -------------------------

  [./j_downcomer_to_inlet_plenum]
    type = PBSingleJunction
    A = 0.1155
    inlet = downcomer:outlet
    outlet = inlet_plenum:inlet
  [../]

  [./j_inlet_plenum_to_core]
    type = PBSingleJunction
    A = 0.1155
    inlet = inlet_plenum:outlet
    outlet = core:inlet
  [../]

  [./j_core_to_upper_plenum]
    type = PBSingleJunction
    A = 0.1155
    inlet = core:outlet
    outlet = upper_plenum:inlet
  [../]

  [./j_upper_plenum_to_pipe1]
    type = PBSingleJunction
    A = 0.1155
    inlet = upper_plenum:outlet
    outlet = pipe1:inlet
  [../]

  [./j_pipe1_to_pipe2]
    type = PBSingleJunction
    A = 0.01292
    inlet = pipe1:outlet
    outlet = pipe2:inlet
  [../]

  [./j_pipe2_to_pump]
    type = PBSingleJunction
    A = 0.01292                              # (pump branch area)
    inlet = pipe2:outlet
    outlet = pump:inlet
  [../]

  [./j_pump_to_pipe3]
    type = PBSingleJunction
    A = 0.01267
    inlet = pump:outlet
    outlet = pipe3:inlet
  [../]

  [./j_pipe3_to_HX_primary]
    type = PBSingleJunction
    A = 0.01267
    inlet = pipe3:outlet
    outlet = HX:primary_inlet
  [../]

  [./j_HX_primary_to_tee_H]
    type = PBSingleJunction
    A = 0.01267
    inlet = HX:primary_outlet
    outlet = tee_H:in
  [../]

  [./tee_H]
    type = PBBranch
    A = 0.01267
    # Tee at point H connects: from HX primary outlet to pipe4 and pipe_ref (image/topology note).
    inlet = j_HX_primary_to_tee_H:out
    branch1 = pipe4:inlet
    branch2 = pipe_ref:inlet
    # Engineering assumption: flow split determined by network solution; no explicit loss coefficients provided.
    # MISSING: tee loss coefficients (if required)
  [../]

  [./j_pipe4_to_pipe5]
    type = PBSingleJunction
    A = 0.01267
    inlet = pipe4:outlet
    outlet = pipe5:inlet
  [../]

  [./j_pipe5_to_downcomer]
    type = PBSingleJunction
    A = 0.01267
    inlet = pipe5:outlet
    outlet = downcomer:inlet
  [../]

  # -------------------------
  # BOUNDARY CONDITIONS
  # -------------------------

  # Primary loop reference boundary attached to pipe_ref (pdf_extracted.boundary_conditions.primary_loop_reference)
  [./pipe_ref_bc]
    type = ReferenceBoundary
    pressure = 123335.1                      # Pa
    temperature = 908.15                     # K
    inlet = pipe_ref:outlet
  [../]

  # Secondary loop inlet/outlet for HX secondary side
  [./hx_s_in]
    type = InletBoundary
    eos = coolant_salt_eos
    velocity = 1.6                           # m/s
    temperature = 824.8167                   # K
    outlet = HX:secondary_inlet
  [../]

  [./hx_s_out]
    type = OutletBoundary
    eos = coolant_salt_eos
    pressure = 100000.0                      # Pa
    temperature = 866.4833                   # K (given as BC fact; engineering assumption: used as initial/outlet target if model needs)
    inlet = HX:secondary_outlet
    # Engineering assumption: If OutletBoundary ignores temperature, this value is treated as an initial guess only.
  [../]

[]

[Preconditioning]
  # Engineering assumption: use default PB solver preconditioning when unspecified.
  [./pb_prec]
    type = SMPPreconditioner
    # MISSING: specific options required for this SAM version (left default)
  [../]
[]

[Postprocessors]
  # Basic monitoring (auditable; does not require intermediate files)
  [./pp_time]
    type = TimePostprocessor
  [../]

  # MISSING: component variable names for pressure/temperature/flow in this SAM build.
  # Add component-specific postprocessors once variable nomenclature is confirmed.
[]

[Executioner]
  type = Transient
  scheme = bdf2

  # Engineering assumption: simulate to steady state; no explicit end time given in facts.
  # MISSING: end_time (set as placeholder)
  end_time = # MISSING: end_time
  dt = # MISSING: dt
  dtmin = # MISSING: dtmin
  dtmax = # MISSING: dtmax

  solve_type = NEWTON
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-10
  l_tol = 1e-6
  l_max_its = 200
  nl_max_its = 50
[]

[Outputs]
  file_base = MSRE_case
  exodus = true
  csv = true
  console = true

  # Condition: no_intermediate_file
  checkpoint = false
[]
