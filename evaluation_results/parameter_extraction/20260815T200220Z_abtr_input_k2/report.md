# AutoSAM ABTR input-parameter RAG evaluation (k=2)

Run ID: `20260815T200220Z_abtr_input_k2`  
Completed: `2026-08-15T20:03:27.210570Z`  

The benchmark contains 15 user-designed input-parameter questions and 37 scored atomic reference claims. The corpus contains three target page chunks and 41 chunks from one related distractor PDF. All questions are answerable in the rendered ABTR_case.pdf. All required values are present in the stored authoritative target text.

| Evidence Recall@10 | CoP | CiP | CiH | HR | Exact-answer rate | Noise citation rate | Retrieved-noise fraction |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 0.938 +/- 0.000 | 0.937 +/- 0.016 | 1.000 +/- 0.000 | 0.933 +/- 0.000 | 0.000 +/- 0.000 | 0.911 +/- 0.038 | 0.000 +/- 0.000 | 0.267 +/- 0.000 |

Repeated properties across the user-supplied questions are intentional but are not independent facts. Ground truth requires domain-expert signoff before publication.

## Traceability

- `manifest.json`: model, configuration, corpus, benchmark, and source hashes.
- `retrieval/rankings.json`: exact top-2 rankings, distances, and target/noise composition.
- `raw/`: retrieved text, prompts, raw outputs, parsed outputs, usage, and claim-level audit decisions.
- `item_scores.csv`, `run_summary.csv`, and `aggregate_summary.json`: item, run, and aggregate scores.
- `failure_audit.md`: every non-perfect or otherwise flagged response.
