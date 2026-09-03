# Strict ABTR k=2 audit

The strict audit counts the two Q2 clad-to-fuel misattributions as false-positive, unsupported parameter claims and numerical errors. It accepts `every branch2 outlet leg` as equivalent to the reference wording `all/each branch2 outlet legs`. No API calls or raw-output changes were made.

## RAG metrics

| Evidence Recall@2 | CoP | CiP | CiH | HR |
|---:|---:|---:|---:|---:|
| 0.938 +/- 0.000 | 0.946 +/- 0.000 | 0.933 +/- 0.000 | 0.933 +/- 0.000 | 0.035 +/- 0.000 |

## Parameter metrics

| Precision | Recall | F1 | Unit accuracy | Mean relative error | Max relative error | Assumption/HR |
|---:|---:|---:|---:|---:|---:|---:|
| 0.946 +/- 0.000 | 0.946 +/- 0.000 | 0.946 +/- 0.000 | 1.000 +/- 0.000 | 0.269 +/- 0.000 | 2.329 +/- 0.000 | 0.035 +/- 0.000 |
