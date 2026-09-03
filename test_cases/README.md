# Test cases

Per-case artifacts for the four AutoSAM test cases. Case descriptions and figures are in the [top-level README](../README.md#test-cases).

| Case | Sources | What it tests |
| --- | --- | --- |
| [`01_pipe/`](01_pipe/) | spreadsheet | Baseline: 1-D flow component, boundary conditions, steady state |
| [`02_pke/`](02_pke/) | spreadsheet | Coupled multiphysics: solid conduction + point kinetics, transient BC |
| [`03_abtr/`](03_abtr/) | PDF + image + spreadsheet | Multi-modal extraction, five parallel channels, conjugate heat transfer |
| [`04_msre/`](04_msre/) | PDF + image + spreadsheet | Closed circulating loop, multiple component types, topology reconstruction |

## Layout

Every case folder has the same five subfolders:

| Subfolder | Contents |
| --- | --- |
| `prompts/` | The user prompts driving the two generation stages, verbatim |
| `intermediate_file/` | The structured intermediate YAML representation — the human-in-the-loop checkpoint |
| `input_file/` | `autosam_generated.i`, the generated SAM deck; for ABTR and MSRE also `manual_reference.i`, the independently developed manual deck |
| `source_documents/` | The documents supplied to the agent, under the names the agent saw. For ABTR and MSRE, a `distractor_corpus/` subfolder holds the related-document noise used only in the retrieval evaluation — those were never inputs to model generation |
| `simulation_results/` | Plots and `simulation_output.csv` from running the generated deck |

Two naming conventions are worth knowing before you browse:

- **Source documents and intermediate files keep their original names.** They appear verbatim inside the generation traces in [`../evaluation_results/05_cost_and_runtime/traces/`](../evaluation_results/05_cost_and_runtime/traces/) and inside generated decks, so renaming them would break that correspondence. This is why the intermediate files are `pipe_regression_test.yaml`, `pke_intermediate.yaml`, `intermediate_ABTR.yaml`, and `msre_intermediate.yaml` rather than one uniform pattern.
- **Post-hoc artifacts are named for what they hold.** Generated decks and plots are named uniformly across cases (`autosam_generated.i`, `temperature.png`, `pressure.png`, …); nothing else in the repository refers to them by name.

Absolute local paths in the prompts have been replaced with `<AUTOSAM_ROOT>`. Nothing else was altered.

## The two-stage prompt structure

Generation runs in two prompted stages, matching the workflow figure:

1. **Stage 1 — intermediate representation.** The agent is directed to inspect the working directory and apply every applicable input-processing tool: `CSVandEXCELFileReaderTool` for spreadsheets; `PDFProcessorTool` with focused queries for material properties, initial and boundary conditions, components, junctions, heat sources, geometry, discretization, and topology; `ImageAnalysisTool` for component placement, connections, flow directions, and boundary locations; `TextFileReaderTool` for text, JSON, and YAML sources. It must not use a pre-existing generated SAM input or intermediate file as a source. The result is valid YAML recording, for each value, its source file and page, sheet, row, or image. **Missing engineering information must be left `null` with the gap explained — not silently invented.**

2. **Stage 2 — input file.** Working from the reviewed intermediate representation, the agent reads the YAML, calls `IntermediateFileToInputFileTool` for SAM-generation guidance, and transfers the documented definitions without changing their meaning. Every unresolved value or analyst-approved assumption must be commented in the deck. Required sections are `GlobalParams`, `Functions`, `EOS`, `MaterialProperties`, `Components`, `Preconditioning`, `Postprocessors`, `Executioner`, and `Outputs` where applicable, with every component endpoint attached exactly once to another component or an appropriate boundary condition. The saved candidate is then checked with `SAMInputFileValidatorTool`, corrected if necessary, and re-validated.

## Where each case is used in the evaluation

| Case | Appears in |
| --- | --- |
| Pipe, PKE | [manual-model comparison](../evaluation_results/03_manual_model_comparison/), [cost and runtime](../evaluation_results/05_cost_and_runtime/) |
| ABTR, MSRE | all five analyses in [`../evaluation_results/`](../evaluation_results/) |
