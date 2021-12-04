%{
    void printnull()
    {
    }
%}
eol \n
%%
^[0-9]+[\.][0-9]*$ {ECHO;printf("\n");}
^[0-9]*[\.][0-9]+$ {ECHO;printf("\n");}
^[0-9]+[\.]?[0-9]*(E|e)(\+|\-)?[0-9]+$ {ECHO;printf("\n");}
^[0-9]*[\.]?[0-9]+(E|e)(\+|\-)?[0-9]+$ {ECHO;printf("\n");}
. {printnull();}
\n {printnull();}
%%
int main(){
    yylex();
    return 0;
}