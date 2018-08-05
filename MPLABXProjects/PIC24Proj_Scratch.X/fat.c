#include "fat.h"

//NOTE: this lib only supports FAT32 filesystems coming from SD cards.  Other versions of FAT or exFAT
//have not been tested and will probably crash.

static sd_block mbr, vbr, fat, root;
static sd_block_addr mbr_addr, vbr_addr, fat_addr, root_addr;
//sd_block_addr current;
//add a thing here to keep track of current location in filesystem

//have different initialization methods here that all do the same thing
int fat_init(void) {
    //initialize the SD card driver
    if (sd_init() == SD_INIT_FAIL) {
        return -1;
    }
    
    //start out by reading block 0, figure out where the VBR is
    mbr_addr.uint = 0;
    sd_readBlock(mbr_addr, &mbr);
    
    
    //need verification that we are indeed dealing with a FAT32 filesystem here!
    
    //read bytes 0x1C6 -> 0x1CA for VBR block
    for (int i = 0; i < 4; i++) {
        vbr_addr.byte[i] = mbr.data[0x1C6 + i];
    }
    sd_readBlock(vbr_addr, &vbr);
    
    //find the FAT from the VBR info
    fat_addr.byte[0] = vbr.data[0x0E];
    fat_addr.byte[1] = vbr.data[0x0F];
    fat_addr.byte[2] = 0;
    fat_addr.byte[3] = 0;
    
    //add the FAT addr to the VBR address, since the FAT location is VBR-relative
    fat_addr.uint += vbr_addr.uint;
    sd_readBlock(fat_addr, &fat);
    
    //also find the root directory from the VBR
    root_addr.byte[0] = vbr.data[0x24];
    root_addr.byte[1] = vbr.data[0x25];
    root_addr.byte[2] = vbr.data[0x26];
    root_addr.byte[3] = vbr.data[0x27];
    
    root_addr.uint *= 2; //skip 2nd FAT
    root_addr.uint += fat_addr.uint; //??
    
    sd_readBlock(root_addr, &root);
    
//    sd_printBlock(&mbr);
//    printf("\n\n");
//    sd_printBlock(&vbr);
//    printf("\n\n");
//    sd_printBlock(&fat);
    printf("\n\n");
    sd_printBlock(&root); //root dir may span two blocks
//    
//    
//    
//    
//    
//    
//    
//    printf("\nroot addr: %ld", root_addr.uint);
//    root_addr.uint += (0x102 * 64);
//    printf("\nnew root addr: %ld", root_addr.uint);
//    sd_readBlock(root_addr, &root);
//    printf("\n\n");
//    sd_printBlock(&root);
    
    return 0;
    
    //in order to find all of a file, first check the root directory, and find the file from there
    //dir will tell you initial block of the file?
    //also check FAT for files that are larger than a single block...
    //need to read more about this.
}

//TODO: link all this stuff to standard C read/write commands maybe, so that fprintf and related calls
//will still work!

//open a file from the SD card
//maybe have this malloc required memory?
int fat_open(char *filename) {
    char name_buf[12]; //always 11 bytes wide, +1 for NULL
    
    for (int i = 32; i < 512; i += 32) { //we can skip the directory info itself, not a file
        if (root.data[i] != 0xE5 && (root.data[i + 0x0B] >> 5) & 1) { //not an unused file and not a directory
            
            memcpy(name_buf, root.data + i, 11);
            name_buf[11] = NULL;
            printf("got name %s\n", name_buf);
            
            //strip whitespace out of name
            
        }
    }
    
    return -1;
}

//close a file
int fat_close(void) {
    return -1;
}

//traverse to a sub or superdirectory

int fat_traverse(void) {
    return -1;
}

//search for a file
//idk if this will be recursive or not...
int fat_search(void) {
    return -1;
}

//close all open files on the SD card
//then optionally reset the SD card and re-initialize the filesystem
int fat_flush(void) {
    return -1;
}
