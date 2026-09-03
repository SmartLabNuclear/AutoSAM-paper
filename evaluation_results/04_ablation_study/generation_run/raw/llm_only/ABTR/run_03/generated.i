[GlobalParams]
  global_init_p = 1.0e5
  global_init_v = 2.0
  global_init_t = 628.15
  gravity = '0 0 -9.8'
[]

[eos]
  [eos]
    type = PBSodiumEquationOfState
  []
[]

[MaterialProperties]
  [fuel-mat]
    type = SolidMaterialProps
    k = 16.0
    cp = 191.67
    rho = 1.4583e4
  []
  [gap-mat]
    type = SolidMaterialProps
    k = 64.0
    cp = 1272.0
    rho = 865.0
  []
  [clad-mat]
    type = SolidMaterialProps
    k = 26.0
    cp = 638.0
    rho = 7.646e3
  []
[]

[Components]
  [reactor]
    type = ReactorPower
    # Engineering assumption: ReactorPower couples to the core channels via their specified power_fraction;
    # no explicit port connections are defined for this component in the provided facts.
  []

  [pipe2]
    type = PBOneDFluidComponent
    eos = eos
    position = '0 0 2.3'
    orientation = '0 0 -1'
    length = 1.5
    n_elems = 4
    a = 0.44934
    dh = 2.972e-3
    f = 0.02
  []

  [ch1]
    type = PBCoreChannel
    eos = eos
    position = '0 -1 0.8'
    orientation = '0 0 -1'
    length = 0.8
    n_elems = 4
    a = 4.9237e-3
    dh = 2.972e-3
    f = 0.022
    ht_surface_area_density = 1107.8
    n_heatstruct = 3
    width_of_hs = '0.003015 0.000465 0.00052'
    elem_number_of_hs = '2 1 1'
    material_hs = 'fuel-mat gap-mat clad-mat'
    power_fraction = '0.02248 0.0 0.0'
  []

  [ch2]
    type = PBCoreChannel
    eos = eos
    position = '0 -0.5 0.8'
    orientation = '0 0 -1'
    length = 0.8
    n_elems = 4
    a = 0.11323
    dh = 2.972e-3
    f = 0.022
    ht_surface_area_density = 1107.8
    n_heatstruct = 3
    width_of_hs = '0.003015 0.000465 0.00052'
    elem_number_of_hs = '2 1 1'
    material_hs = 'fuel-mat gap-mat clad-mat'
    power_fraction = '0.41924 0.0 0.0'
  []

  [ch3]
    type = PBCoreChannel
    eos = eos
    position = '0 0 0.8'
    orientation = '0 0 -1'
    length = 0.8
    n_elems = 4
    a = 0.029539
    dh = 2.972e-3
    f = 0.022
    ht_surface_area_density = 1107.8
    n_heatstruct = 3
    width_of_hs = '0.003015 0.000465 0.00052'
    elem_number_of_hs = '2 1 1'
    material_hs = 'fuel-mat gap-mat clad-mat'
    power_fraction = '0.09852 0.0 0.0'
  []

  [ch4]
    type = PBCoreChannel
    eos = eos
    position = '0 0.5 0.8'
    orientation = '0 0 -1'
    length = 0.8
    n_elems = 4
    a = 0.14769
    dh = 2.972e-3
    f = 0.022
    ht_surface_area_density = 1107.8
    n_heatstruct = 3
    width_of_hs = '0.003015 0.000465 0.00052'
    elem_number_of_hs = '2 1 1'
    material_hs = 'fuel-mat gap-mat clad-mat'
    power_fraction = '0.43116 0.0 0.0'
  []

  [ch5]
    type = PBCoreChannel
    eos = eos
    position = '0 1 0.8'
    orientation = '0 0 -1'
    length = 0.8
    n_elems = 4
    a = 0.153955129
    dh = 2.972e-3
    f = 0.04
    ht_surface_area_density = 2013.6
    n_heatstruct = 2
    width_of_hs = '0.0063234 0.0007026'
    elem_number_of_hs = '2 1'
    material_hs = 'fuel-mat clad-mat'
    power_fraction = '0.0286 0.0'
  []

  [pipe1]
    type = PBOneDFluidComponent
    eos = eos
    position = '0 0 0'
    orientation = '0 0 -1'
    length = 0.6
    n_elems = 2
    a = 0.44934
    dh = 2.972e-3
    f = 0.02
  []

  [branch2]
    type = PBBranch
    eos = eos
    inputs = 'pipe2(out)'
    outputs = 'ch1(in) ch2(in) ch3(in) ch4(in) ch5(in)'
    area = 0.44934
    k = '0 0 0 0 0 0'
  []

  [branch1]
    type = PBBranch
    eos = eos
    inputs = 'ch1(out) ch2(out) ch3(out) ch4(out) ch5(out)'
    outputs = 'pipe1(in)'
    area = 0.44934
    k = '0.1 0.5 1.96 2.16 4.5 3500'
  []

  [inlet]
    type = PBTDJ
    input = 'pipe2(in)'
    eos = eos
    v_bc = 3.25
    t_bc = 628.15
  []

  [outlet]
    type = PBTDV
    input = 'pipe1(out)'
    eos = eos
    p_bc = 1.0e5
    t_bc = 628.15
  []
[]

[Executioner]
  type = Steady

  [quadrature]
    type = TRAP
  []
[]
