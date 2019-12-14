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

PROGRAM:        FDEFS { $$ = makeNode("PROGRAM", NULL, $1); }
FDEFS:
                FDEFS FUNC_API BLK{
                                    $$ = makeNode("FDEFS", NULL, $1);
                                    concatList($1, $2);
                                    concatList($1, $3);
                                    }

            |
                FDEFS FUNC_API ';' {
                                    $$ = makeNode("FDEFS", NULL, $1);
                                    concatList($1, $2);
                                    concatList($1, $3);
                                    }
            |
               /* epsilon */       { $$ = makeNode("FDEFS", NULL, makeNode("EPSILON", NULL, NULL)); }

FUNC_API:
                TYPE id_tok '(' FUNC_ARGS ')' {
                                                $$ = makeNode("FUNC_API", NULL, $1);
                                                concatList($1, $2);
                                                concatList($1, $3);
                                                concatList($1, $4);
                                                concatList($1, $5);
                                                }

FUNC_ARGS:
                FUNC_ARGLIST { $$ = makeNode("FUNC_ARGS", NULL, $1); }
            |
               /* epsilon */       { $$ = makeNode("FUNC_ARGS", NULL, makeNode("EPSILON", NULL, NULL)); }

FUNC_ARGLIST:
                FUNC_ARGLIST ',' DCL {
                                    $$ = makeNode("FUNC_ARGLIST", NULL, $1);
                                    concatList($1, $2);
                                    concatList($1, $3);
                                    }
            |
                DCL { $$ = makeNode("FUNC_ARGLIST", NULL, $1); }

BLK:            '{' STLIST '}' {
                                    $$ = makeNode("BLK", NULL, $1);
                                    concatList($1, $2);
                                    concatList($1, $3);
                                    }

DCL:            id_tok ':' TYPE {
                                    $$ = makeNode("DCL", NULL, $1);
                                    concatList($1, $2);
                                    concatList($1, $3);
                                    }
            |
                id_tok ',' DCL {
                                    $$ = makeNode("DCL", NULL, $1);
                                    concatList($1, $2);
                                    concatList($1, $3);
                                    }

TYPE:
                int_tok { $$ = makeNode("TYPE", NULL, $1); }
            |
                float_tok { $$ = makeNode("TYPE", NULL, $1); }
            |
                void_tok { $$ = makeNode("TYPE", NULL, $1); }
            |
                int_tok'@' {
                                $$ = makeNode("TYPE", NULL, $1);
                                concatList($1, $2);
                                }
            |
                volatile_tok int_tok {
                                        $$ = makeNode("TYPE", NULL, $1);
                                        concatList($1, $2);
                                        }

STLIST:
                STLIST STMT {
                                $$ = makeNode("STLIST", NULL, $1);
                                concatList($1, $2);
                                }
            |
               /* epsilon */       { $$ = makeNode("STLIST", NULL, makeNode("EPSILON", NULL, NULL)); }

STMT:
                DCL ';' {
                            $$ = makeNode("STMT", NULL, $1);
                            concatList($1, $2);
                            }
            |
                ASSN { $$ = makeNode("STMT", NULL, $1); }
            |
                EXP ';' {
                            $$ = makeNode("STMT", NULL, $1);
                            concatList($1, $2);
                            }
            |
                CNTRL { $$ = makeNode("STMT", NULL, $1); }
            |
                READ { $$ = makeNode("STMT", NULL, $1); }
            |
                WRITE { $$ = makeNode("STMT", NULL, $1); }
            |
                RETURN { $$ = makeNode("STMT", NULL, $1); }
            |
                BLK { $$ = makeNode("STMT", NULL, $1); }
            |
                ASSN_C{ $$ = makeNode("STMT", NULL, $1); }


RETURN:
                return_tok EXP ';'{
                                    $$ = makeNode("RETURN", NULL, $1);
                                    concatList($1, $2);
                                    concatList($1, $3);
                                    }
            |
                return_tok';'{
                                $$ = makeNode("RETURN", NULL, $1);
                                concatList($1, $2);
                                }

WRITE:
                write_tok '(' EXP ')' ';'{
                                            $$ = makeNode("WRITE", NULL, $1);
                                            concatList($1, $2);
                                            concatList($1, $3);
                                            concatList($1, $4);
                                            concatList($1, $5);
                                            }
            |
                write_tok '(' str_tok ')' ';'{
                                                $$ = makeNode("WRITE", NULL, $1);
                                                concatList($1, $2);
                                                concatList($1, $3);
                                                concatList($1, $4);
                                                concatList($1, $5);
                                                }

READ:
                read_tok '(' LVAL ')' ';'{
                                                $$ = makeNode("READ", NULL, $1);
                                                concatList($1, $2);
                                                concatList($1, $3);
                                                concatList($1, $4);
                                                concatList($1, $5);
                                                }

