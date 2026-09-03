[GlobalParams]
  # MISSING: SAM-specific global fluid property / eos specification field name
  # fluid = sodium
[]

[Variables]
  # MISSING: If SAM requires explicit variable blocks for T, p, u, etc.
[]

[Functions]
  # Piecewise time step control described in documentation
  [./dt_piecewise]
    type = PiecewiseLinear
    x = '0    0.1   0.2   2.0   1e9'
    y = '0.01 0.01  0.1   1.0   1.0'
  [../]
[]

[Materials]
  # Solid materials as provided
  [./fuel-mat]
    type = SolidMaterial
    # Engineering assumption: SAM material model keyword 'SolidMaterial' and property names below may differ.
    # MISSING: exact SAM material class for constant properties
    k = 16.0
    cp = 191.67
    rho = 1.4583e4
  [../]
  [./gap-mat]
    type = SolidMaterial
    k = 64.0
    cp = 1272.0
    rho = 865.0
  [../]
  [./clad-mat]
    type = SolidMaterial
    k = 26.0
    cp = 638.0
    rho = 7.646e3
  [../]
  [./duct-mat]
    type = SolidMaterial
    k = 26.0
    cp = 638.0
    rho = 7.646e3
  [../]
[]

[Components]

  # -------------------------
  # Boundary conditions (TDV)
  # -------------------------

  [./inlet_tdv]
    type = TDV
    # Enforcing velocity and temperature at pipe1 entrance
    velocity = 3.25       # m/s
    temperature = 628.15  # K
    # MISSING: TDV requires pressure? or type of boundary (inlet/outlet) selector
  [../]

  [./outlet_tdv]
    type = TDV
    pressure = 1.0e5      # Pa
    temperature = 628.15  # K
    # MISSING: TDV requires velocity? or type of boundary (inlet/outlet) selector
  [../]

  # -------------------------
  # Pipes (plenums)
  # -------------------------

  [./pipe1]
    type = Pipe
    A = 0.44934
    Dh = 2.972e-3
    length = 0.6
    n_elems = 20   # Engineering assumption: not provided for pipes; using same axial resolution as channels
    orientation = '0 0 1'  # +z
    # Initial conditions (global stated)
    p_initial = 1.0e5
    u_initial = 2.0
    T_initial = 628.15
    # Connections
    inlet = inlet_tdv
    outlet = branch1:main
    # MISSING: SAM-specific port naming (e.g., inlet/outlet) and TDV hookup syntax
  [../]

  [./pipe2]
    type = Pipe
    A = 0.44934
    Dh = 2.972e-3
    length = 1.5
    n_elems = 20   # Engineering assumption
    orientation = '0 0 1'  # +z
    p_initial = 1.0e5
    u_initial = 2.0
    T_initial = 628.15
    inlet = branch2:main
    outlet = outlet_tdv
    # MISSING: SAM-specific port naming and TDV hookup syntax
  [../]

  # -------------------------
  # Branching junctions
  # -------------------------

  [./branch1]
    type = Branch
    A = 0.44934
    # Form-loss coefficients: main + 5 legs (CH1-CH5) + extra value 3500.0 per doc/spreadsheet
    # Documentation: "K = 0.1, 0.5, 1.96, 2.16, 4.5, and 3500.0, corresponding respectively
    # to the main pipe passage and the five channel inlets (CH1–CH5)."
    # This implies 6 numbers; however list includes 6 where first is main then 5 legs:
    # main=0.1, CH1=0.5, CH2=1.96, CH3=2.16, CH4=4.5, CH5=3500.0 (mapping by order).
    # Engineering assumption: Use the order [main, leg1..leg5] mapped to CH1..CH5 as above.
    K = '0.1  0.5  1.96  2.16  4.5  3500.0'
    # Ports
    main = pipe1:outlet
    leg1 = CH1:inlet
    leg2 = CH2:inlet
    leg3 = CH3:inlet
    leg4 = CH4:inlet
    leg5 = CH5:inlet
    # MISSING: SAM-specific branch port field names
  [../]

  [./branch2]
    type = Branch
    A = 0.44934
    # All K=0 at outlets
    K = '0 0 0 0 0 0'
    main = pipe2:inlet
    leg1 = CH1:outlet
    leg2 = CH2:outlet
    leg3 = CH3:outlet
    leg4 = CH4:outlet
    leg5 = CH5:outlet
    # MISSING: SAM-specific branch port field names
  [../]

  # -------------------------
  # Core channels (5 parallel)
  # -------------------------

  [./CH1]
    type = Channel
    A = 4.9237e-3
    Dh = 2.972e-3
    length = 0.8
    n_elems = 20
    orientation = '0 0 1'
    friction_factor = 0.022
    htc = 161290.0
    ht_area_density = 1107.8
    p_initial = 1.0e5
    u_initial = 2.0
    T_initial = 628.15
    inlet = branch1:leg1
    outlet = branch2:leg1

    # Heat structure coupling
    # Engineering assumption: power provided as volumetric/linear via area density; SAM-specific coupling may differ.
    nhs = 3
    hs_widths = '0.003015 0.000465 0.00052'
    hs_materials = 'fuel-mat gap-mat clad-mat'
    hs_T_initial = 628.15
    hs_axial_elems = 20
    hs_radial_elems = '5 1 1'
    power_fraction = 0.02248
  [../]

  [./CH2]
    type = Channel
    A = 0.11323
    Dh = 2.972e-3
    length = 0.8
    n_elems = 20
    orientation = '0 0 1'
    friction_factor = 0.022
    htc = 161290.0
    ht_area_density = 1107.8
    p_initial = 1.0e5
    u_initial = 2.0
    T_initial = 628.15
    inlet = branch1:leg2
    outlet = branch2:leg2

    nhs = 3
    hs_widths = '0.003015 0.000465 0.00052'
    hs_materials = 'fuel-mat gap-mat clad-mat'
    hs_T_initial = 628.15
    hs_axial_elems = 20
    hs_radial_elems = '5 1 1'
    power_fraction = 0.41924
  [../]

  [./CH3]
    type = Channel
    A = 0.029539
    Dh = 2.972e-3
    length = 0.8
    n_elems = 20
    orientation = '0 0 1'
    friction_factor = 0.022
    htc = 161290.0
    ht_area_density = 1107.8
    p_initial = 1.0e5
    u_initial = 2.0
    T_initial = 628.15
    inlet = branch1:leg3
    outlet = branch2:leg3

    nhs = 3
    hs_widths = '0.003015 0.000465 0.00052'
    hs_materials = 'fuel-mat gap-mat clad-mat'
    hs_T_initial = 628.15
    hs_axial_elems = 20
    hs_radial_elems = '5 1 1'
    power_fraction = 0.09852
  [../]

  [./CH4]
    type = Channel
    A = 0.14769
    Dh = 2.972e-3
    length = 0.8
    n_elems = 20
    orientation = '0 0 1'
    friction_factor = 0.022
    htc = 161290.0
    ht_area_density = 1107.8
    p_initial = 1.0e5
    u_initial = 2.0
    T_initial = 628.15
    inlet = branch1:leg4
    outlet = branch2:leg4

    nhs = 3
    hs_widths = '0.003015 0.000465 0.00052'
    hs_materials = 'fuel-mat gap-mat clad-mat'
    hs_T_initial = 628.15
    hs_axial_elems = 20
    hs_radial_elems = '5 1 1'
    power_fraction = 0.43116
  [../]

  [./CH5]
    type = Channel
    A = 0.153955129
    Dh = 2.972e-3
    length = 0.8
    n_elems = 20
    orientation = '0 0 1'
    friction_factor = 0.04
    htc = 13619.0
    ht_area_density = 2113.6   # from PDF Table 2; spreadsheet shows 2013.6 -> using PDF value
    p_initial = 1.0e5
    u_initial = 2.0
    T_initial = 628.15
    inlet = branch1:leg5
    outlet = branch2:leg5

    nhs = 2
    hs_widths = '6.32340e-3 7.0260e-4'
    hs_materials = 'fuel-mat clad-mat'
    hs_T_initial = 628.15
    hs_axial_elems = 20
    hs_radial_elems = '5 1'
    power_fraction = 0.02860
  [../]

  # -------------------------
  # Core power specification
  # -------------------------

  [./core_power]
    type = HeatSource
    # MISSING: SAM-specific heat source component and how to distribute to channels/HS
    # Engineering assumption: apply total power scaled by channel power_fraction.
    core_total_power = 1.0   # W (normalized). Replace with actual core power.
    targets = 'CH1 CH2 CH3 CH4 CH5'
    fractions = '0.02248 0.41924 0.09852 0.43116 0.02860'
  [../]

[]

[Executioner]
  type = Transient
  # Only five time steps executed (per doc)
  num_steps = 5
  dt = 0.1
  dtmin = 1e-5
  dtmax = 1.0
  # Use piecewise function as a timestepper
  [./TimeStepper]
    type = FunctionDT
    function = dt_piecewise
  [../]

  # Nonlinear/linear solver settings
  # MISSING: exact SAM solver block requirements; scaling factors given below.
[]

[Preconditioning]
  # MISSING: SAM-specific preconditioner setup
[]

[Scaling]
  # Provided scaling factors
  Tsolid_sf = 1e-3
  # MISSING: mapping of variable scaling factors (1, 1e-3, 1e-6) to specific variables
[]

[Outputs]
  # MISSING: required outputs configuration
[]
