# ABTR visual recovery

Original run ID: `20260813T205353Z_abtr_vision_source_aligned`

Two GPT-5.6 Sol configurations scored over the ABTR schematic against 15 required visual facts, three runs each. Scoring uses the endpoint convention defined by the case source files (`intermediate_ABTR.yaml`, confirmed against `ABTR_5channel_min_working.i`): a component position is its start, and the orientation vector `(0, 0, -1)` with the length defines its end.

## What is reported from here

**The ABTR row: ViR 1.000 ± 0.000** — 15 of 15 facts in each of three runs, using the ABTR-instructed configuration.

| Configuration | ABTR ViR | Recoveries by run |
| --- | :---: | :---: |
| GPT-5.6 Sol, generic prompt | 0.333 ± 0.067 | 4, 5, 6 / 15 |
| **GPT-5.6 Sol, ABTR instructions** | **1.000 ± 0.000** | 15, 15, 15 / 15 |

**Read those two rows together.** They use the same images, the same scorer, and the same structuring stage. The only difference is that the instructed configuration is told how to read the schematic — dashed lines are branch links, circular dots are boundary conditions, some endpoints must be inferred from connected components, and each length must be computed. The reported 1.000 depends on supplying that schematic-convention knowledge, not on vision alone.

## Files

| File | Contents |
| --- | --- |
| `manifest.json` | Source-run paths and hashes, raw-log hashes, benchmark and scorer hashes, no-API-call flags |
| `benchmark_correction.json` | The endpoint labels this benchmark applies and the source files that define them |
| `report.md` | Summary and the two-configuration table |
| `raw/gpt56_generic/` | Three logs under the generic prompt |
| `raw/gpt56_abtr_instructions/` | Three logs under ABTR-specific instructions — the reported configuration |
| `item_scores.csv` | Exact fact-level matches for both configurations and all repeats, 90 rows |
| `run_summary.csv`, `aggregate_summary.json` | Run and aggregate ViR |
| `manuscript_results.tex` | The generated LaTeX table |
