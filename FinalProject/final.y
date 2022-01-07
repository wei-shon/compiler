%{
	#include <cstdio>
	#include <cstdlib>
  #include <iostream>
  #include <vector>
  #include <map>
  #include <string>
  #include <cstring>
  using namespace std;
  int yylex();
    
    // This is my node struct
  struct def{
    string op;//To store operator that we should do
    string variablename; // To store the variable's namea when we should define variable or function name
    int valueToDo;// to store the value that we need to calculate later
    bool boolToDo; // if #f store false else if #t store true
    struct def* leftnext; // remember the left node
    struct def* rightnext;//remember the right node
    struct def* functionCanUse;// remember the function we use it in namedFunction
  }node;
  
  struct def head; // to remember the head of tree it is use to check the tree's structure is correct or not
  struct def* run = &head;
  struct def* t =(struct def*) malloc( sizeof(struct def));

  struct def* variable[10];//to remember all the variable we define
  int variableIndex = 0; //to point how many variables we have been defined

  struct def* functionVariable[10];//to remember all the variablethat function will use it int functionVariableIndex = 0;//to point how many functions' variables we have been defined
  int functionVariableIndex =0;
  bool CallFunctionId = false;//to varify we should call variable or functionVariable beacause the varname will repeat in 07_2.lsp
  bool buildFunctionCheck = false;// because we need define a function, this is give us a flag to satisfy we build a variable or function now
  bool functionTransferToVariable = false;// since we have we function that don't have any parameters 
    //e.g. (define bar-z (lambda() 2)) 
    //so we use it to transfer that function tobe variable


  void yyerror(char *s);
  void printnumber(struct def* temp);//print the tree that contains of number
  void printb(struct def* temp);//print the tree that contains of boolean
  int countnumber(struct def* temp , string whatTheNumberToDo);// ifwe meet "print-num" then we call this functino to count number
  bool countboolean(struct def* temp , string whatTheNumberToDo);// ifwe meet "print-bool" then we call this functino to count boolean
  void defineVariable(struct def* temp , string whatTheNumberToDo);//to define variable in example6
  void defineFunctionVariable(struct def* varName , struct def* varNumber );//to define variable in example7
  void defineFunction(struct def* temp , string whatTheNumberToDo);//to define variable in example8
  void typecheck(struct def* temp , string whatTheNumberToDo);  
  int boolprint=0;
%}
%union{
  int integer;
  char *boolop;
  char *var;
  struct def *temp;
}
%token <boolop> boolval
%token <integer> number
%token <var> id
%token printnum
%token printbool
%token mod
%token an
%token orr
%token nott
%token define
%token <var>fun
%token IF

%type <temp> EXPS
%type <temp> PLUS
%type <temp> MINUS 
%type <temp> MULTIPLY
%type <temp> DIVIDE 
%type <temp> MODULUS
%type <temp> GREATER 
%type <temp> SMALLER 
%type <temp> EQUAL
%type <temp> EXP
%type <temp> NUM-OP 
%type <boolop> PRINT-STMT
%type <temp> STMT
%type <temp> PROGRAM
%type <temp> LOGICAL-OP
%type <temp> AND-OP
%type <temp> NOT-OP
%type <temp> OR-OP 
%type <temp> an
%type <temp> orr
%type <temp> nott
%type <temp> IF 
%type <temp> TEST-EXP 
%type <temp> THEN-EXP 
%type <temp> ELSE-EXP
%type <temp> IF-EXP
%type <temp> VARIABLE
%type <temp> DEF-STMT
%type <temp> ID
%type <temp> IDS
%type <temp> FUN-CALL
%type <temp> FUN-EXP
%type <temp> PARAMS
%type <temp> PARAM
%type <temp> FUN-BODY
%type <temp> FUN-IDs
%type <temp> FUN-NAME

%%
PROGRAM     : PROGRAM STMT {/*printnumber(t);printb(t);*/}
            |
            ;
