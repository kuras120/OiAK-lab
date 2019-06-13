NAME=nazwa_zadania
all:
	as -g --32 ${NAME}.s -o ${NAME}.o
	ld -m elf_i386 ${NAME}.o -o ${NAME}
	rm ${NAME}.o

