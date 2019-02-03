/* color graphics example 
 Modern terminals use ANSI escape codes to print special text.


*/

#include <stdio.h>

#define KNRM "\x1B[0m" // reset everything to normal
#define KRED "\x1B[31m"
#define KGRN "\x1B[32m"
#define KYEL "\x1B[33m"
#define KBLU "\x1B[34m"
#define KMAG "\x1B[35m"
#define KCYN "\x1B[36m"
#define KWHT "\x1B[37m"

#define KBOLD "\x1B[1m"
#define KITAL "\x1B[3m"

int main() {
    printf("%sred\n", KRED);
    printf("%sgreen\n", KGRN);
    printf("%syellow\n", KYEL);
    printf("%sblue\n", KBLU);
    printf("%smagenta\n", KMAG);
    printf("%scyan\n", KCYN);
    printf("%swhite\n", KWHT);
    printf("%snormal\n", KNRM);

	printf("%s%sTEST text\n", KRED, KITAL);
}
