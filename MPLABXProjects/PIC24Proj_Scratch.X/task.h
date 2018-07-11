#include "header.h"
#pragma once

struct task_buf {
    void (*func)(void *);
    int tid;
    int priority;
    struct task_buf *next;
};
//do not optimize this
typedef struct task_buf task_buf;

task_buf *task_add(void (*task_func)(void *), int priority);
void task_remove(task_buf *buf, task_buf *prev);

void task_yield(int exit);

int task_init(void);
void task_start(void);