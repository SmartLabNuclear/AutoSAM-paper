# 1. Visual information recovery

Backs the **ViR** table in the [top-level README](../../README.md#visual-information-recovery).

System schematics encode geometry and topology that the accompanying text does not state — component adjacency, flow ordering, segment endpoint coordinates. A *required fact* is any such item needed to construct the model. ViR is the fraction recovered correctly.

| Case | Required facts | Reported ViR | Comes from |
| --- | :---: | :---: | --- |
| ABTR | 15 | 1.000 ± 0.000 | [`abtr_source_aligned/`](abtr_source_aligned/) |
| MSRE | 22 | 0.818 ± 0.079 | [`msre_and_model_comparison/`](msre_and_model_comparison/) |
| **Pooled** | **37** | **0.892 ± 0.047** | weighted by required-fact count |

**The two directories are not interchangeable.** `msre_and_model_comparison/` also contains an ABTR score, but that score used a benchmark with six reversed endpoint labels. `abtr_source_aligned/` is the corrected rescore of the same preserved raw outputs and is the ABTR number the paper reports. Read the two directory READMEs before quoting any ABTR value from here.

| Directory | Original run ID |
| --- | --- |
| `msre_and_model_comparison/` | `20260813T203816Z_vision_gpt56sol_strict` |
| `abtr_source_aligned/` | `20260813T205353Z_abtr_vision_source_aligned` |
