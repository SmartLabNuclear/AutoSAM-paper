[GlobalParams]
  gravity = '0 -9.8 0'                         # from doc
  initial_P = 1.0e5                             # Pa (global fluid IC)
  initial_T = 908.15                            # K (global fluid+solid IC unless locally overridden)
  initial_V = 0.001                             # m/s (global fluid IC)
  solid_temperature_scale = 1e-3                # from doc
[]

[Functions]
  # Fuel salt property functions (PiecewiseLinear) as documented
  [./fuel_salt_rho_func]
    type = PiecewiseLinear
    x = '750 1200'
    y = '2285.31 2032.41'                       # kg/m3
  [../]

  [./fuel_salt_enthalpy_func]
    type = PiecewiseLinear
    x = '750 1200'
    y = '1.51e6 2.41e6'                          # J/kg
  [../]

  [./fuel_salt_mu_func]
    type = PiecewiseLinear
    x = '750 760 770 780 790 800 810 820 830 840 850 860 870 880 890 900 910 920 930 940 950 960 970 980 990 1000 1010 1020 1030 1040 1050 1060 1070 1080 1090 1100 1110 1120 1130 1140 1150 1160 1170 1180 1190 1200'
    y = '2.7378E-02 2.5371E-02 2.3557E-02 2.1915E-02 2.0424E-02 1.9069E-02 1.7834E-02 1.6706E-02 1.5674E-02 1.4728E-02 1.3859E-02 1.3060E-02 1.2324E-02 1.1645E-02 1.1017E-02 1.0436E-02 9.8976E-03 9.3976E-03 8.9328E-03 8.5001E-03 8.0969E-03 7.7206E-03 7.3690E-03 7.0402E-03 6.7322E-03 6.4434E-03 6.1724E-03 5.9178E-03 5.6783E-03 5.4529E-03 5.2404E-03 5.0400E-03 4.8508E-03 4.6720E-03 4.5029E-03 4.3428E-03 4.1911E-03 4.0473E-03 3.9109E-03 3.7813E-03 3.6582E-03 3.5411E-03 3.4297E-03 3.3235E-03 3.2224E-03 3.1259E-03'  # Pa·s
  [../]
[]

[Materials]
  # Primary fuel salt: LiF–BeF4–ZrF4–UF4
  # NOTE: Documentation says SAM uses user-defined piecewise-linear functions for rho, h, and mu.
  # k and cp are provided as constants in Table 1.
  [./fuel_salt]
    type = # MISSING: SAM fuel-salt material model type name
    rho_function = fuel_salt_rho_func           # piecewise-linear
    mu_function  = fuel_salt_mu_func            # piecewise-linear
    h_function   = fuel_salt_enthalpy_func      # piecewise-linear
    k = 1.0                                      # W/m-K
    cp = 2009.66                                 # J/kg-K
    T_melt = 722.15                              # K
  [../]

  # Secondary coolant salt: LiF–BeF2 (0.66–0.34), with EOS used on HX secondary side per doc.
  # Provided constants/correlations (Table 2) are not given as SAM function blocks here.
  [./coolant_salt_flibe]
    type = # MISSING: SAM coolant-salt material model type name (EOS-based as noted)
    # MISSING: How to specify EOS correlation in SAM input for LiF-BeF2
    k = 1.1                                      # W/m-K
    cp = 2390.0                                  # J/kg-K
    T_melt = 728                                 # K
    # Engineering assumption: density/viscosity correlations will be embedded in the EOS model definition,
    # but the exact SAM keywords are not in the provided documentation.
  [../]

  # Heat exchanger tube wall material: Hastelloy N (Table 3)
  [./hastelloy_n]
    type = # MISSING: SAM solid material model type name
    rho = 8860                                   # kg/m3
    k   = 23.6                                   # W/m-K
    cp  = 578                                    # J/kg-K
  [../]
[]

