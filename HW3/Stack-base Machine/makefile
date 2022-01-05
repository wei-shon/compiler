all:
	bison -d -o dm3_1.tab.c dm3_1.y
	gcc -c -g -I.. dm3_1.tab.c
	flex -o dm3_1.yy.c dm3_1.l
	gcc -c -g -I.. dm3_1.yy.c
	gcc -o dm3_1 dm3_1.tab.o dm3_1.yy.o -ll