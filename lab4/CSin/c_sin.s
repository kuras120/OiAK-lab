.text
.global my_sin
.type my_sin, @function
my_sin:
    push %ebp
    mov %esp,    %ebp
    fld 8(%ebp)
    fsin
    mov %ebp,    %esp
    pop %ebp
    ret
