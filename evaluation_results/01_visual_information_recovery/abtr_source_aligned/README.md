# ABTR visual recovery — source-aligned rescore

Original run ID: `20260813T205353Z_abtr_vision_source_aligned`

The original ABTR benchmark reversed six endpoint labels. The included YAML and SAM deck define each component position as its *start*, use orientation `(0, 0, −1)`, connect `Pipe2(out)` to the channel inputs at Branch2, and connect the channel outputs to `Pipe1(in)` at Branch1. This audit applies those source-aligned labels identically to all three preserved configurations. **No API calls were repeated and no source log was changed.**

## What is reported from here

**The ABTR row: ViR 1.000 ± 0.000** — 15 of 15 facts in each of three runs, using case-specific instructions.

| Configuration | ABTR ViR | Recoveries by run |
| --- | :---: | :---: |
| GPT-4o baseline | 0.156 ± 0.038 | 3, 2, 2 / 15 |
| GPT-5.6 Sol, generic prompt | 0.333 ± 0.067 | 4, 5, 6 / 15 |
| **GPT-5.6 Sol, ABTR instructions** | **1.000 ± 0.000** | 15, 15, 15 / 15 |

The spread across these three rows is the point: the same images and the same scorer give ViR from 0.156 to 1.000 depending on the model and how specifically it is instructed.

## Files

| File | Contents |
| --- | --- |
| `manifest.json` | Source-run paths and hashes, raw-log hashes, benchmark and scorer hashes, no-API-call flags |
| `benchmark_correction.json` | The six original labels and values, and their source-aligned replacements — read this to see exactly what the correction changed |
| `report.md` | Summary and the three-configuration table |
| `raw/gpt4o_baseline/` | The three preserved GPT-4o raw logs |
| `raw/gpt56_generic/` | The three GPT-5.6 Sol logs under a generic prompt |
| `raw/gpt56_abtr_instructions/` | The three GPT-5.6 Sol logs under ABTR-specific instructions — the reported configuration |
| `item_scores.csv` | Exact fact-level matches for all configurations and repeats |
| `run_summary.csv`, `aggregate_summary.json` | Run-level and aggregate ViR |
| `events.jsonl` | Chronological event log |
| `manuscript_results.tex` | The generated LaTeX table |
