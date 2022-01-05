%{
    #include <stdlib.h>
    #include "dm3_1.tab.h"
%}
%%
^[a-zA-Z]+$ {
                yylval.op = yytext ;
                return SINGLEWORD;
            }
[a-zA-Z]+   {
                yylval.op = yytext ;
                return WORD;
            }
[0-9]+      {
                yylval.number = atoi(yytext) ;
                return INUMBER;
            }
. { }

%%