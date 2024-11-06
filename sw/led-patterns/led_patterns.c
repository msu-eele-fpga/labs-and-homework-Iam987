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
#include <sys/mman.h> //for mman
#include <fcntl.h> //for file open flags
#include <unistd.h> //for getting the page size
#include <getopt.h> //for handling options
#include <signal.h> //for handling ^C

void usage(){
	fprintf(stderr, "\n\nled_patterns: led_patterns [-options] [filename/pattern durration,...]\n");
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

int devmem(char *Addr, char *val){ // I know this function is very ugly, I didn't want to refactor it from lab 7 so here it is
	//This is the size of the page of memory in the system. (4096 bytes probably)
	const size_t PAGE_SIZE = sysconf(_SC_PAGE_SIZE);
	
	const uint32_t ADDRESS = strtoul(Addr, NULL, 0);
	
	int fd = open("/dev/mem", O_RDWR | O_SYNC);
	if (fd == -1){
		fprintf(stderr, "failed to open /dev/mem.\n");
		return 1;
	}
	
	//mmap needs to map memory at page boundaries; 
	uint32_t page_aligned_addr = ADDRESS & ~(PAGE_SIZE - 1);
	
	//map a page of physical memory into virtual memory. https://www.man7.org/linux/man-pages/man2/mmap.2.html
	uint32_t *page_virtual_addr = (uint32_t *)mmap(NULL, PAGE_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, page_aligned_addr);
	if(page_virtual_addr == MAP_FAILED){
	       fprintf(stderr, "failed to map memory.\n");
	        return 1;
	}	
	
	//The address we want to access might not be page-aligned. Since we mapped a page-aligned address, we need our target address' offet from the page boundary. Using this offset, we can copute the virtual address corresponding to our physical target address (ADDRESS).
	uint32_t offset_in_page = ADDRESS & (PAGE_SIZE - 1);
	
	//Compute the virtual address corresponding to ADDRESS.
	volatile uint32_t *target_virtual_addr = page_virtual_addr + offset_in_page/sizeof(uint32_t *);
	
	const uint32_t VALUE = strtoul(val, NULL, 0);
	*target_virtual_addr = VALUE;
	fclose(fd);
	return 0;
}

void when_exit(){
	devmem("0xff200000", "0x0");
	exit(0);
}

int main(int argc, char **argv){
	signal(2, when_exit);
	atexit(when_exit);
	devmem("0xff200000","0x1");
	int c;
	bool verbose = false;
	bool termpats = false;
	bool filepats = false;
	if((c = getopt(argc, argv, "hvpf")) == -1){
		fprintf(stderr, "Please specify options");
		usage();
		exit(0);
	}
	while (c != -1){ // Get the options inputed and set variables to reflect the ones chosen
		switch(c){
			case 'h':
				usage();
				exit(0);
				break;
			case 'v':
				verbose = true;
				break;
			case 'p':
				termpats = true;
				break;
			case 'f':
				filepats = true;
				break;
			default:
				printf("?? getopt returned character code %o ??\n", c);
				fprintf(stderr, "Please specify options");
				exit(0);
				usage();
				break;
		}
		c = getopt(argc, argv, "hvpf");
	}
	
	if(termpats && filepats){ //handle both p & f options
		fprintf(stderr, "\n\tCannot use both -p and -f options in the same exceution\n");
		usage();
		exit(0);
	}
	int arraysize = 0;
	char patterns[100][10] = {};
	if(termpats){
		arraysize = argc - optind;
		if(arraysize % 2 != 0){
			printf("Incorrect number of arguments given\n");
			usage();
			exit(0);
		}
		while(optind < argc){
			for(int i = 0; i < sizeof(argv[optind]); i++){
				patterns[(argc - optind)-1][i] = argv[(argc - optind)+1][i];
			}
			//printf("%d %d\n", optind, argc);
			optind++;
		}
		//for(int i = 0; i < arraysize; i++){
		//	printf("%s\n", patterns[i]);
		//}
	}
	if(filepats){
		FILE *fptr;
		fptr = fopen(argv[optind], "r");
		char S[6];
		if(fptr == NULL){
			printf("unable to open file\n");
		}
		else{
			int track = 0;
			arraysize = 100;
			while(fgets(S, 6, fptr)){
				printf("%s", S);
				for(int i = 0;i < sizeof(S); i++){
					patterns[track][i] = S[i];
				}
				track++;
			}
			arraysize = track;
		}
		fclose(fptr);
	}
	char pats[arraysize/2][10] = {};
	int patsind = 0;
	int durs[arraysize/2] = {};
	int dursind = 0;
	for(int i = 0; i < arraysize; i++){
		if(i % 2 == 0){
			for(int ii = 0; ii < sizeof(patterns[i]); ii++){
				pats[patsind][ii] = patterns[i][ii];
				
			}
			patsind++;
		}
		else{
			durs[dursind] = atoi(patterns[i]);
			dursind++;
		}
	}
	while(1){
		for(int i = 0; i < arraysize/2; i++){
			if(verbose){printf("LED pattern =  %08lb, Display duration: %d msec\n", strtol(pats[i],0,16),durs[i]);}
			devmem("0xff200008", pats[i]);
			usleep(durs[i] * 1000);
		}
	}
	
	return 0;
}

