# Source-aligned ABTR vision evaluation

Run ID: `20260813T205353Z_abtr_vision_source_aligned`  
Completed: `2026-08-13T20:53:53.397022Z`  

The original ABTR evaluation benchmark reversed six endpoint labels. The included YAML and SAM input define each component position as its start, use orientation `(0, 0, -1)`, connect `Pipe2(out)` to the channel inputs at Branch2, and connect channel outputs to `Pipe1(in)` at Branch1. This audit applies those source-aligned labels identically to all three preserved configurations. No API calls were repeated and no source logs were changed.

| Configuration | ABTR ViR, mean +/- SD | Recoveries by run |
|---|---:|---:|
| GPT-4o baseline | 0.156 +/- 0.038 | 3, 2, 2/15 |
| GPT-5.6 Sol, generic prompt | 0.333 +/- 0.067 | 4, 5, 6/15 |
| GPT-5.6 Sol, ABTR instructions | 1.000 +/- 0.000 | 15, 15, 15/15 |

The source-aligned result should replace the endpoint-reversed score, subject to domain-expert confirmation of the included source files.

## Traceability

- `manifest.json`: source run paths and hashes, raw-log hashes, benchmark and scorer hashes, and no-API-call flags.
- `raw/`: immutable copies of all nine scored ABTR raw logs.
- `item_scores.csv`: exact fact-level matches for all configurations and repeats.
- `run_summary.csv` and `aggregate_summary.json`: run and aggregate ViR.
- `benchmark_correction.json`: the six original labels/values and their source-aligned replacements.