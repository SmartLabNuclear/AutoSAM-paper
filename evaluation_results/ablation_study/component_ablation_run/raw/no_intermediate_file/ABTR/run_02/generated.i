[GlobalParams]
  # Coordinate system plane YZ with x=0; SAM uses gravity vector in global coordinates.
  gravity = '0 0 0'  # assumption due to missing gravity
  initial_P = 100000.0
  initial_T = 628.15
  initial_V = 2.0
[]

[Functions]
  # Placeholder for power history if needed
  [./core_power_multiplier]
    type = ConstantFunction
    value = 1.0
  [../]
[]

[EOS]
  [./coolant]
    # sodium coolant
    type = SodiumProperties
  [../]
[]

[MaterialProperties]
  [./fuel-mat]
    type = SolidMaterialProperties
    k = 16.0
    cp = 191.67
    rho = 14583.0
  [../]

  [./gap-mat]
    type = SolidMaterialProperties
    k = 64.0
    cp = 1272.0
    rho = 865.0
  [../]

  [./clad-mat]
    type = SolidMaterialProperties
    # MISSING: k (W/m-K)
    # MISSING: cp (J/kg-K)
    # MISSING: rho (kg/m^3)
  [../]

  [./ss-mat]
    type = SolidMaterialProperties
    # MISSING: k (W/m-K)
    # MISSING: cp (J/kg-K)
    # MISSING: rho (kg/m^3)
  [../]
[]

