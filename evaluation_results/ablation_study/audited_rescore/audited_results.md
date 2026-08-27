# Audited AutoSAM ablation results

## Protocol

- Cases: ABTR and MSRE.
- Model: `gpt-5.2`, resolved as `gpt-5.2-2025-12-11` in every API response.
- Repetitions: three per ablated configuration. The previously generated full-pipeline artifact is retained as a single existing reference for each case.
- API trace: 30 completed calls, 104,460 prompt tokens, 96,183 completion tokens, and no truncated or mismatched-model responses.
- Deterministic metrics: required-block coverage, reference-component recall, reference-parameter precision/recall/F1, and reference-topology recall.

## Results

Values are mean $\pm$ sample standard deviation across three runs. A dash denotes the single existing full-pipeline artifact, for which run-to-run variation is unavailable.

| Configuration | Case | Required blocks | Component recall | Parameter F1 | Topology recall |
|---|---|---:|---:|---:|---:|
| Existing full pipeline | ABTR | 0.889 (single run) | 1.000 | 1.000 | 1.000 |
| Existing full pipeline | MSRE | 1.000 (single run) | 1.000 | 1.000 | 1.000 |
| LLM-only, complete prompt | ABTR | 0.556 $\pm$ 0.000 | 1.000 $\pm$ 0.000 | 1.000 $\pm$ 0.000 | 1.000 $\pm$ 0.000 |
| LLM-only, complete prompt | MSRE | 0.556 $\pm$ 0.000 | 1.000 $\pm$ 0.000 | 1.000 $\pm$ 0.000 | 1.000 $\pm$ 0.000 |
| No image processing | ABTR | 1.000 $\pm$ 0.000 | 0.694 $\pm$ 0.096 | 0.380 $\pm$ 0.055 | 0.000 $\pm$ 0.000 |
| No image processing | MSRE | 1.000 $\pm$ 0.000 | 0.333 $\pm$ 0.000 | 0.283 $\pm$ 0.007 | 0.000 $\pm$ 0.000 |
| No intermediate file | ABTR | 1.000 $\pm$ 0.000 | 0.917 $\pm$ 0.000 | 0.591 $\pm$ 0.085 | 0.000 $\pm$ 0.000 |
| No intermediate file | MSRE | 1.000 $\pm$ 0.000 | 0.431 $\pm$ 0.400 | 0.393 $\pm$ 0.330 | 0.000 $\pm$ 0.000 |
| No validator | ABTR | 0.889 $\pm$ 0.000 | 1.000 $\pm$ 0.000 | 1.000 $\pm$ 0.000 | 0.900 $\pm$ 0.000 |
| No validator | MSRE | 1.000 $\pm$ 0.000 | 0.958 $\pm$ 0.000 | 0.990 $\pm$ 0.000 | 0.909 $\pm$ 0.000 |
| Validator repair | ABTR | 0.889 $\pm$ 0.000 | 1.000 $\pm$ 0.000 | 1.000 $\pm$ 0.000 | 1.000 $\pm$ 0.000 |
| Validator repair | MSRE | 1.000 $\pm$ 0.000 | 1.000 $\pm$ 0.000 | 1.000 $\pm$ 0.000 | 1.000 $\pm$ 0.000 |

## Interpretation

The LLM-only baseline was deliberately generous: its prompt supplied all reference material properties, dimensions, boundary conditions, and connections. It therefore recovered the supplied parameters and topology, but produced only five of the nine required top-level SAM sections in every run. This separates access to complete case data from the framework's input-assembly workflow.

Removing image processing eliminated recovery of the reference connections in both cases. The non-image intermediate representations explicitly flagged an average of 19.7 missing parameters for ABTR and 11.7 for MSRE. These fields included component coordinates, lengths, boundary attachments, and topology, making the information gap visible before generation.

Direct document-to-input generation without the intermediate checkpoint reduced parameter F1 to 0.591 for ABTR and 0.393 for MSRE, and none of the reference connection sets was reproduced completely. By contrast, the retained intermediate file exposes 19 null ABTR fields for user inspection before input generation. This supports the intermediate representation as a parameter-completeness checklist and a point where the user can supply corrections before the final input is written.

The validator test used a disclosed seeded defect to isolate validator effectiveness. Removing `CH5(in)` from the ABTR inlet branch reduced topology recall to 0.900, while removing the MSRE `pipe4(out) -> pipe5(in)` junction reduced it to 0.909. GPT-5.2 restored the intended connection in all three validator runs for both cases, returning topology recall to 1.000.

## Limitations

The existing full-pipeline artifacts define the structural reference, so their parameter and topology scores are 1.000 by construction and should not be interpreted as an independent accuracy estimate. The validator result measures repair of a controlled connectivity defect, not the natural frequency of such defects. SAM execution was not part of this ablation harness; the study evaluates input structure, parameters, and connectivity.
