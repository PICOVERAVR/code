/*** code that gets included always goes here ***/
%{
	#include <stdio.h>
	#include <math.h>
%}
%option noyywrap

DIGIT [0-9]
ID [a-z][a-z0-9]*

%%

{DIGIT}+	{
		printf("Saw int %s -> %d\n", yytext, atoi(yytext));
		}

{DIGIT}+"."{DIGIT}*	{
		printf("Saw a float %s -> %g\n", yytext, atof(yytext));
		}

if|then|while|for	{
		printf("Saw a keyword %s\n", yytext);
		}

{ID}		printf("Saw an identifier %s\n", yytext);
"+"|"-"		printf("Saw an operator %s\n", yytext);
.		printf("Error: unrecognized character\n");

%%

int main(char argc, char **argv) {
	yyin = stdin;
	yylex();
}
