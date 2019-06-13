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
loading:
	pop 				%esi
	pop 				%esi
	mov %esi,			%ecx

isZero:
	cmp $0x20, 			%esi
	je	end
	
counter:
	inc	%edx
	inc %esi
	cmpb $0, 			(%esi)
	jne	counter

	mov $WRITE, 		%eax
	mov $STDOUT, 		%ebx
	int $SYSCALL

	mov $WRITE, 		%eax
	mov $STDOUT, 		%ebx
	mov $new_line,		%ecx
	mov $new_line_len,	%edx
	int $SYSCALL

	mov $0,				%edx
	jmp	loading

end:
	mov $EXIT, 			%eax
	mov $0, 			%ebx
	int $SYSCALL
