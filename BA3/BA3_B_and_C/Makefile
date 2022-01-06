all: BA3_B_and_C.yy.c BA3_B_and_C.tab.c
	gcc BA3_B_and_C.tab.c BA3_B_and_C.yy.c
BA3_B_and_C.yy.c: BA3_B_and_C.l
	flex  -o BA3_B_and_C.yy.c BA3_B_and_C.l

BA3_B_and_C.tab.c: BA3_B_and_C.y
	bison -d -o BA3_B_and_C.tab.c BA3_B_and_C.y 

clean:
	rm a.out BA3_B_and_C.yy.c BA3_B_and_C.tab.c BA3_B_and_C.tab.h