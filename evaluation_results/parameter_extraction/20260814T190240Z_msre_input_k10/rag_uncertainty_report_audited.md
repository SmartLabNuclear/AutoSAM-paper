# Audited finite-sample uncertainty for MSRE input-parameter RAG (k=10)

| Metric | Mean +/- SD over three runs | Unique-opportunity estimate [95% Wilson interval] |
|---|---:|---:|
| EvidenceRecallAt10 | 0.933 +/- 0.000 | 0.933 [0.702, 0.988] |
| CoP | 0.889 +/- 0.000 | 0.889 [0.719, 0.961] |
| CiP | 0.974 +/- 0.044 | 1.000 [0.758, 1.000] |
| CiH | 0.800 +/- 0.000 | 0.800 [0.548, 0.930] |
| HR | 0.000 +/- 0.000 | 0.000 [0.000, 0.133] |
| ExactAnswerRate | 0.800 +/- 0.000 | 0.800 [0.548, 0.930] |
| NoiseCitationRate | 0.000 +/- 0.000 | 0.000 [0.000, 0.242] |

The Wilson intervals use the first complete set of 15 unique questions and do not triple-count repetitions. CiP varied in run 2 because one abstaining response emitted an unsupported citation; its run-to-run SD is therefore nonzero. Repeated parameter facts across questions are not independent, so these intervals are approximate benchmark-scale uncertainty rather than deployment guarantees.
