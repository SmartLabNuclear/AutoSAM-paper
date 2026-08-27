[GlobalParams]
  coolant = sodium
  gravity = '0 0 -9.81'
  initial_P = 100000.0
  initial_T = 628.15
  initial_v = 2.0
  solid_initial_T = 628.15
[]

[Functions]
  # None provided
[]

[EOS]
  [coolant]
    # MISSING: sam_eos_type (explicit SAM EOS model/type for sodium not provided)
    # MISSING: parameters (EOS parameter set, if required, not provided)
  []
[]

[MaterialProperties]
  [fuel-mat]
    type = SolidMaterialProperties
    k = 16.0
    cp = 191.67
    rho = 14583.0
  []
  [gap-mat]
    type = SolidMaterialProperties
    k = 64.0
    cp = 1272.0
    rho = 865.0
  []
  [clad-mat]
    type = SolidMaterialProperties
    # MISSING: k (W/m-K)
    # MISSING: cp (J/kg-K)
    # MISSING: rho (kg/m^3)
  []
  [ss-mat]
    type = SolidMaterialProperties
    # MISSING: k (W/m-K)
    # MISSING: cp (J/kg-K)
    # MISSING: rho (kg/m^3)
  []
[]

[Components]
  [Pipe1]
    type = PBPipe
    eos = coolant
    A = 0.44934
    Dh = 0.002972
    # MISSING: length
    # MISSING: n_elems (axial discretization)
    # MISSING: orientation/elevation (if required)
    # MISSING: connectivity (inlet/outlet attachments not provided)
  []

  [Pipe2]
    type = PBPipe
    eos = coolant
    A = 0.44934
    Dh = 0.002972
    # MISSING: length
    # MISSING: n_elems (axial discretization)
    # MISSING: orientation/elevation (if required)
    # MISSING: connectivity (inlet/outlet attachments not provided)
  []

  [CH1]
    type = PBCoreChannel
    eos = coolant
    A = 0.0049237
    Dh = 0.002972
    f = 0.022
    htc = 161290.0
    heat_transfer_area_density = 1107.8
    power_fraction = 0.02248
    form_loss = 0.1
    form_loss_2 = 0.0
    # MISSING: length
    # MISSING: n_elems (axial discretization)
    # MISSING: total_power (or equivalent power input specification)
    # MISSING: axial power shape/profile (if required)
    # MISSING: connectivity (inlet/outlet attachments not provided)

    n_heatstruct = 3
    hs_names = 'fuel gap clad'
    hs_materials = 'fuel-mat gap-mat clad-mat'
    hs_widths = '0.003015 0.000465 0.00052'
    hs_initial_T = 628.15
    # MISSING: elem_number_of_hs (required discretization for each HS layer)
  []

  [CH2]
    type = PBCoreChannel
    eos = coolant
    A = 0.11323
    Dh = 0.002972
    f = 0.022
    htc = 161290.0
    heat_transfer_area_density = 1107.8
    power_fraction = 0.41924
    form_loss = 0.5
    form_loss_2 = 0.0
    # MISSING: length
    # MISSING: n_elems (axial discretization)
    # MISSING: total_power (or equivalent power input specification)
    # MISSING: axial power shape/profile (if required)
    # MISSING: connectivity (inlet/outlet attachments not provided)

    n_heatstruct = 3
    hs_names = 'fuel gap clad'
    hs_materials = 'fuel-mat gap-mat clad-mat'
    hs_widths = '0.003015 0.000465 0.00052'
    hs_initial_T = 628.15
    # MISSING: elem_number_of_hs (required discretization for each HS layer)
  []

  [CH3]
    type = PBCoreChannel
    eos = coolant
    A = 0.029539
    Dh = 0.002972
    f = 0.022
    htc = 161290.0
    heat_transfer_area_density = 1107.8
    power_fraction = 0.09852
    form_loss = 1.96
    form_loss_2 = 0.0
    # MISSING: length
    # MISSING: n_elems (axial discretization)
    # MISSING: total_power (or equivalent power input specification)
    # MISSING: axial power shape/profile (if required)
    # MISSING: connectivity (inlet/outlet attachments not provided)

    n_heatstruct = 3
    hs_names = 'fuel gap clad'
    hs_materials = 'fuel-mat gap-mat clad-mat'
    hs_widths = '0.003015 0.000465 0.00052'
    hs_initial_T = 628.15
    # MISSING: elem_number_of_hs (required discretization for each HS layer)
  []

  [CH4]
    type = PBCoreChannel
    eos = coolant
    A = 0.14769
    Dh = 0.002972
    f = 0.022
    htc = 161290.0
    heat_transfer_area_density = 1107.8
    power_fraction = 0.43116
    form_loss = 2.16
    form_loss_2 = 0.0
    # MISSING: length
    # MISSING: n_elems (axial discretization)
    # MISSING: total_power (or equivalent power input specification)
    # MISSING: axial power shape/profile (if required)
    # MISSING: connectivity (inlet/outlet attachments not provided)

    n_heatstruct = 3
    hs_names = 'fuel gap clad'
    hs_materials = 'fuel-mat gap-mat clad-mat'
    hs_widths = '0.003015 0.000465 0.00052'
    hs_initial_T = 628.15
    # MISSING: elem_number_of_hs (required discretization for each HS layer)
  []

  [CH5]
    type = PBCoreChannel
    eos = coolant
    A = 0.153955129
    Dh = 0.002972
    f = 0.04
    htc = 13619.0
    heat_transfer_area_density = 2013.6
    power_fraction = 0.0286
    form_loss = 4.5
    form_loss_2 = 0.0
    # MISSING: length
    # MISSING: n_elems (axial discretization)
    # MISSING: total_power (or equivalent power input specification)
    # MISSING: axial power shape/profile (if required)
    # MISSING: connectivity (inlet/outlet attachments not provided)

    n_heatstruct = 2
    hs_names = 'fuel clad'
    hs_materials = 'fuel-mat clad-mat'
    hs_widths = '0.0063234 0.0007026'
    hs_initial_T = 628.15
    # MISSING: elem_number_of_hs (required discretization for each HS layer)
  []

  [inlet]
    type = PBTDJ
    eos = coolant
    T = 628.15
    v = 3.25
    # MISSING: mdot (mass_flow_kg_s not provided; may be required by PBTDJ depending on SAM definition)
    # MISSING: connectivity (boundary attachment not provided)
  []

  [outlet]
    type = PBTDV
    eos = coolant
    P = 100000.0
    T = 628.15
    # MISSING: connectivity (boundary attachment not provided)
  []
[]

[Preconditioning]
  # Default / not specified
[]

[Postprocessors]
  # None provided
[]

[Executioner]
  type = Transient
  solve_type = 'PJFNK'
  dt = 1e-3
  end_time = 1.0
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-10
  l_max_its = 50
  nl_max_its = 30
  # MISSING: case-specific time stepping / end time controls not provided
[]

[Outputs]
  exodus = false
  csv = true
  print_linear_residuals = false
  perf_graph = false
[]
