# MSRE visual recovery, and the GPT-4o vs. GPT-5.6 Sol comparison

Original run ID: `20260813T203816Z_vision_gpt56sol_strict`

GPT-5.6 Sol replaced the GPT-4o image-description call. The images, description prompt, GPT-4o-mini structuring stage, and benchmark facts were preserved. The upgraded request used the Responses API, medium reasoning, and original image detail. A stricter coordinate-label scorer was then applied identically to both preserved raw logs; it requires exact normalized aliases and forbids substring matches such as `CH1 start` matching `Branch 1 start`.

Because the endpoint and image-detail setting changed with the model migration, this evaluates the upgraded GPT-5.6 Sol vision *configuration*. It is not a strictly model-only causal ablation.

## What is reported from here

**The MSRE row: ViR 0.818 ± 0.079** (recoveries 17, 20, 17 of 22).

⚠️ **Do not quote the ABTR value from this directory.** The ABTR figure here (0.533 ± 0.240) was scored against a benchmark that reversed six endpoint labels. The corrected ABTR result is in [`../abtr_source_aligned/`](../abtr_source_aligned/).

## Files

| File | Contents |
| --- | --- |
| `manifest.json` | Configuration, source-run hashes, resolved models, environment, completion state |
| `report.md` | Summary, including the GPT-4o baseline vs. GPT-5.6 Sol table |
| `raw/run_01`…`run_03` | Prompts, exact image descriptions, structured responses, token usage, latency, and per-fact scores for both cases |
| `item_scores.csv` | One row per visual fact per run |
| `run_summary.csv` | Per-run ABTR, MSRE, and pooled ViR |
| `aggregate_summary.json` | Means, sample standard deviations, token and latency totals |
| `baseline_strict_item_scores.csv` | The GPT-4o baseline scored by the same strict scorer |
| `baseline_strict_run_summary.csv` | Per-run GPT-4o baseline ViR |
| `baseline_strict_aggregate.json` | Aggregated GPT-4o baseline ViR |
| `baseline_comparison.json` | Machine-readable paired deltas between the two models |
| `failure_audit.md` | Every fact that was not recovered, per run |
| `events.jsonl` | This rescore's own event log (2 events: rescore started and completed) |
| `events_source_run.jsonl` | The event log of the **upstream generation run** the rescore consumed, kept for provenance |
| `manuscript_results.tex` | The generated LaTeX table |

Neither source run was modified and no API request was repeated during strict rescoring; the source manifest hashes are recorded in `manifest.json`.