STMT        : EXP {
                    $$ =(struct def*) malloc( sizeof(struct def)) ;
                    $$ = $1;
                    t=$$;
                  }
            | DEF-STMT 
            | PRINT-STMT
            ;
PRINT-STMT  : '(' printnum EXP ')'  { 
                                      int a = countnumber($3,$3->op); 
                                      CallFunctionId = false;
                                      cout<<a<<endl;
                                    }
            | '(' printbool EXP ')' { 
                                      bool a = countboolean($3,$3->op);
                                      if(a)
                                      {
                                        cout<<"#t"<<endl;
                                      }
                                      else
                                      {
                                        cout<<"#f"<<endl;
                                      }
                                    }
            ;
EXPS        : EXP EXPS  { 
/*
we run to here because we have more than 3個運算。
 */ 
                          $$ =(struct def*) malloc( sizeof(struct def)) ; 
                          $$->leftnext = $1 ; 
                          $$->op = "temp"; 
                          $$->rightnext = $2; 
                        }
            | EXP { 
                    $$ =(struct def*) malloc( sizeof(struct def)) ; 
                    $$= $1; 
                  }
            ;
EXP         : boolval { 
                        $$ =(struct def*) malloc( sizeof(struct def)) ; 
                        $$ -> op = "boolean"; 
                        $$ -> leftnext = NULL;
                        $$ -> rightnext = NULL;
                        if(strcmp($1,"#f")==0)
                        {
                          boolprint=1;
                          $$->boolToDo = false;
                        } 
                        else
                        {
                          boolprint=0; 
                          $$->boolToDo = true;
                        } 
                      }
            | number  {
                        $$ = (struct def*) malloc( sizeof(struct def)) ; 
                        $$ -> valueToDo = $1; 
                        $$ -> op = "number"; 
                        $$ -> leftnext = NULL;
                        $$ -> rightnext = NULL;
                      }
            | VARIABLE  {
                          $$ =(struct def*) malloc( sizeof(struct def)) ;
                          $$=$1;
                        }
            | NUM-OP  {
                        $$ =(struct def*) malloc( sizeof(struct def)) ;
                        $$ = $1; 
                      }
            | LOGICAL-OP  {
                            $$ =(struct def*) malloc( sizeof(struct def)) ;
                            $$ = $1; 
                          }
            | FUN-EXP   {
                          $$ =(struct def*) malloc( sizeof(struct def)) ;
                          $$ = $1; 
                        }
            | FUN-CALL {
                          $$ =(struct def*) malloc( sizeof(struct def)) ;
                          $$ = $1; 
                        }
            | IF-EXP  {
                        $$ =(struct def*) malloc( sizeof(struct def)) ;
                        $$=$1;
                      }
            ;
NUM-OP      : PLUS  {  
                      $$ =(struct def*) malloc( sizeof(struct def)) ;
                      $$ = $1;  
                    }
            | MINUS {
                      $$ =(struct def*) malloc( sizeof(struct def)) ;
                      $$ = $1;  
                    }
            | MULTIPLY  {
                          $$ =(struct def*) malloc( sizeof(struct def)) ;
                          $$ = $1;  
                        }
            | DIVIDE  {
                        $$ =(struct def*) malloc( sizeof(struct def)) ;
                        $$ = $1;  
                      }
            | MODULUS {
                        $$ =(struct def*) malloc( sizeof(struct def)) ;
                        $$ = $1;  
                      }
            | GREATER {
                        $$ =(struct def*) malloc( sizeof(struct def)) ;
                        $$ = $1;  
                      }
            | SMALLER {
                        $$ =(struct def*) malloc( sizeof(struct def)) ;
                        $$ = $1;  
                      }
            | EQUAL {
                      $$ =(struct def*) malloc( sizeof(struct def)) ;
                      $$ = $1;  
                    }
            ;
PLUS        : '(' '+' EXP EXPS ')'  {/*+*/
                                      $$ =(struct def*) malloc( sizeof(struct def)) ; 
                                      $$->leftnext = $3 ; 
                                      $$->rightnext = $4; 
                                      $$->op="+"; 
                                    }
            ;

