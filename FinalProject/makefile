all:
	bison -d -o final.tab.c final.y
	g++ -c -g -I.. final.tab.c
	flex -o final.y.c final.l
	g++ -c -g -I.. final.y.c
	g++ -o final final.tab.o final.y.o -ll