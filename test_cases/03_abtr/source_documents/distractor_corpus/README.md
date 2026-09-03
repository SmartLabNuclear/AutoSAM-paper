# ABTR distractor corpus

**These documents were never supplied to the agent when building the ABTR model.** They exist only as related-document noise in the retrieval evaluation, to test whether the agent can find and cite the authoritative source when the corpus also holds closely related material.

| File | Pages | Role |
| --- | :---: | --- |
| `ANL-NSE-19-1_reactivity_feedback_modeling_in_SAM.pdf` | 41 | Distractor. R. Hu et al., *Reactivity Feedback Modeling in SAM*, ANL/NSE-19/1, Argonne National Laboratory |

The authoritative target is [`../ABTR_case.pdf`](../ABTR_case.pdf), three pages, in the parent folder.

Together these form the 44-chunk corpus used in [`../../../../evaluation_results/02_rag_and_parameter_extraction/abtr_k2/`](../../../../evaluation_results/02_rag_and_parameter_extraction/abtr_k2/): one page per retrieval chunk, 3 target and 41 distractor. At *k* = 2 the model sees 4.5 % of the corpus per question, and 26.7 % of the pages it retrieves come from the distractor. It never cited the distractor in any run.
