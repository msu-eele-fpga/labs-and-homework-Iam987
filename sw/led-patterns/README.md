##
# Usage:  
led_patterns: led_patterns [-options] [filename/pattern durration,...]
	
Control the leds on the de10nano with software
	
Without arguments, `led_patterns` will display this help text
	
Options: 

	-h Displays this help text  
	-v Will show the patterns and durations as they are set on the device  
	-p Specify patterns and times as arguments in the terminal (loops until termination)  
	-f Specify file name containing patterns and durations (loops until termination)  
##
# Building
### Compile instructions
1. In the folder with the `led_patterns.c` file, run `arm-linux-gnueabihf-gcc -o led_patterns -Wall -static led_patterns.c` This will make the file `led_patterns` for arm processors
2. Then you can copy the `led_patterns` file to your file system on the soc (put it in bin or another file within the `PATH` to run from any directory)
##
# Required FPGA architecture:
The FPGA must be loaded with a bitstream with the following architecture:  
![arch diagram](./assets/Lab4BlockDiagram.svg)  
>See lab 4 vhdl for an example:  
[HDL for led patterns](../hdl/led-patterns)