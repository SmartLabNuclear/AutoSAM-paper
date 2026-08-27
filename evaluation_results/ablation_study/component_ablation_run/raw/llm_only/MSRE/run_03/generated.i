[GlobalParams]
  global_init_p = 100000.0
  global_init_v = 0.001
  global_init_t = 908.15
  gravity = '0 -9.8 0'
[]

[EOS]
  [./eos_fuel]
    type = PTFunctionsEOS
    rho = fuel_rho          # MISSING: fuel_rho (PTFunctionsEOS function)
    cp  = fuel_cp           # MISSING: fuel_cp  (PTFunctionsEOS function)
    mu  = fuel_mu           # MISSING: fuel_mu  (PTFunctionsEOS function)
    k   = fuel_k            # MISSING: fuel_k   (PTFunctionsEOS function)
  [../]
  [./eos_cool]
    type = PTFunctionsEOS
    rho = cool_rho          # MISSING: cool_rho (PTFunctionsEOS function)
    cp  = cool_cp           # MISSING: cool_cp  (PTFunctionsEOS function)
    mu  = cool_mu           # MISSING: cool_mu  (PTFunctionsEOS function)
    k   = cool_k            # MISSING: cool_k   (PTFunctionsEOS function)
  [../]
[]

[MaterialProperties]
  [./hx_wall]
    type = HeatConductionMaterialProps
    k = 23.6
    cp = 578
    rho = 8860
  [../]
[]

