#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <sys/mman.h> //for mman?
#include <fcntl.h> //for file open flags
#include <unistd.h> //for getting the page size

void usage(){
  fprintf(stderr, "devmem ADDRESS [VALUE]\n");
  fprintf(stderr, " devmem can be used to read/write to physical memory via the /dev/mem device.\n");
  fprintf(stderr, " devmem will only read/write 32-bit values\n\n");
  fprintf(stderr, " Arguments:\n");
  fprintf(stderr, " ADDRESS The address to read/write to/from\n");
  fprintf(stderr, " VALUE The optional value to write to ADDRESS; if not given, a read will be performed.\n");
}

int main(int argc, char **argv){
//This is the size of the page of memory in the system. (4096 bytes probably)
const size_t PAGE_SIZE = sysconf(_SC_PAGE_SIZE);

if(argc == 1){ //No args given, print usage text and exit argv[1] is first actual arg
  usage();
  return 1;
}

//If value arg given, perform a write opp
bool is_write = (argc == 3) ? true : false;

const uint32_t ADDRESS = strtoul(argv[1], NULL, 0);

int fd = open("/dev/mem", O_RDWR | O_SYNC);
if (fd == -1){
  fprintf(stderr, "failed to open /dev/mem.\n");
  return 1;
}
printf("page_virtual_addr = %p\n", page_virtual_addr);

//The address we want to access might not be page-aligned. Since we mapped a page-aligned address, we need our target address' offet from the page boundary. Using this offset, we can copute the virtual address corresponding to our physical target address (ADDRESS).
uint32_t offset_in_page = ADDRESS & (PAGE_SIZE - 1);
printf("offset in page = 0x%x\n",offset_in_page);

//Compute the virtual address corresponding to ADDRESS.
volatile uint32_t *target_virtual_addr = page_virtual_addr + offset_in_page/sizeof(uint32_t*);
printf("target_virtual_addr = %p\n", target_virtual_addr);
printf("-----------------------------------------------------------------------------\n");

if(is_write){
  const uint32_t VALUE = strtoul(argv[2], NULL, 0);
  *target_virtual_addr = VALUE;
}
else{
  printf("\nvalue at 0x%x = 0x%x\n, ADDRESS, *target_virtual_addr);
}
return 0;
}
