%{
#include <stdio.h>
#include <stdlib.h>
#include "part2_helpers.h"
#include "part2.tab.h"

void LexErr();
void printstr();
%}

%option yylineno noyywrap
%option   outfile="part2-lex.c" header-file="part2-lex.h"

digit       ([0-9])
letter      ([a-zA-Z])
newline     (\r?\n)
whitespace  ([\t ]|{newline})
id          {letter}({letter}|{digit}|_)*
num         {digit}+(\.{digit}+)?(E[+-]?{digit}+)?
str         (\"([^"\\\n]?(\\["n\\])?)*\")
sign        [(){}?,:;&@]
comment     #(.*)
rel         ("=="|"<>"|"<"|"<="|">"|">=")
addsub      ("+"|"-")
muldiv      ("*"|"/")


%%
int                              { yylval = makeNode("int", NULL, NULL) ; return int_tok; }
float                            { yylval = makeNode("float", NULL, NULL) ; return float_tok; }
void                             { yylval = makeNode("void", NULL, NULL) ; return void_tok; }
write                            { yylval = makeNode("write", NULL, NULL) ; return write_tok; }
read                             { yylval = makeNode("read", NULL, NULL) ; return read_tok; }
while                            { yylval = makeNode("while", NULL, NULL) ; return while_tok; }
do                               { yylval = makeNode("do", NULL, NULL) ; return do_tok; }
if                               { yylval = makeNode("if", NULL, NULL) ; return if_tok; }
then                             { yylval = makeNode("then", NULL, NULL) ; return then_tok; }
else                             { yylval = makeNode("else", NULL, NULL) ; return else_tok; }
return                           { yylval = makeNode("return", NULL, NULL) ; return return_tok; }
volatile                         { yylval = makeNode("volatile", NULL, NULL) ; return volatile_tok; }
{sign}                           { yylval = makeNode(yytext, NULL, NULL) ; return yytext[0]; }
{id}                             { yylval = makeNode("id" , yytext, NULL) ; return id_tok; }
{num}                            { yylval = makeNode("num" , yytext, NULL) ; return num_tok; }
{str}                            {
                                    yytext[yyleng - 1] = 0;
                                    yylval = makeNode("str" , yytext + 1, NULL) ;
                                    return str_tok;
                                    }
{rel}                            { yylval = makeNode("relop" , yytext, NULL) ; return relop_tok; }
{addsub}                         { yylval = makeNode("addop" , yytext, NULL) ; return addop_tok; }
{muldiv}                         { yylval = makeNode("mulop" , yytext, NULL) ; return mulop_tok; }
"="                              { yylval = makeNode("assign" , yytext, NULL) ; return assign_tok; }
"&&"                             { yylval = makeNode("and" , yytext, NULL) ; return and_tok; }
"||"                             { yylval = makeNode("or" , yytext, NULL) ; return or_tok; }
"!"                              { yylval = makeNode("not" , yytext, NULL) ; return not_tok; }
{whitespace}                     ;
{comment}                        ;
.                                LexErr();
%%

void LexErr()
{
    printf("\nLexical error: '%s' in line number %d\n", yytext, yylineno);
    exit(1);
}


