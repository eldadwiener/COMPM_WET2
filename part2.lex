%{
#include <stdio.h>
void LexErr();
void printstr();
%}

%option yylineno noyywrap
%option   outfile="part1.c" header-file="part1.h"

digit       ([0-9])
letter      ([a-zA-Z])
newline     (\r?\n)
whitespace  ([\t ]|{newline})
id          {letter}({letter}|{digit}|_)*
num         {digit}+(.{digit}+)?(E[+-]?{digit}+)?
str         (\"([^"\\\n]?(\\["n\\])?)*\")
reserved    ((int)|(float)|(void)|(write)|(read)|(while)|(do)|(if)|(then)|(else)|(return)|(volatile))
sign        [(){}?,:;&@]
comment     #(.*)
rel         ("=="|"<>"|"<"|"<="|">"|">=")
addsub      ("+"|"-")
muldiv      ("*"|"/")

%%
{reserved}                          printf("<%s>", yytext);
{sign}                              printf("%s", yytext);
{id}                                printf("<id,%s>", yytext);
{num}                               printf("<num,%s>", yytext);
{str}                               printstr();
{rel}                               printf("<relop,%s>", yytext);
{addsub}                            printf("<addop,%s>", yytext);
{muldiv}                            printf("<mulop,%s>", yytext);
"="                                 printf("<assign,%s>", yytext);
"&&"                                printf("<and,%s>", yytext);
"||"                                printf("<or,%s>", yytext);
"!"                                 printf("<not,%s>", yytext);
{whitespace}                        printf("%s",yytext);
{comment}                           ;
.                                   LexErr(); 
%%

void LexErr()
{
    printf("\nLexical error: '%s' in line number %d\n", yytext, yylineno);
    exit(1);
}


void printstr()
{
    yytext[yyleng - 1] = 0;
    printf("<str,%s>", yytext + 1);
}