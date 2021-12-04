%{
    #include <stdio.h>
    int checklist = 0 ;
    int checkquote = 0 ;
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
        if(checklist==1)
        {
            printf("</ul>\n");
            checklist=0;
        }
        if(checkquote == 1)
        {
            printf("</blockquote>\n");
            checkquote=0;
        }
        printf("<hr />\n");
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
    void printlist(char *s , int len)
    {
        if(checklist==0)
        {
            printf("<ul>\n");
            checklist=1;
        }
        char temp[200]="";
        int j = 0;
        int listnum = 0;
        for(int i = 0 ; i < len ; i++)
        {
            if(i==0||i==1)
            {
                continue;
            }
            else
            {
                temp[j]+=s[i];
                j++;
            } 
        }
        printf("\t<li>%s</li>\n",temp);
    }
    void printlink(char *s , int len)
    {
        char span[200]="";
        char href[200]="";
        int j = 0;
        int checkspan = 0 ;
        int checkhref = 0 ;
        for ( int i = 0 ; i < len ; i++)
        {
            if(s[i]=='[')
            {
                checkspan = 1 ;
            }
            else if(s[i]==']')
            {
                checkspan = 0 ;
                j=0;
            }
            else if(checkspan ==1)
            {
                span[j]+=s[i];
                j++;
            }
            if(s[i]=='(')
            {
                checkhref=1;
            }
            else if(s[i]==')')
            {
                checkhref=0;
            }
            else if(checkhref==1)
            {
                href[j]+=s[i];
                j++;
            }
        }
        printf("<a href=\"%s\">\n",href);
        printf("\t<span>%s</span>\n",span);
        printf("</a>");
    }
    int strongcheck = 0;
    void printquote(char *s , int len)
    {
        if(checkquote==0)
        {
            printf("<blockquote>\n");
            checkquote=1;
        }
        char temp[200]="";
        char* str1 = "<strong>";
        char* str2 = "</strong>";
        int j = 0;
        for(int i = 0 ; i < len ; i++)
        {
            if(i==0||i==1)
            {
                continue;
            }
            else if(s[i]=='*' && s[i+1]=='*')
            {
                if(strongcheck==0)
                {
                    for(int k = 0 ; k <8 ;k++)
                    {
                        temp[j]+=str1[k];
                        j++;
                    }
                    strongcheck=1;
                }
                else if(strongcheck==1)
                {
                    for(int k = 0 ; k < 9 ;k++)
                    {
                        temp[j]+=str2[k];
                        j++;
                    }
                    strongcheck=0;
                }
                i=i+1;
            }
            else{
                temp[j]+=s[i];
                j++;
            }
        }   
        printf("%s\n",temp);  
    }
%}

%%
^[#]+[" "].+$ {printtitle(yytext,yyleng);}
"---" {printdi();}
^[!].+$ {printpictrue(yytext,yyleng);}
"-"[" "].+$ {printbox(yytext,yyleng);}
[\*][" "].+$ {printlist(yytext,yyleng);}
["["].+$ {printlink(yytext,yyleng);}
^>.+$ {printquote(yytext,yyleng);}
%%
int main(){
    yylex();
    return 0;
}