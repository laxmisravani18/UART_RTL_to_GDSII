# UART Controller: RTL to GDSII with OpenROAD

RTL-to-GDSII implementation of a UART controller (baud-rate generator, transmitter and receiver) using OpenROAD-flow-scripts on the Nangate45 library.

## Design
- Top module `uart_top` connects `baud_gen` (parameter DIV = 5208, 9600 baud at 50 MHz), `uart_tx` and `uart_rx`.
- Ports: `clk`, `reset`, `start`, `data_in[7:0]`, `rx`, `tx`, `busy`, `data_out[7:0]`, `done`.
- RTL is in `rtl/`; flow settings in `config/` (core utilization 40%).

## Flow
Yosys synthesis, floorplan, placement, clock-tree synthesis, global and detailed routing, fill and GDSII streaming, all through OpenROAD-flow-scripts (Nangate45).

## Final result (clock period 0.7 ns, 0.1 ns input/output delay)
| Metric | Value |
|---|---|
| Timing | met (WNS 0.00 ns) |
| Detailed-routing DRC violations | 0 |
| Antenna violations | 0 |
| Design area | 525 um^2 (42% utilization) |
| Total power | 0.80 mW |

## Clock-period sweep (0.1 ns I/O delay)
| Period | Timing | Area (um^2) | Power (mW) |
|---|---|---|---|
| 0.8 ns | met | 525 | 0.70 |
| 0.7 ns | met | 525 | 0.80 |
| 0.6 ns | marginal fail (-0.00 ns) | 527 | 0.96 |
| 0.5 ns | fail (-0.10 ns) | 528 | 1.10 |
| 0.4 ns | fail (-0.19 ns) | 533 | 1.44 |

An earlier sweep with a 0.6 ns I/O delay was limited by the clock-to-output path at about 0.87 ns; the numbers above remove that constraint to expose the logic limit.

## Files
- `rtl/` Verilog source and top module
- `config/` ORFS `config.mk` and `constraint.sdc`
- `reports/` final timing/power report, synthesis statistics, routing log
- `layout/uart_top.gds` final layout

## Reproduce
Copy `rtl/*.v` to `flow/designs/src/uart_ctrl/` and `config/*` to `flow/designs/nangate45/uart_ctrl/` inside OpenROAD-flow-scripts, then run:
`make DESIGN_CONFIG=./designs/nangate45/uart_ctrl/config.mk`

## Limitations
Nangate45 is an academic 45 nm library, not a production process. Results are from OpenROAD estimates, not signoff timing. The design was not verified here beyond the original testbench in the Verilog-Projects repo.
