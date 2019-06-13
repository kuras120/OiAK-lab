.data
EXIT = 1 
READ = 3
WRITE = 4
STDIN = 0
STDOUT = 1
SYSCALL = 0x80

new_line:
	.ascii "\n"
new_line_len = . - new_line

.text
.global _start
_start:
loop:
	pop 				%esi
	pop 				%esi
	mov %esi,			%ecx

isZero:
	cmp $0x20, 			%esi
	je 					end
	
	push				%ecx
	call				printf
	pop					%ecx

	push				$new_line
	call				printf
	pop					%edx
	jmp 				loop

end:
	mov $EXIT, 			%eax
	mov $0, 			%ebx
	int $SYSCALL
