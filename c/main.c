#include "header.h"

void ncurses_init() {
	initscr();
	raw(); //no line buffering
	keypad(stdscr, TRUE); //we get function keys
	noecho(); //no echo for getch
}

int main(int argc, char **argv) {
	ncurses_init();
	
	char c = getch();
	
	if (c == KEY_F(1)) {
		printw("F1 key pressed");
	} else {
		attron(A_BOLD);
		printw("got %c\n", c);
		attroff(A_BOLD);
	}
	
	refresh();
	getch(); //without this the program would just not show??
	endwin();
}
