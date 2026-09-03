# AutoSAM GPT-5.6 Sol vision evaluation

Run ID: `20260813T203816Z_vision_gpt56sol_strict`  
Completed: `2026-08-13T20:38:16.073049Z`  

GPT-5.6 Sol replaced the GPT-4o image-description call. The images, description prompt, GPT-4o-mini structuring stage, and benchmark facts were preserved. The upgraded request used the Responses API, medium reasoning, and original image detail. A stricter coordinate-label scorer was applied identically to the preserved GPT-4o and GPT-5.6 raw logs; it requires exact normalized aliases and forbids substring matches such as `CH1 start` to `Branch 1 start`.

Because the endpoint and image-detail setting changed with the model migration, the comparison evaluates the upgraded GPT-5.6 Sol vision configuration; it is not a strictly model-only causal ablation.

| Case | GPT-4o baseline ViR | GPT-5.6 Sol ViR | Absolute change | Sol recoveries by run |
|---|---:|---:|---:|---:|
| ABTR | 0.178 +/- 0.038 | 0.533 +/- 0.240 | +0.356 | 5, 7, 12/15 |
| MSRE | 0.621 +/- 0.507 | 0.818 +/- 0.079 | +0.197 | 17, 20, 17/22 |
| Pooled | 0.441 +/- 0.317 | 0.703 +/- 0.097 | +0.261 | 22, 27, 29/37 |

## Traceability

- `manifest.json`: configuration, source hashes, resolved models, environment, and completion state.
- `events.jsonl`: timestamped API and evaluation events, including any retries.
- `raw/`: prompts, exact descriptions, structured responses, token usage, latency, and fact scores for every case and run.
- `item_scores.csv`: one row for each visual fact in each run.
- `run_summary.csv`: run-level ABTR, MSRE, and pooled ViR.
- `aggregate_summary.json`: means, sample standard deviations, token totals, and latency totals.
- `baseline_comparison.json`: machine-readable comparison with the preserved GPT-4o result bundle.

The benchmark ground truth was reconstructed from included artifacts and requires domain-expert signoff before publication.

Neither source run was modified, no API request was repeated during strict rescoring, and the source manifest hashes are recorded in `manifest.json`.
