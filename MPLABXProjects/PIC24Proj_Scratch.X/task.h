#include "header.h"
#pragma once

typedef enum include {
    TASK_NONE = 0,
    TASK_TIMER = 1,
    TASK_MONITOR = 2,
} include;

struct task_buf {
    void (*func)(void *);
    int tid;
    int priority;
    struct task_buf *next;
    void *args;
};
//do not optimize this
typedef struct task_buf task_buf;

task_buf *task_add(void (*task_func)(void *), int priority, void *args);
void task_del(task_buf *buf, task_buf *prev);

void task_yield(int exit);

int task_init(enum include);
void task_start(void);