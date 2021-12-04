%{
    #include <stdio.h>

    void printtitle(char* s, int len)
    {
        char temp[200]="";
        int j = 0;
        int check=0;
        int num=0;
        for(int i = 0 ; i < len ; i++)
        {
            if(s[i]!='#' && check==0)//we meet the first white space
            {
                check = 1;
            }
            else if(check==0)
            {
                num+=1;
            }
            else if(check==1){
                temp[j]=s[i];
                j++;
            }
        }
        printf("<h%d>%s</h%d>",num,temp,num);
    }
    void printdi()
    {
        printf("<hr />");
    }
    void printpictrue(char* s, int len)
    {
        char alt[200]="";
        char src[200]="";
        int j = 0;
        int checkalt=0;
        int checksrc=0;
        for(int i = 0 ; i < len ; i++)
        {
            if(s[i]=='[')
            {
                checkalt=1;
            }
            else if(s[i]==']')
            {
                checkalt=0;
            }
            else if(checkalt==1)
            {
                alt[j]+=s[i];
                j++;
            }
            if(s[i]=='(')
            {
                checksrc=1;
                j=0;
            }
            else if(s[i]==')'){
                checksrc=0;
            }
            else if(checksrc==1)
            {
                src[j]+=s[i];
                j++;
            }
        }
        printf("<img alt=\"%s\" src=\"%s\">",alt,src);       
    }
    void printbox(char* s , int len)
    {
        char temp[200]="";
        int j = 0;
        int check = 0;
        int in=0;
        int intxt=0;
        for(int i = 0 ; i < len ; i++)
        {
            if(s[i]=='[')
            {
                in = 1;
            }
            else if(intxt==1)
            {
                temp[j]+=s[i];
                j++;
            }
            else if(s[i]==']')
            {
                in = 0;
                intxt=1;
            }
            else if(in == 1)
            {
                if(s[i]=='X' || s[i]=='x')
                {
                    check = 1;
                }
            }
        } 
        if(check == 0 )
        {
            printf("<p>\n");
            printf("\t<input type=\"checkbox\" />%s\n",temp);
            printf("</p>");
        }
        else{
            printf("<p>\n");
            printf("\t<input checked=\"checked\" type=\"checkbox\" />%s\n",temp);
            printf("</p>");            
        }
    }
%}

%%
^[#]+[" "].+$ {printtitle(yytext,yyleng);}
"---" {printdi();}
^[!].+$ {printpictrue(yytext,yyleng);}
"-"[" "].+$ {printbox(yytext,yyleng);}
%%
int main(){
    yylex();
    return 0;
}