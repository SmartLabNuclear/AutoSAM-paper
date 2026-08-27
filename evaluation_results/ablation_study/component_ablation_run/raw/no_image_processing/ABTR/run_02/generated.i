[GlobalParams]
  gravity = '0 0 -9.81'
  initial_P = 100000.0
  initial_T = 628.15
  initial_V = 2.0
  solid_initial_T = 628.15
  # MISSING: fluid_eos (EOS selection for sodium)
[]

[Functions]
  # Placeholder for potential power scaling if total power becomes available
  # MISSING: total_core_power_W (needed to convert power fractions to W)
[]

[EOS]
  # MISSING: sam_eos_type (sodium EOS model selection)
  # MISSING: parameters (EOS parameterization if required)
  [coolant]
    # MISSING: type
    # MISSING: any required EOS parameters for sodium
  []
[]

[MaterialProperties]
  [fuel-mat]
    type = ConstantMaterial
    prop_names = 'k Cp rho'
    prop_values = '16.0 191.67 14583.0'
  []
  [gap-mat]
    type = ConstantMaterial
    prop_names = 'k Cp rho'
    prop_values = '64.0 1272.0 865.0'
  []
  [clad-mat]
    type = ConstantMaterial
    prop_names = 'k Cp rho'
    prop_values = '# MISSING: clad-mat.k_W_mK # MISSING: clad-mat.Cp_J_kgK # MISSING: clad-mat.rho_kg_m3'
  []
  [ss-mat]
    type = ConstantMaterial
    prop_names = 'k Cp rho'
    prop_values = '# MISSING: ss-mat.k_W_mK # MISSING: ss-mat.Cp_J_kgK # MISSING: ss-mat.rho_kg_m3'
  []
[]

