vlog -work work "prim_sim.v"
vlog -work work {top.v}
vlog -work work {gowin_ddr_clocking.v}
vlog -work work {top_tb.v}
vlog -work work {pll_ddr1/pll_ddr1.v}
vlog -work work {pll_ddr2/pll_ddr2.v}
vlog -sv -work work {BrianHG_DDR3_PLL.sv}
vlog -sv -work work {BrianHG_DDR3_PLL_tb.sv}

restart -force
run -all

wave cursor active
wave refresh
wave zoom range 4720ns 4740ns
view signals
