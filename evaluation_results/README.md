# Evaluation results (raw data)

Raw scoring records backing the numbers reported in the [top-level README](../README.md#evaluation). Each run directory is preserved as produced, so aggregates can be traced back to individual model responses.

Absolute local paths in prompts, manifests, and traces have been replaced with `<AUTOSAM_ROOT>`. No scores, responses, or metadata were altered.

## Common run-directory layout

Most run directories share a structure:

| File | Contents |
| --- | --- |
| `manifest.json` | Run configuration: model, settings, benchmark, corpus, retrieval depth |
| `raw/run_01`…`run_03` | Per-run model responses, unmodified |
| `item_scores.csv` | Per-item scoring decisions |
| `run_summary.csv` | Per-run metric totals |
| `aggregate_summary.json` | Mean and standard deviation across the three runs |
| `report.md` | Human-readable summary |
| `failure_audit.md` | Itemized account of what failed and why |
| `manuscript_results.tex` | The generated table as it appears in the manuscript |
| `events.jsonl` | Chronological event log for the run |
| `retrieval/` | Retrieved chunks and rankings, where the analysis involved RAG |

Files carrying an `_audited` or `_strict` suffix are the manually audited or strictly rescored versions. **Where both exist, the audited/strict variant is the one reported.**

---

## [`visual_information_recovery/`](visual_information_recovery/)

Backs the **ViR** tables. Two images, 15 required visual facts for ABTR and 22 for MSRE, three runs each.

- **`20260813T203816Z_vision_gpt56sol_strict/`** — the GPT-4o vs. GPT-5.6 Sol comparison, strictly rescored. Source of the reported **MSRE ViR = 0.818 ± 0.079** and the model-comparison table. `baseline_strict_*` files hold the GPT-4o baseline; `baseline_comparison.json` holds the paired deltas.
- **`20260813T205353Z_abtr_vision_source_aligned/`** — ABTR rescored against a source-aligned benchmark, giving **ViR = 1.000 ± 0.000** with case-specific instructions. `benchmark_correction.json` records the benchmark corrections applied and why.

## [`parameter_extraction/`](parameter_extraction/)

These two run directories back **both** reported tables — the RAG table (evidence recall@*k*, CoP, CiP, CiH, HR) and the parameter-extraction table (precision, recall, F1, unit accuracy, MRE, AHR) — because a single run produces both. The `aggregate_summary*` files carry the RAG metrics; the `parameter_metrics_*` files carry the parameter-extraction metrics.

Both runs used `gpt-5.6-sol` at temperature 0 with `text-embedding-3-large`, three runs each, 15 questions per case. `manifest.json` records the corpus composition, retrieval depth, the immutable vector-store build the run reused, and the benchmark SHA-256.

- **`20260815T200220Z_abtr_input_k2/`** — ABTR at retrieval depth *k* = 2 over a 44-page corpus (3 target pages from `ABTR_case.pdf`, 41 distractor pages from a related ABTR design report).
  - **Reported RAG row: `aggregate_summary_strict_audited.json`** — evidence recall@2 0.938, CoP 0.946, CiP 0.933, CiH 0.933, HR 0.035, noise citation rate 0.000, retrieved-noise fraction 0.267.
  - **Reported parameter row: `parameter_metrics_strict_aggregate.json`** — precision 0.946, recall 0.946, F1 0.946, unit accuracy 1.000, MRE 0.269, AHR 0.035.
  - `strict_audit_report.md` documents the audit. The failure is the substitution of cladding thermal conductivity and heat capacity for the corresponding fuel properties after retrieval missed the fuel-property page.
- **`20260814T190240Z_msre_input_k10/`** — MSRE at *k* = 10 over a 71-page corpus (6 target pages from `MSRE_case.pdf`, 65 distractor pages from *Experience with the Molten-Salt Reactor Experiment* and a NEAMS MSRE report).
  - **Reported RAG row: `aggregate_summary_audited.json`** — evidence recall@10 0.933, CoP 0.889, CiP 0.974 ± 0.044, CiH 0.800, HR 0.000, noise citation rate 0.000, retrieved-noise fraction 0.740.
  - **Reported parameter row: `parameter_metrics_aggregate_audited.json`** — precision 1.000, recall 0.889, F1 0.941, unit accuracy 1.000, MRE 0.000, AHR 0.000.
  - `failure_audit_audited.md` documents the three ingestion-related false negatives — core flow area, downcomer hydraulic diameter, and core length absent from the vector store because a dense multi-column table was incompletely transcribed at ingestion.

Each directory's `retrieval/rankings.json` holds the retrieved chunks and their rankings for every question, so evidence recall and citation scoring can be recomputed. The MSRE directory additionally carries finite-sample uncertainty intervals (`parameter_metrics_uncertainty_audited.json`, `rag_finite_sample_intervals_audited.json`, `rag_uncertainty_report_audited.md`).

## [`ablation_study/`](ablation_study/)

Backs the ablation table. GPT-5.2, three runs per configuration per case.

- **`audited_rescore/`** — **the reported source.** `run_summary.csv` has one row per (configuration, case, run) with `required_block_fraction` (standard-section coverage), `component_recall`, `parameter_precision`/`recall`/`f1`, `topology_recall`/`precision`, plus counts of explicit-missing and assumption markers and latency. `aggregate_summary.json` holds the means and SDs; `audited_results.md` is the narrative.
- **`component_ablation_run/`** — the generation run the rescore was computed over. `raw/` has one subfolder per configuration (`full_pipeline_existing`, `llm_only`, `no_image_processing`, `no_intermediate_file`, `no_validator`, `validator_repair`), matching the layout of `audited_rescore/scores/`. `benchmarks/` holds the reference component, parameter, and topology sets; `source_packets/` holds the inputs given to each configuration; `seeded_inputs/` holds the deliberately defective decks (`ABTR_connectivity_defect.i`, `MSRE_connectivity_defect.i`) and their seed scores; `review_stage/` holds the intermediate-review artifacts; `all_scores.json` holds every scored item.

Note that `no_image_processing` appears in the raw data but is not in the reported table.

## [`manual_model_comparison/`](manual_model_comparison/)

Backs the manual-vs-AutoSAM output table.

- **`output_comparison_summary.csv`** — the reported comparison: case, output quantity, manual value, AutoSAM value, relative difference.
- **`abtr/`, `msre/`, `pke/`** — paired `manual_reference_out.csv` and `autosam_out.csv` postprocessor output from each pair of decks.
- **`pipe/`** — `autosam_out.csv`; the pipe comparison reduces to a single scalar (outlet fluid temperature), which agrees with the manual value to within numerical precision.

The decks that produced these outputs are in [`../test_cases/*/input_file/`](../test_cases/).

## [`cost_and_runtime/`](cost_and_runtime/)

Backs the token / runtime / cost table.

- **`four_case_cost_runtime_summary_20260822.json`** — the reported summary. Records scope (prebuilt PDF retrieval stores; spreadsheet parsing, image analysis, intermediate-YAML generation, input generation, and validator review included; SAM execution and one-time PDF indexing excluded), model (`gpt-5.2-2025-12-11`), environment, the per-million-token pricing used, and per-case input/cached/uncached/output/embedding tokens, wall time, tool-call counts, and estimated cost.
- **`traces/{Pipe,PKE,ABTR,MSRE}/`** — the full generation trace per case: both stage prompts and responses, `stage_*_steps.json` with every tool call and its output, `stage_*_usage_timing.json` with token and latency accounting, and `case_summary.json`. The MSRE folder additionally contains the `stage_2_retry_*` files; the MSRE cost figure includes both the first validator path error and the successful two-call retry from the same valid intermediate YAML.
