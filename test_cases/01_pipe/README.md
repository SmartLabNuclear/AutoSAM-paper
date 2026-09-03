# Test case 1 — Pipe model from a structured document

Steady-state one-meter vertical sodium pipe with an adiabatic outer wall. Boundary conditions are a prescribed inlet velocity and temperature with a fixed outlet pressure, giving single-phase forced-convection flow. Structured spreadsheet input only — no PDF or image processing.

Because the wall is adiabatic and no volumetric heating is applied, the energy balance implies an axially uniform temperature field. This gives three direct validation criteria: outlet bulk temperature equals inlet temperature, wall temperature equals fluid temperature everywhere, and pressure decreases monotonically along the flow direction from friction.

| File | Contents |
| --- | --- |
| `prompts/stage_1_intermediate_prompt.txt` | Prompt driving extraction into the intermediate YAML |
| `prompts/stage_2_input_prompt.txt` | Prompt driving SAM deck generation from the reviewed YAML |
| `intermediate_file/pipe_regression_test.yaml` | The intermediate representation, with each value tagged by source |
| `input_file/autosam_generated.i` | The generated SAM deck |
| `source_documents/Pipe_regression_test.csv` | The spreadsheet supplied to the agent |
| `simulation_results/temperature.png` | Axial fluid temperature — flat, as expected for an adiabatic wall |
| `simulation_results/pressure.png` | Axial pressure — monotonic decrease from friction |
| `simulation_results/velocity.png` | Axial velocity |
| `simulation_results/density.png` | Axial density |
| `simulation_results/simulation_output.csv` | Raw postprocessor output behind the plots |

Compared against a manually developed deck in [`../../evaluation_results/03_manual_model_comparison/`](../../evaluation_results/03_manual_model_comparison/): outlet fluid temperature agrees to 9.6×10⁻¹¹ %.
