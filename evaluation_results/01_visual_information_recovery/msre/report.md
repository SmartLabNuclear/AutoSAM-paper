# MSRE vision evaluation

Run ID: `20260813T203816Z_vision_gpt56sol_strict`

Three fixed-setting runs of GPT-5.6 Sol over the MSRE system-layout schematic, scored against 22 required visual facts. GPT-5.6 Sol was called through the Responses API with medium reasoning effort and original image detail under the description prompt `Describe this image in detail.`; `gpt-4o-mini` performed the geometry-structuring stage at temperature 0. A strict coordinate-label scorer requires exact normalized aliases and forbids substring matches.

| Configuration | MSRE ViR, mean ± SD | Recoveries by run |
|---|---:|---:|
| GPT-5.6 Sol, generic prompt | 0.818 ± 0.079 | 17, 20, 17 / 22 |

Only the generic description prompt was run for this case. The ABTR evaluation additionally ran an instructed configuration in which the description prompt explains the schematic conventions, and that instruction moved ABTR from 0.333 to 1.000. No equivalent MSRE configuration exists, so this value should not be read as directly comparable to the reported ABTR value.

## Remaining failures

Both heat-exchanger secondary coordinates, the reference-pressure coordinate, the core-bottom coordinate, and most component lengths were recovered consistently. The remaining errors were swapped or incomplete endpoint assignments: the pipe4 endpoint and the downcomer top were each recovered in only one run, and some explicit coordinates were omitted in run 3. Pipe5 length was incorrect in one run, and the pipe3 and heat-exchanger lengths were each missed once.

These failures matter more than the aggregate suggests. A single incorrect coordinate or component length changes the resulting SAM geometry, so a ViR of 0.818 does not support treating vision as a sufficient source of model geometry.

## Traceability

- `manifest.json`: configuration, source hashes, resolved models, environment, completion state.
- `raw/gpt56_generic/run_NN_MSRE.json`: the prompt, the exact image description, the structured geometry response, token usage, latency, and per-fact scores.
- `item_scores.csv`: exact fact-level matches for all repeats.
- `run_summary.csv` and `aggregate_summary.json`: run and aggregate ViR.

No API request was repeated during strict rescoring and the source run was not modified; the source manifest hashes are recorded in `manifest.json`.
