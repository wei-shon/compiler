%{
    #include <stdlib.h>
    #include "BA3_A.tab.h"
%}
%%
"push"      {
                yylval.op = yytext ;
                return PUSH;                
            }
"inverse"   {
                yylval.op = yytext ;
                return INVERSE;
            }
"inc"       {
                yylval.op = yytext ;
                return INC;
            }
"dec"       {
                yylval.op = yytext ;
                return DEC;
            }
[0-9]+      {
                yylval.number = atoi(yytext) ;
                return INUMBER;
            }
"$"         {
                yylval.op = yytext ;
                return LEAVE;
            }
. { }

%%