NAME=nazwa_zadania
all:
	as -g --32 ${NAME}.s -o ${NAME}.o
	ld -m elf_i386 -dynamic-linker /lib/ld-linux.so.2 -o ${NAME} ${NAME}.o -lc
	rm ${NAME}.o
