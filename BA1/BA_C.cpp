#include<iostream>
#include<string>
#include<vector>
using namespace std;

char input[1000];

int htmlDocument(int i , int pointer);
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
//this main we need to use recursive 
int main(){
    //input the data
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
    //start to recursive the function
    i=htmlDocument(i,pointer);
    //end of recursive and check whether the recursive is successful
    if(i!=-1)
    {
        cout<<"htmlDocument"<<endl;
        cout<<"valid"<<endl;
    }
    if(i==-1)
    {
        cout<<"invalid"<<endl;
    }
}

int htmlDocument(int i, int pointer)
{
    //if we do not get error or end of file the recursive to call
    if(input[i]!='\0' && input[i]!='\n' && i<pointer && i!=-1  ){//沒有到輸入尾端，就不要停止
        i = htmlElement(i);
        
        i = htmlDocument(i,pointer);
    }
    //if we meet this conditions means we get error
    else if(i==-1)
    {
        return -1;
    }
    //we meet the ' ' or other conditions
    else{
        i = no(i);
    }
    return i;
}
int htmlElement(int i)
{
    //there are a lot of functions to metch the grammer
    i = TAG_OPEN(i);
    i = TAG_NAME(i);
    i = htmlAttributeList(i);
    i = TAG_CLOSE(i);
    i = htmlContent(i);
    i = TAG_OPEN_SLASH(i);
    i = TAG_NAME(i); 
    i = TAG_CLOSE(i);
    if(i!=-1)
    {//if error we do not output htmlElement
        cout<<"htmlElement"<<endl;
    }
    
    return i;
}
//meet '<'
int TAG_OPEN(int i)
{
    if(i==-1)
    {
        return -1;
    }
    return i+1;   
}
//after we meet the '<' or the '</' then the tag name should appear now
int TAG_NAME(int i)
{
    //if error then return -1
    if(i==-1)
    {
        return -1;
    }
    //to get the tag name
    string temp = "";
    while(input[i]!='=' && input[i]!=' ' && input[i]!='>')
    {
        temp+=input[i];
        i++;
    }
    //if we meet this condition that means </> we don't have tag name to close taht is a problem
    if(input[i-1]=='/' && input[i]=='>')
    {
        return -1;
    }
    return i;
}
//after the tag name then the attribut may appear.
int htmlAttributeList(int i)
{
    //if error then return -1
    if(i==-1)
    {
        return -1;
    }
    //since we may meet the ' 'space, we should jummp out of it
    while(input[i]==' ')
    {
        i++;
    }
    //if we meet this means we don't have the attribute
    if(input[i]=='>')
    {
        return i;
    }
    else{
        i = htmlAttribute(i);
        i = htmlAttributeList(i);
    }
    if(i!=-1){
        cout<<"htmlAttributeList"<<endl;
    }
    
    return i;
}
int htmlAttribute(int i)
{
    //if we have attribute then there are three function to call
    i = TAG_NAME(i);
    i = TAG_EQUALS(i);
    i = attribute(i);
    if(i!=-1)
    {
        cout<<"htmlAttribute"<<endl;
    }
    return i;
}
int attribute(int i)
{
    //the attribute usually have '' or "" to contain
    if(input[i]=='\'')
    {
        // if meet '
        i = SINGLE_QUOTE_STRING(i);
    }    
    else if(input[i]=='\"')
    {
        //if meet "
        i = DOUBLE_QUOTE_STRING(i);
    }    
    else if(input[i]=='>')
    {
        //if meet the '>' that means we get error
        return -1;
    }
    if(i!=-1)
    {
        cout<<"attribute"<<endl;    
    }
    
    return i;
}
//meet '='
int TAG_EQUALS(int i)
{
    return i+1;    
}
//meet "
int DOUBLE_QUOTE_STRING(int i)
{
    string temp = "";
    i+=1;
    while(input[i]!='\"')
    {
        temp+=input[i];
        i++;
    }  
    return i+1;     
}
//meet '
int SINGLE_QUOTE_STRING(int i)
{
    string temp = "";
    i+=1;
    while(input[i]!='\'')
    {
        temp+=input[i];
        i++;
    }  
    return i+1; 
}
//if we meet the '>' close tag
int TAG_CLOSE(int i)
{
    if(i==-1)
    {
        return -1;
    }
    return i+1;     
}
int htmlContent(int i)
{
    // if get here that means we finish the tag and we need to output the HTML text
    if(i==-1 || input[i]=='\n' || input[i]=='\0')
    {
        return -1;
    }
    //if we get the next new tag <tag>.It is not close tag </tag>
    if(input[i]=='<'&& input[i+1]!='/')
    {
        i = htmlElement(i);
        i = htmlContent(i);
        cout<<"htmlContent"<<endl;
    }
    //if we not get the close tag</tag> thats means we are still could output the text
    else if(input[i]!='<'){
        i = htmlChardata(i);        
        i = htmlContent(i);  
        cout<<"htmlContent"<<endl; 
        //if we get the end of file
        if(input[i]=='\0')
        {
            return -1;
        }
    }
    return i;
}
//if go to here means we have the html text
int htmlChardata(int i)
{
    i = HTML_TEXT(i);
    return i;
}
//check the HTML_TEXT
int HTML_TEXT(int i)
{
    //if we meet the end of file that means error since we go to here beacuse input[i-1]=='>'
    //we meet this condition is like this: <div>
   if(input[i]=='\n'|| input[i]=='\0')
    {
        return -1;
    }
    // jump out of space 
    while(input[i]==' ')
    {
        i++;
    }
    string temp = "";
    //get data until meet the open tag or OPEN_SLASH tag
    while(input[i]!='<')
    {
        temp+=input[i];
        i++;
    }
    if(temp=="")
    {
        return i; 
    }
    if(i!=-1)
    {
        cout<<"htmlCharData"<<endl;
    }
    
    return i;   
}
//we meet '<'+'/'
int TAG_OPEN_SLASH(int i)
{
    if(i==-1 || input[i]=='\n')
    {
        return -1;
    }
    return i+2;
}
int no(int i)
{//這個大部分不會遇到，因為cin不會輸入其他的東西
    //因為遇到不會計入的東西，所以就往下一個跳。
    return i+1;
}