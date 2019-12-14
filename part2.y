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
              
BLK:  '{' STLIST '}' {}

DCL:   id ':' TYPE {}
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

