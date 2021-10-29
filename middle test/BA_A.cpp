#include<iostream>
#include<string>
#include<vector>
using namespace std;

vector<string> output;
char input[1000];

int s1(int i);
int s2(int i);
int s3(int i);
int s4(int i);

int main()
{
    // input all of the data
    int pointer=0;
    char a;
    while(cin>>a){
        input[pointer]=a;
        pointer++;
    }
    int i = 0 ;

    //start to check the status
    while(i<pointer){
        if(i==-1){//if there are some problem, then break out the loop.
            break;
        }
        i=s1(i);
    }
}

//status 1 to check whether they fit the condition or not
int s1(int i)
{
    //if fitting the status 2 then jump to there
    if(input[i]=='a')
    {
        i = s2(i);
    }
    //if fitting the status 3 then jump to there
    else if(input[i]=='b')
    {
        i=s3(i);
    }
    //if not fit any status that means there are some problem then print NO and return -1
    else
    {
        cout<<"NO"<<endl;
        return -1;
    }
    return i;
}
//now we are in status 2 and we want to  check whether they fit the condition or not
int s2(int i)
{
    //if match condition 'a' then continue to test the next character
    while(input[i]=='a')
    {
        i++;
    }
    //the 'a' is all found out, then to see the next char is 'b' or not 
    //if there is 'b' then jump into status 4 ,or return -1 and print NO
    if(input[i]=='b')
    {
        i++;
        i=s4(i);
    }
    //if not fit any condition that means there are some problem then print NO and return -1
    else
    {
        cout<<"NO"<<endl;
        return -1;
    }
    return i;
}
int s3(int i)
{
    //since we send the index i to this status is the first char
    //we should jump to next cahr ,that is jump the 'b',and test the next char
    i=i+1;
    //if match condition 'a' then continue to test the next character
    while(input[i]=='a')
    {
        i++;
    }
    //if we get the end of input then print YES s3 and return i+2 that is '\0'
    if(input[i]=='$')
    {
        cout<<"YES s3"<<endl;
        return i+2;//since we have \n
    }
    //if match the condition c then jump to the status 4
    else if(input[i]=='c')
    {
        i=i+1;
        i = s4(i);
        return i;
    }
    //there is not any condition we fit then print NO and return -1
    else
    {
        cout<<"NO"<<endl;
        return -1;        
    }
}
//the answer in status 4 is the '$' if we have another char,that is a problem.
int s4(int i)
{
    //if there is '$' that means we fit the condition
    if(input[i]=='$')
    {
        cout<<"YES s4"<<endl;
    }
    //if not , print NO and return -1;
    else
    {
        cout<<"NO"<<endl;
        return -1;
    }
    return i+2;//since we have \n
}