# MSRE visual recovery

Original run ID: `20260813T203816Z_vision_gpt56sol_strict`

One GPT-5.6 Sol configuration scored over the MSRE system-layout schematic against 22 required visual facts, three runs. A strict coordinate-label scorer requires exact normalized aliases and forbids substring matches such as `pipe1 end` against `pipe1 start`.

## What is reported from here

**The MSRE row: ViR 0.818 ± 0.079** — 17, 20, and 17 of 22 required visual facts.

| Configuration | MSRE ViR | Recoveries by run |
| --- | :---: | :---: |
| GPT-5.6 Sol, generic prompt | 0.818 ± 0.079 | 17, 20, 17 / 22 |

⚠️ **This is the generic-prompt configuration.** The ABTR case in [`../abtr_source_aligned/`](../abtr_source_aligned/) reports 1.000 from an *instructed* configuration, whose description prompt additionally explains the schematic conventions. Under its generic prompt ABTR scores 0.333. No instructed MSRE configuration has been run, so the two reported case values do not come from matched prompts, and the pooled 0.892 combines them.

## Files

| File | Contents |
| --- | --- |
| `manifest.json` | Configuration, source-run hashes, resolved models, environment, completion state |
| `report.md` | Summary and the remaining failures |
| `raw/gpt56_generic/` | Three logs: the prompt, the exact image description, the structured geometry response, token usage, latency, and per-fact scores |
| `item_scores.csv` | Exact fact-level matches for all repeats, 66 rows |
| `run_summary.csv`, `aggregate_summary.json` | Run and aggregate ViR |
| `manuscript_results.tex` | The generated LaTeX table |

## Remaining failures

Both heat-exchanger secondary coordinates, the reference-pressure coordinate, the core-bottom coordinate, and most component lengths were recovered consistently. The remaining errors were swapped or incomplete endpoint assignments: the pipe4 endpoint and the downcomer top were each recovered in only one run, and some explicit coordinates were omitted in run 3. Pipe5 length was incorrect in one run, and the pipe3 and heat-exchanger lengths were each missed once.

A single incorrect coordinate or component length changes the resulting SAM geometry, so a ViR of 0.818 does not support treating vision as a sufficient source of model geometry. It supports supplying structured component metadata directly where it exists and reserving visual interpretation as complementary verification.

## How a fact is scored

Each run makes two calls. GPT-5.6 Sol describes the schematic in prose; `gpt-4o-mini` then converts that prose into structured geometry — coordinates, component endpoints, and lengths — under an instruction not to invent anything the description does not state. Each benchmark fact is matched against that structure, and ViR is the fraction matched. Because scoring runs on the structured output, a fact present in the description but not lifted by the structuring stage counts as not recovered; `image_description` in each raw log preserves the description verbatim so the two stages can be separated.