[Components]
  # -------------------------
  # Primary loop (fuel salt)
  # -------------------------

  [./downcomer]
    type = PBOneDFluidComponent
    fluid_material = fuel_salt
    A  = 0.1589
    Dh = 0.0508
    length = 1.7272
    position = '-0.7366 1.7272 0'
    orientation = '0 -1 0'
    n_elems = 18
  [../]

  [./iplnm]
    type = PBOneDFluidComponent
    fluid_material = fuel_salt
    A  = 0.3932
    Dh = 0.6997
    length = 0.7366
    position = '-0.7366 0 0'
    orientation = '1 0 0'
    n_elems = 8
  [../]

  [./core]
    type = PBOneDFluidComponent
    fluid_material = fuel_salt
    A  = 0.3512
    Dh = 0.6687
    length = 1.7272
    position = '0 0 0'
    orientation = '0 1 0'
    n_elems = 20
    # MISSING: volumetric heat source specification and magnitude corresponding to 10 MW(th) or operating power
    # Engineering assumption: core power model exists but cannot be defined from provided documentation.
  [../]

  [./uplnm]
    type = PBOneDFluidComponent
    fluid_material = fuel_salt
    A  = 0.3932
    Dh = 0.6997
    length = 0.4346
    position = '0 1.7272 0'
    orientation = '0 1 0'
    n_elems = 6
  [../]

  [./pipe1]
    type = PBOneDFluidComponent
    fluid_material = fuel_salt
    A  = 0.01267
    Dh = 0.127
    length = 1.8288
    position = '0 2.1618 0'
    orientation = '1 0 0'
    n_elems = 19
  [../]

  [./pipe2]
    type = PBOneDFluidComponent
    fluid_material = fuel_salt
    A  = 0.01267
    Dh = 0.127
    length = 0.8128
    position = '1.8288 2.1618 0'
    orientation = '0 1 0'
    n_elems = 9
  [../]

  # Pump (between pipe2 and pipe3): head adjusted to sustain circulation.
  [./pump]
    type = # MISSING: SAM pump component type name
    fluid_material = fuel_salt
    initial_internal_pressure = 1.1e5            # Pa (doc)
    head = 43909.58                               # Pa (from spreadsheet "Head")
    K = '0.15 0.1'                                # from spreadsheet "K, 0.15 0.1" (interpretation unclear)
    # Engineering assumption: pump has inlet/outlet ports named (in/out) and uses head directly in Pa.
  [../]

  [./pipe3]
    type = PBOneDFluidComponent
    fluid_material = fuel_salt
    A  = 0.01267
    Dh = 0.127
    length = 1.0668
    position = '1.8288 2.9746 0'
    orientation = '-1 0 0'
    n_elems = 11
  [../]

  [./hx_primary]
    type = PBOneDFluidComponent
    fluid_material = fuel_salt
    A  = 0.10183
    Dh = 0.020945
    length = 2.5298
    position = '0.762 2.9746 0'
    orientation = '-1 0 0'
    n_elems = 26
  [../]

  [./pipe_ref]
    type = PBOneDFluidComponent
    fluid_material = fuel_salt
    A  = 0.01267
    Dh = 0.127
    length = 0.1
    position = '-1.8678 2.9746 0'
    orientation = '1 0 0'
    n_elems = 2
  [../]

  [./pipe4]
    type = PBOneDFluidComponent
    fluid_material = fuel_salt
    A  = 0.01267
    Dh = 0.127
    length = 1.2474
    position = '-1.7678 2.9746 0'
    orientation = '0 -1 0'
    n_elems = 13
  [../]

  [./pipe5]
    type = PBOneDFluidComponent
    fluid_material = fuel_salt
    A  = 0.01267
    Dh = 0.127
    length = 1.0312
    position = '-1.7678 1.7272 0'
    orientation = '1 0 0'
    n_elems = 11
  [../]

  # -------------------------
  # Branches (primary loop)
  # -------------------------

  [./j_dn_pl]
    type = PBBranch
    A = 0.1155
    K = '0.0 0.0'
    inputs = 'downcomer(out)'
    outputs = 'iplnm(in)'
  [../]

  [./j_ip_c]
    type = PBBranch
    A = 0.1155
    K = '0.0 0.0'
    inputs = 'iplnm(out)'
    outputs = 'core(in)'
  [../]

  [./j_c_up]
    type = PBBranch
    A = 0.1155
    K = '0.0 0.0'
    inputs = 'core(out)'
    outputs = 'uplnm(in)'
  [../]

  [./j_up_ps1]
    type = PBBranch
    A = 0.1155
    K = '0.0 0.0'
    inputs = 'uplnm(out)'
    outputs = 'pipe1(in)'
  [../]

  [./j1]
    type = PBBranch
    A = 0.01292
    K = '0.0 0.0'
    inputs = 'pipe1(out)'
    outputs = 'pipe2(in)'
  [../]

  # Pump connectivity (explicit junctions to ensure all ports connected)
  [./j_pump_in]
    type = PBBranch
    A = 0.01292                                   # engineering assumption: same as j1 area/piping
    K = '0.0 0.0'
    inputs = 'pipe2(out)'
    outputs = 'pump(in)'
  [../]

  [./j_pump_out]
    type = PBBranch
    A = 0.01267                                   # engineering assumption: pipe diameter area on discharge
    K = '0.0 0.0'
    inputs = 'pump(out)'
    outputs = 'pipe3(in)'
  [../]

  [./j2]
    type = PBBranch
    A = 0.01267
    K = '0.0 0.0'
    inputs = 'pipe3(out)'
    outputs = 'hx_primary(in)'
  [../]

  # Mixing junction at HX outlet with pressure-reference leg
  [./j3]
    type = PBBranch
    A = 0.01267
    K = '0.0 1000 0.0'                             # as Table 8 (path ordering is SAM-specific)
    inputs = 'hx_primary(out) pipe_ref(out)'
    outputs = 'pipe4(in)'
  [../]

  [./j4]
    type = PBBranch
    A = 0.01267
    K = '0.0 0.0'
    inputs = 'pipe4(out)'
    outputs = 'pipe5(in)'
  [../]

  [./j5]
    type = PBBranch
    A = 0.01267
    K = '0.0 0.0'
    inputs = 'pipe5(out)'
    outputs = 'downcomer(in)'
  [../]

  # -------------------------
  # Primary-loop pressure anchor boundary (ref_p) connected to pipe_ref
  # -------------------------
  [./ref_p]
    type = # MISSING: SAM pressure boundary component type name
    p = 1.233351e5
    T = 908.15
    # Engineering assumption: boundary has a single port "out" that connects to a fluid component inlet.
  [../]

  [./j_ref_p]
    type = PBBranch
    A = 0.01267                                   # engineering assumption: same as pipe_ref
    K = '0.0 0.0'
    inputs = 'ref_p(out)'
    outputs = 'pipe_ref(in)'
  [../]

  # -------------------------
  # Secondary side of heat exchanger (Flibe coolant)
  # -------------------------

  [./hx_tube1]
    type = PBOneDFluidComponent
    fluid_material = coolant_salt_flibe
    A  = 0.027885
    Dh = 0.010566
    length = # MISSING: HX secondary tube1 length
    position = # MISSING: HX secondary tube1 position
    orientation = # MISSING: HX secondary tube1 orientation
    n_elems = # MISSING: HX secondary tube1 n_elems
    initial_T = 824.8167                          # doc
  [../]

  [./hx_tube2]
    type = PBOneDFluidComponent
    fluid_material = coolant_salt_flibe
    A  = 0.027885
    Dh = 0.010566
    length = # MISSING: HX secondary tube2 length (vertical bend)
    position = # MISSING: HX secondary tube2 position
    orientation = # MISSING: HX secondary tube2 orientation
    n_elems = # MISSING: HX secondary tube2 n_elems
    initial_T = 824.8167                          # doc
  [../]

  [./hx_tube3]
    type = PBOneDFluidComponent
    fluid_material = coolant_salt_flibe
    A  = 0.027885
    Dh = 0.010566
    length = # MISSING: HX secondary tube3 length (return leg)
    position = # MISSING: HX secondary tube3 position
    orientation = # MISSING: HX secondary tube3 orientation
    n_elems = # MISSING: HX secondary tube3 n_elems
    initial_T = 824.8167                          # doc
  [../]

  # Secondary inlet/outlet boundary conditions (Table 9 + text)
  [./hx_s_in]
    type = # MISSING: SAM velocity inlet boundary component type name
    v = 1.6
    T = 824.8167
  [../]

  [./hx_s_out]
    type = # MISSING: SAM pressure outlet boundary component type name
    p = 1.0e5                                     # doc narrative (Table 9 shows 105 Pa, conflicting; using narrative value)
    T = 866.4833
    # Engineering assumption: pressure outlet temperature is used only for initialization/reference as in doc.
  [../]

  # Connect secondary BCs to tube train
  [./j_hx_s_in]
    type = PBBranch
    A = 0.027885                                  # engineering assumption: same as secondary flow area
    K = '0.0 0.0'
    inputs = 'hx_s_in(out)'
    outputs = 'hx_tube1(in)'
  [../]

  [./j_hx_s_12]
    type = PBBranch
    A = 0.027885
    K = '0.0 0.0'
    inputs = 'hx_tube1(out)'
    outputs = 'hx_tube2(in)'
  [../]

  [./j_hx_s_23]
    type = PBBranch
    A = 0.027885
    K = '0.0 0.0'
    inputs = 'hx_tube2(out)'
    outputs = 'hx_tube3(in)'
  [../]

  [./j_hx_s_out]
    type = PBBranch
    A = 0.027885
    K = '0.0 0.0'
    inputs = 'hx_tube3(out)'
    outputs = 'hx_s_out(in)'
  [../]

  # -------------------------
  # Heat exchanger tube-wall heat structures (coupling primary shell <-> secondary tubes)
  # -------------------------

  [./hx_wall1]
    type = # MISSING: SAM heat structure component type name (coupled, axial+radial conduction)
    material = hastelloy_n
    geometry_type = Cylinder                       # from spreadsheet
    width = 0.0010668                              # m (spreadsheet "Width of heat structure"; equals tube wall thickness)
    radius = 0.0052832                             # m (spreadsheet)
    heat_transfer_surface_area_density = 1000      # from spreadsheet
    initial_T = 824.8167                           # doc
    # MISSING: required coupling keywords/ports for primary/secondary convection attachment
  [../]

  [./hx_wall2]
    type = # MISSING: SAM heat structure component type name
    material = hastelloy_n
    geometry_type = Cylinder
    width = 0.0010668
    radius = 0.0052832
    heat_transfer_surface_area_density = 1000
    initial_T = 824.8167
    # MISSING: required coupling keywords/ports for primary/secondary convection attachment
  [../]

  # MISSING: explicit thermal coupling components/blocks that link hx_primary <-> hx_wall(s) <-> hx_tube(s)
  # Engineering assumption: SAM provides automatic coupling via named references, but keywords are not in provided documentation.
[]

[Executioner]
  type = # MISSING: SAM executioner type name (transient/steady)
  # MISSING: timestep controls / end_time / solver settings
[]

[Outputs]
  # MISSING: requested outputs; provide minimal placeholder
  exodus = false
  csv = true
[]