[Components]

  #-------------------------
  # Boundary conditions
  #-------------------------
  [./inlet]
    type = PBTDJ
    input = Pipe2:in
    velocity = 3.25
    temperature = 628.15
    # MISSING: pressure or mass_flow (inlet.mass_flow_kg_s is None; no inlet pressure provided)
  [../]

  [./outlet]
    type = PBTDV
    input = Pipe1:out
    pressure = 100000.0
    temperature = 628.15
  [../]

  #-------------------------
  # Loop piping
  #-------------------------
  [./Pipe2]
    type = PBPipe
    eos = coolant
    A = 0.44934
    Dh = 0.002972
    length = 1.5
    position = '0.0 0.0 2.3'
    orientation = '0.0 0.0 -1.0'
    # MISSING: n_elems
  [../]

  [./Pipe1]
    type = PBPipe
    eos = coolant
    A = 0.44934
    Dh = 0.002972
    length = 0.6
    position = '0.0 0.0 0.0'
    orientation = '0.0 0.0 -1.0'
    # MISSING: n_elems
  [../]

  #-------------------------
  # Branch junctions
  #-------------------------
  [./Branch2]
    type = PBBranch
    inputs = 'Pipe2:out'
    outputs = 'CH1:in CH2:in CH3:in CH4:in CH5:in'
    # MISSING: Area
    # MISSING: K
    # Spreadsheet: Branch 2 form losses column is 0 for all => K likely 0, but not explicitly given for the junction itself.
  [../]

  [./Branch1]
    type = PBBranch
    inputs = 'CH1:out CH2:out CH3:out CH4:out CH5:out'
    outputs = 'Pipe1:in'
    # MISSING: Area
    # MISSING: K
    # Spreadsheet Branch 1 form losses are per-channel; junction K/Area still required if the component needs them.
  [../]

  #-------------------------
  # Core channels with heat structures
  #-------------------------
  [./CH1]
    type = PBCoreChannel
    eos = coolant
    A = 0.0049237
    Dh = 0.002972
    length = 0.8
    position = '0.0 -1.0 0.8'
    orientation = '0.0 0.0 -1.0'
    f = 0.022
    htc = 161290.0
    h_area_density = 1107.8
    form_loss_in = 0.1
    form_loss_out = 0.0

    n_heatstruct = 3
    heatstruct_names = 'fuel gap clad'
    heatstruct_widths = '0.003015 0.000465 0.00052'
    heatstruct_materials = 'fuel-mat gap-mat clad-mat'
    # MISSING: heat_structure element counts / discretization (elem_number_of_hs)
    # MISSING: fluid n_elems
    # Power coupling:
    # MISSING: total_core_power_W
    power_fraction = 0.02248
    power_multiplier = core_power_multiplier
  [../]

  [./CH2]
    type = PBCoreChannel
    eos = coolant
    A = 0.11323
    Dh = 0.002972
    length = 0.8
    position = '0.0 -0.5 0.8'
    orientation = '0.0 0.0 -1.0'
    f = 0.022
    htc = 161290.0
    h_area_density = 1107.8
    form_loss_in = 0.5
    form_loss_out = 0.0

    n_heatstruct = 3
    heatstruct_names = 'fuel gap clad'
    heatstruct_widths = '0.003015 0.000465 0.00052'
    heatstruct_materials = 'fuel-mat gap-mat clad-mat'
    # MISSING: heat_structure element counts / discretization
    # MISSING: fluid n_elems
    # MISSING: total_core_power_W
    power_fraction = 0.41924
    power_multiplier = core_power_multiplier
  [../]

  [./CH3]
    type = PBCoreChannel
    eos = coolant
    A = 0.029539
    Dh = 0.002972
    length = 0.8
    position = '0.0 0.0 0.8'
    orientation = '0.0 0.0 -1.0'
    f = 0.022
    htc = 161290.0
    h_area_density = 1107.8
    form_loss_in = 1.96
    form_loss_out = 0.0

    n_heatstruct = 3
    heatstruct_names = 'fuel gap clad'
    heatstruct_widths = '0.003015 0.000465 0.00052'
    heatstruct_materials = 'fuel-mat gap-mat clad-mat'
    # MISSING: heat_structure element counts / discretization
    # MISSING: fluid n_elems
    # MISSING: total_core_power_W
    power_fraction = 0.09852
    power_multiplier = core_power_multiplier
  [../]

  [./CH4]
    type = PBCoreChannel
    eos = coolant
    A = 0.14769
    Dh = 0.002972
    length = 0.8
    position = '0.0 0.5 0.8'
    orientation = '0.0 0.0 -1.0'
    f = 0.022
    htc = 161290.0
    h_area_density = 1107.8
    form_loss_in = 2.16
    form_loss_out = 0.0

    n_heatstruct = 3
    heatstruct_names = 'fuel gap clad'
    heatstruct_widths = '0.003015 0.000465 0.00052'
    heatstruct_materials = 'fuel-mat gap-mat clad-mat'
    # MISSING: heat_structure element counts / discretization
    # MISSING: fluid n_elems
    # MISSING: total_core_power_W
    power_fraction = 0.43116
    power_multiplier = core_power_multiplier
  [../]

  [./CH5]
    type = PBCoreChannel
    eos = coolant
    A = 0.153955129
    Dh = 0.002972
    length = 0.8
    position = '0.0 1.0 0.8'
    orientation = '0.0 0.0 -1.0'
    f = 0.04
    htc = 13619.0
    h_area_density = 2013.6
    form_loss_in = 4.5
    form_loss_out = 0.0

    n_heatstruct = 2
    heatstruct_names = 'fuel clad'
    heatstruct_widths = '0.0063234 0.0007026'
    heatstruct_materials = 'fuel-mat clad-mat'
    # MISSING: heat_structure element counts / discretization
    # MISSING: fluid n_elems
    # MISSING: total_core_power_W
    power_fraction = 0.0286
    power_multiplier = core_power_multiplier
  [../]

[]

[Preconditioning]
  active = 'SMP'
  [./SMP]
    type = SMP
    full = true
  [../]
[]

[Postprocessors]
  [./inlet_T]
    type = SAMComponentOutletTemperature
    component = inlet
  [../]
  [./outlet_T]
    type = SAMComponentInletTemperature
    component = outlet
  [../]
  [./outlet_P]
    type = SAMComponentInletPressure
    component = outlet
  [../]
[]

[Executioner]
  type = Transient
  scheme = 'bdf2'

  dt = 1e-3
  end_time = 1.0
  solve_type = 'NEWTON'

  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-10
  nl_max_its = 30

  l_tol = 1e-8
  l_max_its = 200
[]

[Outputs]
  console = true
  file_base = 'abtr_no_intermediate_file'
  exodus = true
  csv = true
[]
