# Figures

Manuscript figures embedded in the [top-level README](../README.md). File names are referenced directly from that README and from the paper, so they are kept as published.

| File | Figure |
| --- | --- |
| `methodology_workflow.jpg` | The agent's tool chain for multi-modal document processing: unstructured sources are parsed by specialized tools, structured into the intermediate YAML representation, combined with structured sources, and transformed into a SAM input file that the validator then checks |
| `tools_invocation.jpg` | The seven tools available to the agent — two content-parsing, two instruction-passing, two retrieval, and one Python code-execution tool |
| `testCase1.jpg` | Test case 1, pipe model — inputs, generated model, and simulation results |
| `testCase2.jpg` | Test case 2, solid-fuel temperature reactivity feedback |
| `testCase3.jpg` | Test case 3, ABTR core — multi-modal inputs, intermediate representation, and results |
| `testCase4.jpg` | Test case 4, MSRE primary loop |

The artifacts behind each test-case figure are in [`../test_cases/`](../test_cases/).
