# MSRE distractor corpus

**These documents were never supplied to the agent when building the MSRE model.** They exist only as related-document noise in the retrieval evaluation, to test whether the agent can find and cite the authoritative source when the corpus also holds closely related material.

| File | Pages | Role |
| --- | :---: | --- |
| `ANL-NSE-21-48_application_of_NEAMS_codes_to_MSR_phenomena.pdf` | 45 | Distractor. Feng et al., *Application of NEAMS Codes to Capture MSR Phenomena*, ANL/NSE-21/48, Argonne National Laboratory |

The authoritative target is [`../MSRE_case.pdf`](../MSRE_case.pdf), six pages, in the parent folder.

A third document, Haubenreich & Engel, *Experience with the Molten-Salt Reactor Experiment*, contributed the remaining 20 distractor pages of the evaluated corpus. It is not redistributed here because it is a journal article under publisher copyright rather than an openly redistributable laboratory report; see the citation in the [top-level README](../../../../README.md#citation) and retrieve it from the publisher.

The full evaluated corpus was 71 chunks at one page each: 6 target, 45 from the NEAMS report, and 20 from the Haubenreich article. At *k* = 10 the model saw 14.1 % of the corpus per question, and on average 74 % of the pages it retrieved were distractors. It never cited a distractor in any run. See [`../../../../evaluation_results/02_rag_and_parameter_extraction/msre_k10/`](../../../../evaluation_results/02_rag_and_parameter_extraction/msre_k10/).
