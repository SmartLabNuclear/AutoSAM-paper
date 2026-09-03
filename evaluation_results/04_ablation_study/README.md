# 5. Ablation study

Backs the [ablation table](../../README.md#ablation-study). Test cases 3 and 4 repeated with `gpt-5.2`, three runs per ablated configuration, one pipeline stage disabled at a time.

Run ID: `20260903T185135Z_component_ablation`.

## What every configuration is given

**Each ablated configuration receives the same source documentation and must extract the model specifications and parameters from it**: the case PDF, the specification spreadsheet, and the schematic description. No value is supplied pre-extracted, and nothing presented to the model is derived from the reference input deck or from the intermediate representation. The exact material is in [`source_packets/`](source_packets/).

## Configurations

| Configuration | Pipeline change |
|---|---|
| `full_pipeline_existing` | No components removed. Uses the existing full-pipeline artifact, with one run per case. |
| `llm_only` | Removes retrieval, the intermediate representation, validation, and the SAM-specific system instructions. The documentation is supplied under a general-purpose system instruction. |
| `no_intermediate_file` | Removes the intermediate representation. The documentation is passed directly to input generation, which extracts and writes the deck in a single step. |
| `no_validator` | Removes connectivity and section-presence validation. Each case contains a seeded connectivity defect. |
| `validator_repair` | Removes no components. Validator diagnostics are returned to the agent, separating defect detection from defect correction. |

## Results

Mean ± SD over three runs.

| Configuration | Case | Standard sections | Component recall | Parameter F1 | Topology recall |
| --- | --- | :---: | :---: | :---: | :---: |
| Full pipeline | ABTR | 0.889 | 1.000 | 1.000 | 1.000 |
| | MSRE | 1.000 | 1.000 | 1.000 | 1.000 |
| LLM only | ABTR | 0.593 ± 0.064 | 0.750 ± 0.000 | 0.287 ± 0.015 | 0.000 ± 0.000 |
| | MSRE | 0.556 ± 0.000 | 0.375 ± 0.000 | 0.429 ± 0.071 | 0.091 ± 0.157 |
| No intermediate file | ABTR | 1.000 ± 0.000 | 0.917 ± 0.000 | 0.334 ± 0.053 | 0.000 ± 0.000 |
| | MSRE | 1.000 ± 0.000 | 0.375 ± 0.000 | 0.477 ± 0.010 | 0.000 ± 0.000 |
| No validator | ABTR | 0.889 ± 0.000 | 1.000 ± 0.000 | 1.000 ± 0.000 | 0.900 ± 0.000 |
| | MSRE | 1.000 ± 0.000 | 0.958 ± 0.000 | 0.990 ± 0.000 | 0.909 ± 0.000 |
| Validator repair | ABTR | 0.889 ± 0.000 | 1.000 ± 0.000 | 1.000 ± 0.000 | 1.000 ± 0.000 |
| | MSRE | 1.000 ± 0.000 | 1.000 ± 0.000 | 1.000 ± 0.000 | 1.000 ± 0.000 |

## What the ablation shows

**LLM only.** Recovered 0.287 (ABTR) and 0.429 (MSRE) of the reference parameters and generated 0.593 and 0.556 of the nine standard SAM sections. Its failures are concentrated in solver-specific knowledge rather than engineering content: it emits plausible but incorrect MOOSE class names for SAM component types — `Pipe1Phase` for `PBOneDFluidComponent`, `Channel1Phase` for `PBCoreChannel` in all ten ABTR components — and omits `EOS`, `MaterialProperties`, `Postprocessors`, and `Preconditioning` in every run. It never instantiates the ABTR reactor-power and boundary components, or fifteen MSRE components including the heat exchanger and every junction.

**No intermediate file.** Adding the SAM-specific system instructions restores the section structure completely, at 1.000 for both cases, but not the content. Parameter F1 stays at 0.334 and 0.477, and topology recall is 0.000 in every run. Component recall improves for ABTR, from 0.750 to 0.917, but not for MSRE. Extracting, reconciling, and transferring properties, geometry, units, names, boundary conditions, and connections from heterogeneous documentation while simultaneously emitting SAM syntax leaves the deck structurally complete and substantively incomplete.

Read together, these two rows separate the two contributions: **the solver-specific instructions supply the section scaffold, and the intermediate representation is what parameter transfer and topology depend on.**

**No validator.** Unaffected by the extraction pathway, since it operates on the reference deck carrying a seeded defect. ABTR loses the branch-to-channel connection, leaving nine of ten edges at 0.900; MSRE loses one pipe-junction block, leaving ten of eleven at 0.909, and because that block also carries component and parameter information, component recall and parameter F1 decrease accordingly. **The agent never identified or corrected either defect on its own.** Given the validator's specific diagnosis, it repaired all six seeded defects across both cases and three runs.

## Limitation

The full-pipeline artifacts **define the structural reference**, so their component, parameter, and topology scores are 1.000 by construction and are not an independent accuracy estimate. The table should be read as a comparison among the ablated configurations, not as a measurement of full-pipeline accuracy. Section coverage measures presence only — the ABTR reference itself omits the optional `[Postprocessors]` section without becoming invalid. The seeded defects are disclosed, deliberate, and single: they isolate validator effectiveness and say nothing about how often such defects arise naturally. SAM execution was not part of this harness.

## Files

| Path | Contents |
| --- | --- |
| `report.md` | Auto-generated summary table |
| `aggregate_summary.json` | Mean and SD per configuration and case, every metric |
| `run_summary.csv` | One row per (configuration, case, run) |
| `all_scores.json` | Every scored item |
| `manifest.json` | Model, settings, source hashes, and the design notes for this run |
| `raw/<configuration>/<CASE>/run_NN/` | `prompt.txt`, `raw_response.txt`, `generated.i`, `api.json`, `score.json` |
| `benchmarks/` | Reference component, parameter, and topology sets |
| `source_packets/*_documentation_nonvisual.txt` | The case PDF text plus the spreadsheet table, as supplied |
| `source_packets/*_documentation_visual.txt` | The schematic description, as supplied |
| `seeded_inputs/` | The deliberately defective decks and their scores |
| `review_stage/` | The `null` fields the intermediate file exposes before generation — 19 paths for ABTR, 0 for MSRE |

Scores here need no separate audit pass: the harness parser handles legacy MOOSE `[./name]` and `[../]` block notation, which the earlier run's scorer did not. Re-scoring all 32 items reproduced them exactly.

## Withdrawn arm

A sixth configuration, `no_image_processing`, was executed but is not published. Its runs, scores, and aggregate rows are removed here. The token and API-call totals in `manifest.json` cover the full six-arm run.
