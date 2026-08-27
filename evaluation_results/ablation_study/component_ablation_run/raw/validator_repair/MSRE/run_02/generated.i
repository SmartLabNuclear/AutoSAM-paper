[GlobalParams]
  global_init_P = 100000.0                 # Pa (from PDF)
  global_init_V = 0.001                    # m/s (from PDF)
  global_init_T = 908.15                   # K (from PDF)
  scaling_factor_var = '1 1e-3 1e-6'       # ASSUMED: SAM typical
  gravity = '0 -9.8 0'                     # m/s^2 (from PDF; matches XY-plane layout)
  Tsolid_sf = 1e-3                         # ASSUMED: SAM typical
  p_order = 1                              # ASSUMED: SAM default/typical
[]

[Functions]
  # ASSUMED: constant-property functions to enable PTFunctionsEOS without inferring enthalpy.
  [fuel_cp]
    type = ConstantFunction
    value = 2009.66
  []
  [fuel_k]
    type = ConstantFunction
    value = 1.0
  []
  [fuel_rho]
    type = ParsedFunction
    expression = 2553.3 - 0.562*x          # x is temperature in SAM FunctionsEOS context
  []
  [fuel_mu]
    type = ParsedFunction
    expression = 8.4e-5*exp(2390/x)
  []

  [cool_cp]
    type = ConstantFunction
    value = 2390.0
  []
  [cool_k]
    type = ConstantFunction
    value = 1.1
  []
  [cool_rho]
    type = ParsedFunction
    expression = 2146.3 - 0.488*x
  []
  [cool_mu]
    type = ParsedFunction
    expression = 1.16e-4*exp(3755/x)
  []
[]

[EOS]
  [eos_fuel]
    type = PTFunctionsEOS
    rho = fuel_rho
    cp  = fuel_cp
    mu  = fuel_mu
    k   = fuel_k
    # Enthalpy not specified (optional); SAM will build internally
  []

  [eos_cool]
    type = PTFunctionsEOS
    rho = cool_rho
    cp  = cool_cp
    mu  = cool_mu
    k   = cool_k
  []
[]

[MaterialProperties]
  [hx_wall]
    type = HeatConductionMaterialProps
    k = 23.6                               # W/m-K (from PDF Table 3)
    Cp = 578                               # J/kg-K (from PDF Table 3)
    rho = 8860                             # kg/m^3 (from PDF Table 3)
  []
[]

