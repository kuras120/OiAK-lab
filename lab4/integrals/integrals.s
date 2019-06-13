.data
EXIT = 						1 
READ = 						3
WRITE = 					4
STDIN = 					0
STDOUT = 					1
SYSCALL = 					0x80

msg1: .string "Choose integral: 1. sin,  2. log:\n"
msg2: .string "Lower limit:\n"
msg3: .string "Upper limit:\n"
msg4: .string "Integral:\n"
notImplError: .string "Not implemented yet.\n"

format: .string "%d"
float_format: .string "%f"
float_print: .string "%f\n"

algorithm: .int 0

.bss
.comm limitUp, 8
.comm limitDown, 8
.comm result, 8

.text
.global _start
_start:
    push $msg1
    call printf
    add $4,                 %esp
    push $algorithm
    push $format
    call scanf
    add $8,                 %esp
    push $msg2
    call printf
    add $4,                 %esp
    push $limitDown
    push $float_format
    call scanf
    add $8,                 %esp
    push $msg3
    call printf
    add $4,                 %esp
    push $limitUp
    push $float_format
    call scanf
    add $8,                 %esp

    cmp $1,                 algorithm
    je alg1
    cmp $2,                 algorithm
    je alg2
    jmp end         

alg1:
    fld limitUp
    fcos 
    fld limitDown
    fcos

    fsubp
    fstl result

    jmp print
alg2:
    push $notImplError
    call printf
    add $4,                 %esp
    jmp end
print:
	fldl result
	sub $4,                 %esp
	fstl (%esp)

	push $float_print
	call printf
	add $8,                 %esp
end:
    mov $EXIT,              %eax
    mov $0,                 %ebx
    int $SYSCALL
