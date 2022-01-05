%{
    #include <stdlib.h>
    #include "dm3_2.tab.h"
    int whereWeAre = 0;
%}
%%
" "+                 { whereWeAre+=yyleng;}
[0-9]+              { whereWeAre+=yyleng; yylval.inumber = atoi(yytext); return MATRIXNUMBER;}
"+"|"-"|"*"|"^"    { whereWeAre+=yyleng; yylval.whereWeAreNow = whereWeAre; return yytext[0]; /*we send whereWeAre because we may have problem in Arithmetic*/}
"("|")"|"["|"]"|","|"T" { whereWeAre+=yyleng;  return yytext[0];}
. {}
%%