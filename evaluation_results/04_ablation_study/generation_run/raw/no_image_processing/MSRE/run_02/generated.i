[GlobalParams]
  gravity = '0 -9.8 0'         # m/s^2
  P_init = 100000.0            # Pa
  T_init = 908.15              # K
  vel_init = 0.001             # m/s
[]

[Functions]
  # MISSING: If time-dependent BCs/controls are required; none provided.
[]

[EOS]
  # MISSING: SAM EOS model selection/configuration for fuel_salt (compressible/incompressible, reference state, etc.)
  # MISSING: SAM EOS model selection/configuration for coolant_salt_hx (compressible/incompressible, reference state, etc.)
[]

[MaterialProperties]
  # Fluid: fuel_salt (Table 1)
  # Density correlation: 2553.3 - 0.562*T   (kg/m^3), T in K, valid 750-1200 K
  # Viscosity correlation: 8.4e-5 * exp(2390/T) (Pa*s), T in K, valid 750-1200 K
  # k = 1.0 W/(m*K), cp = 2009.66 J/(kg*K)
  #
  # MISSING: Exact SAM material property block types for user-defined molten salts.
  # MISSING: How SAM expects correlations to be entered (parsed expressions vs tabular vs coded material).

  # Fluid: coolant_salt_hx (LiF-BeF2 0.66-0.34) (Table 2)
  # Density correlation: 2146.3 - 0.488*T (kg/m^3)
  # Viscosity correlation: 1.16e-4 * exp(3755/T) (Pa*s)
  # k = 1.1 W/(m*K), cp = 2390.0 J/(kg*K)
  #
  # Solid: hx_wall_alloy (Hastelloy N) (Table 3)
  # rho = 8860 kg/m^3, k = 23.6 W/(m*K), cp = 578 J/(kg*K)
  #
  # Placeholder declarations (non-functional until mapped to actual SAM material models):

  [./fuel_salt_props]
    type = GenericConstantMaterial
    # MISSING: Replace with correct SAM fluid property material
    prop_names = 'k cp'
    prop_values = '1.0 2009.66'
  [../]

  [./coolant_salt_hx_props]
    type = GenericConstantMaterial
    # MISSING: Replace with correct SAM fluid property material
    prop_names = 'k cp'
    prop_values = '1.1 2390.0'
  [../]

  [./hx_wall_alloy_props]
    type = GenericConstantMaterial
    # MISSING: Replace with correct SAM solid thermal property material
    prop_names = 'rho k cp'
    prop_values = '8860 23.6 578'
  [../]
[]

