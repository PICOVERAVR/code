#include <pthread.h> //link against -lpthread
#define THREADNUM 4

pthread_attr_t attr;

void *test(void *tid) {
    pthread_attr_setstacksize(&attr, 0x2000); //sets stackSize to 8K, default is 1M for this mac
    
    pthread_exit(NULL);
}

int main (int argc, char *argv[]) {
    pthread_attr_init(&attr); //initialize attribute
    pthread_t tstr[THREADNUM]; //thread id's
    
    
    for (int i = 1; i <= THREADNUM; i++) {
        pthread_create(&tstr[i], NULL, test, (void *)42);
    }
    
    pthread_exit(NULL);
}


