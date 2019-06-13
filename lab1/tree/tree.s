.data
EXIT = 1 
READ = 3
WRITE = 4
STDIN = 0
STDOUT = 1
SYSCALL = 0x80

star:
	.string "*"
star_len = . - star

space:
	.string " "
space_len = . - space

new_line:
	.string "\n"
new_line_len = . - new_line

tree_len = 3

.text
.global _start
_start:
	mov $tree_len, %esi
loop:
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

