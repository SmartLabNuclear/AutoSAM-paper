# Ablation generation run

The run that produced every deck the ablation scores. Its own scoring is **superseded** — see [`../audited_scores/`](../audited_scores/) for the reported numbers.

Original run ID: `20260815T212712Z_component_ablation`. Model `gpt-5.2`, resolved as `gpt-5.2-2025-12-11` in every response. The run made 30 API calls in total; the token and call counts recorded in `manifest.json` cover the withdrawn `no_image_processing` arm as well as the six published ones.

| Path | Contents |
| --- | --- |
| `manifest.json` | Run configuration and source hashes |
| `report_preaudit.md` | The pre-audit summary table. **Superseded** — kept so the effect of the audit is visible |
| `aggregate_summary.json`, `run_summary.csv`, `all_scores.json` | Pre-audit scoring, likewise superseded |
| `raw/<configuration>/<CASE>/run_NN/` | One generation: `prompt.txt`, `raw_response.txt`, `generated.i`, `api.json` (usage and model), and `score_preaudit.json` |
| `benchmarks/ABTR_benchmark.json`, `benchmarks/MSRE_benchmark.json` | The reference component, parameter, and topology sets everything is scored against |
| `source_packets/*_llm_only_complete_spec.txt` | The complete engineering specification handed to the `llm_only` baseline — read this to see how generous that baseline was |
| `source_packets/*_visual.txt`, `*_nonvisual.txt` | The image-derived and non-image source records supplied to the other configurations |
| `seeded_inputs/ABTR_connectivity_defect.i`, `MSRE_connectivity_defect.i` | The deliberately defective decks used in the no-validator test |
| `seeded_inputs/*_seed_score.json` | The score of each seeded deck, confirming the defect is the only difference: ABTR loses `pipe2(out) → ch5` and drops to topology recall 0.900 with parameters still at 1.000 |
| `review_stage/ABTR_missing_parameters.json`, `MSRE_missing_parameters.json` | The `null` fields the intermediate file exposes before generation — 19 paths for ABTR, 0 for MSRE. This is the parameter-completeness checklist the ablation credits the intermediate file for |

`raw/` mirrors the configuration layout of [`../audited_scores/scores/`](../audited_scores/scores/), so any deck can be placed beside both its pre-audit and audited score.
