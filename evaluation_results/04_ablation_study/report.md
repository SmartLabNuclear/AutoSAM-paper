# AutoSAM GPT-5.2 component ablation

Model requested: `gpt-5.2`

## Aggregate results

| Condition | Case | n | Blocks | Components | Parameter F1 | Topology recall | Missing markers |
|---|---:|---:|---:|---:|---:|---:|---:|
| full_pipeline_existing | ABTR | 1 | 0.889 | 1.000 | 1.000 | 1.000 | 0.0 |
| full_pipeline_existing | MSRE | 1 | 1.000 | 1.000 | 1.000 | 1.000 | 0.0 |
| llm_only | ABTR | 3 | 0.593 | 0.750 | 0.287 | 0.000 | 17.7 |
| llm_only | MSRE | 3 | 0.556 | 0.375 | 0.429 | 0.091 | 32.7 |
| no_intermediate_file | ABTR | 3 | 1.000 | 0.917 | 0.334 | 0.000 | 19.3 |
| no_intermediate_file | MSRE | 3 | 1.000 | 0.375 | 0.477 | 0.000 | 40.0 |
| no_validator | ABTR | 3 | 0.889 | 1.000 | 1.000 | 0.900 | 0.0 |
| no_validator | MSRE | 3 | 1.000 | 0.958 | 0.990 | 0.909 | 0.0 |
| validator_repair | ABTR | 3 | 0.889 | 1.000 | 1.000 | 1.000 | 0.0 |
| validator_repair | MSRE | 3 | 1.000 | 1.000 | 1.000 | 1.000 | 0.0 |

## Intermediate-file review visibility

- ABTR: the existing intermediate file exposes 19 null fields before input generation. See `review_stage/ABTR_missing_parameters.json` for the exact paths.
- MSRE: the existing intermediate file exposes 0 null fields before input generation. See `review_stage/MSRE_missing_parameters.json` for the exact paths.

The no-validator condition contains a disclosed seeded connectivity defect. It is not a naturally occurring random error and is used only to isolate validator effectiveness.
