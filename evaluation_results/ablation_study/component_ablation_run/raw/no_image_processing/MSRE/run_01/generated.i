[GlobalParams]
  gravity = '0.0 -9.8 0.0'
  P_initial = 100000.0
  T_initial = 908.15
  vel_initial = 0.001

  # MISSING: global hydraulic diameter default (if required by selected components)
  # MISSING: global area default (if required by selected components)

  # MISSING: dimensionality/pipe orientation/elevation data (not provided)
[]

[Functions]
  # Fluid property correlations provided as strings; implemented here as ParsedFunctions.
  # NOTE: These functions require variable 'T' in Kelvin.

  [./fuel_salt_rho]
    type = ParsedFunction
    expression = '2553.3 - 0.562*T'
  [../]
  [./fuel_salt_mu]
    type = ParsedFunction
    expression = '8.4e-5*exp(2390/T)'
  [../]

  [./coolant_salt_hx_rho]
    type = ParsedFunction
    expression = '2146.3 - 0.488*T'
  [../]
  [./coolant_salt_hx_mu]
    type = ParsedFunction
    expression = '1.16e-4*exp(3755/T)'
  [../]
[]

[EOS]
  # MISSING: SAM EOS type/package selection for molten salts (compressibility/enthalpy models not provided)
  # The provided data include rho(T), mu(T), constant k, constant cp, but no full EOS closure is specified.

  [./fuel_salt_eos]
    type = # MISSING: EOS type (e.g., Saha, StiffenedGas, Incompressible, UserDefined, etc.)
    # MISSING: required EOS parameters
  [../]

  [./coolant_salt_hx_eos]
    type = # MISSING: EOS type
    # MISSING: required EOS parameters
  [../]
[]

[MaterialProperties]
  # Fluids
  [./fuel_salt]
    type = SAMMaterial
    eos = fuel_salt_eos
    rho = fuel_salt_rho
    mu = fuel_salt_mu
    k = 1.0
    cp = 2009.66
    # MISSING: any additional SAM-required fluid properties (beta, Pr model, h(T) reference, etc.)
  [../]

  [./coolant_salt_hx]
    type = SAMMaterial
    eos = coolant_salt_hx_eos
    rho = coolant_salt_hx_rho
    mu = coolant_salt_hx_mu
    k = 1.1
    cp = 2390.0
    # MISSING: any additional SAM-required fluid properties
  [../]

  # Solids
  [./hx_wall_alloy]
    type = SolidMaterial
    rho = 8860.0
    k = 23.6
    cp = 578.0
    # MISSING: temperature dependence (not provided)
  [../]
[]

