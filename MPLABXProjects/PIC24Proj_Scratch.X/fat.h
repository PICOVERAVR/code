#include "sd.h"
#pragma once

//NOTE: this lib only supports FAT32 filesystems coming from SD cards.  Other versions of FAT or exFAT
//have not been tested and will probably crash.

static sd_block mbr, vbr, fat, root;
static sd_block_addr mbr_addr, vbr_addr, fat_addr, root_addr;
//sd_block_addr current;
//add a thing here to keep track of current location in filesystem

typedef struct {
    char *name;
    char permissions;
    sd_block *file_ptr;
} file;

//have different initialization methods here that all do the same thing
int fat_init() {
    //initialize the SD card driver
    if (!sd_init()) {
        return -1;
    }
    
    //start out by reading block 0, figure out where the VBR is
    mbr_addr = {0};
    sd_readBlock(mbr_addr, &mbr);
    
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
    
    root_addr.uint *= 2;
    root_addr.uint = root_addr.uint + fat_addr.uint;
    
    sd_readBlock(root_addr, &root);
    
    sd_printBlock(&fat);
    printf("\n\n");
    sd_printBlock(&root);
    
    //in order to find all of a file, first check the root directory, and find the file from there
    //dir will tell you initial block of the file?
    //also check FAT for files that are larger than a single block...
    //need to read more about this.
}

//TODO: link all this stuff to standard C read/write commands maybe, so that fprintf and related calls
//will still work!

//open a file from the SD card
int fat_open() {
    return -1;
}

//close a file
int fat_close() {
    return -1;
}

//traverse to a sub or superdirectory

int fat_traverse() {
    return -1;
}

//search for a file
//idk if this will be recursive or not...
int fat_search() {
    return -1;
}

//close all open files on the SD card
//then optionally reset the SD card and re-initialize the filesystem
int fat_flush() {
    return -1;
}