MINUS       : '(' '-' EXP EXP ')'   { 
                                      $$ =(struct def*) malloc( sizeof(struct def)) ; 
                                      $$->leftnext = $3 ; 
                                      $$->rightnext = $4; 
                                      $$->op="-"; 
                                    }
            ;

MULTIPLY    : '(' '*' EXP EXPS  ')' {/*+*/
                                      $$ =(struct def*) malloc( sizeof(struct def)) ; 
                                      $$->leftnext = $3 ; 
                                      $$->rightnext = $4; 
                                      $$->op="*"; 
                                    }
            ;

DIVIDE      : '(' '/' EXP EXP ')' {
                                      $$ =(struct def*) malloc( sizeof(struct def)) ; 
                                      $$->leftnext = $3 ; 
                                      $$->rightnext = $4; 
                                      $$->op="/"; 
                                  }
            ;

MODULUS     : '(' mod EXP EXP ')' {
                                      $$ =(struct def*) malloc( sizeof(struct def)) ; 
                                      $$->leftnext = $3 ; 
                                      $$->rightnext = $4; 
                                      $$->op="mod"; 
                                  }
            ;
GREATER     : '(' '>' EXP EXP ')' {
                                      $$ =(struct def*) malloc( sizeof(struct def)) ; 
                                      $$->leftnext = $3 ; 
                                      $$->rightnext = $4; 
                                      $$->op=">"; 
                                  }
            ;
SMALLER     : '(' '<' EXP EXP ')' {
                                      $$ =(struct def*) malloc( sizeof(struct def)) ; 
                                      $$->leftnext = $3 ; 
                                      $$->rightnext = $4; 
                                      $$->op="<"; 
                                  }
            ;
EQUAL       : '(' '=' EXP EXPS  ')' {/*+*/
                                      $$ =(struct def*) malloc( sizeof(struct def)) ; 
                                      $$->leftnext = $3 ; 
                                      $$->rightnext = $4; 
                                      $$->op="="; 
                                    }
            ;
LOGICAL-OP  : AND-OP  {  
                        $$ =(struct def*) malloc( sizeof(struct def)) ;
                        $$ = $1;  
                      }
            | OR-OP {  
                      $$ =(struct def*) malloc( sizeof(struct def)) ;
                      $$ = $1;  
                    }
            | NOT-OP{  
                      $$ =(struct def*) malloc( sizeof(struct def)) ;
                      $$ = $1;  
                    }
            ;
AND-OP      : '(' an EXP EXPS  ')' {/*+*/
                                      $$ =(struct def*) malloc( sizeof(struct def)) ; 
                                      $$->leftnext = $3 ; 
                                      $$->rightnext = $4; 
                                      $$->op="and"; 
                                    }
            ;
OR-OP       : '(' orr EXP EXPS  ')' {/*+*/
                                      $$ =(struct def*) malloc( sizeof(struct def)) ; 
                                      $$->leftnext = $3 ; 
                                      $$->rightnext = $4; 
                                      $$->op="or"; 
                                    }
            ;
NOT-OP      : '(' nott EXP ')'{/*+*/
                                $$ =(struct def*) malloc( sizeof(struct def)) ; 
                                $$->leftnext = $3 ; 
                                $$->op="not"; 
                              }
            ;
DEF-STMT    : '(' define VARIABLE EXP ')' {
/*
structure:
第一個if
        define node
         /        \
variable_name    variable_value

第二個 else
        define node
        /        \
function_name   function_body(整個運算的框架)

*/
                                            if(!buildFunctionCheck)
                                            {
                                              $$ =(struct def*) malloc( sizeof(struct def)) ; 
                                              $$->op="define";
                                              $$->leftnext = $3;
                                              $$ ->rightnext = $4;
                                              defineVariable($$,$$->op);
                                              buildFunctionCheck=false;
                                            }
                                            else{
                                              $$ =(struct def*) malloc( sizeof(struct def)) ; 
                                              $$->op="define";
                                              $$->leftnext = $3;
                                              $$ ->rightnext = $4;
                                              defineVariable($$,$$->op);  //to save vriable name
                                              defineFunction($$,$$->op) ; //to save function 
                                              buildFunctionCheck = false;                                           
                                            }

                                          }
            ;
