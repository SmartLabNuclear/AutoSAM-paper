# MSRE visual information recovery

Three fixed-setting runs of GPT-5.6 Sol over the MSRE system-layout schematic, scored against 22 required visual facts.

| Case | Required visual facts | ViR, mean ± SD | Recoveries by run |
|---|---:|---:|---:|
| MSRE | 22 | 0.818 ± 0.079 | 17, 20, 17 / 22 |

GPT-5.6 Sol was called through the Responses API with medium reasoning effort and original image detail under the prompt `Describe this image in detail.`; `gpt-4o-mini` performed the geometry-structuring stage at temperature 0. A strict coordinate-label scorer was applied, requiring exact normalized aliases and forbidding substring matches such as `CH1 start` against `Branch 1 start`.

## Remaining failures

Both heat-exchanger secondary coordinates, the reference-pressure coordinate, the core-bottom coordinate, and most component lengths were recovered consistently. The remaining errors were swapped or incomplete endpoint assignments: the pipe4 endpoint and the downcomer top were each recovered in only one run, and some explicit coordinates were omitted in run 3. Pipe5 length was incorrect in one run, and the pipe3 and heat-exchanger lengths were each missed once.

These failures matter more than the aggregate suggests. A single incorrect coordinate or component length changes the resulting SAM geometry, so a ViR of 0.818 does not support treating vision as a sufficient source of model geometry. It supports supplying structured component metadata directly where it exists and reserving visual interpretation as complementary verification.

## Traceability

- `manifest.json`: configuration, source hashes, resolved models, environment, completion state.
- `raw/run_NN/MSRE.json`: the prompt, the exact image description, the structured geometry response, token usage, latency, and per-fact scores.
- `item_scores.csv`: one row per visual fact per run.
- `run_summary.csv`: per-run ViR.
- `aggregate_summary.json`: mean, sample standard deviation, token and latency totals.
- `failure_audit.md`: every fact not recovered.

No API request was repeated during strict rescoring and the source run was not modified; the source manifest hashes are recorded in `manifest.json`.
