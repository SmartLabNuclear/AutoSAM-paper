# Test case details

Per-case artifacts for the four AutoSAM test cases. Case descriptions and figures are in the [top-level README](../README.md#test-cases).

Every case folder has the same layout:

| Subfolder | Contents |
| --- | --- |
| `prompts/` | The user prompts driving the two generation stages, verbatim |
| `intermediate_file/` | The structured intermediate YAML representation (the human-in-the-loop checkpoint) |
| `input_file/` | The generated SAM input deck, and — for ABTR and MSRE — the manually developed reference deck |
| `source_documents/` | The documents supplied to the agent |
| `simulation_results/` | Plots and CSV output from running the generated deck |

Absolute local paths in the prompts and traces have been replaced with `<AUTOSAM_ROOT>`. Nothing else was altered.

## The two-stage prompt structure

Generation runs in two prompted stages, matching the workflow figure:

1. **Stage 1 — intermediate representation.** The agent is directed to inspect the working directory and apply every applicable input-processing tool: `CSVandEXCELFileReaderTool` for spreadsheets, `PDFProcessorTool` with focused queries for material properties, initial and boundary conditions, components, junctions, heat sources, geometry, discretization, and topology; `ImageAnalysisTool` for component placement, connections, flow directions, and boundary locations; `TextFileReaderTool` for text, JSON, and YAML sources. It must not use a pre-existing generated SAM input or intermediate file as a source. The result is valid YAML recording, for each value, its source file and page, sheet, row, or image. **Missing engineering information must be left `null` with the gap explained — not silently invented.**

2. **Stage 2 — input file.** Working from the reviewed intermediate representation, the agent reads the YAML, calls `IntermediateFileToInputFileTool` for SAM-generation guidance, and transfers the documented definitions without changing their meaning. Every unresolved value or analyst-approved assumption must be commented in the deck. Required sections are `GlobalParams`, `Functions`, `EOS`, `MaterialProperties`, `Components`, `Preconditioning`, `Postprocessors`, `Executioner`, and `Outputs` where applicable, with every component endpoint attached exactly once to another component or an appropriate boundary condition. The saved candidate is then checked with `SAMInputFileValidatorTool`, corrected if necessary, and re-validated.

---

## [`01_pipe/`](01_pipe/) — Pipe model from a structured document

Steady-state one-meter vertical sodium pipe, adiabatic outer wall. Structured input only.

| | |
| --- | --- |
| Prompts | `stage_1_intermediate_prompt.txt`, `stage_2_input_prompt.txt` |
| Intermediate file | `pipe_regression_test.yaml` |
| Input file | `sam_model_autosam.i` |
| Source documents | `Pipe_regression_test.csv` |
| Simulation results | `T.png`, `P.png`, `V.png`, `rho.png`, `pipe.csv` |

## [`02_pke/`](02_pke/) — Solid-fuel temperature reactivity feedback

Heated flow channel with fuel and cladding solid regions, transient inlet-temperature ramp (628.15 K → 728.15 K over 10 s), negative reactivity feedback coefficient. Structured input only.

| | |
| --- | --- |
| Prompts | `stage_1_intermediate_prompt.txt`, `stage_2_input_prompt.txt` |
| Intermediate file | `pke_intermediate.yaml` |
| Input file | `sam_model_autosam.i` |
| Source documents | `pke.xlsx` |
| Simulation results | `Fuel_T.jpeg`, `Reactivity.jpeg`, `sam_model_csv.csv` |

## [`03_abtr/`](03_abtr/) — Advanced Burner Test Reactor core

Five parallel heated channels between splitting and merging junctions, 250 MW total, sodium coolant. Multi-modal input: schematic image + PDF + spreadsheet.

| | |
| --- | --- |
| Prompts | `stage_1_intermediate_prompt.txt`, `stage_2_input_prompt.txt` |
| Intermediate file | `intermediate_ABTR.yaml` |
| Input file | `sam_model_autosam.i` (generated), `sam_model_manual_reference.i` (manual reference) |
| Source documents | `ABTR_case.pdf`, `ABTR_schematic.png`, `model_specifications.xlsx` |
| Simulation results | `T.png`, `P.png`, `v.png`, `rho.png`, `ABTR_results_plotting.csv` |

The generated deck's header comments record the explicit assumptions the agent made and flagged — the sodium EOS selection, gravity vector, element counts, and radial heat-structure mesh — each traceable to a `null` in the intermediate YAML.

## [`04_msre/`](04_msre/) — Molten Salt Reactor Experiment primary loop

Closed loop: inlet plenum, heated core, upper plenum, pipes, pump, heat-exchanger primary side, downcomer. Secondary side represented by boundary conditions. Multi-modal input: layout image + PDF + spreadsheet.

| | |
| --- | --- |
| Prompts | `stage_1_intermediate_prompt.txt`, `stage_2_input_prompt.txt`, `stage_2_retry_prompt.txt` |
| Intermediate file | `msre_intermediate.yaml` |
| Input file | `sam_model_autosam.i` (generated), `sam_model_manual_reference.i` (manual reference) |
| Source documents | `MSRE_case.pdf`, `MSRE_system_layout.png`, `MSRE_specifications.xlsx` |
| Simulation results | `core_T.png`, `HX_T.png`, `P.png`, `plot.csv` |

`stage_2_retry_prompt.txt` is the validation retry issued after the first stage-2 attempt hit a validator path error; it regenerates from the same valid intermediate YAML. Both are included because the cost and runtime reported for MSRE cover the retry.

Values in the generated deck marked `ASSUMED` were not explicitly provided in the source files and were chosen to make the model executable — the traceability mechanism the evaluation's assumption/hallucination rate measures.
