##
# Lab 8 - Creating LED Patterns with a C Program Using /dev/mem in Linux
## Overview
In this Lab, I created a `led_patterns.c` program that can drive the leds on board the fpga via the lightweight bus by setting the correct register to the correct values.
## Deliverables
### Example calculation of component's register addresses:
$Register2 = Lightweight\_Bridge\_Address + Component\_Address + 2 * 4$  
$Register3 = 0xFF200000 + 0x0000 + 0x8$  
$Register3 = 0xFF200008$  

### README file:
[Readmefile](../sw/led-patterns/README.md)
##