VARIABLE    : id  {
                    $$ =(struct def*) malloc( sizeof(struct def)) ; 
                    $$ -> op = "id";
                    $$ -> leftnext = NULL;
                    $$ -> rightnext = NULL;
                    $$ -> variablename = $1;
                  }
            ;
FUN-EXP     : '(' fun FUN-IDs FUN-BODY ')'  {
                                              $$ =(struct def*) malloc( sizeof(struct def)) ;
                                              $$ -> op ="function";
                                              $$ -> variablename = "lambda";
                                              $$ -> leftnext = $4;
                                              $$ -> rightnext = $3;
                                              buildFunctionCheck = true;
                                            }
            ;
FUN-IDs     : '(' IDS ')' {
                            $$ =(struct def*) malloc( sizeof(struct def)) ;
                            $$ = $2;
                          }
            ;
IDS         : ID IDS  {
/*
we use this because the id can more than one
 */ 
                        $$ =(struct def*) malloc( sizeof(struct def)) ;
                        $$ -> op = "param_id";
                        $$ -> rightnext = $2;
                        $$ -> leftnext = $1;
                      }
            | ID  {
                    $$ =(struct def*) malloc( sizeof(struct def)) ;
                    $$ = $1;
                  }
            ;
ID          :  id   {
                      $$ =(struct def*) malloc( sizeof(struct def)) ;
                      $$ -> op = "id";
                      $$ -> variablename = $1;
                    }
            |       {
                      //we use this because ID maybe not exist like example_8-2
                      $$ =(struct def*) malloc( sizeof(struct def)) ;
                      $$ -> op = "NULLID";
                    }
            ;
FUN-BODY    : EXP {
                    $$ =(struct def*) malloc( sizeof(struct def)) ;
                    $$ = $1;                      
                  }
            ;
FUN-CALL    : '(' FUN-EXP PARAMS ')'  {
                                        $$ =(struct def*) malloc( sizeof(struct def)) ;
                                        $$ -> op = "function";
                                        $$ ->variablename = $2 -> variablename;
                                        $$ -> leftnext = $2->leftnext;
                                        $$ -> rightnext = NULL; 
                                        defineFunctionVariable($2->rightnext,$3);
                                      }
            | '(' FUN-NAME PARAMS ')' {                                        
                                        $$ =(struct def*) malloc( sizeof(struct def)) ;
                                        $$ = $2; 
                                        $$ -> op = "functionName";
                                        $$ -> leftnext = $3; 
                                      }
            ;
PARAMS      : PARAM PARAMS  {
                              $$ =(struct def*) malloc( sizeof(struct def)) ;
                              $$ -> op = "param";
                              $$ -> leftnext = $1;
                              $$ -> rightnext = $2;
                            }
            | PARAM {
                      $$ =(struct def*) malloc( sizeof(struct def)) ;
                      $$ = $1; 
                    }
            |       {
                      //we use this because the parameters may not exist
                      $$ =(struct def*) malloc( sizeof(struct def)) ;
                      $$ -> op = "NULLPARAM";
                    }
            ;
PARAM       : EXP {
                    $$ =(struct def*) malloc( sizeof(struct def)) ;
                    $$ = $1;
                  }
            ;
FUN-NAME    : id  {
                    $$ =(struct def*) malloc( sizeof(struct def)) ;
                    $$-> op = "funName";
                    $$ -> variablename = $1;
                  }
            ;
