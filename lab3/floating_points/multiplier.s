.data
EXIT = 						1 
READ = 						3
WRITE = 					4
STDIN = 					0
STDOUT = 					1
SYSCALL = 					0x80

# MODEL: 
# znak 8 bit (0 lub 1)
# wykladnik 8 bit
# mantysa 24bit + 8bit znak czy znormalizowana
#         pisane od prawej do lewej, bo big endian

sign1:
    .byte 1
exponent1:
    .byte 2
mantissa1:
    .byte 2, 0, 0, 1

sign2:
    .byte 0
exponent2:
    .byte 2
mantissa2:
    .byte 2, 0, 0, 1

signout:
    .byte 0
exponentout:
    .byte 0
mantissaout:
    .byte 0, 0, 0, 0

.text
.global _start
_start:
# PRZYGOTOWANIE
    add $0b01111111,        exponent1
    add $0b01111111,        exponent2

# ZNAK KONCOWY
    mov sign1,              %al
    mov sign2,              %bl
    xor %al,                %bl
    mov %bl,                signout

# DODAWANIE WYKLADNIKOW
    mov exponent1,          %al
    mov exponent2,          %bl
    sub $0b01111111,        %bl
    add %al,                %bl
    jc errors
    mov %bl,                exponentout

# MNOZENIE MANTYS
    mov mantissa1,          %eax
    mov mantissa2,          %esi
    mul %esi
breakpoint:
    cmp $0,                 %edx
    je last_check
    
    shrd $24,               %edx, %eax

last_check:
    mov %eax,               %esi
    shr $24,                %esi
    cmp $1,                 %esi
    je end

    mov exponentout,        %bl

last_check_loop:
    shr $1,                 %eax
    inc %bl
    mov %eax,               %esi
    shr $24,                %esi
    cmp $1,                 %esi
    jne last_check_loop

    mov %bl,                exponentout
    mov %eax,               mantissaout
    jnc end
errors:
    mov $0b11111111,        %al
    mov %al,                exponentout
    mov $0x00000000,        %eax
    mov %eax,               mantissaout

# KONIEC
end:
    shl $8,                 %eax
    mov %eax,               mantissaout

    mov $EXIT,              %eax
    mov $0,                 %ebx
    int $SYSCALL
