.data
EXIT = 						1 
READ = 						3
WRITE = 					4
STDIN = 					0
STDOUT = 					1
SYSCALL = 					0x80

.bss
.comm input1, 				512
.comm input2, 				512
.comm value1,				256
.comm value2,				256
.comm sum, 					256
.comm output, 				515

.text
.global _start
_start:
	mov $256, 				%esi
	mov $0,					%al

zerowanie:
	dec %esi
	mov %al,				value1(, %esi, 1)
	mov %al, 				value2(, %esi, 1)
	cmp $0, 				%esi
	jg zerowanie
	
#	PIERWSZY CIAG

	mov $READ, 				%eax
	mov $STDIN,				%ebx
	mov $input1,			%ecx
	mov $512,				%edx
	int $SYSCALL

	mov %eax, 				%esi
	# USUWANIE ZNAKU NOWEJ LINII
	dec %esi
	mov $256, 				%edi

dekodowanie:
	dec %esi
	dec %edi

	mov input1(, %esi, 1), 	%al

	cmp $'A', 				%al
	jge litera

	sub $'0', 				%al
	jmp dekodowanie_1

litera:
	sub $55, 				%al

dekodowanie_1:
	cmp $0, 				%esi
	jle dekodowanie_3

	mov %al,				%bl
	dec %esi
	mov input1(, %esi, 1), 	%al

	cmp $'A', 				%al
	jge litera_2

	sub $'0',				%al
	jmp dekodowanie_2

litera_2:
	sub $55, 				%al

dekodowanie_2:
	mov $16, 				%cl
	mul %cl
	add %bl,				%al

dekodowanie_3:
	mov %al,				value1(, %edi, 1)

	cmp $0, 				%esi
	jg dekodowanie

#	DRUGI CIAG

	mov $READ, 				%eax
	mov $STDIN,				%ebx
	mov $input2,			%ecx
	mov $512,				%edx
	int $SYSCALL

	mov %eax, 				%esi
	dec %esi
	mov $256, 				%edi

dekodowanie1:
	dec %esi
	dec %edi

	mov input2(, %esi, 1), 	%al

	cmp $'A', 				%al
	jge litera1

	sub $'0', 				%al
	jmp dekodowanie1_1

litera1:
	sub $55, 				%al

dekodowanie1_1:
	cmp $0, 				%esi
	jle dekodowanie1_3

	mov %al,				%bl
	dec %esi
	mov input2(, %esi, 1), 	%al

	cmp $'A', 				%al
	jge litera1_2

	sub $'0',				%al
	jmp dekodowanie1_2

litera1_2:
	sub $55, 				%al

dekodowanie1_2:
	mov $16, 				%cl
	mul %cl
	add %bl,				%al

dekodowanie1_3:
	mov %al,				value2(, %edi, 1)

	cmp $0, 				%esi
	jg dekodowanie1

# DODAWANIE
	clc
	pushf
	mov $255,					%esi

dodawanie:
	mov value1(, %esi, 1),		%al
	mov value2(, %esi, 1),		%bl
	popf
	adc %bl, 					%al
	pushf
	mov %al,					sum(, %esi, 1)

	dec %esi
	cmp $0, 					%esi
	jg dodawanie

# KONWERSJA HEX
	mov $255,					%esi
	mov $513,					%edi

konwersja:
	mov sum(, %esi, 1), 		%al
	mov %al,					%bl
	mov %al,					%cl

	shr $4,						%cl
	and $0b1111,				%bl
	and $0b1111,				%cl
	add $'0',					%bl
	add $'0',					%cl

	cmp $'9',					%bl
	jle dalej
	add $7,						%bl

dalej:
	cmp $'9',					%cl
	jle dalej1
	add $7,						%cl

dalej1:
	mov %bl,					output(, %edi, 1)
	dec %edi
	mov %cl,					output(, %edi, 1)
	dec %edi

	dec %esi
	cmp $0,						%esi
	jge konwersja

# WYSWIETLANIE
test1:
	mov $514,					%esi
	movb $0x0A,					output(, %esi, 1)
	mov $WRITE,					%eax
	mov $STDOUT,				%ebx
	mov $output,				%ecx
	mov $515,					%edx
	int $SYSCALL

# ZAKONCZENIE
	mov $EXIT,					%eax
	mov $0,						%ebx
	int $SYSCALL