[Components]
  # --- Primary loop components (fuel salt) ---
  [inlet_plenum]
    type = PBOneDFluidComponent
    eos = eos_fuel
    position = '-0.7366 0 0'               # from layout
    orientation = '1 0 0'                  # from layout
    length = 0.7366                        # m (from layout)
    A = 0.3932                             # m^2 (from XLSX: inlet plenum)
    Dh = 0.6997                            # m (from XLSX: inlet plenum)
    n_elems = 4                            # ASSUMED
  []

  [core]
    type = PBOneDFluidComponent
    eos = eos_fuel
    position = '0 0 0'
    orientation = '0 1 0'
    length = 1.7272
    A = 0.3512                             # m^2 (from XLSX)
    Dh = 0.6687                            # m (from XLSX)
    n_elems = 10                           # ASSUMED
  []

  [upper_plenum]
    type = PBOneDFluidComponent
    eos = eos_fuel
    position = '0 1.7272 0'
    orientation = '0 1 0'
    length = 0.4346
    A = 0.3932                             # m^2 (from XLSX: upper plenum)
    Dh = 0.6997                            # m (from XLSX: upper plenum)
    n_elems = 3                            # ASSUMED
  []

  [pipe1]
    type = PBOneDFluidComponent
    eos = eos_fuel
    position = '0 2.1618 0'
    orientation = '1 0 0'
    length = 1.8288
    A = 0.01267
    Dh = 0.127
    n_elems = 10                           # ASSUMED
  []

  [pipe2]
    type = PBOneDFluidComponent
    eos = eos_fuel
    position = '1.8288 2.1618 0'
    orientation = '0 1 0'
    length = 0.8128
    A = 0.01267
    Dh = 0.127
    n_elems = 6                            # ASSUMED
  []

  [pipe3]
    type = PBOneDFluidComponent
    eos = eos_fuel
    position = '1.8288 2.9746 0'
    orientation = '-1 0 0'
    length = 1.0668
    A = 0.01267
    Dh = 0.127
    n_elems = 6                            # ASSUMED
  []

  # Heat exchanger: primary side = shell (fuel), secondary side = tube (coolant)
  [HX]
    type = PBHeatExchanger
    eos = eos_fuel
    eos_secondary = eos_cool

    # Primary (shell) geometry from layout + XLSX
    position = '0.762 2.9746 0'
    orientation = '-1 0 0'
    length = 2.5298
    A = 0.10183                             # m^2 (XLSX: HX primary side)
    Dh = 0.020945                           # m (XLSX: HX primary side)

    # Secondary (tube) geometry
    position_secondary = '0.762 2.9746 0'   # ASSUMED: colocated with primary for 1-D representation
    orientation_secondary = '-1 0 0'        # ASSUMED: counter-current handled by initial_V_secondary sign below
    length_secondary = 2.5298               # ASSUMED: same as primary (not explicitly stated)
    A_secondary = 0.027885                  # m^2 (XLSX: HX secondary side)
    Dh_secondary = 0.010566                 # m (XLSX: HX secondary side)

    n_elems = 10                            # ASSUMED

    # Heat transfer geometry
    HT_surface_area_density = 1000          # 1/m (XLSX hx_wall)
    HT_surface_area_density_secondary = 1000  # 1/m (XLSX hx_wall)

    # Wall
    hs_type = cylinder                      # from XLSX: wall_geometry_type = Cylinder
    radius_i = 0.0052832                    # m (XLSX)
    wall_thickness = 0.0010668              # m (XLSX)
    Twall_init = 908.15                     # K (ASSUMED: use global init T)
    dim_wall = 1                            # ASSUMED
    n_wall_elems = 1                        # ASSUMED
    material_wall = hx_wall
  []

  [pipe4]
    type = PBOneDFluidComponent
    eos = eos_fuel
    position = '-1.7678 2.9746 0'
    orientation = '0 -1 0'
    length = 1.2474
    A = 0.01267
    Dh = 0.127
    n_elems = 8                             # ASSUMED
  []

  [pipe5]
    type = PBOneDFluidComponent
    eos = eos_fuel
    position = '-1.7678 1.7272 0'
    orientation = '1 0 0'
    length = 1.0312
    A = 0.01267
    Dh = 0.127
    n_elems = 6                             # ASSUMED
  []

  [downcomer]
    type = PBOneDFluidComponent
    eos = eos_fuel
    position = '-0.7366 1.7272 0'
    orientation = '0 -1 0'
    length = 1.7272
    A = 0.1589                              # m^2 (XLSX: deowncomer)
    Dh = 0.0508                             # m (XLSX: deowncomer)
    n_elems = 10                            # ASSUMED
  []

  [pipe_ref]
    type = PBOneDFluidComponent
    eos = eos_fuel
    position = '-1.7678 2.9746 0'
    orientation = '-1 0 0'
    length = 0.5
    A = 0.01267
    Dh = 0.127
    n_elems = 2                             # ASSUMED
  []

  # --- Junctions and pump (primary loop) ---
  [J_downcomer_to_inlet_plenum]
    type = PBSingleJunction
    eos = eos_fuel
    inputs = 'downcomer(out)'
    outputs = 'inlet_plenum(in)'
    Area = 0.1155                           # m^2 (XLSX branch area)
    K = 0                                   # ASSUMED (not provided)
  []

  [J_inlet_plenum_to_core]
    type = PBSingleJunction
    eos = eos_fuel
    inputs = 'inlet_plenum(out)'
    outputs = 'core(in)'
    Area = 0.1155
    K = 0                                   # ASSUMED
  []

  [J_core_to_upper_plenum]
    type = PBSingleJunction
    eos = eos_fuel
    inputs = 'core(out)'
    outputs = 'upper_plenum(in)'
    Area = 0.1155
    K = 0                                   # ASSUMED
  []

  [J_upper_plenum_to_pipe1]
    type = PBSingleJunction
    eos = eos_fuel
    inputs = 'upper_plenum(out)'
    outputs = 'pipe1(in)'
    Area = 0.1155
    K = 0                                   # ASSUMED
  []

  [J_pipe1_to_pipe2]
    type = PBSingleJunction
    eos = eos_fuel
    inputs = 'pipe1(out)'
    outputs = 'pipe2(in)'
    Area = 0.01292
    K = 0                                   # ASSUMED
  []

  [Pump]
    type = PBPump
    eos = eos_fuel
    inputs = 'pipe2(out)'
    outputs = 'pipe3(in)'
    Area = 0.01292                           # m^2 (XLSX: pipe2->pipe3 area marked pump)
    K = '0.15 0.1'                            # (XLSX)
    initial_P = 110000                        # Pa (XLSX)
    Head = 43909.58                           # Pa (XLSX)
  []

  [J_pipe3_to_HX]
    type = PBSingleJunction
    eos = eos_fuel
    inputs = 'pipe3(out)'
    outputs = 'HX(primary_in)'
    Area = 0.01267
    K = 0                                   # ASSUMED
  []

  # Tee at H: HX(primary_out) to pipe4 and pipe_ref
  [T_H]
    type = PBBranch
    eos = eos_fuel
    inputs = 'HX(primary_out)'
    outputs = 'pipe4(in) pipe_ref(in)'
    Area = 0.01267
    K = '0 0 0'                              # ASSUMED: 3 connections, losses not provided
  []

  [J_pipe4_to_pipe5]
    type = PBSingleJunction
    eos = eos_fuel
    inputs = 'pipe4(out)'
    outputs = 'pipe5(in)'
    Area = 0.01267
    K = 0                                   # ASSUMED
  []

  [J_pipe5_to_downcomer]
    type = PBSingleJunction
    eos = eos_fuel
    inputs = 'pipe5(out)'
    outputs = 'downcomer(in)'
    Area = 0.01267
    K = 0                                   # ASSUMED
  []

  # --- Boundary conditions ---
  # Primary reference pressure on pipe_ref outlet
  [ref_pressure]
    type = PBTDV
    input = 'pipe_ref(out)'
    eos = eos_fuel
    p_bc = 123335.1                          # Pa (PDF)
    T_bc = 908.15                            # K (PDF)
  []

  # Secondary side inlet/outlet (coolant loop external)
  [HX_secondary_in]
    type = PBTDJ
    input = 'HX(secondary_in)'
    eos = eos_cool
    v_bc = 1.6                               # m/s (PDF)
    T_bc = 824.8167                          # K (PDF)
  []

  [HX_secondary_out]
    type = PBTDV
    input = 'HX(secondary_out)'
    eos = eos_cool
    p_bc = 100000.0                          # Pa (PDF)
    T_bc = 866.4833                          # K (PDF) (only used if backflow)
  []
