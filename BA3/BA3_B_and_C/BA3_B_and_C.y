%{
#include<stdio.h>
#include <stdlib.h>
#include "string.h"

extern int yylex();
extern FILE *yyin;
typedef struct List {
    int size;
    char** items;
    int maxSize;
}my_list;

typedef struct Slice {
    int startIndex;
    int endIndex;
    int hasStartIndex;
    int hasEndIndex;
    int step;
}my_slice;

my_list* create_list() {
    const int maxSize = 10000;
    my_list* list = malloc(sizeof(my_list));
    list->items = malloc(sizeof(char*)*maxSize);
    list->size = 0;
    list->maxSize = maxSize;
    return list;
}


int append_last(my_list* list, char* c) {
    list->items[list->size] = malloc((strlen(c)+1) * sizeof(char));
    strcpy(list->items[list->size], c);
    list->size+=1;
    return list->size;
}

int append_head(my_list* list, char* c) {
    int i;
    for (i = list->size-1; i > -1 ; i--) {
        list->items[i+1] = list->items[i];
    }
    list->items[0] = malloc((strlen(c)+1) * sizeof(char));
    strcpy(list->items[0], c);
    list->size+=1;
    return list->size;
}

my_list* concat_list(my_list* first_list , my_list* second_list) {
    my_list* new_list = create_list();
    int i;
    for(i = 0; i < first_list->size; i++) {
        append_last(new_list, first_list->items[i]);
    }
    for(i = 0; i < second_list->size; i++) {
        append_last(new_list, second_list->items[i]);
    }
    return new_list;
}

my_list* repeat_list(my_list* list , int repeat_num) {
    my_list* new_list = create_list();
    // if repeat num <= 0, list would be empty
    int ori_size = list->size;
    if (repeat_num <= 0) {
        return new_list;
    }
    int r; 
    int i;
    for (r = 0 ; r < repeat_num ; r++) {
        for(i =0; i < ori_size; i++) {
            append_last(new_list, list->items[i]);
        }
    }
    return new_list;
}

void print_list(my_list* list) {
    printf("[");
    int i;
    for (i = 0 ; i < list->size ; i++ ) {
        printf("%s", list->items[i]);
        if (i != list->size - 1) {
            printf(", ");
        }
    }
    printf("]\n");
}

my_list* create_list_slice(my_list* list, my_slice* slice) {
    int start_index = slice->hasStartIndex?slice->startIndex:0;
    int end_index = slice->hasEndIndex?slice->endIndex:list->size;
    if (start_index < 0 ) {
        start_index += list->size;
    }
    if (end_index < 0) {
        end_index += list->size;
    }

    if (start_index < 0) {
        start_index = 0;
    }
    
    if (end_index < 0) {
        end_index = 0;
    }

    int len = end_index - start_index;
    if (end_index > list->size) {
        end_index = list->size;
    }
    if (start_index > list->size) {
        end_index = list->size;
    }
    my_list* new_list = create_list();
    int i;
    for(i = start_index; i < end_index ; i+=slice->step) {
        append_last(new_list, list->items[i]);
    }
    return new_list;
}
my_list* list;
%}
%union {
  int ival;
  char* word;
  struct List* list;
  struct Slice* slice;
}

%start S
%token<word> DIGITS
%token LBRACKET RBRACKET COMMA MULTIPLY ADDITION COLON

%type<word> StartIndex EndIndex Step
%type<list> ListItem List Term Sum
%type<ival> MulDigit
%type<slice> Slice
%%
S 
    : Sum   {
                print_list($1);
            }
    ;
Sum 
    : Term ADDITION Sum { 
                            $$ = concat_list($1,$3);
                        }
    | Term  { 
                $$=$1;
            }
    ;
Term 
    : List MULTIPLY MulDigit    {
                                    $$ = repeat_list($1,$3);
                                }
    | MulDigit MULTIPLY List    {
                                    $$ = repeat_list($3,$1);
                                }
    | MulDigit MULTIPLY List MULTIPLY MulDigit  {
                                                    $$ = repeat_list($3,$1*$5);
                                                }
    | List  {
                $$ = $1;
            }
    ;
MulDigit 
    : MulDigit MULTIPLY  DIGITS {
                                    $$ = $1 * atoi($3);
                                }
    | DIGITS    {
                    $$ = atoi($1);
                }
    ;
List 
    : LBRACKET ListItem RBRACKET Slice  {
                                            $$ = create_list_slice($2,$4);
                                        }
    ;
Slice
    : LBRACKET StartIndex COLON EndIndex RBRACKET   {
                                                        $$ = malloc(sizeof(my_slice));
                                                        if($2 !="!")
                                                        {
                                                            $$ -> hasStartIndex =1;
                                                            $$ -> startIndex = atoi($2);
                                                        }
                                                        if($4 != "!")
                                                        {
                                                            $$ -> hasEndIndex = 1;
                                                            $$ -> endIndex = atoi($4);
                                                        }
                                                        $$ -> step = 1;
                                                    }
    | LBRACKET StartIndex COLON EndIndex COLON Step RBRACKET    {
                                                                    $$ = malloc(sizeof(my_slice));
                                                                    if($2 !="!")
                                                                    {
                                                                        $$ -> hasStartIndex =1;
                                                                        $$ -> startIndex = atoi($2);
                                                                    }
                                                                    if( $4 != "!")
                                                                    {
                                                                        $$ -> hasEndIndex = 1;
                                                                        $$ -> endIndex = atoi($4);
                                                                    }
                                                                    $$ -> step = atoi($6);
                                                                }
    |   {
            $$ = malloc(sizeof(my_slice));
            $$ -> step = 1;
        }
    ;
StartIndex
    : DIGITS    { 
                    $$ = $1;
                }
    |   { 
            $$ = "!";
        }
    ;
EndIndex
    : DIGITS    { 
                    $$ = $1;
                }
    |   {  
            $$ = "!";
        }
    ;
Step
    : DIGITS    {  
                    $$ = $1;
                }
    | 
    ;
ListItem 
    : DIGITS COMMA ListItem {
                                $3 ->size = append_head($3,$1);
                                $$=$3;
                            }
    | DIGITS    {
                    $$ = create_list();
                    $$ -> size = append_head($$,$1);
                }
    ;
%%

void yyerror (char const *s) 
{
   fprintf (stderr, "%s\n", s);
}

int main(int argc, char** argv)
{
    // if you need submit the code, need comment below
    // if you need run locally by input file t.txt, need uncomment below

    /*
    FILE *fp;
    fp=fopen("all_open.txt","r");
    yyin=fp;
    */

    // if you need submit the code, need comment above
    // if you need run locally by input file t.txt, need uncomment above
    yyparse();
    return 0;
}
