# MSRE vision failure audit

## Execution and provenance

- Three fixed-setting runs evaluated 22 MSRE visual facts per run.
- GPT-5.6 Sol was called through the Responses API with medium reasoning and original image detail.
- The API resolved the requested model to `gpt-5.6-sol`.
- `gpt-4o-mini-2024-07-18` performed the geometry-structuring stage.
- Three raw case logs and 66 item-level scores were produced with no API failures, parser failures, or retries.
- The strict label rescore repeated no API calls and did not change the source run.

## Result

| Case | ViR, mean ± SD | Recoveries by run |
|---|---:|---:|
| MSRE | 0.818 ± 0.079 | 17, 20, 17 / 22 |

## Remaining failures

Both heat-exchanger secondary coordinates, the reference-pressure coordinate, the core-bottom coordinate, and most component lengths were consistently recovered. Remaining errors involved swapped or incomplete endpoint assignments: the pipe4 endpoint and downcomer top were each recovered once, while some explicit coordinates were omitted in run 3. Pipe5 length was incorrect in one run, and pipe3 and heat-exchanger lengths were each missed once.

## Interpretation

The result does not support a full vision-completeness claim. Vision-derived geometry should remain subject to deterministic validation and expert review. The benchmark ground truth should receive domain-expert signoff before publication.
