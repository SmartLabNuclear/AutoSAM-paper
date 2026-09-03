# Audited MSRE input-parameter metrics (k=10)

| Metric | Mean +/- SD over three runs | Unique-opportunity 95% Wilson interval |
|---|---:|---:|
| Parameter precision | 1.000 +/- 0.000 | [0.862, 1.000] |
| Parameter recall | 0.889 +/- 0.000 | [0.719, 0.961] |
| Parameter F1 | 0.941 +/- 0.000 | not treated as a binomial proportion |
| Unit accuracy on recovered numeric parameters | 1.000 +/- 0.000 | [0.806, 1.000] |
| Numeric parameter coverage | 0.842 +/- 0.000 | [0.624, 0.945] |
| Mean numerical relative error, recovered values | 0.000 +/- 0.000 | descriptive |
| Assumption/hallucination rate | 0.000 +/- 0.000 | [0.000, 0.133] |

Precision treats an incorrect or unsupported generated parameter claim as a false positive; supported auxiliary statements such as the independent-variable unit are not parameters. Unit accuracy and numerical relative error are conditional on recovered numeric parameters (16/19); the three missing Table 7 parameters are reflected in recall and numeric coverage. The Wilson intervals use one set of unique opportunities and do not triple-count repetitions. Repeated properties across the 15 questions are still not statistically independent, so the intervals are approximate benchmark-scale uncertainty, not deployment guarantees.
