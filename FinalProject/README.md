# Compiler Final Project

## Function Introdunction
``` c=
    void printnumber(struct def* temp)
    -> to print the tree only contain number
```

```c=
    void printb(struct def* temp)
    -> to print the tree only contain boolean
```   

```c=
    int countnumber(struct def* temp , string whatTheNumberToDo)
    -> if we meet "printnum" then we should count number and print number,
       so this function is to countnumber
```

```c=
    bool countboolean(struct def* temp , string whatTheNumberToDo)
    -> if we meet "printbool" then we should count boolean and print boolean,
       so this function is to count boolean
```
```c=
    void defineVariable(struct def* temp , string whatTheNumberToDo)
    -> if we meet the normal define a variable.
       like: (define x 0)
       then we just define it and save in the array called variable
```
```c=
    void defineFunctionVariable(struct def* varName , struct def* varNumber )
    -> if we meet the function's variable. 
       like: (define x 0)
       then we just define it,
       match the function's variable and its values
       and save in the array called functionVariable
```
```c=
    void defineFunction(struct def* temp , string whatTheNumberToDo)
    -> if we meet the function. 
       like: (define bar (lambda (x) (+ x 1)))
       then we just define it and 
       save function name including function into the array called variable 
```

## Example8-2:
```
answer = 3

(define bar (lambda (x) (+ x 1)))

(define bar-z (lambda () 2)) 

(print-num (bar (bar-z)))
```
![](https://i.imgur.com/FMkNcMM.jpg)

![](https://i.imgur.com/H5KtLNr.jpg)

## Example8-1:
```
answer = 91

(define foo
  (lambda (a b c) (+ a b (* b c))))

(print-num (foo 10 9 8))
```
![](https://i.imgur.com/7LN1eAb.jpg)

![](https://i.imgur.com/sRXVnvS.jpg)

## Example7-2:
```

answer = 610,0

(define x 0)

(print-num
  ((lambda (x y z) (+ x (* y z))) 10 20 30))


(print-num x)
```
![](https://i.imgur.com/hDwdCTE.jpg)

## Example7-1:
```
answer = 4,9
(print-num
  ((lambda (x) (+ x 1)) 3))

(print-num
  ((lambda (a b) (+ a b)) 4 5))
```
![](https://i.imgur.com/mfeatvO.jpg)
