%{
#include <stdlib.h>
#include <stdio.h>
#include "part2_helpers.h"

extern int yylex();

void yyerror(const char*);

ParserNode* parseTree;
%}

%token EXP_END NUM_I NUM_F
%left '+'
%left '*'

%%

PROGRAM:  FDEFS {}
FDEFS: FDEFS FUNC_API BLK{}
     |
       FDEFS FUNC_API ;
        ;

%%

void yyerror(const char* msg)
{
    printf("yyerror %s\n", msg);
    exit(2);
}

int main(void)
{
    return yyparse();
}

