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

**LLM only.** Recovered 0.287 (ABTR) and 0.429 (MSRE) of the reference parameters and generated 0.593 and 0.556 of the nine standard SAM sections.

| Case | Run | Blocks | Comp. recall | Precision | Recall | F1 | Topology | TP | FP | FN |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| ABTR | 1 | 0.556 | 0.750 | 0.464 | 0.220 | 0.299 | 0.000 | 26 | 30 | 92 |
| ABTR | 2 | 0.667 | 0.750 | 0.442 | 0.195 | 0.271 | 0.000 | 23 | 29 | 95 |
| ABTR | 3 | 0.556 | 0.750 | 0.575 | 0.195 | 0.291 | 0.000 | 23 | 17 | 95 |
| MSRE | 1 | 0.556 | 0.375 | 0.750 | 0.226 | 0.347 | 0.000 | 33 | 11 | 113 |
| MSRE | 2 | 0.556 | 0.375 | 0.800 | 0.329 | 0.466 | 0.000 | 48 | 12 | 98 |
| MSRE | 3 | 0.556 | 0.375 | 0.803 | 0.336 | 0.473 | 0.273 | 49 | 12 | 97 |

**Extraction is not what fails.** The decks correctly carry the ABTR form losses `0.1, 0.5, 1.96, 2.16, 4.5, 3500.0` out of the spreadsheet, and even flag the ambiguous `3500.0` as an explicit assumption. Every failure mode is SAM's encoding conventions, and they separate cleanly:

- **Block names.** It emits `[Materials]`, a generic MOOSE block, where SAM expects `[EOS]` and `[MaterialProperties]`, and omits `Preconditioning` and `Postprocessors`. This is the whole of the 0.556-0.667 section coverage.
- **Component type names.** It produces `Pipe1Phase`, `Channel1Phase`, `TDV`, `Branch`, `HeatStructure` — plausible MOOSE-family names, none of them SAM's `PBOneDFluidComponent`, `PBCoreChannel`, `PBTDJ`/`PBTDV`, `PBBranch`. Each wrong `type =` counts as both a false positive and a false negative, which is why ABTR shows 24 TP against 25.3 FP.
- **Connectivity syntax.** SAM joins components with port strings, `inputs = 'Pipe2(out)'` and `outputs = 'CH1(in) CH2(in) ...'`. On ABTR the baseline instead writes per-component references such as `inlet = branch2:main` with `K_main`/`K_leg1..K_leg5` on the branch, and emits **zero** `inputs=`/`outputs=` statements in all three runs, so no reference edge can match. On MSRE it does emit port statements in two of three runs (26 and 32), which is why run 3 is the only baseline run to score any topology at all.

Precision separates the two cases. ABTR sits at 0.44-0.58 because its ten densely typed components each contribute a wrong `type =`; MSRE holds 0.75-0.80 because its misses are absences rather than errors, with fifteen components never instantiated including the heat exchanger and every junction. ABTR's component recall is exactly 0.750 in all three runs — the same three components missing every time, `inlet`, `outlet`, and `reactor`, so the baseline builds the flow path but omits the power and boundary components.

**Read the MSRE spread with care.** F1 moves 0.347, 0.466, 0.473 across runs, and run 3 is the only run in the entire baseline to score any topology at all. Three runs at temperature 1 do not pin that down: `0.429 ± 0.071` is indicative, and `0.091 ± 0.157` has a standard deviation larger than its mean.

**No intermediate file.** This arm differs from `llm_only` only in that it keeps the
SAM-specific system instruction. That restores the section structure completely, at 1.000 for
both cases, but not the content.

| Case | Run | Blocks | Comp. recall | Precision | Recall | F1 | Topology | TP | FP | FN |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| ABTR | 1 | 1.000 | 0.917 | 0.565 | 0.297 | 0.389 | 0.000 | 35 | 27 | 83 |
| ABTR | 2 | 1.000 | 0.917 | 0.476 | 0.254 | 0.331 | 0.000 | 30 | 33 | 88 |
| ABTR | 3 | 1.000 | 0.917 | 0.511 | 0.195 | 0.282 | 0.000 | 23 | 22 | 95 |
| MSRE | 1 | 1.000 | 0.375 | 0.800 | 0.329 | 0.466 | 0.000 | 48 | 12 | 98 |
| MSRE | 2 | 1.000 | 0.375 | 0.820 | 0.342 | 0.483 | 0.000 | 50 | 11 | 96 |
| MSRE | 3 | 1.000 | 0.375 | 0.820 | 0.342 | 0.483 | 0.000 | 50 | 11 | 96 |

Section coverage of 1.000 is close to tautological: the system instruction names all nine blocks
explicitly, so their presence measures compliance rather than modelling skill. The substantive
result is that parameter F1 sits at 0.282-0.483 and topology recall is 0.000 in every run.

The two cases fail differently. ABTR misses only `reactor`, the power component, so it builds the
flow path but not the heat source; the decks carry 27 `# MISSING:` markers and use no SAM `PB*`
component type at all, substituting `Pipe`, `CoreChannel`, `SodiumEOS` and `TDVBoundary`. MSRE
instantiates 27-35 `PB*`-typed components correctly but omits fifteen reference components,
including the heat exchanger, both secondary boundaries, and all eight junctions, and carries 59
`# MISSING:` markers. Its topology recall is zero for a different reason than ABTR's: run 1 emits
26 correct `inputs=`/`outputs=` port statements, but names its junctions differently from the
reference `j_*` components, so no reference edge matches.

**A confound worth stating.** The MSRE arms score higher than the ABTR arms in both ablated
configurations, and the reason is in the source documents rather than in case difficulty:
`MSRE_case.pdf` names two SAM classes, `PBBranch` and `PBOneDFluidComponent`, while `ABTR_case.pdf`
names none. Where the documentation supplies solver vocabulary the ablated model reuses it; where
it does not, the model invents MOOSE-family names. The ABTR-versus-MSRE difference in these rows
should therefore not be read as a property of the cases.

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
