#include<iostream>
#include<string>

using namespace std;

int main(){
    //for input
    char input[1000];
    int pointer = 0 ;// point out the end of file
    char a;
    bool flag =false;//確認是否有連續的數字
    while(cin>>a){
        input[pointer]=a;
        pointer++;
    }
    input[pointer]='\0';
    pointer++;
    int sum_num=0;
    //for output
    for(int i = 0 ; i < pointer ; i++)
    {
        if(flag==true && 48<=input[i] && input[i]<=57)
        {
            sum_num = sum_num*10+int(input[i]-48);
        }
        else if(flag==true)//since the this char is not integer but we didn't print the sum_number 
        {
            cout<<"NUM "<<sum_num<<endl;//print the number
            sum_num=0;
            i--;//do this because we should print the char right now but the for loop will skip this. 
            flag=false;
        }
        else if(48<=input[i]&&input[i]<=57)
        {
            flag = true;
            sum_num=int(input[i]-48);
        }
        else if(input[i]=='(')
        {
            cout<<"LPR"<<endl;
        }
        else if(input[i]==')')
        {
            cout<<"RPR"<<endl;
        }
        else if(input[i]=='+')
        {
            cout<<"PLUS"<<endl;
        }
        else if(input[i]=='-')
        {
            cout<<"MINUS"<<endl;
        }
        else if(input[i]=='*')
        {
            cout<<"MUL"<<endl;
        }
        else if(input[i]=='/')
        {
            cout<<"DIV"<<endl;
        }
        else if(input[i]=='\0'){
            break;
        }
    }
}