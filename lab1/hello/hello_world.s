# Sekcja danych - deklaracje zmiennych
.data

# Numery funkcji systemowych na podstawie pliku asm/unistd.h
EXIT = 1 
READ = 3
WRITE = 4
STDIN = 0
STDOUT = 1
SYSCALL = 0x80

# Etykieta wskazujaca na adres poczatku danej instrukcji
buf:
	.ascii "hello world\n" # Dyrektywa adresujaca znaki miedzy " "

# Obliczenie wielkosci etykiety. '.' oznacza adres pod którym się znajdujemy,
# podana nazwa etykiety wskazuje na adres poczatku danej instrukcji
buf_len = . - buf

# Sekcja programu
.text
# Sekcja wskazujaca na punkt poczatkowy programu
.global _start
# Start programu
_start:
	mov $WRITE, 	%eax	# Funkcja:	wywolana funkcja (4 = write)
	mov $STDOUT, 	%ebx	# arg1 Gdzie:	podstawowy strumień wyjściowy
	mov $buf, 		%ecx	# arg2 Co:	wczytanie początku adresu bufora
	mov $buf_len, 	%edx	# arg3 Dlugosc:	wczytanie wielkosci bufora
	int $SYSCALL

	mov $EXIT, 	%eax	# Funkcja: 	wywolana funkcja (1 = exit)
	mov $0, 	%ebx	# arg1 Kod: 	możliwy kod błędu (0 = bez błędu) 
	int $SYSCALL

