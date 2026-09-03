# Source-aligned ABTR vision evaluation

Run ID: `20260813T205353Z_abtr_vision_source_aligned`
Completed: `2026-08-13T20:53:53.397022Z`

The benchmark applies the endpoint convention defined by the case source files: a component position is its start coordinate, the orientation vector `(0, 0, -1)` and the length define its end, `Pipe2(out)` connects to the channel inputs at Branch2, and the channel outputs connect to `Pipe1(in)` at Branch1. Dashed branch-link indicators are connectivity rather than physical components, and circular dots are boundary conditions. The same labels were applied identically to both preserved configurations. No API calls were repeated and no source log was changed.

| Configuration | ABTR ViR, mean ± SD | Recoveries by run |
|---|---:|---:|
| GPT-5.6 Sol, generic prompt | 0.333 ± 0.067 | 4, 5, 6 / 15 |
| GPT-5.6 Sol, ABTR instructions | 1.000 ± 0.000 | 15, 15, 15 / 15 |

The two rows differ only in the description prompt. The generic configuration is asked to describe the image; the instructed configuration is additionally told how to read the schematic — that dashed lines denote branch links, that circular dots are boundary conditions, that some endpoint coordinates must be inferred from connected endpoints, and to compute each component length. That instruction is what separates 0.333 from 1.000 on the same images under the same scorer.

## Traceability

- `manifest.json`: source run paths and hashes, raw-log hashes, benchmark and scorer hashes, and no-API-call flags.
- `raw/gpt56_generic/`, `raw/gpt56_abtr_instructions/`: the three preserved raw logs per configuration.
- `item_scores.csv`: exact fact-level matches for both configurations and all repeats.
- `run_summary.csv` and `aggregate_summary.json`: run and aggregate ViR.
- `benchmark_correction.json`: the endpoint labels this benchmark applies, and the source files that define them.
