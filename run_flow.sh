#!/bin/bash
# Run the UART RTL-to-GDSII flow in OpenROAD-flow-scripts (Nangate45).
# Usage: ./run_flow.sh            (uses ~/OpenROAD-flow-scripts)
#        ORFS=/path/to/OpenROAD-flow-scripts ./run_flow.sh
# Run this in a terminal where the OpenROAD environment is loaded
# (for example after: source ~/or_flow.sh).
set -e
ORFS=${ORFS:-$HOME/OpenROAD-flow-scripts}
HERE=$(cd "$(dirname "$0")" && pwd)
FLOW=$ORFS/flow

mkdir -p "$FLOW/designs/src/uart_ctrl" "$FLOW/designs/nangate45/uart_ctrl"
cp "$HERE"/rtl/*.v "$FLOW/designs/src/uart_ctrl/"
cp "$HERE/config/config.mk" "$HERE/config/constraint.sdc" "$FLOW/designs/nangate45/uart_ctrl/"

cd "$FLOW"
make DESIGN_CONFIG=./designs/nangate45/uart_ctrl/config.mk 2>&1 | tee uart_ctrl_run.log

echo "--- timing ---";  grep -E "wns" reports/nangate45/uart_ctrl/base/6_finish.rpt | head -2
echo "--- DRC ---";     grep -iE "violation" logs/nangate45/uart_ctrl/base/5_2_route.log | tail -5
echo "--- area ---";    grep -E "Design area" logs/nangate45/uart_ctrl/base/6_report.log
echo "--- power ---";   grep -E "^Total" reports/nangate45/uart_ctrl/base/6_finish.rpt | head -1
ls -lh results/nangate45/uart_ctrl/base/6_final.gds
