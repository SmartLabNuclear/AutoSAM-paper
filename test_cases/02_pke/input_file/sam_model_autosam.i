
# SAM Input File: Point Kinetics Regression Test
# Description: Single core channel with point kinetics, transient inlet temperature, and outlet pressure BC.
# Quantities measured: Core coolant/fuel/clad temperatures, reactivity feedback, power, and outlet conditions.

[GlobalParams]
  global_init_P = 1.0e5                       # Pa, initial pressure
  global_init_V = 5.0                         # m/s, initial velocity
  global_init_T = 628.15                      # K, initial temperature
  scaling_factor_var = '1 1e-3 1e-6'          # Scaling factors for (p, v, T)
  Tsolid_sf = 1e-3                            # Scaling for solid temperature
  gravity = '0 0 -9.8'                        # Gravity vector
[]

[EOS]
  [eos]
    type = PTConstantEOS
    p_0 = 1.0e5
    rho_0 = 865.51
    beta = 2.7524e-4
    cp = 1272.0
    h_0 = 7.9898e5
    T_0 = 628.15
    mu = 2.6216e-4
    k = 72
  []
[]

[MaterialProperties]
  [fuel-mat]
    type = SolidMaterialProps
    k = 16.0
    Cp = 191.67
    rho = 14583.0
    alpha = 1.76e-5
    YoungsM = 2.8e10
  []
  [clad-mat]
    type = SolidMaterialProps
    k = 26.0
    Cp = 638.0
    rho = 7646.0
    alpha = 1.4e-5
    YoungsM = 1.5e11
  []
[]

[Functions]
  [Tin_transient]
    type = PiecewiseLinear
    x = '0 10'
    y = '628.15 728.15'
  []
  [uniform]
    type = PiecewiseLinear
    x = '0 0.8'
    y = '1 1'
    axis = x
  []
[]

[Components]
  [reactor]
    type = ReactorPower
    initial_power = 0
  []
  [CH1]
    type = PBCoreChannel
    eos = eos
    position = '0 0 0'
    orientation = '0 0 1'
    A = 2e-5
    Dh = 0.0031830989
    length = 0.8
    n_elems = 20
    f = 0.017
    Hw = 1.6e5
    HT_surface_area_density = 1256.637
    name_of_hs = 'fuel clad'
    Ts_init = 628.15
    n_heatstruct = 2
    fuel_type = cylinder
    width_of_hs = '0.00348 0.00052'
    elem_number_of_hs = '5 1'
    material_hs = 'fuel-mat clad-mat'
    power_fraction = '1.0 0.0'
    power_shape_function = uniform
    pke_material_type = 'FuelDoppler None'
    n_layers_doppler = 20
    fuel_doppler_coef = -1e-7
  []
  [inlet]
    type = PBTDJ
    input = 'CH1(in)'
    v_bc = 8.6654
    T_fn = Tin_transient
    eos = eos
  []
  [outlet]
    type = PBTDV
    input = 'CH1(out)'
    p_bc = 2.0e5
    T_bc = 728.15
    eos = eos
  []
  [pke]
    type = PointKinetics
    LAMBDA = 3.46402e-7
    lambda = '0.013345 2.8738'
    betai = '0.00023929 0.0004921'
  []
[]

[Postprocessors]
  [pke_comp_equal]
    type = PostprocessorComparison
    comparison_type = equals
    value_a = 'Total_Reactivity_Feedback'
    value_b = ${drho}
    absolute_tolerance = 1e-12
    execute_on = FINAL
    execution_order_group = 3
  []
[]

[Preconditioning]
  [SMP_PJFNK]
    type = SMP
    full = true
    solve_type = 'PJFNK'
    petsc_options_iname = '-pc_type'
    petsc_options_value = 'lu'
  []
[]

[Executioner]
  type = Transient
  dt = 0.5
  dtmin = 1e-5
  start_time = 0.0
  end_time = 20.0
  nl_rel_tol = 1e-7
  nl_abs_tol = 1e-6
  nl_max_its = 20
  l_tol = 1e-4
  l_max_its = 100
  [Quadrature]
    type = TRAP
    order = FIRST
  []
[]

[Outputs]
  perf_graph = true
  [console]
    type = Console
  []
  [out_displaced]
    type = Exodus
    use_displaced = true
    execute_on = 'initial timestep_end'
    sequence = false
  []
  [csv]
    type = CSV
  []
[]
