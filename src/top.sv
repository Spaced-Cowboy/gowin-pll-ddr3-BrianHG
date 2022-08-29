`timescale 1ps / 1ps // 1 ps steps, 1 ps precision.

`define ROLLOVER 7

module top
   #(
    // Use ALTERA, INTEL, GOWIN, LATTICE or XILINX.
    parameter string     FPGA_VENDOR             = "Gowin",

    // (FPGA family identifier), passed to PLL
    parameter string     FPGA_FAMILY             = "GW2A-18",

    // PLL source input clock frequency in KHz.
    parameter int        CLK_KHZ_IN              = 50000,         

    // Multiply factor to generate the DDR MTPS speed divided by 2.
    parameter int        CLK_IN_MULT             = 32,

    // Divide factor.  When CLK_KHZ_IN is 25k,50k,7k,100k,125k,150k,
    // use 2,4,6,8,10,12.
    parameter int        CLK_IN_DIV              = 4,              
 
	// 270/90.  Select the write and write DQS output clock phase relative
	// to the DDR3_CLK
	parameter int        DDR3_WDQ_PHASE         = 270            
   )
    (
    input           clk,                // External clock
	input			rst,				// External reset

	input 			phase_step,			// Step the phase
	input			phase_updn,			// Direction to step

    output reg      led                 // External LED
    );

	wire 			clk_ddrMain;		// Main DDR clock @ 400 MHz 
	wire 			clk_ddrWrite;		// 270-degree shifted clock @ 400 MHz
	wire 			clk_ddrRead;		// shiftable clock @ 400 MHz
	wire 			clk_ddrClient;		// client-interface clock @ 200 MHz
	wire 			clk_ddrMgmt;		// Internal management clock @ 100 MHz

	wire 			ddr_locked;			// All clocks locked and ready to go
	reg  	[3:0]	ddr_psda;			// Phase-shift for read-clock
	reg		[3:0]	ddr_delay;			// Delay for read-clock


	// Just so there's something to do while the clocks sync up
    localparam COUNTER_SZ  			= $clog2(`ROLLOVER);
	wire [COUNTER_SZ-1:0] increment = {{COUNTER_SZ-1{1'b0}}, 1'b1};
	reg  [COUNTER_SZ-1:0] counter;


	// Invoke the DDR clocks
    wire gowin_clocks_locked;
    gowin_ddr_clocking 
    #(
        .FPGA_FAMILY		(FPGA_FAMILY),
        .CLK_KHZ_IN			(CLK_KHZ_IN),
        .CLK_IN_MULT		(CLK_IN_MULT),
        .CLK_IN_DIV			(CLK_IN_DIV),
        .DDR3_WDQ_PHASE 	(DDR3_WDQ_PHASE)
        )
        gowin_ddr_clocks
        (
        .clk(clk),					// Input clock from the board
        .rst(rst),					// Input reset signal 
        
        .phase_step(phase_step),		// Step the phase
        .phase_updn(phase_updn),        // Direction to step

        .clk_ddrMain(clk_ddrMain),		// Main DDR clock
        .clk_ddrWrite(clk_ddrWrite),	// DDR clock for write-ops
        .clk_ddrRead(clk_ddrRead),		// DDR clock for read-ops
        .clk_ddrClient(clk_ddrClient),	// clock for the DDR client interface
        .clk_ddrMgmt(clk_ddrMgmt),		// clock for internal DDR use
        
        .locked(gowin_clocks_locked)    // We're up and running
        );

	always @ (posedge clk)
		if (rst == 1'b1) 
			begin
				ddr_psda	<= 4'b0100;	// Set user-phase to 90 degrees
				ddr_delay	<= 4'b0;
			end

	always @ (posedge clk_ddrMain)
		if (rst) 
			begin
				counter 	<= 0;
				led 		<= 0;
			end
		else if (gowin_clocks_locked)
			begin
				counter <= counter + increment;
				if (counter == `ROLLOVER)
					begin
						counter <= 0;
						led <= ~led;
					end
			end
endmodule