[Components]

  # --- Boundary conditions (declared but not connected due to missing topology) ---
  [inlet]
    type = PBTDJ
    velocity = 3.25
    temperature = 628.15
    # MISSING: connection (which component/port?)
    # MISSING: mass_flow_kg_s (if required by intended BC specification)
  []

  [outlet]
    type = PBTDV
    pressure = 100000.0
    temperature = 628.15
    # MISSING: connection (which component/port?)
  []

  # --- Pipes ---
  [Pipe1]
    type = PBOneDFluidComponent
    eos = coolant
    A = 0.44934
    Dh = 0.002972
    # MISSING: length (or equivalent axial geometry)
    # MISSING: n_elems / axial discretization
    # MISSING: orientation/elevation change (if gravity head is modeled)
    # Ports (not connected):
    # - inlet  -> # MISSING: connection
    # - outlet -> # MISSING: connection
  []

  [Pipe2]
    type = PBOneDFluidComponent
    eos = coolant
    A = 0.44934
    Dh = 0.002972
    # MISSING: length (or equivalent axial geometry)
    # MISSING: n_elems / axial discretization
    # MISSING: orientation/elevation change (if gravity head is modeled)
    # Ports (not connected):
    # - inlet  -> # MISSING: connection
    # - outlet -> # MISSING: connection
  []

  # --- Core channels ---
  [CH1]
    type = PBCoreChannel
    eos = coolant
    A = 0.0049237
    Dh = 0.002972

    friction_factor = 0.022
    htc = 161290.0
    ht_area_density = 1107.8

    form_loss_branch_1 = 0.1
    form_loss_branch_2 = 0.0

    power_fraction = 0.02248
    # MISSING: total power (W) or absolute_power_W / axial power profile definition
    # MISSING: channel length / heated length / axial discretization / power shape vs z

    n_heatstruct = 3
    hs_names = 'fuel gap clad'
    hs_widths = '0.003015 0.000465 0.00052'
    hs_materials = 'fuel-mat gap-mat clad-mat'
    # MISSING: elem_number_of_hs (radial discretization per layer)
    # MISSING: axial coupling/segmentation to fluid mesh (if required)

    # Ports (not connected):
    # - inlet  -> # MISSING: connection
    # - outlet -> # MISSING: connection
  []

  [CH2]
    type = PBCoreChannel
    eos = coolant
    A = 0.11323
    Dh = 0.002972

    friction_factor = 0.022
    htc = 161290.0
    ht_area_density = 1107.8

    form_loss_branch_1 = 0.5
    form_loss_branch_2 = 0.0

    power_fraction = 0.41924
    # MISSING: total power (W) or absolute_power_W / axial power profile definition
    # MISSING: channel length / heated length / axial discretization / power shape vs z

    n_heatstruct = 3
    hs_names = 'fuel gap clad'
    hs_widths = '0.003015 0.000465 0.00052'
    hs_materials = 'fuel-mat gap-mat clad-mat'
    # MISSING: elem_number_of_hs (radial discretization per layer)
    # MISSING: axial coupling/segmentation to fluid mesh (if required)

    # Ports (not connected):
    # - inlet  -> # MISSING: connection
    # - outlet -> # MISSING: connection
  []

  [CH3]
    type = PBCoreChannel
    eos = coolant
    A = 0.029539
    Dh = 0.002972

    friction_factor = 0.022
    htc = 161290.0
    ht_area_density = 1107.8

    form_loss_branch_1 = 1.96
    form_loss_branch_2 = 0.0

    power_fraction = 0.09852
    # MISSING: total power (W) or absolute_power_W / axial power profile definition
    # MISSING: channel length / heated length / axial discretization / power shape vs z

    n_heatstruct = 3
    hs_names = 'fuel gap clad'
    hs_widths = '0.003015 0.000465 0.00052'
    hs_materials = 'fuel-mat gap-mat clad-mat'
    # MISSING: elem_number_of_hs (radial discretization per layer)
    # MISSING: axial coupling/segmentation to fluid mesh (if required)

    # Ports (not connected):
    # - inlet  -> # MISSING: connection
    # - outlet -> # MISSING: connection
  []

  [CH4]
    type = PBCoreChannel
    eos = coolant
    A = 0.14769
    Dh = 0.002972

    friction_factor = 0.022
    htc = 161290.0
    ht_area_density = 1107.8

    form_loss_branch_1 = 2.16
    form_loss_branch_2 = 0.0

    power_fraction = 0.43116
    # MISSING: total power (W) or absolute_power_W / axial power profile definition
    # MISSING: channel length / heated length / axial discretization / power shape vs z

    n_heatstruct = 3
    hs_names = 'fuel gap clad'
    hs_widths = '0.003015 0.000465 0.00052'
    hs_materials = 'fuel-mat gap-mat clad-mat'
    # MISSING: elem_number_of_hs (radial discretization per layer)
    # MISSING: axial coupling/segmentation to fluid mesh (if required)

    # Ports (not connected):
    # - inlet  -> # MISSING: connection
    # - outlet -> # MISSING: connection
  []

  [CH5]
    type = PBCoreChannel
    eos = coolant
    A = 0.153955129
    Dh = 0.002972

    friction_factor = 0.04
    htc = 13619.0
    ht_area_density = 2013.6

    form_loss_branch_1 = 4.5
    form_loss_branch_2 = 0.0

    power_fraction = 0.0286
    # MISSING: total power (W) or absolute_power_W / axial power profile definition
    # MISSING: channel length / heated length / axial discretization / power shape vs z

    n_heatstruct = 2
    hs_names = 'fuel clad'
    hs_widths = '0.0063234 0.0007026'
    hs_materials = 'fuel-mat clad-mat'
    # MISSING: elem_number_of_hs (radial discretization per layer)
    # MISSING: axial coupling/segmentation to fluid mesh (if required)

    # Ports (not connected):
    # - inlet  -> # MISSING: connection
    # - outlet -> # MISSING: connection
  []

  # Unmapped spreadsheet tail (NOT APPLIED)
  # - branch_1_form_losses = 3500.0
  # - branch_2_form_losses = 0.0
  # MISSING: component association for form_loss=3500.0

[]

[Preconditioning]
  # MISSING: case-appropriate preconditioning settings (not provided)
[]

[Postprocessors]
  # Minimal placeholders; actual variable names depend on SAM component implementation
  # MISSING: definitive postprocessor targets/variable names for SAM objects
[]

[Executioner]
  type = Transient
  scheme = bdf2

  dt = 1.0
  end_time = 10.0

  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-8
  nl_max_its = 50

  l_tol = 1e-8
  l_max_its = 200

  # MISSING: solver/preconditioner selections appropriate for final connected network
[]

[Outputs]
  exodus = true
  csv = true
  print_linear_residuals = false
[]
