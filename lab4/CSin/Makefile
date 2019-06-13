NAME=nazwa_zadania
all:
	as -g --32 ${NAME}.s -o ${NAME}.o
	gcc -g -m32 -o main main.c ${NAME}.o
	rm ${NAME}.o
