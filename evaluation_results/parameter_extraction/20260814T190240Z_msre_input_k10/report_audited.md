# Audited AutoSAM MSRE input-parameter RAG evaluation (k=10)

The original raw outputs were rescored without new API calls. The audit canonicalizes LaTeX math wrappers, multiplication-sign spacing, and the target PDF's `Hastelloy(r) N` spelling. It does not supply any missing answer value or alter retrieval.

| Evidence Recall@10 | CoP | CiP | CiH | HR | Exact-answer rate | Noise citation rate | Retrieved-noise fraction |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 0.933 +/- 0.000 | 0.889 +/- 0.000 | 0.974 +/- 0.044 | 0.800 +/- 0.000 | 0.000 +/- 0.000 | 0.800 +/- 0.000 | 0.000 +/- 0.000 | 0.740 +/- 0.000 |

Questions 13-15 remain incorrect because the relevant Table 7 rows are absent from AutoSAM's stored target text; Question 15 also failed to retrieve target page 4 at k=10. Repeated properties across questions are intentional but are not independent facts.
