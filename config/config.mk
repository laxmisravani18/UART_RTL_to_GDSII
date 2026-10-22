export DESIGN_NICKNAME = uart_ctrl
export DESIGN_NAME     = uart_top
export PLATFORM        = nangate45
export VERILOG_FILES   = $(sort $(wildcard $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/*.v))
export SDC_FILE        = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc
export CORE_UTILIZATION = 40
export PLACE_DENSITY_LB_ADDON = 0.20
