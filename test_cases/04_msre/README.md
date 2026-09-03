# Test case 4 — Molten Salt Reactor Experiment (MSRE) primary loop

A system-level circulating loop spanning core, plenums, pump, heat exchanger, and connecting piping, with information distributed across a layout image, a PDF, and user-provided structured data.

The primary loop runs through an inlet plenum, a heated core segment, an upper plenum, connecting pipes, a pump, and the primary side of a heat exchanger, returning through additional piping and a downcomer to close the loop. The secondary coolant-salt side is represented by inlet/outlet boundary conditions. A volumetric heat source in the core raises the primary-salt temperature; heat is removed in the exchanger.

Validation criteria: hottest temperatures near the core outlet, a measurable primary-side temperature drop across the heat exchanger, a secondary-side temperature rise, and a self-consistent loop temperature profile once transients decay.

| File | Contents |
| --- | --- |
| `prompts/stage_1_intermediate_prompt.txt` | Prompt driving multi-modal extraction into the intermediate YAML |
| `prompts/stage_2_input_prompt.txt` | Prompt driving SAM deck generation from the reviewed YAML |
| `prompts/stage_2_retry_prompt.txt` | The validation retry issued after the first stage-2 attempt hit a validator path error; it regenerates from the same valid intermediate YAML. Included because the reported MSRE cost and runtime cover the retry |
| `intermediate_file/msre_intermediate.yaml` | The intermediate representation |
| `input_file/autosam_generated.i` | The generated SAM deck; values marked `ASSUMED` were not in the sources and were chosen to make the model executable |
| `input_file/manual_reference.i` | The independently developed manual deck used for output comparison |
| `source_documents/MSRE_case.pdf` | The authoritative case document (6 pages) |
| `source_documents/MSRE_system_layout.png` | The loop layout; the only source of connectivity and segment coordinates |
| `source_documents/MSRE_specifications.xlsx` | Structured specifications, including the geometry that retrieval could not recover from the PDF |
| `simulation_results/core_temperature.png` | Temperature rise through the heated core |
| `simulation_results/heat_exchanger_temperature.png` | Primary-side drop and secondary-side rise across the exchanger |
| `simulation_results/pressure.png` | Loop pressure distribution |
| `simulation_results/simulation_output.csv` | Raw postprocessor output behind the plots |

The `ASSUMED` markers in the generated deck are the traceability mechanism that the evaluation's assumption/hallucination rate measures.

## Where this case appears in the evaluation

| Analysis | Result |
| --- | --- |
| [Visual information recovery](../../evaluation_results/01_visual_information_recovery/) | ViR 0.818 ± 0.079 over 22 required facts; the two failures were an omitted downcomer-top coordinate and a wrong pipe-5 length |
| [RAG and parameter extraction](../../evaluation_results/02_rag_and_parameter_extraction/msre_k10/) | Precision 1.000, recall 0.889, F1 0.941 at *k* = 10; the three misses are ingestion-related, not generation errors |
| [Manual-model comparison](../../evaluation_results/03_manual_model_comparison/) | Up to 12.669 % on primary mass flow, from the single-component heat-exchanger approximation |
| [Ablation study](../../evaluation_results/04_ablation_study/) | Full pipeline vs. LLM-only, no-intermediate-file, no-validator |
| [Cost and runtime](../../evaluation_results/05_cost_and_runtime/) | 5.83 min, $0.87, including the retry |
