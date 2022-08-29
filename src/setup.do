transcript on

#
# New libraries
#
if {[file exists work]} {
	vdel -lib work -all
}
vlib work

#
# Compile the testbench and its dependencies
#
vmap work work
vlog -work work "prim_sim.v"
vlog -sv -work work {gowin_ddr_clocking.sv}
vlog -sv -work work {BrianHG_DDR3_PLL.sv}
vlog -sv -work work {BrianHG_DDR3_PLL_tb.sv}


# Make Cyclone IV E Megafunctions and PLL available.
#vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L work -voptargs="+acc"  BrianHG_DDR3_PLL_tb

# Make MAX 10 Megafunctions and PLL available.
#vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L work -voptargs="+acc"    BrianHG_DDR3_PLL_tb

# Make Cyclone V Megafunctions and PLL available.
vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L work -voptargs="+acc"  BrianHG_DDR3_PLL_tb

restart -force -nowave




#
# This line shows only the varible name instead of the full path and which module it was in
#
config wave -signalnamewidth 1

add wave -color white /BrianHG_DDR3_PLL_tb/CLK_IN
add wave -color white /BrianHG_DDR3_PLL_tb/RST_IN
add wave -color white /BrianHG_DDR3_PLL_tb/RST_OUT
add wave -height 40 -divider Phase
add wave -color green /BrianHG_DDR3_PLL_tb/phase_done
add wave -color white /BrianHG_DDR3_PLL_tb/phase_step
add wave -color white /BrianHG_DDR3_PLL_tb/phase_updn
add wave -color white /BrianHG_DDR3_PLL_tb/phase_sclk
add wave -color white /BrianHG_DDR3_PLL_tb/gowin_ddr_clocks/phase
add wave -height 40 -divider "BrianHG_DDR3_PLL clocks" 
add wave -color red /BrianHG_DDR3_PLL_tb/DDR3_CLK
add wave -color cyan /BrianHG_DDR3_PLL_tb/DDR3_CLK_WDQ
add wave -color blue /BrianHG_DDR3_PLL_tb/DDR3_CLK_RDQ
add wave -color green /BrianHG_DDR3_PLL_tb/DDR3_CLK_50
add wave -color green /BrianHG_DDR3_PLL_tb/DDR3_CLK_25
add wave -color white /BrianHG_DDR3_PLL_tb/PLL_LOCKED
add wave -height 40 -divider "Gowin clocks"
add wave -color red /BrianHG_DDR3_PLL_tb/clk_ddrMain
add wave -color cyan /BrianHG_DDR3_PLL_tb/clk_ddrWrite
add wave -color blue /BrianHG_DDR3_PLL_tb/clk_ddrRead
add wave -color green /BrianHG_DDR3_PLL_tb/clk_ddrClient
add wave -color green /BrianHG_DDR3_PLL_tb/clk_ddrMgmt
add wave -color white /BrianHG_DDR3_PLL_tb/gowin_clocks_locked

#
# Look at everything
#
log -r /*

do run.do
