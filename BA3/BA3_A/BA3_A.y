%{
    #include <stdio.h>
    #include <stdlib.h>
	#define MAXSTACK 100 /*定義最大堆疊容量*/
	int stack[MAXSTACK];  //堆疊的陣列宣告 
	int top=-1;		//堆疊的頂端
	int isEmpty();
	void push(int); 
	int pop();
	int yylex(void);
	void yyerror(char *s);
	int temp = 0;
	char *t="";
    int outputStack();
    void inverse();
    void inc();
    void dec();
	void finalcheckstack(int flag);
	int flag = 0;
%}
%union{
	char* op;
	int number;
}
%token <number> INUMBER 
%token <op> PUSH;
%token <op> INVERSE;
%token <op> INC;
%token <op> DEC;
%token <op> LEAVE;
%%
program : function { }
		;
function: function expr 
		|
		;
expr    : PUSH   INUMBER   {push($2);}
        | INVERSE      {inverse();}
        | INC          {inc();}
        | DEC           {dec();}
        | LEAVE         {int temp = outputStack() ; printf("%d\n",temp); exit(0);}
        ;
%%
void finalcheckstack(int flag)
{
	if(flag == 1)
	{
		return;
	}
	if(top<=0 && flag==0)
	{
		printf("%d",stack[top]);
	}
	else{
		yyerror("Invalid format");
	}
	
}
int outputStack()
{
    int a = pop();
    return a;
}
void dec()
{
    int a = pop();
    a = a-1;
    push(a);
    return;
}
void inc()
{
    int a = pop();
    a = a+1;
    push(a);
    return;
}
void inverse()
{
    int first = pop();
    int second = pop();
    push(first);
    push(second);
    return;
}
/*判斷是否為空堆疊*/
int isEmpty(){
	if(top==-1){
		return 1; 
	}else{
		return 0;
	}
} 
/*將指定的資料存入堆疊*/
void push(int data)
{
	if(top>=MAXSTACK){
		yyerror("Invalid format");	
	}else{
		top++;
		stack[top]=data;
	}
 
} 
/*從堆疊取出資料*/
int pop()
{
	int data;
	if(isEmpty()){
		yyerror("Invalid format");	
		flag=1;
	}else{
		data=stack[top];
		top--;
		return data; 
	}
}
void yyerror(char *s)
{
  printf("%s\n",s);
}
int main()
{
    yyparse();
    return 0;
}