# MSRE input-parameter extraction at *k* = 10

Original run ID: `20260814T190240Z_msre_input_k10`

15 input-parameter questions, three fixed-setting runs of `gpt-5.6-sol` at temperature 0. The corpus holds 6 target pages from `MSRE_case.pdf` and 65 distractor pages from *Experience with the Molten-Salt Reactor Experiment* (20) and a NEAMS MSRE report (45); at *k* = 10 the model sees 14.1 % of the corpus per question, and on average **74 % of the pages it retrieves are distractors**.

## Reported numbers — use the `_audited` files

| | RAG row | Parameter row |
| --- | --- | --- |
| **File** | `aggregate_summary_audited.json` | `parameter_metrics_aggregate_audited.json` |
| **Values** | evidence recall@10 0.933, CoP 0.889, CiP 0.974 ± 0.044, CiH 0.800, HR 0.000, noise citation rate 0.000 | precision 1.000, recall 0.889, F1 0.941, unit accuracy 1.000, MRE 0.000, AHR 0.000 |

The audit canonicalizes LaTeX math wrappers, multiplication-sign spacing, and the target PDF's `Hastelloy(r) N` spelling. **It supplies no missing answer value and does not alter retrieval** — every corrected item was already right on the substance and wrong only on formatting.

## The failure mode is ingestion, not generation

Questions 13–15 fail in all three runs. The relevant Table 7 rows are **absent from the stored target text**: a dense multi-column table was incompletely transcribed when the PDF was ingested, so the core flow area (0.3512 m²), downcomer hydraulic diameter (0.0508 m), and core length (1.7272 m) never entered the vector store. Q15 additionally failed to retrieve target page 4 at *k* = 10.

No retrieval depth could have recovered these values. That is why precision and AHR are perfect while recall is 0.889 — the model correctly declined to invent what was not there. The three values were later supplied from `MSRE_specifications.xlsx`; see the provenance table in the [top-level README](../../../README.md#representative-parameter-provenance).

## Files

| File | Contents |
| --- | --- |
| `manifest.json` | Models, `top_k = 10`, corpus composition, vector-store build, benchmark and script SHA-256 |
| `retrieval/rankings.json` | The top-10 ranking per question: chunk IDs, distance, target/noise role, evidence recall. No chunk text, no model answers |
| `raw/run_NN/MSRE_INPUT_K10/msre_param_NN.json` | One API call: retrieved chunks with text, the `user_prompt` (question plus the rendered evidence blocks), unmodified response, parsed claims, usage, latency, per-claim scoring |
| `events.jsonl` | Chronological event log |
| `report.md` / `report_audited.md` | Automated summary, then **the audit narrative — read that one** |
| `failure_audit.md` / `failure_audit_audited.md` | The flagged responses; the audited version shows the 9 flagged of 45, all from Q13–Q15 |
| `item_scores.csv` / `item_scores_audited.csv` | One row per question per run |
| `run_summary.csv` / `run_summary_audited.csv` | One row per run |
| `aggregate_summary.json` / `aggregate_summary_audited.json` | Mean ± SD across runs |
| `parameter_metrics_per_run_audited.csv` | Parameter TP/FP/FN and derived metrics per run |
| `parameter_metrics_aggregate_audited.json` | Aggregated parameter metrics |
| `parameter_metrics_report_audited.md` | Parameter-metric summary |
| `parameter_metrics_uncertainty_audited.json` | Finite-sample uncertainty intervals on the parameter metrics |
| `rag_finite_sample_intervals_audited.json` | Finite-sample intervals on the RAG metrics |
| `rag_uncertainty_report_audited.md` | Narrative for the two uncertainty files — the honest read on how much 15 questions × 3 runs can support |
| `manuscript_results.tex` / `manuscript_results_audited.tex` | The generated LaTeX tables |

Small standard deviations here reflect **repeatability under fixed conditions**, not a claim of general stability: the store, embeddings, questions, rankings, prompts, and settings were all held constant and generation ran at temperature 0.
