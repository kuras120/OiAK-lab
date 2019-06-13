.data
EXIT = 1 
READ = 3
WRITE = 4
STDIN = 0
STDOUT = 1
SYSCALL = 0x80

star:
	.ascii "*"
star_len = . - star

new_line:
	.ascii "\n"
new_line_len = . - new_line

num = 5

.text
.global _start
_start:
	mov $num, 	%esi
loop:
	dec %esi

	mov $WRITE, 	%eax
	mov $STDOUT, 	%ebx
	mov $star, 	%ecx
	mov $star_len, 	%edx
	int $SYSCALL

	cmp $0, %esi
	jg loop

mov $WRITE, 		%eax
mov $STDOUT, 		%ebx
mov $new_line, 		%ecx
mov $new_line_len, 	%edx
int $SYSCALL
mov $EXIT, 		%eax
mov $0, 		%ebx
int $SYSCALL

