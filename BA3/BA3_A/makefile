all:
	bison -d -o BA3_A.tab.c BA3_A.y
	g++ -c -g -I.. BA3_A.tab.c
	flex -o BA3_A.y.c BA3_A.l
	g++ -c -g -I.. BA3_A.y.c
	g++ -o BA3_A BA3_A.tab.o BA3_A.y.o -ll