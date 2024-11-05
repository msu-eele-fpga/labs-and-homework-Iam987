/* Name: Ian Crittenden
 * SoC FPGAs I - Trevor Vannoy
 * 11/04/24
 * SW Led Pattern Controller
 * This program will control the leds with various patterns when software control mode is enabled in the fpga via the lightweight bus
 */
 
 //0xff200000 - hps_led_control (boolean)
 //0xff200004 - base rate (fixed point u8.4)
 //0xff200008 - ledpattern (8-bit register)
 
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <sys/mman.h> //for mman?
#include <fcntl.h> //for file open flags
#include <unistd.h> //for getting the page size
#include <getopt.h> //for handling options

void usage(){
	fprintf(stderr, "\n\nled_patterns: led_patterns [-options] [filename/pattern+durration,...]\n");
	fprintf(stderr, "\tControl the leds on the de10nano with software\n");
	fprintf(stderr, "\n\tWithout arguments, `led_patterns` will display this help text\n");
	fprintf(stderr, "\nOptions:\n"
	"\t-h Displays this help text\n"
	"\t-v Will show the patterns and durrations as they are set on the device\n"
	"\t-p Specify patterns and times as arguments in the terminal (loops until termination)\n"
	"\t-f Specify file name containing patterns and durrations (loops until termination)\n\n");
}
void dvmemusage(){
	fprintf(stderr, "\n\ndevmem ADDRESS [VALUE]\n");
	fprintf(stderr, " devmem can be used to read/write to physical memory via the /dev/mem device.\n");
	fprintf(stderr, " devmem will only read/write 32-bit values\n\n");
	fprintf(stderr, " Arguments:\n");
	fprintf(stderr, " ADDRESS The address to read/write to/from\n");
	fprintf(stderr, " VALUE The optional value to write to ADDRESS; if not given, a read will be performed.\n\n");
}

int devmem(char *Addr, char *val){
	//This is the size of the page of memory in the system. (4096 bytes probably)
	const size_t PAGE_SIZE = sysconf(_SC_PAGE_SIZE);
	
	
	//If value arg given, perform a write opp
	bool is_write = true;
	
	const uint32_t ADDRESS = strtoul(Addr, NULL, 0);
	
	int fd = open("/dev/mem", O_RDWR | O_SYNC);
	if (fd == -1){
		//fprintf(stderr, "failed to open /dev/mem.\n");
		return 1;
	}
	
	//mmap needs to map memory at page boundaries; 
	uint32_t page_aligned_addr = ADDRESS & ~(PAGE_SIZE - 1);
	//printf("memory addresses:\n");
	//printf("---------------------------------------------------------------------------\n");
	//printf("page aligned address = 0x%x\n",page_aligned_addr);
	
	//map a page of physical memory into virtual memory. https://www.man7.org/linux/man-pages/man2/mmap.2.html
	uint32_t *page_virtual_addr = (uint32_t *)mmap(NULL, PAGE_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, page_aligned_addr);
	if(page_virtual_addr == MAP_FAILED){
	       // fprintf(stderr, "failed to map memory.\n");
	        return 1;
	}	
	//printf("page_virtual_addr = %p\n", page_virtual_addr);
	
	//The address we want to access might not be page-aligned. Since we mapped a page-aligned address, we need our target address' offet from the page boundary. Using this offset, we can copute the virtual address corresponding to our physical target address (ADDRESS).
	uint32_t offset_in_page = ADDRESS & (PAGE_SIZE - 1);
	//printf("offset in page = 0x%x\n",offset_in_page);
	
	//Compute the virtual address corresponding to ADDRESS.
	volatile uint32_t *target_virtual_addr = page_virtual_addr + offset_in_page/sizeof(uint32_t *);
	//printf("target_virtual_addr = %p\n", target_virtual_addr);
	//printf("-----------------------------------------------------------------------------\n");
	
	if(is_write){
		const uint32_t VALUE = strtoul(val, NULL, 0);
		*target_virtual_addr = VALUE;
	}
	else{
		//printf("\nvalue at 0x%x = 0x%x\n", ADDRESS, *target_virtual_addr);
	}
	return 0;
}

void when_exit(){
	devmem("0xff200000", "0x0");
}

int main(int argc, char **argv){
	devmem("0xff200000","0x1");
	usage();
	dvmemusage();
	atexit(when_exit); //Maybe use signal interrupts for ^C
	char n;
	scanf("%c", &n);
}
