%{
	#include <stdio.h>
	#include <stdlib.h>
	struct matrix{
		int left;
		int right;
	};
	struct matrix node[10];
	int Checkflag = 0;//to see whether we meet error if not then print Accepted
	int index = 0;//we pointer to the empty position in node
	int wemaywrong; // to save the '+' '-' '*' location

	void trans();
	void add();
	void sub();
	void mul();
	void push(int i , int j );
    void yyerror(char *s);
	void finalcheck();
	
%}

%union{
	int inumber;
	int whereWeAreNow;
}
%token <inumber> MATRIXNUMBER
%token <whereWeAreNow> '+' 
%token <whereWeAreNow> '-'
%token <whereWeAreNow> '*'
%left '+' '-'
%left '*'
%left '^'
%%
program  : function { finalcheck();}
		 ;
function : '[' MATRIXNUMBER ','  MATRIXNUMBER ']' { push($2,$4); }
		 | function '+' function { wemaywrong=$2 ; add(); }
		 | function '-' function { wemaywrong=$2 ; sub(); }
		 | function '*' function { wemaywrong=$2 ; mul(); }
		 | function '^' 'T' { trans(); }
		 | '(' function ')' {  }
		 ;
%%
void mul()
{
	if(Checkflag==1)
	{
		return ;
	}
	if(node[index-1].left != node[index-2].right )
	{
		Checkflag = 1;
		yyerror("");
	}	
	else{
		node[index-1].left = node[index-2].left ;
	}
}
void sub()
{
	if(Checkflag==1)
	{
		return ;
	}
	if(node[index-1].left != node[index-2].left || node[index-1].right != node[index-2].right)
	{
		Checkflag = 1;
		yyerror("");
	}	
}
void add()
{
	if(Checkflag==1)
	{
		return ;
	}
	if(node[index-1].left != node[index-2].left || node[index-1].right != node[index-2].right)
	{
		Checkflag = 1;
		yyerror("");
	}
}
void trans()
{
	if(Checkflag==1)
	{
		return ;
	}
	//printf("trans\n");
	//printf("left:%d , right:%d\n",node[index-1].left,node[index-1].right);
	int temp = node[index-1].left;
	node[index-1].left = node[index-1].right;
	node[index-1].right = temp;
	//printf("left:%d , right:%d\n",node[index-1].left,node[index-1].right);
	//printf("trans over\n");
}
void push(int i , int j )
{
	node[index].left = i;
	node[index].right = j;
	//printf("left:%d , right:%d\n",node[index].left,node[index].right);
	index++;
}
void finalcheck()
{
	if(Checkflag==0)
	{
		printf("Accepted");	
	}
}
void yyerror(char *s)
{
  printf("Semantic error on col %d\n",wemaywrong);
}
int main()
{
    yyparse();
    return 0;
}