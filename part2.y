%{
#include <stdlib.h>
#include <stdio.h>
#include "part2_helpers.h"

extern int yylex();

void yyerror(const char*);

ParserNode* parseTree;
%}

%token int_tok
%token float_tok
%token void_tok
%token write_tok
%token read_tok
%token while_tok
%token do_tok
%token if_tok
%token then_tok
%token else_tok
%token return_tok
%token volatile_tok
%token '('
%token ')'
%token '{'
%token '}'
%token '?'
%token ','
%token ':'
%token ';'
%token '&'
%token '@'
%token id_tok
%token num_tok
%token str_tok
%token relop_tok
%token addop_tok
%token mulop_tok
%token assign_tok
%token and_tok
%token or_tok
%token not_tok

%%

PROGRAM:        FDEFS {}
FDEFS:
                FDEFS FUNC_API BLK{}

            |
                FDEFS FUNC_API ';' {}
            |
               /* epsilon */

FUNC_API:
                TYPE id_tok '(' FUNC_ARGS ')' {}

FUNC_ARGS:
                FUNC_ARGLIST {}
            |
                /* epsilon */

FUNC_ARGLIST:
                FUNC_ARGLIST ',' DCL {}
            |
                DCL {}

BLK:            '{' STLIST '}' {}

DCL:            id_tok ':' TYPE {}
            |
                id_tok ',' DCL {} 

TYPE:
                int_tok {}
            |
                float_tok {}
            |
                void_tok {}
            |
                int_tok'@' {}
            |
                volatile_tok int_tok {}

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
                return_tok EXP ';'{}
            |
                return_tok';'{}

WRITE:
                write_tok '(' EXP ')' ';'{}
            |
                write_tok '(' str_tok ')' ';'{}

READ:
                read_tok '(' LVAL ')' ';'{}

ASSN:
                LVAL assign_tok EXP ';'{}

ASSN_C:
                LVAL assign_tok '('BEXP')''?' EXP ':' EXP{}

LVAL:
                id_tok{}
            |
                '@'EXP{}

CNTRL:
                if_tok BEXP then_tok STMT else_tok STMT{}
            |
                if_tok BEXP then_tok STMT{}
            |
                while_tok BEXP do_tok STMT{}

BEXP:
                BEXP or_tok BEXP{}
            |
                BEXP and_tok BEXP{}
            |
                not_tok BEXP{}
            |
                EXP relop_tok EXP{}
            |
                '(' BEXP ')'{}

EXP:
                EXP addop_tok EXP{}
            |
                EXP mulop_tok EXP{}
            |
                '(' EXP ')'{}
            |
                '(' TYPE ')' EXP{}
            |
                id_tok{}
            |
                '&'EXP{}
            |
                '@'EXP{}
            |
                num_tok{}
            |
                CALL{}

CALL:
                id_tok '(' CALL_ARGS ')'{}

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

