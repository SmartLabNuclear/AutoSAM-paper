# Test case 2 — Solid-fuel temperature reactivity feedback

A single heated flow channel with concentric solid regions representing fuel and cladding, adding heat conduction in the solids and a temperature-dependent reactivity feedback model on top of the 1-D fluid equations. Internal volumetric power is zero, which isolates the feedback mechanism. Structured spreadsheet input only.

A transient inlet boundary condition ramps the coolant temperature linearly from 628.15 K to 728.15 K over 10 s. With a negative feedback coefficient prescribed, the reactivity feedback should decrease smoothly and monotonically, and both fuel temperature and feedback should approach steady values after the ramp ends.

| File | Contents |
| --- | --- |
| `prompts/stage_1_intermediate_prompt.txt` | Prompt driving extraction into the intermediate YAML |
| `prompts/stage_2_input_prompt.txt` | Prompt driving SAM deck generation from the reviewed YAML |
| `intermediate_file/pke_intermediate.yaml` | The intermediate representation |
| `input_file/autosam_generated.i` | The generated SAM deck, including the point-kinetics and heat-structure blocks |
| `source_documents/pke.xlsx` | The spreadsheet supplied to the agent |
| `simulation_results/fuel_temperature.jpeg` | Fuel temperature through the inlet-temperature ramp |
| `simulation_results/reactivity_feedback.jpeg` | Total reactivity feedback — smooth, monotonic, settling after the ramp |
| `simulation_results/simulation_output.csv` | Raw postprocessor output behind the plots |

Compared against a manually developed deck in [`../../evaluation_results/03_manual_model_comparison/`](../../evaluation_results/03_manual_model_comparison/): total reactivity feedback agrees to 1.7×10⁻⁹ %.
