.data
scanf_f: .ascii "%s/0"
.text
.global _start
_start:
	push %ebp
	movl %esp, %ebp
	subl $80, %esp
	leal -80(%ebp), %eax
	push %eax
	push $scanf_f
	call scanf

	movl %ebp, %esp
	pop %ebp
	push $0
	call exit
