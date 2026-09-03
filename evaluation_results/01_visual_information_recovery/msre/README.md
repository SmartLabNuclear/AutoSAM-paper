# MSRE visual recovery

Original run ID: `20260813T203816Z_vision_gpt56sol_strict`

Three fixed-setting runs of GPT-5.6 Sol over the MSRE system-layout schematic. The image, the description prompt, the `gpt-4o-mini` structuring stage, and the benchmark facts were held constant across runs; a strict coordinate-label scorer requires exact normalized aliases and forbids substring matches such as `CH1 start` against `Branch 1 start`.

## What is reported from here

**The MSRE row: ViR 0.818 ± 0.079** — 17, 20, and 17 of 22 required visual facts.

## Files

| File | Contents |
| --- | --- |
| `manifest.json` | Configuration, source-run hashes, resolved models, environment, completion state |
| `report.md` | Summary and the remaining failures |
| `raw/run_01`…`run_03` | The prompt, exact image description, structured geometry response, token usage, latency, and per-fact scores |
| `item_scores.csv` | One row per visual fact per run, 66 rows |
| `run_summary.csv` | Per-run ViR |
| `aggregate_summary.json` | Mean, sample standard deviation, token and latency totals |
| `failure_audit.md` | Every fact not recovered, per run |

## How a fact is scored

Each run makes two calls. GPT-5.6 Sol describes the schematic in prose; `gpt-4o-mini` then converts that prose into structured geometry — coordinates, component endpoints, and lengths — under an instruction not to invent anything the description does not state. Each benchmark fact is matched against that structure, and ViR is the fraction matched. Because scoring runs on the structured output, a fact present in the description but not lifted by the structuring stage is counted as not recovered; `image_description` in each raw log preserves the description verbatim so the two stages can be separated.
