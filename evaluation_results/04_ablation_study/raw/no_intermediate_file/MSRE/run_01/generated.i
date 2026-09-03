[GlobalParams]
  gravity = '0 -9.8 0'
  initial_P = 1.0e5
  initial_T = 908.15
  initial_V = 0.001
  solid_temperature_scaling = 1e-3
[]

[Functions]
  # Fuel salt (primary) piecewise-linear property functions (750 K to 1200 K)
  [./fuel_salt_rho_func]
    type = PiecewiseLinear
    x = '750 1200'
    y = '2285.31 2032.41'
  [../]

  [./fuel_salt_enthalpy_func]
    type = PiecewiseLinear
    x = '750 1200'
    y = '1.51e6 2.41e6'
  [../]

  [./fuel_salt_mu_func]
    type = PiecewiseLinear
    x = '750 760 770 780 790 800 810 820 830 840 850 860 870 880 890 900 910 920 930 940 950 960 970 980 990 1000 1010 1020 1030 1040 1050 1060 1070 1080 1090 1100 1110 1120 1130 1140 1150 1160 1170 1180 1190 1200'
    y = '2.7378E-02 2.5371E-02 2.3557E-02 2.1915E-02 2.0424E-02 1.9069E-02 1.7834E-02 1.6706E-02 1.5674E-02 1.4728E-02 1.3859E-02 1.3060E-02 1.2324E-02 1.1645E-02 1.1017E-02 1.0436E-02 9.8976E-03 9.3976E-03 8.9328E-03 8.5001E-03 8.0969E-03 7.7206E-03 7.3690E-03 7.0402E-03 6.7322E-03 6.4434E-03 6.1724E-03 5.9178E-03 5.6783E-03 5.4529E-03 5.2404E-03 5.0400E-03 4.8508E-03 4.6720E-03 4.5029E-03 4.3428E-03 4.1911E-03 4.0473E-03 3.9109E-03 3.7813E-03 3.6582E-03 3.5411E-03 3.4297E-03 3.3235E-03 3.2224E-03 3.1259E-03'
  [../]
[]

[EOS]
  # Primary loop fuel salt uses user-defined property functions.
  [./fuel_salt_eos]
    # MISSING: exact SAM EOS type/name and required parameter keys for function-based molten salt EOS
    # Assumption: SAM supports an EOS that can take rho(T), h(T), mu(T), k(const), cp(const) via functions/constants.
    type = # MISSING: EOS type for function-based incompressible/molten salt
    rho_function = fuel_salt_rho_func          # MISSING: key name if different
    h_function = fuel_salt_enthalpy_func       # MISSING: key name if different
    mu_function = fuel_salt_mu_func            # MISSING: key name if different
    k = 1.0
    cp = 2009.66
    T_melt = 722.15
  [../]

  # Secondary heat exchanger side coolant salt: LiF-BeF2 (Flibe 0.66-0.34)
  # Documentation note: "salt equation of state is used for the heat exchanger secondary side."
  [./flibe_salt_eos]
    # MISSING: exact SAM "salt equation of state" type/name and required parameter keys
    type = # MISSING: salt EOS type used for secondary side
    # Provided correlations (Tables 2):
    rho_coeffs = '2146.3 -0.488'               # Assumption: rho = a + b*T (kg/m3)
    mu_A = 1.16e-4                            # Assumption: mu = A*exp(B/T)
    mu_B = 3755.0
    k = 1.1
    cp = 2390.0
    T_melt = 728
  [../]
[]

[MaterialProperties]
  # Heat exchanger wall material: Hastelloy N (Table 3)
  [./hastelloyN]
    type = GenericConstantMaterial
    prop_names = 'rho cp k'
    prop_values = '8860 578 23.6'
  [../]
[]

