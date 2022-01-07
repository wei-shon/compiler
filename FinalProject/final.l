%{
    #include <stdlib.h>
    #include "final.tab.h"
    
%}
separator "\t"|"\n"|"\r"|" "
letter [a-z]
digit [0-9]
%%
0|[1-9]{digit}*|"-"[1-9]{digit}* {  yylval.integer=atoi(yytext); return number;}
"print-num" {return printnum;}
"print-bool" {return printbool;}
"mod" {return mod;}
"and" {return an;}
"or" { return orr ;}
"fun" { return fun ;}
"not" { return nott ;}
"define" { return define; }
"lambda" { return fun ;}
"if" { return IF; }
"("|")"|"+"|"-"|"*"|"/"|">"|"<"|"=" { return yytext[0];}
[a-z]({letter}|{digit}|"-")* { yylval.var = yytext; return id; }
"#t"|"#f" {  yylval.boolop=yytext; return boolval;}
. {}
%%