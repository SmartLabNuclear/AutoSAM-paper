# Audited ablation scores — the reported source

The rescore of [`../generation_run/`](../generation_run/), correcting the deterministic scorer to accept legacy MOOSE `[./name]` and `[../]` block notation. **No API call was repeated and no generated deck was altered** — only the scoring of already-produced decks changed.

| File | Contents |
| --- | --- |
| `results_audited.md` | **Start here.** Protocol, the reported table with standard deviations, interpretation, and stated limitations |
| `aggregate_summary.json` | Mean and SD per configuration and case, for every metric |
| `run_summary.csv` | One row per (configuration, case, run): `required_block_fraction` (standard-section coverage), `component_recall`, `parameter_precision`/`recall`/`f1`, `topology_recall`/`precision`, counts of explicit-missing and assumption markers, and latency |
| `all_scores.json` | Every scored item in one file |
| `rescore_manifest.json` | Source run and script hashes, the reason for the rescore, and `api_calls_repeated: false` |
| `scores/<configuration>__<case>__run_NN.json` | The audited score for one run: which required blocks were present or missing, component recall with the missing components named, parameter TP/FP/FN with every mismatch listed, and topology recall with the missing edges named |

The `scores/` files are the ones to open when a table number looks surprising — each names the exact blocks, components, parameters, and edges behind its metrics. Their pre-audit counterparts are `score_preaudit.json` inside [`../generation_run/raw/`](../generation_run/raw/), stored beside the deck each was computed from.

## Limitations stated by the audit

The full-pipeline artifacts define the structural reference, so their parameter and topology scores are 1.000 *by construction* and are not an independent accuracy estimate. The validator result measures repair of a controlled defect, not the natural frequency of such defects. SAM execution was not part of this harness — the study evaluates input structure, parameters, and connectivity only.