[Components]
  # -----------------------------
  # Primary loop 1-D components
  # -----------------------------

  [./deowncomer]
    type = PBOneDFluidComponent
    fluid = fuel_salt
    A = 0.1589
    Dh = 0.0508
    # MISSING: length or volume
    # MISSING: n_elems (axial discretization)
    # MISSING: elevation change / orientation (affects gravity head)
  [../]

  [./inlet plenum]
    type = # MISSING: PBOneDFluidComponent or PBVolumeBranch (ambiguous per facts)
    fluid = fuel_salt
    A = 0.3932
    Dh = 0.6997
    # MISSING: length or volume
    # MISSING: n_elems (if 1-D)
  [../]

  [./core]
    type = # MISSING: PBOneDFluidComponent or PBCoreChannel (ambiguous per facts)
    fluid = fuel_salt
    A = 0.3512
    Dh = 0.6687
    # MISSING: length or volume
    # MISSING: n_elems
    # MISSING: power/heat source or coupling details
  [../]

  [./upper plenum]
    type = PBOneDFluidComponent
    fluid = fuel_salt
    A = 0.3932
    Dh = 0.6997
    # MISSING: length or volume
    # MISSING: n_elems
  [../]

  [./pipe1]
    type = PBOneDFluidComponent
    fluid = fuel_salt
    A = 0.01267
    Dh = 0.127
    # MISSING: length or volume
    # MISSING: n_elems
  [../]

  [./pipe2]
    type = PBOneDFluidComponent
    fluid = fuel_salt
    A = 0.01267
    Dh = 0.127
    # MISSING: length or volume
    # MISSING: n_elems
  [../]

  [./pump]
    type = PBPump
    fluid = fuel_salt
    K = '0.15 0.1'
    Head = 43909.58
    P_initial = 110000.0
    # MISSING: pump curve definition (head vs flow) and sign convention
    # MISSING: control/input signal (speed/torque) if required by model
  [../]

  [./pipe3]
    type = PBOneDFluidComponent
    fluid = fuel_salt
    A = 0.01267
    Dh = 0.127
    # MISSING: length or volume
    # MISSING: n_elems
  [../]

  [./HX primary side]
    type = # MISSING: PBHeatExchanger primary-side component type OR PBOneDFluidComponent (representation ambiguous)
    fluid = fuel_salt
    A = 0.10183
    Dh = 0.020945
    # MISSING: length or volume
    # MISSING: n_elems
    # MISSING: heat transfer correlation/closure and coupling to hx_wall
  [../]

  [./pipe_ref]
    type = PBOneDFluidComponent
    fluid = fuel_salt
    A = 0.01267
    Dh = 0.127
    # MISSING: length or volume
    # MISSING: n_elems
    # MISSING: how reference boundary condition is applied (boundary component at end vs internal constraint)
  [../]

  [./pipe4]
    type = PBOneDFluidComponent
    fluid = fuel_salt
    A = 0.01267
    Dh = 0.127
    # MISSING: length or volume
    # MISSING: n_elems
  [../]

  [./pipe5]
    type = PBOneDFluidComponent
    fluid = fuel_salt
    A = 0.01267
    Dh = 0.127
    # MISSING: length or volume
    # MISSING: n_elems
  [../]

  # -----------------------------
  # Primary loop junctions/branches
  # -----------------------------

  [./downcomer_to_inlet_plenum]
    type = PBSingleJunction
    A = 0.1155
    from = 'deowncomer:out'
    to   = 'inlet plenum:in'
    # MISSING: junction loss coefficients / form loss model inputs
  [../]

  [./inlet_plenum_to_core]
    type = PBSingleJunction
    A = 0.1155
    from = 'inlet plenum:out'
    to   = 'core:in'
    # MISSING: junction loss coefficients / form loss model inputs
  [../]

  [./core_to_upper_plenum]
    type = PBSingleJunction
    A = 0.1155
    from = 'core:out'
    to   = 'upper plenum:in'
    # MISSING: junction loss coefficients / form loss model inputs
  [../]

  [./upper_plenum_to_pipe1]
    type = PBSingleJunction
    A = 0.1155
    from = 'upper plenum:out'
    to   = 'pipe1:in'
    # MISSING: junction loss coefficients / form loss model inputs
  [../]

  [./pipe1_to_pipe2]
    type = PBSingleJunction
    A = 0.01292
    from = 'pipe1:out'
    to   = 'pipe2:in'
    # MISSING: junction loss coefficients / form loss model inputs
  [../]

  # Inline pump placement between pipe2 and pipe3 (per annotation).
  [./pipe2_to_pump]
    type = PBSingleJunction
    A = 0.01292
    from = 'pipe2:out'
    to   = 'pump:in'
    # MISSING: junction loss coefficients / form loss model inputs
  [../]

  [./pump_to_pipe3]
    type = PBSingleJunction
    A = 0.01292
    from = 'pump:out'
    to   = 'pipe3:in'
    # MISSING: junction loss coefficients / form loss model inputs
  [../]

  [./pipe3_to_HX_primary]
    type = PBSingleJunction
    A = 0.01267
    from = 'pipe3:out'
    to   = 'HX primary side:in'
    # MISSING: junction loss coefficients / form loss model inputs
  [../]

  # Tee at HX primary outlet to pipe_ref and pipe4 (explicitly NOT_CLOSED in facts).
  [./HX_primary_to_pipe_ref_and_pipe4]
    type = PBBranch
    A = 0.01267
    from = 'HX primary side:out'
    to_1 = 'pipe_ref:in'
    to_2 = 'pipe4:in'
    # MISSING: flow split ratios or hydraulic closure for tee
    # MISSING: branch loss coefficients / form loss model inputs
  [../]

  [./pipe4_to_pipe5]
    type = PBSingleJunction
    A = 0.01267
    from = 'pipe4:out'
    to   = 'pipe5:in'
    # MISSING: junction loss coefficients / form loss model inputs
  [../]

  [./pipe5_to_downcomer]
    type = PBSingleJunction
    A = 0.01267
    from = 'pipe5:out'
    to   = 'deowncomer:in'
    # MISSING: junction loss coefficients / form loss model inputs
  [../]

  # -----------------------------
  # Primary loop reference condition (pipe_ref)
  # -----------------------------
  [./pipe_ref_reference_bc]
    type = # MISSING: ReferenceBoundary / PressureBoundary / TimeDependentBoundary type
    # MISSING: exact attachment port for reference BC (pipe_ref:out assumed but not provided as a fact)
    # Intended values from facts:
    P = 123335.1
    T = 908.15
  [../]

  # -----------------------------
  # Secondary loop components (connectivity explicitly flagged missing)
  # -----------------------------

  [./HX secondary side]
    type = # MISSING: PBHeatExchanger secondary-side component type OR PBOneDFluidComponent (representation ambiguous)
    fluid = coolant_salt_hx
    A = 0.027885
    Dh = 0.010566
    # MISSING: length or volume
    # MISSING: n_elems
    # MISSING: heat transfer correlation/closure and coupling to hx_wall
  [../]

  [./hx_s_in]
    type = InletBoundary
    fluid = coolant_salt_hx
    vel = 1.6
    T = 824.8167
    # MISSING: explicit attachment target component/port (facts mark missing attachment)
  [../]

  [./hx_s_out]
    type = OutletBoundary
    fluid = coolant_salt_hx
    P = 100000.0
    T = 866.4833
    # MISSING: explicit attachment target component/port (facts mark missing attachment)
  [../]

  # -----------------------------
  # Heat structures
  # -----------------------------

  [./hx_wall]
    type = HeatStructure
    material = hx_wall_alloy
    geometry = Cylinder
    radius_i = 0.0052832
    thickness = 0.0010668
    HT_surface_area_density_per_m = 1000.0
    # MISSING: length
    # MISSING: n_elems (axial wall segments)
    # MISSING: coupling surfaces/port mapping to primary and secondary fluids
    # MISSING: initial temperature (if not defaulted); secondary-side initial tube temperature targets exist but are not mapped
  [../]

  # These are referenced only for initial temperature targets; no definitions exist in the supplied facts.
  [./hx_tube1]
    type = # MISSING: HeatStructureSegment (no geometry/material/coupling provided)
    T_initial = 824.8167
  [../]
  [./hx_tube2]
    type = # MISSING: HeatStructureSegment (no geometry/material/coupling provided)
    T_initial = 824.8167
  [../]
  [./hx_tube3]
    type = # MISSING: HeatStructureSegment (no geometry/material/coupling provided)
    T_initial = 824.8167
  [../]
[]

[Preconditioning]
  # MISSING: preconditioning strategy (not provided)
[]

[Postprocessors]
  # Minimal network diagnostics; detailed quantities depend on finalized component models/variable names.
  # MISSING: specific postprocessors for mass flow, pressures, temperatures at key locations.
[]

[Executioner]
  type = Transient
  # MISSING: start_time
  # MISSING: end_time
  # MISSING: dt / time step controls
  # MISSING: nonlinear/linear solver settings
[]

[Outputs]
  exodus = true
  csv = true
  # MISSING: output interval/settings
[]