IF-EXP      : '(' IF TEST-EXP THEN-EXP ELSE-EXP ')' {
                                                      $$ =(struct def*) malloc( sizeof(struct def)) ;
                                                      $$->leftnext = $3;
                                                      struct def* _temp =(struct def*) malloc( sizeof(struct def));
                                                      _temp->leftnext = $4;
                                                      _temp->rightnext = $5;
                                                      $$->rightnext = _temp;
                                                      $$->op = "if";
                                                    }
            ;
TEST-EXP    : EXP {
                    $$ =(struct def*) malloc( sizeof(struct def)) ;
                    $$=$1;
                  }
            ;
THEN-EXP    : EXP {
                    $$ =(struct def*) malloc( sizeof(struct def)) ;
                    $$=$1;
                  }
            ;
ELSE-EXP    : EXP {
                    $$ =(struct def*) malloc( sizeof(struct def)) ;
                    $$=$1;
                  }
            ;

%%

void typecheck(struct def* temp , string whatTheNumberToDo)
{
  if(whatTheNumberToDo=="and" || whatTheNumberToDo=="or" ||whatTheNumberToDo=="not" || whatTheNumberToDo==">" || whatTheNumberToDo=="<" || whatTheNumberToDo=="=")
  {
    countboolean(temp,temp->op);
  }
  else
  {
    countnumber(temp,temp->op);
  }
}

/*
to define namedFunction e.g.example_8
the node temp's structure:
        define node
        /        \
function_name   function_body(整個運算的框架)
the funcbody structure:

        function_body
        /        \
operator_tree    variable tree(儲存所有的)
*/
void defineFunction(struct def* temp , string whatTheNumberToDo)
{
  struct def* __temp =(struct def*) malloc( sizeof(struct def));
  __temp->variablename = temp->leftnext->variablename;
  __temp->functionCanUse = temp->rightnext;
  variable[variableIndex] = __temp;
  variableIndex++;  
}



/*
varName : function的變數tree 也就是function tree's rightnext
varNumber : 對應於function變數的值
e.g. x y z -> 10 20 30
varName's structure:
    param_id
    /    \
   x     param_id
           /    \
           y    z
varNumber's structure:
    param
    /    \
  10     param
        /    \
       20    30
       
由上圖可知樹會長一樣。
*/
void defineFunctionVariable(struct def* varName , struct def* varNumber )
{
  if(varName->op == "id")//代表已經跑到最下面的id (像是上面的xyz都是id)所以開始建立function variable 建立好並儲存在 functionVariable
  {
    struct def* __temp =(struct def*) malloc( sizeof(struct def));
    __temp -> variablename = varName ->variablename;
    __temp -> valueToDo = countnumber(varNumber,varName->op);
    functionVariable[functionVariableIndex] = __temp;
    functionVariableIndex++;
    return ;
  }
  else if(varName -> op == "param_id")//代表還沒有跑道最下面的id 所以繼續recursive的跑
  {
    defineFunctionVariable(varName->leftnext,varNumber -> leftnext);
    defineFunctionVariable(varName->rightnext,varNumber -> rightnext);
  }
}




/*
This is go to define a normal variable in example_6
 the temp structure: it is called in define 那邊
         temp=define
         /        \
variable_name    variable_value
*/

void defineVariable(struct def* temp , string whatTheNumberToDo)
{
  struct def* __temp =(struct def*) malloc( sizeof(struct def));
  __temp->variablename = temp->leftnext->variablename;
  __temp->valueToDo = countnumber(temp->rightnext,temp->op);
  variable[variableIndex] = __temp;
  variableIndex++;
}




//to calculate the boolean value
//because having a lots of situation so I use if-else to seperate the different operator

