#include<iostream>
#include<string>
#include<vector>
using namespace std;

vector<string> output;
char input[1000];

int stmts(int i);
int stmt(int i);
int no(int i);
int STRLIT(int i);
int primary(int i);
int primary_tail(int i);
void LBR();
void RBR();
void DOT();
int ID(int i);

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
        i=stmts(i);
        //cout<<i<<" final"<<endl;
    }
    i=0;
    while(flag_invalid&&i<output.size())
    {
        cout<<output[i]<<endl;
        i++;
    }
}




//ok
int ID(int i){
    string temp="";
    //若是符合[0-9,A-Z,a-z,_]就可以放在temp裡面，我是用ascii code去判別是否符合。
    while((48<=int(input[i]) && int(input[i])<=57) || (65<=int(input[i]) && int(input[i])<=90) || (97<=int(input[i]) && int(input[i])<=122) || int(input[i])==95){
        temp+=input[i];
        i++;
    }
    if(input[i]=='\n' || input[i]=='\0'){//遇到我在前面塞的'\0'，代表已經到輸入的最尾端了。
        output.push_back("ID "+temp);
        //cout<<"ID "<<temp<<endl;
        //cout<<i<<" ID"<<endl;
        return i;
    }
    else if(input[i]=='.' || input[i]=='(' || input[i]==')' || input[i]=='"'){//若是在ID當中遇到其他可用符號，則要挑出這邊的東西，並輸出。
        output.push_back("ID "+temp);
        //cout<<"ID "<<temp<<endl;
        return i;
    }
    else{//若是都不符合上面，代表你有問題了，一定有其他東西卡住。
        return -1;
    }
}
void LBR(){
    output.push_back("LBR (");
}
void RBR(){
    output.push_back("RBR )");
}
void DOT(){
    output.push_back("DOT .");
}
int primary_tail(int i){
    if(input[i]=='.'){//因為遇到dot，所以輸出dot就可以跳到下一個char
        DOT();
        return i+1;
    }
    else if(input[i]=='('){//因為遇到左括弧，所以輸出左括弧就可以跳到下一個char
        LBR();
        return i+1;
    }
    else if(input[i]==')'){//因為遇到右括弧，所以輸出右括弧就可以跳到下一個char
        RBR();
        return i+1;
    }
    //因為遇到有關於ID的東西，所以可以直接跳去ID準備ID的輸出。
    else if((48<=int(input[i]) && int(input[i])<=57) || (65<=int(input[i]) && int(input[i])<=90) || (97<=int(input[i]) && int(input[i])<=122) || int(input[i])==95){
        i=ID(i) ;
        return i;
    }
    else{//若是上述狀況都不符合代表有問題!!!!
        return -1;
    }
}
int primary(int i){
    if(input[i]=='(' || input[i]==')' || input[i]=='.'){//遇到這幾個可以call primary_tail，因為是屬於primary_tail裡面的東西
        i=primary_tail(i);
        //cout<<i<<"primary1"<<endl;
    }
    else{//剩下的情況就是ID了，有問題ID會解決，但大部分前面main裡面已經處理過了。
        i = ID(i);
        //cout<<i<<"primary2"<<endl;
    }
    return i ;
}
int STRLIT(int i){
    i++;//因為第一個是 " 會被傳進來，但是我們只需要後面幾個字到下一個"就好
    string temp="";
    while(input[i]!='"' ){
        if(input[i]=='\0'){//若是遇到只有第一個"，但是沒有下一個 " ，我的程式會run time error，並且這也是一種輸入錯誤，所以我們在這邊處理，因為沒有遇到下一個 " 他就會跑進來，那我們就強制結束，並輸出invalid
            return -1;
        }
        temp+=input[i];
        i++;
    }
    output.push_back("STRLIT \""+temp+"\"");
    return i+1;//因為現在是 " ，所以他就從迴圈跳出來了，所以我們要回傳下一個，而不是現在這個 " 
}
int no(int i){//這個大部分不會遇到，因為cin不會輸入其他的東西
    //因為遇到不會計入的東西，所以就往下一個跳。
    return i+1;
}

int stmt(int i){
    if(input[i]=='"'){//遇到 " 要轉給STRLIT處理。
        i=STRLIT(i);
    }
    else if(input[i]!=' ' && input[i]!='\n' && input[i]!='\0'){
        i=primary(i);
       // cout<<i<<"stmt"<<endl;
    }
    else{//這個其實沒有甚麼用處
        i=no(i);
    }
    return i;
}
int stmts(int i){//cin不會吃到空白，換行，tab
    if(input[i]!='\0'){//沒有到輸入尾端，就不要停止
        i = stmt(i);
        //cout<<i<<"stmts"<<endl;
    }
    else{
        i = no(i);
    }
    return i;
}