[Components]
  [./inlet_plenum]
    type = PBOneDFluidComponent
    eos = eos_fuel
    position = '-0.7366 0 0'
    orientation = '1 0 0'
    length = 0.7366
    a = 0.3932
    dh = 0.6997
    n_elems = 4
  [../]

  [./core]
    type = PBOneDFluidComponent
    eos = eos_fuel
    position = '0 0 0'
    orientation = '0 1 0'
    length = 1.7272
    a = 0.3512
    dh = 0.6687
    n_elems = 10
  [../]

  [./upper_plenum]
    type = PBOneDFluidComponent
    eos = eos_fuel
    position = '0 1.7272 0'
    orientation = '0 1 0'
    length = 0.4346
    a = 0.3932
    dh = 0.6997
    n_elems = 3
  [../]

  [./pipe1]
    type = PBOneDFluidComponent
    eos = eos_fuel
    position = '0 2.1618 0'
    orientation = '1 0 0'
    length = 1.8288
    a = 0.01267
    dh = 0.127
    n_elems = 10
  [../]

  [./pipe2]
    type = PBOneDFluidComponent
    eos = eos_fuel
    position = '1.8288 2.1618 0'
    orientation = '0 1 0'
    length = 0.8128
    a = 0.01267
    dh = 0.127
    n_elems = 6
  [../]

  [./pipe3]
    type = PBOneDFluidComponent
    eos = eos_fuel
    position = '1.8288 2.9746 0'
    orientation = '-1 0 0'
    length = 1.0668
    a = 0.01267
    dh = 0.127
    n_elems = 6
  [../]

  [./hx]
    type = PBHeatExchanger
    eos = eos_fuel
    position = '0.762 2.9746 0'
    orientation = '-1 0 0'
    length = 2.5298
    a = 0.10183
    dh = 0.020945
    a_secondary = 0.027885
    dh_secondary = 0.010566
    n_elems = 10
    ht_surface_area_density = 1000
    ht_surface_area_density_secondary = 1000

    radius_i = 0.0052832
    wall_thickness = 0.0010668
    twall_init = 908.15
    n_wall_elems = 1

    # Engineering assumption: The HX wall material is taken from the provided
    # hx_wall material properties block; if PBHeatExchanger requires an explicit
    # material coupling parameter name, it is not provided in the case facts.
    # MISSING: HX wall material coupling parameter name (if required by SAM build)
  [../]

  [./pipe4]
    type = PBOneDFluidComponent
    eos = eos_fuel
    position = '-1.7678 2.9746 0'
    orientation = '0 -1 0'
    length = 1.2474
    a = 0.01267
    dh = 0.127
    n_elems = 8
  [../]

  [./pipe5]
    type = PBOneDFluidComponent
    eos = eos_fuel
    position = '-1.7678 1.7272 0'
    orientation = '1 0 0'
    length = 1.0312
    a = 0.01267
    dh = 0.127
    n_elems = 6
  [../]

  [./downcomer]
    type = PBOneDFluidComponent
    eos = eos_fuel
    position = '-0.7366 1.7272 0'
    orientation = '0 -1 0'
    length = 1.7272
    a = 0.1589
    dh = 0.0508
    n_elems = 10
  [../]

  [./pipe_ref]
    type = PBOneDFluidComponent
    eos = eos_fuel
    position = '-1.7678 2.9746 0'
    orientation = '-1 0 0'
    length = 0.5
    a = 0.01267
    dh = 0.127
    n_elems = 2
  [../]

  [./j_downcomer_to_inlet_plenum]
    type = PBSingleJunction
    eos = eos_fuel
    inputs = 'downcomer(out)'
    outputs = 'inlet_plenum(in)'
    area = 0.1155
    k = 0
  [../]

  [./j_inlet_plenum_to_core]
    type = PBSingleJunction
    eos = eos_fuel
    inputs = 'inlet_plenum(out)'
    outputs = 'core(in)'
    area = 0.1155
    k = 0
  [../]

  [./j_core_to_upper_plenum]
    type = PBSingleJunction
    eos = eos_fuel
    inputs = 'core(out)'
    outputs = 'upper_plenum(in)'
    area = 0.1155
    k = 0
  [../]

  [./j_upper_plenum_to_pipe1]
    type = PBSingleJunction
    eos = eos_fuel
    inputs = 'upper_plenum(out)'
    outputs = 'pipe1(in)'
    area = 0.1155
    k = 0
  [../]

  [./j_pipe1_to_pipe2]
    type = PBSingleJunction
    eos = eos_fuel
    inputs = 'pipe1(out)'
    outputs = 'pipe2(in)'
    area = 0.01292
    k = 0
  [../]

  [./pump]
    type = PBPump
    eos = eos_fuel
    inputs = 'pipe2(out)'
    outputs = 'pipe3(in)'
    area = 0.01292
    k = '0.15 0.1'
    initial_p = 110000
    head = 43909.58
  [../]

  [./j_pipe3_to_hx]
    type = PBSingleJunction
    eos = eos_fuel
    inputs = 'pipe3(out)'
    outputs = 'HX(primary_in)'   # MISSING: canonical component name mismatch (hx vs HX)
    area = 0.01267
    k = 0
  [../]

  [./t_h]
    type = PBBranch
    eos = eos_fuel
    inputs = 'HX(primary_out)'   # MISSING: canonical component name mismatch (hx vs HX)
    outputs = 'pipe4(in) pipe_ref(in)'
    area = 0.01267
    k = '0 0 0'
  [../]

  [./j_pipe4_to_pipe5]
    type = PBSingleJunction
    eos = eos_fuel
    inputs = 'pipe4(out)'
    outputs = 'pipe5(in)'
    area = 0.01267
    k = 0
  [../]

  [./j_pipe5_to_downcomer]
    type = PBSingleJunction
    eos = eos_fuel
    inputs = 'pipe5(out)'
    outputs = 'downcomer(in)'
    area = 0.01267
    k = 0
  [../]

  [./ref_pressure]
    type = PBTDV
    input = 'pipe_ref(out)'
    eos = eos_fuel
    p_bc = 123335.1
    t_bc = 908.15
  [../]

  [./hx_secondary_in]
    type = PBTDJ
    input = 'HX(secondary_in)'   # MISSING: canonical component name mismatch (hx vs HX)
    eos = eos_cool
    v_bc = 1.6
    t_bc = 824.8167
  [../]

  [./hx_secondary_out]
    type = PBTDV
    input = 'HX(secondary_out)'  # MISSING: canonical component name mismatch (hx vs HX)
    eos = eos_cool
    p_bc = 100000.0
    t_bc = 866.4833
  [../]
[]

[Executioner]
  type = Steady
  [./quadrature]
    type = TRAP
  [../]
[]
