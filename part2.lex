%{
#include <stdio.h>
#include <stdlib.h>
#include "part2_helpers.h"
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
int                              { yylval = makeNode("int", NULL, NULL) ; return int_token; }
float                            { yylval = makeNode("float", NULL, NULL) ; return float_token; }
void                             { yylval = makeNode("void", NULL, NULL) ; return void_token; }
write                            { yylval = makeNode("write", NULL, NULL) ; return write_token; }
read                             { yylval = makeNode("read", NULL, NULL) ; return read_token; }
while                            { yylval = makeNode("while", NULL, NULL) ; return while_token; }
do                               { yylval = makeNode("do", NULL, NULL) ; return do_token; }
if                               { yylval = makeNode("if", NULL, NULL) ; return if_token; }
then                             { yylval = makeNode("then", NULL, NULL) ; return then_token; }
else                             { yylval = makeNode("else", NULL, NULL) ; return else_token; }
return                           { yylval = makeNode("return", NULL, NULL) ; return return_token; }
volatile                         { yylval = makeNode("volatile", NULL, NULL) ; return volatile_token; }
{sign}                           { yylval = makeNode(yytext[0], NULL, NULL) ; return yytext[0]; }
{id}                             { yylval = makeNode("id" , yytext, NULL) ; return id_token; }
{num}                            { yylval = makeNode("num" , yytext, NULL) ; return num_token; }
{str}                            { yylval = makeNode("str" , yytext, NULL) ; return str_token; }
{rel}                            { yylval = makeNode("relop" , yytext, NULL) ; return relop_token; }
{addsub}                         { yylval = makeNode("addop" , yytext, NULL) ; return addop_token; }
{muldiv}                         { yylval = makeNode("mulop" , yytext, NULL) ; return mulop_token; }
"="                              { yylval = makeNode("assign" , yytext, NULL) ; return assign_token; }
"&&"                             { yylval = makeNode("and" , yytext, NULL) ; return and_token; }
"||"                             { yylval = makeNode("or" , yytext, NULL) ; return or_token; }
"!"                              { yylval = makeNode("not" , yytext, NULL) ; return not_token; }
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
