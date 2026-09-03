# Evaluation results

Raw scoring records backing every number in the [top-level README](../README.md#evaluation). Directories are numbered in the order the analyses appear there.

| Directory | Backs | Headline result |
| --- | --- | --- |
| [`01_visual_information_recovery/`](01_visual_information_recovery/) | Analysis 1 | Pooled ViR **0.892 ± 0.047** over 37 required visual facts |
| [`02_rag_and_parameter_extraction/`](02_rag_and_parameter_extraction/) | Analyses 2 and 3 | Pooled evidence recall **0.935**; parameter F1 **0.944**, unit accuracy **1.000** |
| [`03_manual_model_comparison/`](03_manual_model_comparison/) | Analysis 4 | Pipe/PKE agree to numerical precision; ABTR ≈ 1 %; MSRE up to 12.7 % |
| [`04_ablation_study/`](04_ablation_study/) | Analysis 5 | Removing the intermediate file drops parameter F1 to 0.591/0.393 and topology recall to 0 |
| [`05_cost_and_runtime/`](05_cost_and_runtime/) | Cost table | Under 6 min and below $1 per case |

Analyses 2 and 3 share one directory because a single run produces both the RAG metrics and the parameter-extraction metrics.

## Reading the two-tier scoring

**This is the one convention to learn before opening anything.** Most analyses were scored twice: once by the automated scorer at run time, and once by a manual audit that corrected specific scoring decisions. Both are published so the audit itself is inspectable.

| Name pattern | Meaning |
| --- | --- |
| `<name>.<ext>` | Automated scoring produced at run time. **Superseded wherever an audited counterpart exists.** |
| `<name>_audited.<ext>` | The manually audited rescore. **This is what the paper reports.** |
| `audit_manifest.json`, `rescore_manifest.json` | What the audit changed, why, and the SHA-256 of every artifact it wrote |

Every audit was performed offline: **no API call was repeated and no raw model output was altered.** The audit manifests record `api_calls_made: false`.

## Common run-directory layout

| Path | Contents |
| --- | --- |
| `manifest.json` | Run configuration: model, settings, benchmark, corpus, retrieval depth, source hashes |
| `retrieval/rankings.json` | Which chunks the vector search returned, with rank, distance, and target/noise role — no model answers |
| `raw/` | One file per question per run: the question prompt with its retrieved evidence, retrieved text, unmodified model output, token usage, latency, per-claim scoring |
| `item_scores.csv` | One row per scored item per run |
| `run_summary.csv` | One row per run |
| `aggregate_summary.json` | Mean and standard deviation across the three runs |
| `report.md` | Human-readable summary |
| `failure_audit.md` | Itemized account of every non-perfect response |
| `events.jsonl` | Chronological event log |
| `manuscript_results.tex` | The generated LaTeX table |

**`retrieval/` versus `raw/`.** Retrieval is deterministic — one fixed vector store, fixed embeddings, fixed *k* — so it was executed **once** and its output reused by all three runs. Only generation was repeated. This is why evidence recall has zero standard deviation while answer-level metrics do not; the retrieved chunk IDs in every `raw/run_NN/` file are identical to `retrieval/rankings.json`.

## Provenance notes

- Absolute local paths in prompts, manifests, and traces have been replaced with `<AUTOSAM_ROOT>`. **No score, response, or metadata value was altered.**
- Run directories were renamed from their timestamped run IDs to descriptive names. The original run ID is still recorded inside each directory's `manifest.json`, `report.md`, and scored CSVs, and each directory's README states the mapping.
- Some file names were normalized so the two-tier convention above reads the same everywhere. File **contents** are byte-identical to what the harness produced, so the SHA-256 values recorded in the audit manifests still verify; only the artifact keys in those manifests use the pre-normalization names.
