all:
	bison -d -o dm3_2.tab.c dm3_2.y
	gcc -c -g -I.. dm3_2.tab.c
	flex -o dm3_2.yy.c dm3_2.l
	gcc -c -g -I.. dm3_2.yy.c
	gcc -o dm3_2 dm3_2.tab.o dm3_2.yy.o -ll