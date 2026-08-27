# GPT-5.6 Sol vision failure audit

## Execution and provenance

- Three fixed-setting runs evaluated 15 ABTR and 22 MSRE visual facts per run.
- GPT-5.6 Sol was called through the Responses API with medium reasoning and original image detail.
- The API resolved the requested model to `gpt-5.6-sol`.
- `gpt-4o-mini-2024-07-18` performed the unchanged geometry-structuring stage.
- Six raw case logs and 111 item-level scores were produced with no API failures, parser failures, or retries.
- The strict label rescore repeated no API calls and changed neither source run.

## Strict ViR comparison

| Case | GPT-4o baseline | GPT-5.6 Sol | Absolute change |
|---|---:|---:|---:|
| ABTR | 0.178 +/- 0.038 | 0.533 +/- 0.240 | +0.356 |
| MSRE | 0.621 +/- 0.507 | 0.818 +/- 0.079 | +0.197 |
| Pooled | 0.441 +/- 0.317 | 0.703 +/- 0.097 | +0.261 |

GPT-5.6 Sol recovered 5/15, 7/15, and 12/15 ABTR facts and 17/22, 20/22, and 17/22 MSRE facts. The pooled run values were 22/37, 27/37, and 29/37.

## Remaining failures

For ABTR, the inlet, outlet, Pipe1 length, Pipe2 start, and Pipe2 length were recovered in all three runs. Channel-coordinate recovery improved but remained variable. The 0.8 m lengths of CH2 and CH4 were missed in all runs, while the other channel lengths were recovered in only one of three runs. The structuring stage sometimes interpreted horizontal displacement as channel length even when the GPT-5.6 description correctly identified vertical channels.

For MSRE, both heat-exchanger secondary coordinates, the reference-pressure coordinate, the core-bottom coordinate, and most component lengths were consistently recovered. Remaining errors involved swapped or incomplete endpoint assignments: the pipe4 endpoint and downcomer top were each recovered once, while some explicit coordinates were omitted in run 3. Pipe5 length was incorrect in one run, and pipe3/HX lengths were each missed once.

## Interpretation

The upgraded GPT-5.6 Sol configuration materially improves mean ViR and pooled repeatability relative to GPT-4o. It still does not support a 100% vision-completeness claim. Because the migration also changed the endpoint from Chat Completions to Responses and image detail from high to original, the comparison measures the upgraded configuration rather than a strictly model-only causal effect.

The benchmark ground truth should receive domain-expert signoff before publication, and vision-derived geometry should remain subject to deterministic validation and expert review.
