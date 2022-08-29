`timescale 1ps / 1ps // 1 ps steps, 1 ps precision.

module top_tb;

	///////////////////////////////////////////////////////////////////////////
	// Instantiate the test module
	///////////////////////////////////////////////////////////////////////////
	reg clk, rst;
	wire led;

	top dut
		(
		.rst(rst),
		.clk(clk),
		.led(led)
		);


	///////////////////////////////////////////////////////////////////////////
	// Set everything going
	///////////////////////////////////////////////////////////////////////////
    	initial
        	begin
            	$dumpfile("wave.vcd");
            	$dumpvars(0, top_tb);
                
            	clk 		= 1'b0;
				rst		= 1'b0;
				dut.counter	<= 0;
				dut.led		<= 0;

		#20000
			rst		= 1'b1;
		#10000
			rst		= 1'b0;

		
		#60000000
			$stop;
		end

	///////////////////////////////////////////////////////////////////////////
	// Toggle the clock indefinitely
	///////////////////////////////////////////////////////////////////////////
    always 
	    begin
        	#20000		clk = ~clk;
	    end
 endmodule
