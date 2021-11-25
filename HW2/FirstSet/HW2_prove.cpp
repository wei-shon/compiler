#include <iostream>
#include<string>
#include<vector>
#include <algorithm>

using namespace std;

string input[1000];

struct First 
{
    vector <string> Father;//LHS
    vector <string> child;//RHS
};

string find_child(string father , int len);
bool checknull(string temp);


int main()
{
    //for input
    int len=0;
    string a;
    while(cin>>a){
        if(a=="END_OF_GRAMMAR")
        {
            break;
        }
        input[len]=a;
        len++;
    }

    First answer;
    for(int i = 0 ; i < len ;i++)
    {
        if(i%2==0)
        {
            answer.Father.push_back(input[i]);
        }
    }
    
    sort(answer.Father.begin(),answer.Father.end());
    
    //to find_child the children
    for(int i = 0 ; i < answer.Father.size();i++)
    {
        a = find_child(answer.Father[i],len);
        answer.child.push_back(a);
    }

    //output
    for(int i = 0 ; i < answer.Father.size() ; i++)
    {
        sort(answer.child[i].begin(),answer.child[i].end());
        answer.child[i].erase( unique( answer.child[i].begin(), answer.child[i].end() ), answer.child[i].end() );
        cout<<answer.Father[i]<<" "<<answer.child[i]<<endl;
    }
    cout<<"END_OF_FIRST"<<endl;

}

bool checknull(string temp)
{
    for(int i = 0 ; i < temp.length() ;i++)
    {
        if(temp[i]==';')
        {
            return true;
        }
    }
    return false;
}

string find_child(string father , int len)
{
    string temp="";//to save the father's child e.g. A a|Cb|; then father is A and temp is "a|Cb|;"
    //to find the LHS's RHS
    for(int i  = 0 ; i < len ; i++)
    {
        if(input[i]==father)
        {
            temp = input[i+1];
            break;
        }
    }

    string answer="";// to save the answer
    bool check = true;//to check whether a~z character is behind a~z?
    bool checkWhetherHaveNull=false;
    // to find the child(RHS)
    for(int i = 0 ; i < temp.length() ; i++)
    {
        if( 'a'<=temp[i] && temp[i]<='z' && check)//it means the char is a~z
        {
            //if go to here. it means we go to the end of char
            //e.g. A a|Cb|;
            //then we go to the 'b' where is behind the 'C'.
            if(checkWhetherHaveNull)
            {
                checkWhetherHaveNull=false;
            }
            answer+=temp[i];
            check=false;
        }
        else if(  'A'<=temp[i] && temp[i]<='Z' && check  )//it means the char is A~Z
        {
            string cool="";
            cool+=temp[i];
            cool = find_child(cool,len);
            checkWhetherHaveNull=checknull(cool);
            if(checkWhetherHaveNull)
            {
                //because we do not want to plus ; in answer, we have to check the char behind this
                string t="";
                for(int j = 0 ; j < cool.length();j++)
                {
                    if(cool[j]!=';')
                    {
                        t+=cool[j];
                    }
                }
                answer+=t;
                if(i==temp.length()-1)
                {
                    answer+=';';
                    return answer;
                }
            }
            else{
                answer+=cool;
                check=false;
            }
        }
        else if( temp[i]==';')
        {
            answer+=';';
            return answer;
        }
        else if(temp[i]=='|')
        {
            check = true;
            if(checkWhetherHaveNull)//it mean we go the end of string but don't have any small character
            {
                checkWhetherHaveNull=false;
                answer+=';';
            }
        }
        else if(temp[i]=='$'&&check)
        {
            answer+='$';
            return answer;
        }
    }
    return answer;
}