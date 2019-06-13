.data
EXIT = 						1 
READ = 						3
WRITE = 					4
STDIN = 					0
STDOUT = 					1
SYSCALL = 					0x80

row: .int 0
col: .int 0

.bss
.comm array, 20*20*4
.equ j, 20
.equ i, 20

.comm rows_time_counter, 8
.comm cols_time_counter, 8

.text
.global _start
_start:
# Mierzenie wypelnienia kolumn
	rdtsc
	movl %eax, 						cols_time_counter
	mov $cols_time_counter, 		%ecx
	movl %edx, 						4(%ecx) 

	movl $0, 						col
	movl $0, 						row
next_col_cols:
	movl col, 						%ecx
next_row_cols:
	movl row, 						%eax
	movl $i, 						%edx
	mull %edx
	movl $4, 						%edx
	mull %edx
	movl $1, 						array(%eax, %ecx, 4)
	incl row
	movl row,	 					%eax
	cmpl $j, 						%eax
	jne next_row_cols

	movl $0, 						row
	incl col
	incl 							%ecx
	cmp $i, 						%ecx
	jne next_col_cols
	
	movl $0, 						col

	rdtsc
	subl cols_time_counter, 		%eax
	movl %eax, 						cols_time_counter
	movl $cols_time_counter, 		%ecx
	subl 4(%ecx), 					%edx
	movl %edx, 						4(%ecx)

# Mierzenie wypelnienia wierszy
	rdtsc
	movl %eax, 						rows_time_counter
	mov $rows_time_counter, 		%ecx
	movl %edx, 						4(%ecx) 

	movl $0, 						col
	movl $0, 						row
next_row_rows:
	movl row, 						%eax
	movl $i, 						%edx
	mull %edx
	movl $4, 						%edx
	mull %edx
next_col_rows:
	movl col, 						%ecx
	movl $2, 						array(%eax, %ecx, 4)
	incl col
	incl %ecx
	cmpl $i, 						%ecx 
	jne next_col_rows

	movl $0, 						col
	incl row
	movl row, 						%eax
	cmp $j, 						%eax
	jne next_row_rows

	movl $0, 						row

	rdtsc
	subl rows_time_counter, 		%eax
	movl %eax, rows_time_counter
	movl $rows_time_counter, 		%ecx
	subl 4(%ecx), 					%edx
	movl %edx, 						4(%ecx)

end:
	mov $EXIT, 						%eax
	mov $0, 						%ebx
	int $SYSCALL
