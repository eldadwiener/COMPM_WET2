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

PROGRAM:        FDEFS {}
FDEFS:
                FDEFS FUNC_API BLK{}
            |
                FDEFS FUNC_API ';' {}
            |
               /* epsilon */

FUNC_API:
                TYPE id '(' FUNC_ARGS ')' {}

FUNC_ARGS:
                FUNC_ARGLIST {}
            |
                /* epsilon */

FUNC_ARGLIST:
                FUNC_ARGLIST ',' DCL {}
            |
                DCL {}

BLK:            '{' STLIST '}' {}

DCL:            id ':' TYPE {}
            |
                id ',' DCL {} 

TYPE:
                int {}
            |
                float {}
            |
                void {}
            |
                int'@' {}
            |
                volatile int {}

STLIST:
                STLIST STMT
            |
                /* epsilon */

STMT:
                DCL ';' {}
            |
                ASSN {}
            |
                EXP ';' {}
            |
                CNTRL {}
            |
                READ {}
            |
                WRITE {}
            |
                RETURN {}
            |
                BLK {}
            |
                ASSN_C{}


RETURN:
                return EXP ';'{}
            |
                return';'{}

WRITE:
                write '(' EXP ')' ';'{}
            |
                write '(' str ')' ';'{}

READ:
                read '(' LVAL ')' ';'{}

ASSN:
                LVAL assign EXP ';'{}

ASSN_C:
                LVAL assign '('BEXP')''?' EXP ':' EXP{}

LVAL:
                id{}
            |
                '@'EXP{}

CNTRL:
                if BEXP then STMT else STMT{}
            |
                if BEXP then STMT{}
            |
                while BEXP do STMT{}

BEXP:
                BEXP or BEXP{}
            |
                BEXP and BEXP{}
            |
                not BEXP{}
            |
                EXP relop EXP{}
            |
                '(' BEXP ')'{}

EXP:
                EXP addop EXP{}
            |
                EXP mulop EXP{}
            |
                '(' EXP ')'{}
            |
                '(' TYPE ')' EXP{}
            |
                id{}
            |
                '&'EXP{}
            |
                '@'EXP{}
            |
                num{}
            |
                CALL{}

CALL:
                id '(' CALL_ARGS ')'{}

CALL_ARGS:
                CALL_ARGLIST{}
            |   /*epsilon*/

CALL_ARGLIST:
                CALL_ARGLIST ',' EXP{}
            |
                EXP{}
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