bool countboolean(struct def* temp , string whatTheNumberToDo)
{
  if(temp->op=="and")
  {
    bool leftboolean = countboolean(temp->leftnext,temp->op);
    bool rightboolean = countboolean(temp->rightnext,temp->op);
    return (leftboolean&rightboolean);
  }
  else if(temp->op=="or")
  {
    bool leftboolean = countboolean(temp->leftnext,temp->op);
    bool rightboolean = countboolean(temp->rightnext,temp->op);
    return (leftboolean|rightboolean);
  }
  else if(temp->op=="not")
  {
    bool leftboolean = countboolean(temp->leftnext,temp->op);
    return !leftboolean;
  }
    //this node will become difficult to call
  else if( temp -> op == "temp")
  {
      //if we meet the temp node 我們讓上面下來的operator繼續跟著temp，這樣我們才知道temp的運算是要做甚麼的
/*
e.g.     and
        / \
      true  temp(op=and 從上面的傳下來的and是儲存在whatTheNumberToDo)
           /\
        true false
          
 */
    bool leftboolean = countboolean(temp->leftnext,whatTheNumberToDo);
    bool rightboolean = countboolean(temp->rightnext,whatTheNumberToDo); 
    if(whatTheNumberToDo=="and")
    {
      return (leftboolean&rightboolean);
    }
    else if(whatTheNumberToDo=="or")
    {
      return (leftboolean|rightboolean);
    }
    else if(whatTheNumberToDo=="not")
    {
      return !leftboolean;
    }  
  }
  else if(temp->op == "boolean")
  {
    return temp->boolToDo;
  }

  else if(temp->op=="<")
  {
    int leftnumber = countnumber(temp->leftnext,temp->op);
    int rightnumber = countnumber(temp->rightnext,temp->op);
    if(leftnumber<rightnumber)
    {
      return true;
    }
    else
    {
      return false;
    }   
  } 
  else if(temp->op==">")
  {
    int leftnumber = countnumber(temp->leftnext,temp->op);
    int rightnumber = countnumber(temp->rightnext,temp->op);
    if(leftnumber>rightnumber)
    {
      return true;
    }
    else
    {
      return false;
    }     
  } 
  else if(temp->op=="=")
  {
    int leftnumber = countnumber(temp->leftnext,temp->op);
    int rightnumber = countnumber(temp->rightnext,temp->op);
    if(leftnumber==rightnumber)
    {
      return true;
    }
    else
    {
      return false;
    }     
  }
}




//it's to count number called by print-num grammer