[]

[Postprocessors]
  [primary_mdot]
    type = ComponentBoundaryFlow
    input = core(in)
  []

  [HX_Tin_primary]
    type = ComponentBoundaryVariableValue
    input = HX(primary_in)
    variable = temperature
  []
  [HX_Tout_primary]
    type = ComponentBoundaryVariableValue
    input = HX(primary_out)
    variable = temperature
  []

  [HX_Tin_secondary]
    type = ComponentBoundaryVariableValue
    input = HX(secondary_in)
    variable = temperature
  []
  [HX_Tout_secondary]
    type = ComponentBoundaryVariableValue
    input = HX(secondary_out)
    variable = temperature
  []
[]

[Preconditioning]
  [SMP_PJFNK]
    type = SMP
    full = true
    solve_type = 'PJFNK'
    petsc_options_iname = '-pc_type -ksp_gmres_restart'
    petsc_options_value = 'lu 101'           # ASSUMED
  []
[]

[Executioner]
  type = Steady                              # ASSUMED: steady-state initialization
  nl_rel_tol = 1e-7                          # ASSUMED
  nl_abs_tol = 1e-6                          # ASSUMED
  nl_max_its = 30                            # ASSUMED
  l_tol = 1e-5                               # ASSUMED
  l_max_its = 100                            # ASSUMED
  [Quadrature]
    type = TRAP
    order = FIRST
  []
[]

[Outputs]
  print_linear_residuals = false             # ASSUMED
  perf_graph = true
  [console]
    type = Console
    execute_scalars_on = 'none'              # ASSUMED: reduce console clutter
  []
  [out_displaced]
    type = Exodus
    use_displaced = true
    execute_on = 'initial'
    sequence = false
  []
  [csv]
    type = CSV
  []
[]
