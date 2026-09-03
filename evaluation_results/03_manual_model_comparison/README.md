# 4. Comparison with manually developed models

Backs the [manual-vs-AutoSAM output table](../../README.md#comparison-with-manually-developed-models).

Structural validity and parameter fidelity do not guarantee correct physical behavior. Each generated deck was therefore run alongside an equivalent deck developed independently by an experienced analyst, and the quantities characterizing the dominant system response were compared as a percentage relative difference.

| File | Contents |
| --- | --- |
| `output_comparison_summary.csv` | **The reported comparison.** One row per quantity: case, output quantity, manual value, AutoSAM value, relative difference in percent |
| `pipe/autosam_out.csv` | Postprocessor output from the generated pipe deck |
| `pke/autosam_out.csv`, `pke/manual_reference_out.csv` | Paired output for the PKE case |
| `abtr/autosam_out.csv`, `abtr/manual_reference_out.csv` | Paired output for the ABTR case |
| `msre/autosam_out.csv`, `msre/manual_reference_out.csv` | Paired output for the MSRE case |

`pipe/` has no manual counterpart file because that comparison reduces to a single scalar — outlet fluid temperature — which agrees with the manual value to within numerical precision.

## What the numbers say

- **Pipe and PKE** agree to numerical precision (9.6×10⁻¹¹ % and 1.7×10⁻⁹ %). Both are structured-input cases with no document interpretation.
- **ABTR** agrees closely: core temperature rise and total core mass flow within 0.1 %, inlet and outlet temperatures around 1 %.
- **MSRE** differs by up to 12.669 % on primary mass flow, 11.207 % on core temperature rise, and 8.278 % on primary heat-exchanger temperature drop.

The MSRE discrepancy is **a modeling simplification, not a data-transfer error**. The manual deck represents the U-tube heat exchanger as three fluid segments with two coupled wall structures; AutoSAM approximates it as a single component. The two models are therefore not physically identical, which changes hydraulic resistance, primary flow, and heat-transfer response. Because the manual models were developed independently, this comparison is what surfaces such component-level choices.

The decks that produced these outputs are in [`../../test_cases/*/input_file/`](../../test_cases/) as `autosam_generated.i` and `manual_reference.i`.