int countnumber(struct def* temp , string whatTheNumberToDo)
{
  //we use rucursive to count number
  //we use whatTheNumberToDo to remember the "temp" node should do what calculator e.g.+ or -
  if(temp->op=="+")
  {
    int leftnumber = countnumber(temp->leftnext,temp->op);
    int rightnumber = countnumber(temp->rightnext,temp->op);
    return leftnumber+rightnumber;
  }
  else if(temp->op=="-")
  {
    int leftnumber = countnumber(temp->leftnext,temp->op);
    int rightnumber = countnumber(temp->rightnext,temp->op);
    return leftnumber-rightnumber;    
  }
  else if(temp->op=="*")
  {
    int leftnumber = countnumber(temp->leftnext,temp->op);
    int rightnumber = countnumber(temp->rightnext,temp->op);
    return leftnumber*rightnumber;    
  }
  else if(temp->op=="/")
  {
    int leftnumber = countnumber(temp->leftnext,temp->op);
    int rightnumber = countnumber(temp->rightnext,temp->op);
    return leftnumber/rightnumber;    
  }  

  else if(temp->op=="mod")
  {
    int leftnumber = countnumber(temp->leftnext,temp->op);
    int rightnumber = countnumber(temp->rightnext,temp->op);
    return leftnumber%rightnumber;      
  }  
    //this is temp node很麻煩
  else if(temp->op=="temp")
  {
//if we meet the temp node 我們讓上面下來的operator繼續跟著temp，這樣我們才知道temp的運算是要做甚麼的
/*
e.g.     +
        / \
      1  temp(op=+ 從上面的傳下來的+是儲存在whatTheNumberToDo 所以都用whatTheNumberToDo來運算)
           /\
          2 3
*/
    int leftnumber = countnumber(temp->leftnext,whatTheNumberToDo);
    int rightnumber = countnumber(temp -> rightnext,whatTheNumberToDo); 
    if(whatTheNumberToDo=="+")
    {
      return leftnumber+rightnumber;
    }
    else if(whatTheNumberToDo=="-")
    {
      return leftnumber-rightnumber;    
    }
    else if(whatTheNumberToDo=="*")
    {
      return leftnumber*rightnumber;    
    }
    else if(whatTheNumberToDo=="/")
    {
      return leftnumber/rightnumber;    
    }  
    else if(whatTheNumberToDo=="mod")
    {
      return leftnumber%rightnumber;      
    } 
  } 
  else if(temp->op=="number")
  {
    return temp->valueToDo;
  }   
    //if we meet "if" then we run this since we save 邏輯判斷在 if->leftnext
/*
This temp's structure :
            temp=if
           /       \
        邏輯判斷    運算式子=temp
 */ 
  else if(temp->op == "if")
  {
    bool leftbool = countboolean(temp->leftnext,temp->op);
    if(leftbool)//if leftbool is true
    {
      int rightnumber = countnumber(temp->rightnext->leftnext,temp->op);
      return rightnumber;
    }
    else//if leftbool is false
    {
      int rightnumber = countnumber(temp->rightnext->rightnext,temp->op);
      return rightnumber;      
    }
  }
  else if(temp->op=="id" && !CallFunctionId) // catch define variable's value
  {
      //下面的for 是為了找到variable而做的
    for(int i = 0 ; i < variableIndex ; i++)
    {
      if(temp->variablename == variable[i]->variablename)
      {
          //找到變數就回傳變數的值
        return variable[i]->valueToDo;
      }
    }
  }
  else if( temp->op=="id" && CallFunctionId ) // catch defined function variable in lambda
  {
    for(int i = 0 ; i < functionVariableIndex ; i++)
    {
      if(temp->variablename == functionVariable[i]->variablename)
      {
        return functionVariable[i]->valueToDo;
      }
    }
  }
  else if(temp -> op =="function") // do call function to calculate value
  {
    CallFunctionId = true;//if we need to calculate the function then we need to use the variables in functionVariable[10]
    return countnumber(temp->leftnext,temp->leftnext->op);
  }

  else if(temp-> op == "functionName") // do struct namedfunction
  {
    struct def* __temp =(struct def*) malloc( sizeof(struct def));
      //since we save the namedFunction's name in variable[10] and we need to find 對應的name以及抓出儲存在裡面的function。因為我儲存在functionCanUse裡面。
    for(int i = 0 ; i < variableIndex ; i++)
    {

      if(temp->variablename == variable[i]->variablename)
      {
        __temp = variable[i] -> functionCanUse;
      }
    }
    if(__temp -> rightnext->op !="NULLID")// it represent this function have parameter since we nned to 應付example_8-2
    {
      //這是抓出function 之後，我會先讓function裏面的變數先去對應變數的值，並建立variable在functionVariable裡面，之後我要計算function的時候，就可去裡面抓就好了。
      defineFunctionVariable(__temp -> rightnext , temp->leftnext);
    }
    int a = countnumber(__temp->leftnext,__temp->leftnext->op);
    return a;
  }
}




//to print number's tree
void printnumber(struct def* temp)
{
  if(temp == NULL)
  {
    return;
  } 
  
  cout<<temp->op<<"  "<<temp->valueToDo<<endl;
  printnumber(temp->leftnext);
  printnumber(temp->rightnext);
}




//to print boolean's tree
void printb(struct def* temp)
{
  if(temp == NULL)
  {
    return;
  } 
  if(temp->boolToDo==true)
  {
    cout<<temp->op<<"  "<<"true"<<endl;
  }
  else{
    cout<<temp->op<<"  "<<"false"<<endl;
  }
  printb(temp->leftnext);
  printb(temp->rightnext);
}



void yyerror(char *s)
{
  printf("%s\n",s);
  exit(0);
}




int main()
{
    yyparse();
    return 0;
}