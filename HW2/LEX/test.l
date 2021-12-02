%{
    int Count=0;
    void cool()
    {
        for(int i =0 ; i < Count ; i++) 
        {
            printf("\t");
        }
    }
%}
LHS [{]
RHS [}]
%%
{RHS}   { Count--  ; cool() ;printf("%s",yytext) ;}
^\{ { cool() ;printf("%s",yytext) ; Count++ ;}
^.   { cool() ;  printf("%s",yytext);}
{LHS}   { Count++ ; printf("%s",yytext) ; } 
%%
int main(){
    yylex();
    return 0;
}