[Components]
  # -----------------------
  # Primary loop (fuel salt)
  # -----------------------

  [./downcomer]
    type = PBOneDFluidComponent
    eos = fuel_salt_eos
    A = 0.1589
    Dh = 0.0508
    length = 1.7272
    position = '-0.7366 1.7272 0'
    orientation = '0 -1 0'
    n_elems = 18
  [../]

  [./iplnm]
    type = PBOneDFluidComponent
    eos = fuel_salt_eos
    A = 0.3932
    Dh = 0.6997
    length = 0.7366
    position = '-0.7366 0 0'
    orientation = '1 0 0'
    n_elems = 8
  [../]

  [./core]
    type = PBOneDFluidComponent
    eos = fuel_salt_eos
    A = 0.3512
    Dh = 0.6687
    length = 1.7272
    position = '0 0 0'
    orientation = '0 1 0'
    n_elems = 20

    # MISSING: core volumetric heat source specification (total power 10 MWth max; operating power not specified)
    # Assumption: a volumetric heat source is applied uniformly; magnitude not available from documentation.
    volumetric_heat_source = # MISSING: q'''(W/m3) or power specification input for SAM
  [../]

  [./uplnm]
    type = PBOneDFluidComponent
    eos = fuel_salt_eos
    A = 0.3932
    Dh = 0.6997
    length = 0.4346
    position = '0 1.7272 0'
    orientation = '0 1 0'
    n_elems = 6
  [../]

  [./pipe1]
    type = PBOneDFluidComponent
    eos = fuel_salt_eos
    A = 0.01267
    Dh = 0.127
    length = 1.8288
    position = '0 2.1618 0'
    orientation = '1 0 0'
    n_elems = 19
  [../]

  [./pipe2]
    type = PBOneDFluidComponent
    eos = fuel_salt_eos
    A = 0.01267
    Dh = 0.127
    length = 0.8128
    position = '1.8288 2.1618 0'
    orientation = '0 1 0'
    n_elems = 9
  [../]

  # Pump located between pipe2 and pipe3 (per schematic and spreadsheet pump head)
  [./pump]
    # MISSING: exact SAM pump component type name
    type = # MISSING: Pump component type
    eos = fuel_salt_eos
    initial_internal_pressure = 1.1e5
    head = 43909.58
    # MISSING: pump loss coefficient / efficiency / inertia fields (if required by SAM)
  [../]

  [./pipe3]
    type = PBOneDFluidComponent
    eos = fuel_salt_eos
    A = 0.01267
    Dh = 0.127
    length = 1.0668
    position = '1.8288 2.9746 0'
    orientation = '-1 0 0'
    n_elems = 11
  [../]

  [./hx_primarySide]
    type = PBOneDFluidComponent
    eos = fuel_salt_eos
    A = 0.10183
    Dh = 0.020945
    length = 2.5298
    position = '0.762 2.9746 0'
    orientation = '-1 0 0'
    n_elems = 26
  [../]

  [./pipe_ref]
    type = PBOneDFluidComponent
    eos = fuel_salt_eos
    A = 0.01267
    Dh = 0.127
    length = 0.1
    position = '-1.8678 2.9746 0'
    orientation = '1 0 0'
    n_elems = 2
  [../]

  [./pipe4]
    type = PBOneDFluidComponent
    eos = fuel_salt_eos
    A = 0.01267
    Dh = 0.127
    length = 1.2474
    position = '-1.7678 2.9746 0'
    orientation = '0 -1 0'
    n_elems = 13
  [../]

  [./pipe5]
    type = PBOneDFluidComponent
    eos = fuel_salt_eos
    A = 0.01267
    Dh = 0.127
    length = 1.0312
    position = '-1.7678 1.7272 0'
    orientation = '1 0 0'
    n_elems = 11
  [../]

  # -----------------------
  # Primary loop branches
  # -----------------------

  [./j_dn_pl]
    type = PBBranch
    A = 0.1155
    K = '0.0 0.0'
    inputs = 'downcomer:out'
    outputs = 'iplnm:in'
  [../]

  [./j_ip_c]
    type = PBBranch
    A = 0.1155
    K = '0.0 0.0'
    inputs = 'iplnm:out'
    outputs = 'core:in'
  [../]

  [./j_c_up]
    type = PBBranch
    A = 0.1155
    K = '0.0 0.0'
    inputs = 'core:out'
    outputs = 'uplnm:in'
  [../]

  [./j_up_ps1]
    type = PBBranch
    A = 0.1155
    K = '0.0 0.0'
    inputs = 'uplnm:out'
    outputs = 'pipe1:in'
  [../]

  [./j1]
    type = PBBranch
    A = 0.01292
    K = '0.0 0.0'
    inputs = 'pipe1:out'
    outputs = 'pipe2:in'
  [../]

  # Connect pipe2 to pump, then pump to pipe3 using branches (explicit to ensure port connectivity)
  [./j_pump_in]
    type = PBBranch
    # MISSING: branch area between pipe2 and pump (spreadsheet suggests 0.01292 at pump leg but not in Table 8)
    A = # MISSING: area for pipe2->pump junction
    K = '0.0 0.0'
    inputs = 'pipe2:out'
    outputs = 'pump:in'
  [../]

  [./j_pump_out]
    type = PBBranch
    A = 0.01292  # Assumption: same as pipe1->pipe2 junction area from spreadsheet (pump leg)
    K = '0.0 0.0'
    inputs = 'pump:out'
    outputs = 'pipe3:in'
  [../]

  [./j2]
    type = PBBranch
    A = 0.01267
    K = '0.0 0.0'
    inputs = 'pipe3:out'
    outputs = 'hx_primarySide:in'
  [../]

  [./j3]
    type = PBBranch
    A = 0.01267
    K = '0.0 1000 0.0'
    inputs = 'hx_primarySide:out pipe_ref:out'
    outputs = 'pipe4:in'
  [../]

  [./j4]
    type = PBBranch
    A = 0.01267
    K = '0.0 0.0'
    inputs = 'pipe4:out'
    outputs = 'pipe5:in'
  [../]

  [./j5]
    type = PBBranch
    A = 0.01267
    K = '0.0 0.0'
    inputs = 'pipe5:out'
    outputs = 'downcomer:in'
  [../]

  # -----------------------
  # Pressure reference BC on primary loop (ref_p) connected to pipe_ref inlet
  # -----------------------
  [./ref_p]
    # MISSING: exact SAM boundary component type name for fixed pressure+temperature boundary
    type = # MISSING: PressureTemperatureBoundary type
    p = 1.233351e5
    T = 908.15
    connect_to = 'pipe_ref:in'   # MISSING: correct SAM syntax for attaching boundary to component port
  [../]

  # -----------------------
  # Secondary loop (heat exchanger tube-side) + BCs
  # -----------------------
  # Geometry for hx secondarySide (tube-side) is not provided in Table 7 (length/position/orientation/n_elems are '-').
  # Assumption: represent U-tube as 3 1-D tube components per narrative: tube1 (horizontal), tube2 (vertical bend), tube3 (horizontal return).
  # MISSING: tube lengths, positions, orientations, n_elems, and flow areas per leg.

  [./hx_tube1]
    type = PBOneDFluidComponent
    eos = flibe_salt_eos
    A = 0.027885
    Dh = 0.010566
    length = # MISSING: tube1 length (m)
    position = # MISSING: tube1 position (x y z)
    orientation = # MISSING: tube1 orientation
    n_elems = # MISSING: tube1 n_elems
    initial_T = 824.8167
  [../]

  [./hx_tube2]
    type = PBOneDFluidComponent
    eos = flibe_salt_eos
    A = 0.027885
    Dh = 0.010566
    length = # MISSING: tube2 length (m)
    position = # MISSING: tube2 position (x y z)
    orientation = # MISSING: tube2 orientation
    n_elems = # MISSING: tube2 n_elems
    initial_T = 824.8167
  [../]

  [./hx_tube3]
    type = PBOneDFluidComponent
    eos = flibe_salt_eos
    A = 0.027885
    Dh = 0.010566
    length = # MISSING: tube3 length (m)
    position = # MISSING: tube3 position (x y z)
    orientation = # MISSING: tube3 orientation
    n_elems = # MISSING: tube3 n_elems
    initial_T = 824.8167
  [../]

  [./hx_s_in]
    # MISSING: exact SAM boundary component type for velocity+temperature inlet
    type = # MISSING: VelocityTemperatureInletBoundary type
    v = 1.6
    T = 824.8167
    connect_to = 'hx_tube1:in'  # MISSING: correct SAM syntax
  [../]

  [./hx_s_out]
    # MISSING: exact SAM boundary component type for pressure+temperature outlet
    type = # MISSING: PressureTemperatureOutletBoundary type
    p = 1.0e5
    T = 866.4833
    connect_to = 'hx_tube3:out' # MISSING: correct SAM syntax
  [../]

  [./hx_s_j12]
    type = PBBranch
    # MISSING: branch area for tube-side junctions
    A = # MISSING: tube-side junction area
    K = '0.0 0.0'
    inputs = 'hx_tube1:out'
    outputs = 'hx_tube2:in'
  [../]

  [./hx_s_j23]
    type = PBBranch
    A = # MISSING: tube-side junction area
    K = '0.0 0.0'
    inputs = 'hx_tube2:out'
    outputs = 'hx_tube3:in'
  [../]

  # -----------------------
  # Heat exchanger heat structures (two walls) coupled to primary shell and secondary tubes
  # -----------------------
  # From spreadsheet:
  # - Heat transfer surface area density = 1000  (# units not stated)
  # - Heat structure width (thickness) = 0.0010668 m
  # - Radius = 0.0052832 m
  # Assumption: cylindrical tube wall with thickness = 1.0668 mm and inner radius = 5.2832 mm (consistent with 1.27 cm OD, 1.07 mm thickness).
  # MISSING: exact SAM heat structure component type and coupling field names.

  [./hx_wall1]
    type = # MISSING: HeatStructure type (e.g., HeatStructureCylindrical / HeatStructure)
    material = hastelloyN
    geometry = Cylinder
    r_inner = 0.0052832
    thickness = 0.0010668
    # MISSING: axial length and discretization; assume matches hx_primarySide length for coupling
    length = 2.5298
    n_elems = # MISSING: wall axial n_elems
    initial_T = 824.8167
    # MISSING: coupling specification to hx_primarySide and hx_tube1/hx_tube2
    # Assumption: wall1 couples primary to first leg of U-tube bundle
    primary_component = hx_primarySide          # MISSING: field name
    secondary_component = hx_tube1              # MISSING: field name
    heat_transfer_area_density = 1000           # MISSING: field name and units
  [../]

  [./hx_wall2]
    type = # MISSING: HeatStructure type (e.g., HeatStructureCylindrical / HeatStructure)
    material = hastelloyN
    geometry = Cylinder
    r_inner = 0.0052832
    thickness = 0.0010668
    length = 2.5298
    n_elems = # MISSING: wall axial n_elems
    initial_T = 824.8167
    # Assumption: wall2 couples primary to return leg (hx_tube3)
    primary_component = hx_primarySide          # MISSING: field name
    secondary_component = hx_tube3              # MISSING: field name
    heat_transfer_area_density = 1000           # MISSING: field name and units
  [../]
[]

[Preconditioning]
  # MISSING: case-specific preconditioner settings from documentation
  [./precond]
    type = SMP
    petsc_options_iname = '-pc_type -ksp_type'
    petsc_options_value = 'ilu gmres'
  [../]
[]

[Postprocessors]
  # Basic monitoring
  [./pp_time]
    type = TimePostprocessor
  [../]

  # MISSING: SAM-specific component-average postprocessors (names/types)
  # Assumption: placeholders for outlet temperatures/pressures if supported by SAM.
  [./T_core_out]
    type = # MISSING: ComponentOutletTemperaturePostprocessor type
    component = core
    boundary = out
  [../]

  [./T_hx_primary_out]
    type = # MISSING: ComponentOutletTemperaturePostprocessor type
    component = hx_primarySide
    boundary = out
  [../]

  [./T_hx_secondary_out]
    type = # MISSING: ComponentOutletTemperaturePostprocessor type
    component = hx_tube3
    boundary = out
  [../]
[]

[Executioner]
  type = Transient
  scheme = bdf2
  dt = # MISSING: time step
  end_time = # MISSING: end time
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-10
  l_max_its = 50
  nl_max_its = 30
[]

[Outputs]
  exodus = true
  csv = true
  print_linear_residuals = false
[]
