# ABTR input-parameter extraction at *k* = 2

Original run ID: `20260815T200220Z_abtr_input_k2`

15 input-parameter questions, 37 scored atomic reference claims, three fixed-setting runs of `gpt-5.6-sol` at temperature 0. The corpus holds 3 target pages from `ABTR_case.pdf` and 41 distractor pages from a related ABTR design report; at *k* = 2 the model sees 4.5 % of the corpus per question.

## Reported numbers — use the `_audited` files

| | RAG row | Parameter row |
| --- | --- | --- |
| **File** | `aggregate_summary_audited.json` | `parameter_metrics_aggregate_audited.json` |
| **Values** | evidence recall@2 0.938, CoP 0.946, CiP 0.933, CiH 0.933, HR 0.035 | precision 0.946, recall 0.946, F1 0.946, unit accuracy 1.000, MRE 0.269, AHR 0.035 |

The automated scorer accepted the Q2 answer as unsupported-but-not-wrong. The audit re-scores the two values `26 W/(m·K)` and `638 J/(kg·K)` as **cladding properties misattributed to `fuel-mat`**, counting them as false positives *and* numerical errors. The difference is large enough to matter:

| | Automated | Audited (reported) |
| --- | :---: | :---: |
| Precision | 1.000 | 0.946 |
| Recall | 0.937 | 0.946 |
| F1 | 0.967 | 0.946 |
| Unit accuracy | 0.818 | 1.000 |
| Mean relative error | 0.000 | 0.269 |
| Assumption/HR | 0.000 | 0.035 |

`report_audited.md` documents the audit; `audit_manifest.json` records that no API call was made and no raw output changed.

## Files

| File | Contents |
| --- | --- |
| `manifest.json` | Models, `top_k = 2`, corpus composition, the immutable 44-chunk vector store reused, benchmark and script SHA-256, package versions |
| `retrieval/rankings.json` | The top-2 ranking for each of the 15 questions: chunk IDs, cosine distance, target/noise role, required-evidence match, `EvidenceRecallAt2`. **No chunk text and no model answers** |
| `raw/run_NN/ABTR_INPUT_K2/abtr_param_NN.json` | One API call in full: retrieved chunks *with text*, exact system and user prompts, unmodified response, parsed claims, token usage, latency, and per-claim scoring |
| `events.jsonl` | 100-event timeline: retrieval once, then 3 runs × 15 questions |
| `report.md` | Automated summary |
| `report_audited.md` | **The audit narrative — read this first** |
| `audit_manifest.json` | What the audit changed, and the SHA-256 of each artifact it wrote |
| `failure_audit.md` | The 4 flagged responses out of 45, each classified and linked to its raw log |
| `item_scores.csv` / `item_scores_audited.csv` | One row per question per run |
| `run_summary.csv` / `run_summary_audited.csv` | One row per run |
| `aggregate_summary.json` / `aggregate_summary_audited.json` | Mean ± SD across runs, plus token and latency totals |
| `parameter_metrics_per_run.csv` / `..._per_run_audited.csv` | Parameter TP/FP/FN and derived metrics per run |
| `parameter_metrics_aggregate.json` / `..._aggregate_audited.json` | Aggregated parameter metrics, with metric definitions inline |
| `parameter_metrics_report.md` | Automated parameter-metric summary |
| `parameter_metrics_manifest.json` | Provenance for the parameter-metric computation |
| `manuscript_results.tex` | The generated LaTeX table. ⚠️ Its column header reads `Evidence recall@10` because the table generator was shared with the *k* = 10 MSRE run; the values are the *k* = 2 values |

## Tracing one number end to end

`retrieval/rankings.json` → the prompt and response in `raw/run_01/ABTR_INPUT_K2/abtr_param_02.json` → the row in `item_scores_audited.csv` → the aggregate in `aggregate_summary_audited.json`. The retrieved chunk IDs are identical across all three runs because retrieval ran once; only generation was repeated.
