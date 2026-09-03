# 2 & 3. Retrieval-augmented generation, and parameter extraction

Backs **both** the [RAG table](../../README.md#retrieval-augmented-generation) and the [parameter-extraction table](../../README.md#parameter-extraction) in the top-level README. They share a directory because one run produces both: the `aggregate_summary*` files carry the RAG metrics, the `parameter_metrics_*` files carry the parameter-extraction metrics.

Both runs used `gpt-5.6-sol` at temperature 0 with `text-embedding-3-large`, three runs, 15 questions per case.

| Directory | Case | Corpus | *k* | Corpus seen per question | Original run ID |
| --- | --- | --- | :---: | :---: | --- |
| [`abtr_k2/`](abtr_k2/) | ABTR | 44 pages: 3 target + 41 distractor | 2 | 4.5 % | `20260815T200220Z_abtr_input_k2` |
| [`msre_k10/`](msre_k10/) | MSRE | 71 pages: 6 target + 65 distractor | 10 | 14.1 % | `20260814T190240Z_msre_input_k10` |

The retrieval depths differ deliberately. ABTR's source is compact and preliminary runs at *k* = 3 and *k* = 6 saturated, so *k* = 2 was chosen to avoid a ceiling effect. MSRE's required parameters are spread across all six target pages amid closely related distractors, so *k* = 10 gives a moderate budget. On average 74 % of retrieved MSRE pages were distractors, 26.7 % for ABTR — and in both cases the noise citation rate was **0.000**.

## Reported numbers

| Metric | ABTR | MSRE | Pooled |
| --- | :---: | :---: | :---: |
| Evidence recall@*k* | 0.938 | 0.933 | 0.935 |
| CoP | 0.946 | 0.889 | 0.922 |
| CiP | 0.933 | 0.974 ± 0.044 | 0.951 ± 0.020 |
| CiH | 0.933 | 0.800 | 0.867 |
| HR | 0.035 | 0.000 | 0.024 |
| Parameter precision / recall / F1 | 0.946 / 0.946 / 0.946 | 1.000 / 0.889 / 0.941 | 0.967 / 0.922 / 0.944 |
| Unit accuracy | 1.000 | 1.000 | 1.000 |
| Mean relative error | 0.269 | 0.000 | 0.109 |
| Assumption/HR | 0.035 | 0.000 | 0.024 |

**All of these come from the `_audited` files.** Files without that suffix are the automated pre-audit scoring and are superseded — see the convention in the [parent README](../README.md#reading-the-two-tier-scoring). Pooled values are computed from combined parameter-level counts, not by averaging the two case scores.

## The two cases fail in different ways

- **ABTR** — retrieval did not return the fuel-property page, and the agent substituted **cladding** thermal conductivity and heat capacity for the fuel properties. This single misattribution produces the entire ABTR mean relative error of 0.269 and AHR of 0.035.
- **MSRE** — a dense multi-column table was incompletely transcribed during ingestion. The core flow area, downcomer hydraulic diameter, and core length were therefore **absent from the vector store** and unrecoverable by any retrieval depth. These are ingestion-related false negatives, not generation errors — hence MSRE precision 1.000 and AHR 0.000.
