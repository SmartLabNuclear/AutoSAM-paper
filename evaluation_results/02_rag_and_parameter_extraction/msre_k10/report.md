# AutoSAM MSRE input-parameter RAG evaluation (k=10)

Run ID: `20260814T190240Z_msre_input_k10`  
Completed: `2026-08-14T19:15:40.103691Z`  

The benchmark contains 15 user-designed input-parameter questions and 27 scored atomic reference claims. The corpus contains six target page chunks and 65 chunks from two related distractor PDFs. All questions are answerable in the rendered MSRE_case.pdf. Table 7 is truncated in AutoSAM's stored target text, so Questions 13-15 test the complete ingestion-retrieval-answering pipeline.

| Evidence Recall@10 | CoP | CiP | CiH | HR | Exact-answer rate | Noise citation rate | Retrieved-noise fraction |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 0.933 +/- 0.000 | 0.778 +/- 0.000 | 0.974 +/- 0.044 | 0.800 +/- 0.000 | 0.000 +/- 0.000 | 0.600 +/- 0.000 | 0.000 +/- 0.000 | 0.740 +/- 0.000 |

Repeated properties across the user-supplied questions are intentional but are not independent facts. Ground truth requires domain-expert signoff before publication.

## Traceability

- `manifest.json`: model, configuration, corpus, benchmark, and source hashes.
- `retrieval/rankings.json`: exact top-10 rankings, distances, and target/noise composition.
- `raw/`: retrieved text, prompts, raw outputs, parsed outputs, usage, and claim-level audit decisions.
- `item_scores.csv`, `run_summary.csv`, and `aggregate_summary.json`: item, run, and aggregate scores.
- `failure_audit.md`: every non-perfect or otherwise flagged response.
