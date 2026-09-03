# Generation cost and runtime

Backs the [cost and runtime table](../../README.md#generation-cost-and-runtime). One full AutoSAM generation per case with `gpt-5.2-2025-12-11`.

| Case | Input tokens | Output tokens | Time (min) | Cost (USD) |
| --- | ---: | ---: | ---: | ---: |
| Pipe | 1,631,514 | 13,673 | 2.56 | 0.91 |
| PKE | 1,396,870 | 15,337 | 2.65 | 0.63 |
| ABTR | 1,837,583 | 27,822 | 4.87 | 0.94 |
| MSRE | 1,397,468 | 29,470 | 5.83 | 0.87 |

The large input-token counts are **cumulative across the agent's successive tool calls** — system instructions, tool definitions, conversation history, and intermediate results are re-included in the context on every call. Most of it is cache reads; `stage_*_usage_timing.json` breaks out cached from uncached.

| Path | Contents |
| --- | --- |
| `four_case_cost_runtime_summary_20260822.json` | **The reported summary.** Scope, model, environment, per-million-token pricing used, and per-case input/cached/uncached/output/embedding tokens, wall time, tool-call counts, and estimated cost |
| `traces/{Pipe,PKE,ABTR,MSRE}/` | The full generation trace for that case |

**Scope of the cost figures:** spreadsheet parsing, image analysis, intermediate-YAML generation, input generation, and validator review are included. SAM execution and the one-time PDF indexing are excluded; the retrieval stores were prebuilt.

## Inside each trace directory

| File | Contents |
| --- | --- |
| `run_manifest.json` | Run configuration and source hashes |
| `case_summary.json` | Per-stage wall time, the **ordered list of tool calls** the agent actually made in each stage, validator call count, and SHA-256 of the intermediate file and generated deck |
| `stage_1_intermediate_response.txt` | The agent's stage-1 output in full, including its reasoning prose |
| `stage_1_intermediate_steps.json` | Every stage-1 tool call with its arguments and output |
| `stage_1_usage_timing.json` | Stage-1 token accounting and latency, per model, cached vs. uncached |
| `stage_2_input_response.txt`, `stage_2_input_steps.json`, `stage_2_usage_timing.json` | The same for stage 2 |
| `MSRE/stage_2_retry_*` | MSRE only. The first stage-2 attempt hit a validator path error; these are the successful two-call retry from the same valid intermediate YAML. **The reported MSRE cost includes both attempts** |

`case_summary.json` is the quickest way to see how the agent worked: for ABTR it records 14 stage-1 tool calls across the spreadsheet, PDF, image, text, and Python tools, then 6 stage-2 calls including 3 validator invocations.

## Prompts

The stage prompts are **not duplicated here**. They are byte-identical to the copies in [`../../test_cases/*/prompts/`](../../test_cases/), which is their canonical home:

| Trace | Prompts |
| --- | --- |
| `traces/Pipe/` | [`test_cases/01_pipe/prompts/`](../../test_cases/01_pipe/prompts/) |
| `traces/PKE/` | [`test_cases/02_pke/prompts/`](../../test_cases/02_pke/prompts/) |
| `traces/ABTR/` | [`test_cases/03_abtr/prompts/`](../../test_cases/03_abtr/prompts/) |
| `traces/MSRE/` | [`test_cases/04_msre/prompts/`](../../test_cases/04_msre/prompts/) — including `stage_2_retry_prompt.txt` |
