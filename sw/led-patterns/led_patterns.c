/* Name: Ian Crittenden
 * SoC FPGAs I - Trevor Vannoy
 * 11/04/24
 * SW Led Pattern Controller
 * This program will control the leds with various patterns when software control mode is enabled in the fpga via the lightweight bus
 */
 
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>

int main(void){
	system("devmem1 0xff200000 0x0");
}
