#include "sd.h"
#pragma once

typedef struct {
    char *name;
    char permissions;
    sd_block *file_ptr;
} sd_file;

int fat_init(void);
int fat_open(char *filename);
int fat_close(void);
int fat_traverse(void);
int fat_search(void);
int fat_flush(void);

