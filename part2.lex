%{
#include <stdio.h>
#include <stdlib.h>
#include "part2.h"
void LexErr();
void printstr();
%}

%option yylineno noyywrap
%option   outfile="part2.lex.c" header-file="part2.lex.h"

digit       ([0-9])
letter      ([a-zA-Z])
newline     (\r?\n)
whitespace  ([\t ]|{newline})
id          {letter}({letter}|{digit}|_)*
num         {digit}+(.{digit}+)?(E[+-]?{digit}+)?
str         (\"([^"\\\n]?(\\["n\\])?)*\")
sign        [(){}?,:;&@]
comment     #(.*)
rel         ("=="|"<>"|"<"|"<="|">"|">=")
addsub      ("+"|"-")
muldiv      ("*"|"/")


%%
int                              { yylval = makeNode("int", NULL, NULL, NULL) ; return int_token; }
float                            { yylval = makeNode("float", NULL, NULL, NULL) ; return float_token; }
void                             { yylval = makeNode("void", NULL, NULL, NULL) ; return void_token; }
write                            { yylval = makeNode("write", NULL, NULL, NULL) ; return write_token; }
read                             { yylval = makeNode("read", NULL, NULL, NULL) ; return read_token; }
while                            { yylval = makeNode("while", NULL, NULL, NULL) ; return while_token; }
do                               { yylval = makeNode("do", NULL, NULL, NULL) ; return do_token; }
if                               { yylval = makeNode("if", NULL, NULL, NULL) ; return if_token; }
then                             { yylval = makeNode("then", NULL, NULL, NULL) ; return then_token; }
else                             { yylval = makeNode("else", NULL, NULL, NULL) ; return else_token; }
return                           { yylval = makeNode("return", NULL, NULL, NULL) ; return return_token; }
volatile                         { yylval = makeNode("volatile", NULL, NULL, NULL) ; return volatile_token; }
{sign}                           { yylval = makeNode(yytext[0], NULL, NULL, NULL) ; return yytext[0]; }
{id}                             { yylval = makeNode("id" , yytext, NULL, NULL); return id; }
{num}                            { yylval = makeNode("num" , yytext, NULL, NULL); return num; }
{str}                            { yylval = makeNode("str" , yytext, NULL, NULL); return str; }
{rel}                            { yylval = makeNode("relop" , yytext, NULL, NULL); return relop; }
{addsub}                         { yylval = makeNode("addop" , yytext, NULL, NULL); return addop; }
{muldiv}                         { yylval = makeNode("mulop" , yytext, NULL, NULL); return mulop; }
"="                              { yylval = makeNode("assign" , yytext, NULL, NULL); return assign; }
"&&"                             { yylval = makeNode("and" , yytext, NULL, NULL); return and; }
"||"                             { yylval = makeNode("or" , yytext, NULL, NULL); return or; }
"!"                              { yylval = makeNode("not" , yytext, NULL, NULL); return not; }
{whitespace}                     ;
{comment}                        ;
.                                LexErr(); 
%%
// TODO: should we remove quotes from str?


void LexErr()
{
    printf("\nLexical error: '%s' in line number %d\n", yytext, yylineno);
    exit(1);
}


// TODO: REMOVE THIS
void printstr()
{
    yytext[yyleng - 1] = 0;
    printf("<str,%s>", yytext + 1);
}
