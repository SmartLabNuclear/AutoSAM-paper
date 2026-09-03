# 5. Ablation study

Backs the [ablation table](../../README.md#ablation-study). Test cases 3 and 4 repeated with `gpt-5.2`, three runs per configuration per case, one pipeline stage disabled at a time.

| Directory | What it is |
| --- | --- |
| [`audited_scores/`](audited_scores/) | **The reported source.** The audited rescore of the generation run below |
| [`generation_run/`](generation_run/) | The generation run itself: prompts, generated decks, benchmarks, seeded defects, and the superseded pre-audit scoring |

**The two directories disagree, and the audited one is correct.** The original scorer did not understand legacy MOOSE `[./name]` and `[../]` block notation, so it scored several structurally valid decks as near-zero. The rescore fixed that without repeating any API call. 7 of the 26 remaining item scores changed. Compare `generation_run/report_preaudit.md` against `audited_scores/results_audited.md` to see the difference — for example, MSRE `llm_only` parameter F1 goes from 0.369 to 1.000.

## Configurations

| Configuration | What was removed | Reported? |
| --- | --- | :---: |
| `full_pipeline_existing` | Nothing — the existing full-pipeline artifact, one run per case | yes |
| `llm_only` | Retrieval, image processing, intermediate file, validator. A single prompt supplies **all** reference material properties, dimensions, boundary conditions, components, and connections | yes |
| `no_intermediate_file` | The intermediate representation; extracted text, spreadsheet data, and image facts go straight to input generation | yes |
| `no_validator` | Connectivity and section-presence checks, with a connectivity defect seeded in each case | yes |
| `validator_repair` | Nothing — the validator diagnosis is fed back to the agent, separating defect *detection* from *correction* | in prose |

## What the ablation shows

- **LLM only** preserved the supplied parameters and topology — it was given them — but produced only five of the nine standard SAM sections in every run, omitting `Functions`, `Preconditioning`, `Postprocessors`, and `Outputs`. Complete engineering data is not a substitute for the solver-specific section scaffold.
- **No intermediate file** left all nine section headings present but degraded their *content*: parameter F1 fell to 0.591 (ABTR) and 0.393 (MSRE), and topology recall was **zero** in both cases.
- **No validator**: the seeded defects reduced topology recall to 0.900 (ABTR) and 0.909 (MSRE), and **the agent never identified or corrected either defect on its own**. Given the validator's specific diagnosis, it repaired all six seeded defects across both cases and three runs.

Section coverage measures presence only. The ABTR reference itself omits the optional `[Postprocessors]` section without becoming invalid, so coverage below 1.000 is not automatically a defect.

The seeded defects are disclosed, deliberate, and single: they isolate validator effectiveness and say nothing about how often such defects arise naturally.

## Withdrawn arm

A sixth configuration, `no_image_processing`, was run but is not published. Its runs, per-item scores, and aggregate rows have been removed from this directory. Two consequences to be aware of when auditing:

- `generation_run/manifest.json` still reports the token and API-call totals for the full six-arm run.
- `audited_scores/rescore_manifest.json` records `source_all_scores_sha256` for `all_scores.json` as it stood before the arm was removed, so that hash no longer matches the file in this directory. Every other hash it records is unaffected.