ASSN:
                LVAL assign_tok EXP ';'{
                                                $$ = makeNode("ASSN", NULL, $1);
                                                concatList($1, $2);
                                                concatList($1, $3);
                                                concatList($1, $4);
                                                }

ASSN_C:
                LVAL assign_tok '('BEXP')''?' EXP ':' EXP{
                                                            /* TODO: is this missing a ';' ?? */
                                                            $$ = makeNode("ASSN_C", NULL, $1);
                                                            concatList($1, $2);
                                                            concatList($1, $3);
                                                            concatList($1, $4);
                                                            concatList($1, $5);
                                                            concatList($1, $6);
                                                            concatList($1, $7);
                                                            concatList($1, $8);
                                                            concatList($1, $9);
                                                            }

LVAL:
                id_tok{ $$ = makeNode("LVAL", NULL, $1); }
            |
                '@'EXP{
                        $$ = makeNode("LVAL", NULL, $1);
                        concatList($1, $2);
                        }

CNTRL:
                if_tok BEXP then_tok STMT else_tok STMT{
                                                            $$ = makeNode("CNTRL", NULL, $1);
                                                            concatList($1, $2);
                                                            concatList($1, $3);
                                                            concatList($1, $4);
                                                            concatList($1, $5);
                                                            concatList($1, $6);
                                                            }
            |
                if_tok BEXP then_tok STMT{
                                            $$ = makeNode("CNTRL", NULL, $1);
                                            concatList($1, $2);
                                            concatList($1, $3);
                                            concatList($1, $4);
                                            }
            |
                while_tok BEXP do_tok STMT{
                                            $$ = makeNode("CNTRL", NULL, $1);
                                            concatList($1, $2);
                                            concatList($1, $3);
                                            concatList($1, $4);
                                            }

BEXP:
                BEXP or_tok BEXP{
                                    $$ = makeNode("BEXP", NULL, $1);
                                    concatList($1, $2);
                                    concatList($1, $3);
                                    }
            |
                BEXP and_tok BEXP{
                                    $$ = makeNode("BEXP", NULL, $1);
                                    concatList($1, $2);
                                    concatList($1, $3);
                                    }
            |
                not_tok BEXP{
                                    $$ = makeNode("BEXP", NULL, $1);
                                    concatList($1, $2);
                                    }
            |
                EXP relop_tok EXP{
                                    $$ = makeNode("BEXP", NULL, $1);
                                    concatList($1, $2);
                                    concatList($1, $3);
                                    }
            |
                '(' BEXP ')'{
                                    $$ = makeNode("BEXP", NULL, $1);
                                    concatList($1, $2);
                                    concatList($1, $3);
                                    }

EXP:
                EXP addop_tok EXP{
                                    $$ = makeNode("EXP", NULL, $1);
                                    concatList($1, $2);
                                    concatList($1, $3);
                                    }
            |
                EXP mulop_tok EXP{
                                    $$ = makeNode("EXP", NULL, $1);
                                    concatList($1, $2);
                                    concatList($1, $3);
                                    }
            |
                '(' EXP ')'{
                                    $$ = makeNode("EXP", NULL, $1);
                                    concatList($1, $2);
                                    concatList($1, $3);
                                    }
            |
                '(' TYPE ')' EXP{
                                    $$ = makeNode("EXP", NULL, $1);
                                    concatList($1, $2);
                                    concatList($1, $3);
                                    concatList($1, $4);
                                    }
            |
                id_tok{ $$ = makeNode("EXP", NULL, $1); }
            |
                '&'EXP{
                            $$ = makeNode("EXP", NULL, $1);
                            concatList($1, $2);
                            }
            |
                '@'EXP{
                            $$ = makeNode("EXP", NULL, $1);
                            concatList($1, $2);
                            }
            |
                num_tok{ $$ = makeNode("EXP", NULL, $1); }
            |
                CALL{ $$ = makeNode("EXP", NULL, $1); }

CALL:
                id_tok '(' CALL_ARGS ')'{
                                                $$ = makeNode("CALL", NULL, $1);
                                                concatList($1, $2);
                                                concatList($1, $3);
                                                concatList($1, $4);
                                                }

CALL_ARGS:
                CALL_ARGLIST{ $$ = makeNode("CALL_ARGS", NULL, $1); }
            |
               /* epsilon */       { $$ = makeNode("CALL_ARGS", NULL, makeNode("EPSILON", NULL, NULL)); }

CALL_ARGLIST:
                CALL_ARGLIST ',' EXP{
                                        $$ = makeNode("CALL_ARGLIST", NULL, $1);
                                        concatList($1, $2);
                                        concatList($1, $3);
                                        }
            |
                EXP{ $$ = makeNode("CALL_ARGLIST", NULL, $1); }
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

