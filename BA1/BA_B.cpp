#include<iostream>
#include<string>
#include<vector>
using namespace std;

vector<string> output;
char input[1000];
bool IsNowInTheHTMLflag = false;


int htmlDocument(int i);
int htmlElement(int i);
int htmlContent(int i);
int htmlAttributeList(int i);
int htmlAttribute(int i);
int htmlChardata(int i);
int attribute(int i);
int TAG_OPEN(int i);
int TAG_NAME(int i);
int TAG_CLOSE(int i);
int TAG_OPEN_SLASH(int i);
int TAG_EQUALS(int i);
int DOUBLE_QUOTE_STRING(int i);
int SINGLE_QUOTE_STRING(int i);
int no(int i);
int HTML_TEXT(int i);
int main(){
    int pointer=0;
    char a;
    while((a=getchar())!=EOF){
        input[pointer]=a;
        pointer++;
    }
    input[pointer]='\0';
    pointer++;
    string temp="";
    int i = 0 ;
    bool flag_invalid=true;

    while(i<pointer){
        if(i==-1){//若有invalid，就不要輸出，直接跳出迴圈。
            flag_invalid=false;
            cout<<"invalid input"<<endl;
            break;
        }
        i=htmlDocument(i);
        //cout<<i<<" final"<<endl;
        //cout<<input[i]<<"  !!!!!"<<endl;
    }
    i=0;
    // while(flag_invalid&&i<output.size())
    // {
    //     cout<<output[i]<<endl;
    //     i++;
    // }
}

int htmlDocument(int i)
{
    if(input[i]!='\0' && input[i]!='\n'){//沒有到輸入尾端，就不要停止
        i = htmlElement(i);
        //cout<<i<<"stmts"<<endl;
    }
    else{
        i = no(i);
    }
    return i;
}
int htmlElement(int i)
{
    if(input[i]=='<'&& input[i+1]=='/')
    {
        i=TAG_OPEN_SLASH(i);
    }
    else if(input[i]=='<')
    {
        i = TAG_OPEN(i);
    }
    else if(input[i]=='>')
    {
        i = TAG_CLOSE(i);
    }
    else if(input[i]==' ')
    {
        i=i+1;
    }
    else if(IsNowInTheHTMLflag==true)
    {
        i = htmlAttributeList(i);
    }
    else if(IsNowInTheHTMLflag==false)
    {
        i = htmlContent(i);
    }
    return i;
}
int htmlContent(int i)
{
    i = htmlChardata(i);
    return i;
}
int htmlAttributeList(int i)
{
    i = htmlAttribute(i);
    return i;
}
int htmlAttribute(int i)
{
    i = TAG_NAME(i);
    if(input[i]=='>')
    {
        return i;
    }
    while(input[i]==' ')
    {
        i++;
    }
    if(input[i]=='=')
    {
        i = TAG_EQUALS(i);
        i = attribute(i);
    }
    return i;
}
int htmlChardata(int i)
{
    i = HTML_TEXT(i);
    return i;
}
int HTML_TEXT(int i)
{
    string temp = "";
    while(input[i]!='<')
    {
        temp+=input[i];
        i++;
    }
    cout<<"HTML_TEXT "<<temp<<endl;
    return i;   
}
int attribute(int i)
{
    while(input[i]!='\''&& input[i]!='\"')
    {
        i++;
    }
    if(input[i]=='\'')
    {
        i = SINGLE_QUOTE_STRING(i);
    }    
    else if(input[i]=='\"')
    {
        i = DOUBLE_QUOTE_STRING(i);
    }    
    return i;
}
int TAG_OPEN(int i)
{
     cout<<"TAG_OPEN <"<<endl;
     IsNowInTheHTMLflag=true;
    return i+1;   
}
int TAG_NAME(int i)
{
    string temp = "";
    while(input[i]!='=' && input[i]!=' ' && input[i]!='>')
    {
        temp+=input[i];
        i++;
    }
    cout<<"TAG_NAME "<<temp<<endl;
    return i;
}
int TAG_CLOSE(int i)
{
     cout<<"TAG_CLOSE >"<<endl;
     IsNowInTheHTMLflag=false;
    return i+1;     
}
int TAG_OPEN_SLASH(int i)
{
    cout<<"TAG_OPEN_SLASH </"<<endl;
    IsNowInTheHTMLflag=true;
    return i+2;
}
int TAG_EQUALS(int i)
{
    cout<<"TAG_EQUALS ="<<endl;
    return i+1;    
}
int DOUBLE_QUOTE_STRING(int i)
{
    string temp = "";
    i+=1;
    while(input[i]!='\"')
    {
        temp+=input[i];
        i++;
    }  
    cout<<"DOUBLE_QUOTE_STRING "<<temp<<endl;
    return i+1;     
}
int SINGLE_QUOTE_STRING(int i)
{
    string temp = "";
    i+=1;
    while(input[i]!='\'')
    {
        temp+=input[i];
        i++;
    }  
    cout<<"SINGLE_QUOTE_STRING "<<temp<<endl;
    return i+1; 
}
int no(int i){//這個大部分不會遇到，因為cin不會輸入其他的東西
    //因為遇到不會計入的東西，所以就往下一個跳。
    return i+1;
}