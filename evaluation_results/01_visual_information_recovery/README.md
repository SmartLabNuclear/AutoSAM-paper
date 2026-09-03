# 1. Visual information recovery

Backs the **ViR** table in the [top-level README](../../README.md#visual-information-recovery).

System schematics encode geometry and topology that the accompanying text does not state — component adjacency, flow ordering, segment endpoint coordinates. A *required fact* is any such item needed to construct the model. ViR is the fraction recovered correctly.

| Case | Required facts | Reported ViR | Comes from |
| --- | :---: | :---: | --- |
| ABTR | 15 | 1.000 ± 0.000 | [`abtr_source_aligned/`](abtr_source_aligned/) |
| MSRE | 22 | 0.818 ± 0.079 | [`msre/`](msre/) |
| **Pooled** | **37** | **0.892 ± 0.047** | weighted by required-fact count |
