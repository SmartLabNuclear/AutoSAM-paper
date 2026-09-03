
# sam_model.i
# Title: Steady-State Sodium Pipe with Adiabatic Wall
# Description: 1-meter sodium pipe, 20 axial elements, adiabatic wall, fixed inlet velocity/temperature, fixed outlet pressure.
# Measured Quantities: Pipe inlet/outlet temperature, wall average temperature, inlet/outlet energy.

[GlobalParams]
  global_init_P = 1.0e5                # Initial fluid pressure [Pa]
  global_init_V = 1.0                  # Initial fluid velocity [m/s]
  global_init_T = 628.15               # Initial fluid and solid temperature [K]
  scaling_factor_var = '1 1e-3 1e-6'   # Scaling factors for (p, v, T)
  Tsolid_sf = 1e-3                     # Scaling for solid temperature
  gravity = '0 0 -9.8'                 # Gravity vector [m/s^2]
[]
[EOS]
  [eos]
    type = PTConstantEOS
    p_0 = 1.0e5                        # Reference pressure [Pa]
    rho_0 = 865.51                     # Density [kg/m^3]
    beta = 2.7524e-4                   # Thermal expansion [1/K]
    cp = 1272.0                        # Specific heat [J/kg.K]
    h_0 = 7.9898e5                     # Reference enthalpy [J/kg]
    T_0 = 628.15                       # Reference temperature [K]
    mu = 2.6216e-4                     # Viscosity [Pa.s]
    k = 72.0                           # Thermal conductivity [W/m.K]
  []
[]
[MaterialProperties]
  [pipe_wall_mat]
    type = HeatConductionMaterialProps
    k = 20.0                           # Wall thermal conductivity [W/m.K]
    Cp = 300.0                         # Wall specific heat [J/kg.K]
    rho = 5000.0                       # Wall density [kg/m^3]
  []
[]
[Components]
  [pipe]
    type = PBPipe
    eos = eos
    position = '0 0 0'                 # Start at origin
    orientation = '0 0 1'              # Flow in +Z (vertical)
    A = 0.000314                       # Flow area [m^2]
    Dh = 0.02                          # Hydraulic diameter [m]
    length = 1.0                       # Pipe length [m]
    n_elems = 20                       # Axial elements
    f = 0.01                           # Friction factor
    Hw = 10000.0                       # Convective heat transfer coefficient [W/m^2.K]
    Ph = 0.062831853                   # Heated perimeter [m]
    HT_surface_area_density = 3.1415927 # Perimeter/area
    # Wall/heat structure
    dim_wall = 1
    wall_thickness = 0.001             # Wall thickness [m]
    n_wall_elems = 2                   # Wall radial elements
    material_wall = pipe_wall_mat
    Twall_init = 628.15                # Initial wall temperature [K]
    HS_BC_type = Adiabatic             # Adiabatic outer wall
  []
  [inlet]
    type = PBTDJ
    input = 'pipe(in)'
    eos = eos
    v_bc = 1.0                         # Inlet velocity [m/s]
    T_bc = 628.15                      # Inlet temperature [K]
  []
  [outlet]
    type = PBTDV
    input = 'pipe(out)'
    eos = eos
    p_bc = 1.0e5                       # Outlet pressure [Pa]
  []
[]
[Postprocessors]
  [Tin]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = pipe(in)
  []
  [Tout]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = pipe(out)
  []
  [Twall_avg]
    type = HeatStructureElementAverage
    variable = T_solid
    block = 'pipe:solid'
  []
  [Ein]
    type = ComponentBoundaryEnergyBalance
    eos = eos
    input = 'pipe(in) pipe(in)'
  []
  [Eout]
    type = ComponentBoundaryEnergyBalance
    eos = eos
    input = 'pipe(out) pipe(out)'
  []
[]
[Preconditioning]
  [SMP_PJFNK]
    type = SMP
    full = true
    solve_type = 'PJFNK'
    petsc_options_iname = '-pc_type'
    petsc_options_value = 'lu'
  []
[]
[Executioner]
  type = Steady
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-7
  nl_max_its = 20
  l_tol = 1e-5
  l_max_its = 100
  [Quadrature]
    type = TRAP
    order = FIRST
  []
[]
[Outputs]
  perf_graph = true
  [console]
    type = Console
  []
  [out_displaced]
    type = Exodus
    use_displaced = true
    execute_on = 'initial timestep_end'
    sequence = false
  []
  [csv]
    type = CSV
  []
[]
