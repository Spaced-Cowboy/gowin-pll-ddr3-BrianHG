# gowin-pll-ddr3-BrianHG
This is version 2 of gowin-modelsim-test, where the interface to the Gowin PLLs is matched to be the same as the Altera interface

# Steps to build:

- Open up the test.gprj in the top level folder you checked this out into
- Click on synthesize / place-and-route, it all ought to work

# Steps to simulate

- open up cmd.exe from the Windows menu
- cd to the folder you checked out into, and then into 'src'
- type 'modelsim' to run Modelsim
- Open up the transcript window (if necessary) and type 'do setup.do'

You ought to see the DDR3 clocks wave-form appear within modelsim for both BrianHG's PLL and the Gowin one.

The step-up/down interface is implemented, so on the rising edge of phase_step, the DDR3 read-clock will have its phase modified