[Components]

  # ----------------------------
  # Primary loop components
  # ----------------------------

  [./deowncomer]
    type = PBOneDFluidComponent
    A = 0.1589                 # m^2
    Dh = 0.0508                # m
    # MISSING: length
    # MISSING: n_elems / nodalization
    # MISSING: elevation / orientation
    # MISSING: friction model / roughness
    # MISSING: EOS/material assignment mechanism for fuel_salt
  [../]

  [./inlet plenum]
    type = PBOneDFluidComponent
    A = 0.3932                 # m^2
    Dh = 0.6997                # m
    # MISSING: length
    # MISSING: n_elems / nodalization
    # MISSING: elevation / orientation
    # MISSING: friction model / roughness
    # MISSING: EOS/material assignment mechanism for fuel_salt
  [../]

  [./core]
    type = PBOneDFluidComponent
    A = 0.3512                 # m^2
    Dh = 0.6687                # m
    # MISSING: length
    # MISSING: n_elems / nodalization
    # MISSING: elevation / orientation
    # MISSING: friction model / roughness
    # MISSING: EOS/material assignment mechanism for fuel_salt
    # MISSING: core heat source / power model (if any)
  [../]

  [./upper plenum]
    type = PBOneDFluidComponent
    A = 0.3932                 # m^2
    Dh = 0.6997                # m
    # MISSING: length
    # MISSING: n_elems / nodalization
    # MISSING: elevation / orientation
    # MISSING: friction model / roughness
    # MISSING: EOS/material assignment mechanism for fuel_salt
  [../]

  [./pipe1]
    type = PBOneDFluidComponent
    A = 0.01267                # m^2
    Dh = 0.127                 # m
    # MISSING: length
    # MISSING: n_elems / nodalization
    # MISSING: elevation / orientation
    # MISSING: friction model / roughness
    # MISSING: EOS/material assignment mechanism for fuel_salt
  [../]

  [./pipe2]
    type = PBOneDFluidComponent
    A = 0.01267                # m^2
    Dh = 0.127                 # m
    # MISSING: length
    # MISSING: n_elems / nodalization
    # MISSING: elevation / orientation
    # MISSING: friction model / roughness
    # MISSING: EOS/material assignment mechanism for fuel_salt
  [../]

  [./pump]
    type = PBPump
    # Provided pump parameters:
    Head = 43909.58            # Pa
    K = '0.15 0.1'             # units unspecified
    P_init = 110000.0          # Pa (initial internal pressure)
    # MISSING: pump model form / interpretation of K and Head (constant head vs curve)
    # MISSING: pump speed/control inputs if required
    # MISSING: loss model details
    # MISSING: EOS/material assignment mechanism for fuel_salt
  [../]

  [./pipe3]
    type = PBOneDFluidComponent
    A = 0.01267                # m^2
    Dh = 0.127                 # m
    # MISSING: length
    # MISSING: n_elems / nodalization
    # MISSING: elevation / orientation
    # MISSING: friction model / roughness
    # MISSING: EOS/material assignment mechanism for fuel_salt
  [../]

  [./HX primary side]
    type = PBHeatExchanger
    A = 0.10183                # m^2
    Dh = 0.020945              # m
    # MISSING: length
    # MISSING: n_elems / nodalization
    # MISSING: elevation / orientation
    # MISSING: friction model / roughness
    # MISSING: EOS/material assignment mechanism for fuel_salt
    # MISSING: coupling definition to hx_wall (side naming, segment mapping, heat transfer correlation)
  [../]

  [./pipe_ref]
    type = PBOneDFluidComponent
    A = 0.01267                # m^2
    Dh = 0.127                 # m
    # MISSING: length (if this is a real stub volume/pipe)
    # MISSING: n_elems / nodalization
    # MISSING: friction model / roughness
    # MISSING: EOS/material assignment mechanism for fuel_salt
  [../]

  [./pipe4]
    type = PBOneDFluidComponent
    A = 0.01267                # m^2
    Dh = 0.127                 # m
    # MISSING: working fluid assignment (primary fuel_salt vs secondary coolant_salt_hx)
    # MISSING: length
    # MISSING: n_elems / nodalization
    # MISSING: elevation / orientation
    # MISSING: friction model / roughness
  [../]

  [./pipe5]
    type = PBOneDFluidComponent
    A = 0.01267                # m^2
    Dh = 0.127                 # m
    # MISSING: working fluid assignment (primary fuel_salt vs secondary coolant_salt_hx)
    # MISSING: length
    # MISSING: n_elems / nodalization
    # MISSING: elevation / orientation
    # MISSING: friction model / roughness
  [../]

  # ----------------------------
  # Primary loop reference boundary condition (name preserved: pipe_ref)
  # ----------------------------
  [./pipe_ref_bc]
    type = PBReferenceBoundary
    input = pipe_ref
    pressure = 123335.1        # Pa
    temperature = 908.15       # K
    # MISSING: boundary semantics (pressure reference with no net flow vs true boundary)
    # MISSING: which port of pipe_ref component this attaches to (inlet/outlet)
  [../]

  # ----------------------------
  # Secondary loop components and boundaries
  # ----------------------------

  [./HX secondary side]
    type = PBHeatExchanger
    A = 0.027885               # m^2
    Dh = 0.010566              # m
    # MISSING: length
    # MISSING: n_elems / nodalization
    # MISSING: elevation / orientation
    # MISSING: friction model / roughness
    # MISSING: EOS/material assignment mechanism for coolant_salt_hx
    # MISSING: connection to secondary boundaries hx_s_in and hx_s_out (ports)
    # MISSING: coupling definition to hx_wall (side naming, segment mapping, heat transfer correlation)
  [../]

  [./hx_wall]
    type = HeatStructure
    material = hx_wall_alloy_props
    geometry_type = Cylinder
    radius_i = 0.0052832       # m
    thickness = 0.0010668      # m
    HT_surface_area_density = 1000   # 1/m
    # MISSING: length / axial segmentation consistent with HX primary/secondary discretization
    # MISSING: initial temperature (if needed)
    # MISSING: convective coupling blocks to HX primary side and HX secondary side
  [../]

  [./hx_s_in]
    type = PBInletBoundary
    # Provided BC:
    velocity = 1.6             # m/s
    temperature = 824.8167     # K
    # MISSING: attached component (likely "HX secondary side") and port (inlet)
    # MISSING: fluid assignment (coolant_salt_hx) binding mechanism
  [../]

  [./hx_s_out]
    type = PBOutletBoundary
    # Provided BC:
    pressure = 100000.0        # Pa
    temperature = 866.4833     # K
    # MISSING: attached component (likely "HX secondary side") and port (outlet)
    # MISSING: fluid assignment (coolant_salt_hx) binding mechanism
  [../]

  [./hx_tube1]
    type = PBOneDFluidComponent
    # MISSING: A, Dh, length, nodalization, friction, EOS/material assignment
    T_init = 824.8167          # K
    # MISSING: connectivity (whether part of HX secondary side or separate loop segments)
  [../]

  [./hx_tube2]
    type = PBOneDFluidComponent
    # MISSING: A, Dh, length, nodalization, friction, EOS/material assignment
    T_init = 824.8167          # K
    # MISSING: connectivity
  [../]

  [./hx_tube3]
    type = PBOneDFluidComponent
    # MISSING: A, Dh, length, nodalization, friction, EOS/material assignment
    T_init = 824.8167          # K
    # MISSING: connectivity
  [../]

  # ----------------------------
  # Primary loop junctions/branches (connectivity)
  # ----------------------------

  [./downcomer_to_inlet_plenum]
    type = PBBranch
    from = deowncomer
    to = 'inlet plenum'
    area = 0.1155              # m^2
    # MISSING: port specification (from_port/to_port) if required by SAM
  [../]

  [./inlet_plenum_to_core]
    type = PBBranch
    from = 'inlet plenum'
    to = core
    area = 0.1155              # m^2
    # MISSING: port specification if required
  [../]

  [./core_to_upper_plenum]
    type = PBBranch
    from = core
    to = 'upper plenum'
    area = 0.1155              # m^2
    # MISSING: port specification if required
  [../]

  [./upper_plenum_to_pipe1]
    type = PBBranch
    from = 'upper plenum'
    to = pipe1
    area = 0.1155              # m^2
    # MISSING: port specification if required
  [../]

  [./pipe1_to_pipe2]
    type = PBBranch
    from = pipe1
    to = pipe2
    area = 0.01292             # m^2
    # MISSING: port specification if required
  [../]

  # Inline pump between pipe2 and pipe3 represented by two branches:
  [./pipe2_to_pump]
    type = PBBranch
    from = pipe2
    to = pump
    area = 0.01292             # m^2 (from "0.01292 (pump)")
    # MISSING: port specification if required
  [../]

  [./pump_to_pipe3]
    type = PBBranch
    from = pump
    to = pipe3
    area = 0.01292             # m^2 (from "0.01292 (pump)")
    # MISSING: port specification if required
  [../]

  [./pipe3_to_HX_primary]
    type = PBBranch
    from = pipe3
    to = 'HX primary side'
    area = 0.01267             # m^2
    # MISSING: port specification if required
  [../]

  # Tee at HX primary outlet: to pipe_ref and pipe4
  [./HX_primary_to_pipe_ref_and_pipe4]
    type = PBBranch
    from = 'HX primary side'
    to = 'pipe_ref pipe4'
    area = 0.01267             # m^2
    junction_type = tee
    # MISSING: explicit port mapping for 3-way junction (main/run/branch)
    # MISSING: loss coefficients for tee junction (if required)
  [../]

  [./pipe4_to_pipe5]
    type = PBBranch
    from = pipe4
    to = pipe5
    area = 0.01267             # m^2
    # MISSING: port specification if required
  [../]

  [./pipe5_to_downcomer]
    type = PBBranch
    from = pipe5
    to = deowncomer
    area = 0.01267             # m^2
    # MISSING: port specification if required
  [../]

[]

[Preconditioning]
  # MISSING: Preconditioner selection/tuning for this coupled thermal-hydraulics network.
[]

[Postprocessors]
  # MISSING: Requested outputs not specified; add mass flow, pressures, temperatures as needed.
[]

[Executioner]
  type = Transient
  # MISSING: start_time, end_time, dt, solver settings
  # Example placeholders (must be confirmed):
  start_time = 0.0
  end_time = 1.0            # MISSING: desired simulation duration
  dt = 1e-3                 # MISSING: desired timestep
  solve_type = PJFNK
[]

[Outputs]
  exodus = false
  csv = true
  print_linear_residuals = false
[]
