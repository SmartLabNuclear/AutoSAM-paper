[GlobalParams]
  global_init_P = 1.0e5
  global_init_V = 2.0
  global_init_T = 628.15
  gravity = '0 0 -9.8'
  scaling_factor_var = '1 1e-3 1e-6'
  Tsolid_sf = 1e-3
[]

[EOS]
  [eos]
    type = PBSodiumEquationOfState
  []
[]

[Functions]
  # Uniform axial power shape on x in [0, 0.8]
  [uniform_axial]
    type = PiecewiseLinear
    axis = x
    x = '0 0.8'
    y = '1 1'
  []
[]

[MaterialProperties]
  [fuel-mat]
    type = SolidMaterialProps
    k = 16.0
    Cp = 191.67
    rho = 1.4583e4
  []

  [gap-mat]
    type = SolidMaterialProps
    k = 64.0
    Cp = 1272.0
    rho = 865.0
  []

  # User-provided cladding material properties
  [clad-mat]
    type = SolidMaterialProps
    k = 26.0
    Cp = 638.0
    rho = 7.646e3
  []
[]

[Components]
  # Needed for PBCoreChannel power input
  [reactor]
    type = ReactorPower
    initial_power = 1.0  # W  (ASSUMPTION A5)
  []

  # Upstream pipe from inlet BC to Branch2
  [Pipe2]
    type = PBOneDFluidComponent
    eos = eos
    position = '0 0 2.3'
    orientation = '0 0 -1'
    length = 1.5
    n_elems = 4
    A = 0.44934
    Dh = 2.972e-3
    f = 0.02  # (ASSUMPTION A7)
  []

  # Five parallel heated core channels between Branch2 (top) and Branch1 (bottom)
  [CH1]
    type = PBCoreChannel
    eos = eos
    position = '0 -1 0.8'
    orientation = '0 0 -1'
    length = 0.8
    n_elems = 4
    A = 4.9237e-3
    Dh = 2.972e-3
    f = 0.022
    Hw = 1.6129e5
    HTC_geometry_type = Pipe
    HT_surface_area_density = 1107.8

    Ts_init = 628.15
    dim_hs = 2
    n_heatstruct = 3
    name_of_hs = 'fuel gap clad'
    fuel_type = cylinder
    width_of_hs = '0.003015 0.000465 0.00052'
    elem_number_of_hs = '2 1 1'  # (ASSUMPTION A4)
    material_hs = 'fuel-mat gap-mat clad-mat'
    power_fraction = '0.02248 0.0 0.0'
    power_shape_function = uniform_axial
  []

  [CH2]
    type = PBCoreChannel
    eos = eos
    position = '0 -0.5 0.8'
    orientation = '0 0 -1'
    length = 0.8
    n_elems = 4
    A = 0.11323
    Dh = 2.972e-3
    f = 0.022
    Hw = 1.6129e5
    HTC_geometry_type = Pipe
    HT_surface_area_density = 1107.8

    Ts_init = 628.15
    dim_hs = 2
    n_heatstruct = 3
    name_of_hs = 'fuel gap clad'
    fuel_type = cylinder
    width_of_hs = '0.003015 0.000465 0.00052'
    elem_number_of_hs = '2 1 1'  # (ASSUMPTION A4)
    material_hs = 'fuel-mat gap-mat clad-mat'
    power_fraction = '0.41924 0.0 0.0'
    power_shape_function = uniform_axial
  []

  [CH3]
    type = PBCoreChannel
    eos = eos
    position = '0 0 0.8'
    orientation = '0 0 -1'
    length = 0.8
    n_elems = 4
    A = 0.029539
    Dh = 2.972e-3
    f = 0.022
    Hw = 1.6129e5
    HTC_geometry_type = Pipe
    HT_surface_area_density = 1107.8

    Ts_init = 628.15
    dim_hs = 2
    n_heatstruct = 3
    name_of_hs = 'fuel gap clad'
    fuel_type = cylinder
    width_of_hs = '0.003015 0.000465 0.00052'
    elem_number_of_hs = '2 1 1'  # (ASSUMPTION A4)
    material_hs = 'fuel-mat gap-mat clad-mat'
    power_fraction = '0.09852 0.0 0.0'
    power_shape_function = uniform_axial
  []

  [CH4]
    type = PBCoreChannel
    eos = eos
    position = '0 0.5 0.8'
    orientation = '0 0 -1'
    length = 0.8
    n_elems = 4
    A = 0.14769
    Dh = 2.972e-3
    f = 0.022
    Hw = 1.6129e5
    HTC_geometry_type = Pipe
    HT_surface_area_density = 1107.8

    Ts_init = 628.15
    dim_hs = 2
    n_heatstruct = 3
    name_of_hs = 'fuel gap clad'
    fuel_type = cylinder
    width_of_hs = '0.003015 0.000465 0.00052'
    elem_number_of_hs = '2 1 1'  # (ASSUMPTION A4)
    material_hs = 'fuel-mat gap-mat clad-mat'
    power_fraction = '0.43116 0.0 0.0'
    power_shape_function = uniform_axial
  []

  [CH5]
    type = PBCoreChannel
    eos = eos
    position = '0 1 0.8'
    orientation = '0 0 -1'
    length = 0.8
    n_elems = 4
    A = 0.153955129
    Dh = 2.972e-3
    f = 0.04
    Hw = 13619.0
    HTC_geometry_type = Pipe
    HT_surface_area_density = 2013.6

    Ts_init = 628.15
    dim_hs = 2
    n_heatstruct = 2
    name_of_hs = 'fuel clad'
    fuel_type = cylinder
    width_of_hs = '0.0063234 0.0007026'
    elem_number_of_hs = '2 1'  # (ASSUMPTION A4)
    material_hs = 'fuel-mat clad-mat'
    power_fraction = '0.0286 0.0'
    power_shape_function = uniform_axial
  []

  # Downstream pipe from Branch1 to outlet BC
  [Pipe1]
    type = PBOneDFluidComponent
    eos = eos
    position = '0 0 0'
    orientation = '0 0 -1'
    length = 0.6
    n_elems = 2
    A = 0.44934
    Dh = 2.972e-3
    f = 0.02  # (ASSUMPTION A7)
  []

  # Junctions
  [Branch2]
    type = PBBranch
    eos = eos
    inputs  = 'Pipe2(out)'
    outputs = 'CH1(in) CH2(in) CH3(in) CH4(in) CH5(in)'
    Area = 0.44934  # (ASSUMPTION A6)
    # Branch 2 form losses from model_specifications.xlsx: all zeros (6 connections)
    K = '0 0 0 0 0 0'
  []

  [Branch1]
    type = PBBranch
    eos = eos
    inputs  = 'CH1(out) CH2(out) CH3(out) CH4(out) CH5(out)'
    outputs = 'Pipe1(in)'
    Area = 0.44934  # (ASSUMPTION A6)
    # Branch 1 form losses from model_specifications.xlsx (6 connections)
    K = '0.1 0.5 1.96 2.16 4.5 3500'
  []

  # Boundary conditions
  [inlet]
    type = PBTDJ
    input = 'Pipe2(in)'
    eos = eos
    v_bc = 3.25
    T_bc = 628.15
  []

  [outlet]
    type = PBTDV
    input = 'Pipe1(out)'
    eos = eos
    p_bc = 1.0e5
    T_bc = 628.15
  []
[]

[Preconditioning]
  active = 'SMP_PJFNK'
  [SMP_PJFNK]
    type = SMP
    full = true
    solve_type = 'PJFNK'
    petsc_options_iname = '-pc_type -ksp_gmres_restart'
    petsc_options_value = 'lu 100'
  []
[]

[Executioner]
  type = Steady
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-7
  nl_max_its = 30

  l_tol = 1e-5
  l_max_its = 200

  [Quadrature]
    type = TRAP
    order = FIRST
  []
[]

[Outputs]
  perf_graph = true
  print_linear_residuals = false
  csv = true
  [console]
    type = Console
    execute_scalars_on = 'none'
  []
  [out_displaced]
    type = Exodus
    use_displaced = true
    execute_on = 'initial'
    sequence = false
  []
[]
