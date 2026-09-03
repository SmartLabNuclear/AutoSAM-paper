# Test case 3 — Advanced Burner Test Reactor (ABTR) core model

The first case requiring unstructured, multi-modal sources: a schematic image encoding system topology, and a PDF containing boundary conditions, material properties, and operating parameters, alongside a spreadsheet.

Sodium enters an upstream pipe, splits through a junction into five parallel vertical channels, then recombines through a second junction into an outlet pipe discharging to a fixed-pressure boundary. Inlet velocity and temperature are 3.25 m/s and 628 K; outlet pressure is 0.1 MPa. A total of 250 MW is distributed among the five channels, each with a simplified solid region enabling conjugate heat transfer.

Three physics-based checks: uneven flow distribution among the five channels (branch hydraulic resistances differ), monotonic pressure decrease from friction and junction form losses, and coolant temperature rise through the heated channels.

| File | Contents |
| --- | --- |
| `prompts/stage_1_intermediate_prompt.txt` | Prompt driving multi-modal extraction into the intermediate YAML |
| `prompts/stage_2_input_prompt.txt` | Prompt driving SAM deck generation from the reviewed YAML |
| `intermediate_file/intermediate_ABTR.yaml` | The intermediate representation; unresolved fields are left `null` |
| `input_file/autosam_generated.i` | The generated SAM deck |
| `input_file/manual_reference.i` | The independently developed manual deck used for output comparison |
| `source_documents/ABTR_case.pdf` | The authoritative case document (3 pages) |
| `source_documents/ABTR_schematic.png` | The system schematic; the only source of topology and geometry |
| `source_documents/model_specifications.xlsx` | Supplementary structured specifications |
| `simulation_results/temperature.png` | Channel temperature rise |
| `simulation_results/pressure.png` | Pressure decrease along the flow path |
| `simulation_results/velocity.png` | Per-channel velocity — shows the uneven flow split |
| `simulation_results/density.png` | Density field |
| `simulation_results/simulation_output.csv` | Raw postprocessor output behind the plots |

**A documented retrieval failure and its correction.** During initial extraction, the RAG stage failed to retrieve the 250 MW reactor power stated in the source document, and the preliminary model used a default of 1 W. The agent **explicitly labeled this value as an assumption** and directed the user to verify it. The omission was caught during review of the intermediate representation and corrected before simulation. All results here use the corrected model — this is the intended function of the intermediate-file checkpoint.

The generated deck's header comments record the other explicit assumptions the agent flagged — the sodium EOS selection, gravity vector, element counts, and radial heat-structure mesh — each traceable to a `null` in the intermediate YAML. The full list of 19 `null` fields this case exposes before generation is in [`../../evaluation_results/04_ablation_study/review_stage/ABTR_missing_parameters.json`](../../evaluation_results/04_ablation_study/review_stage/ABTR_missing_parameters.json).

## Where this case appears in the evaluation

| Analysis | Result |
| --- | --- |
| [Visual information recovery](../../evaluation_results/01_visual_information_recovery/) | ViR 1.000 ± 0.000 over 15 required facts |
| [RAG and parameter extraction](../../evaluation_results/02_rag_and_parameter_extraction/abtr_k2/) | Precision 0.946, recall 0.946, F1 0.946 at *k* = 2 |
| [Manual-model comparison](../../evaluation_results/03_manual_model_comparison/) | Core temperature rise within 0.019 %, mass flow within 0.088 % |
| [Ablation study](../../evaluation_results/04_ablation_study/) | Full pipeline vs. LLM-only, no-intermediate-file, no-validator |
| [Cost and runtime](../../evaluation_results/05_cost_and_runtime/) | 4.87 min, $0.94 |
