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
	void find(char* s);
	void load(int num);
	void finalcheckstack(int flag);
	int flag = 0;
%}
%union{
	char* op;
	int number;
}
%token INUMBER 
%token WORD
%token SINGLEWORD;
%type <op> singleoprand oprand WORD SINGLEWORD;
%type <number> integer INUMBER;
%left ' '
%%
program : function { finalcheckstack(flag) ;exit(0);}
		;
function: function expr 
		|
		;

expr    : singleoprand {find(t);}
		| oprand integer {load(temp);}
        ;

oprand  :  WORD {t = $1; }
		;  

singleoprand : SINGLEWORD {t = $1; }
		;

integer : INUMBER {temp = $1;} 
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
void find(char* s)
{
	if(strcmp(s,"add")==0)
	{
		int a = pop();
		int b = pop();
		a = a + b;
		push(a);
	}
	else if(strcmp(s,"sub")==0)
	{
		int a = pop();
		int b = pop();
		a = a - b;
		push(a);
	}
	else if(strcmp(s,"mul")==0)
	{
		int a = pop();
		int b = pop();
		a = a * b;
		push(a);
	}
	else if(strcmp(s,"mod")==0)
	{
		int a = pop();
		int b = pop();
		a = a % b;
		push(a);
	}
	else if(strcmp(s,"inc")==0)
	{
		int a = pop();
		a = a + 1;
		push(a);
	}
	else if(strcmp(s,"dec")==0)
	{
		int a = pop();
		a = a - 1;
		push(a);
	}
}
void load(int num)
{
	push(num);
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
void push(int data){
	if(top>=MAXSTACK){
		yyerror("Invalid format");	
	}else{
		top++;
		stack[top]=data;
	}
 
} 
/*從堆疊取出資料*/
int pop(){
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