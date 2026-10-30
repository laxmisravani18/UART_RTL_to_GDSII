#!/bin/bash
# Clock-period sweep with 0.1 ns input/output delay. Usage: ./run_sweep.sh
# Leaves the design at the last period tried; rerun ./run_flow.sh afterwards
# (after restoring config/constraint.sdc) for the final 0.7 ns result.
ORFS=${ORFS:-$HOME/OpenROAD-flow-scripts}
FLOW=$ORFS/flow
D=$FLOW/designs/nangate45/uart_ctrl
cd "$FLOW" || exit 1
for P in 0.8 0.7 0.6 0.5 0.4; do
  cat > "$D/constraint.sdc" <<SDC
create_clock -name clk -period $P [get_ports clk]
set_input_delay  0.1 -clock clk [all_inputs -no_clocks]
set_output_delay 0.1 -clock clk [all_outputs]
SDC
  rm -rf results/nangate45/uart_ctrl logs/nangate45/uart_ctrl reports/nangate45/uart_ctrl
  make DESIGN_CONFIG=./designs/nangate45/uart_ctrl/config.mk > sweep_$P.log 2>&1
  echo "=== period $P ns ==="
  grep -E "wns" reports/nangate45/uart_ctrl/base/6_finish.rpt | head -2
  grep -E "Design area" logs/nangate45/uart_ctrl/base/6_report.log
  grep -E "^Total" reports/nangate45/uart_ctrl/base/6_finish.rpt | head -1
done
