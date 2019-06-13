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
    .byte 1, 2, 4, 1

sign2:
    .byte 0
exponent2:
    .byte 2
mantissa2:
    .byte 1, 1, 3, 1

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
    add $0b01111111,      exponent1
    add $0b01111111,      exponent2

# ZNAK KONCOWY
    mov exponent1,          %al
    mov exponent2,          %bl
    cmp %al,                %bl
    jg set_sign_2
    jl set_sign_1
    
    mov mantissa1,          %eax
    mov mantissa2,          %ebx
    cmp %eax,               %ebx
    jg set_sign_2
    jl set_sign_1
    je preparations

set_sign_1:
    mov sign1,              %al
    mov %al,                signout
    jmp preparations
    
set_sign_2:
    mov sign2,              %al
    mov %al,                signout

# PRZYGOTOWANIA CD.
preparations:
    mov $0,                 %cl
    mov exponent1,          %al
    mov exponent2,          %bl
    cmp %al,                %bl
    jl  increment_exp2
    je  end_shift

increment_exp1:
    inc %al
    inc %cl
    cmp %al,                %bl
    jg  increment_exp1

# PRZESUNIECIE MANTYSY 1
    mov mantissa1,          %esi
    shr %cl,                %esi
    mov %esi,               mantissa1
    jmp end_shift

increment_exp2:
    inc %bl
    inc %cl
    cmp %bl,                %al
    jg  increment_exp2

# PRZESUNIECIE MANTYSY 2
    mov mantissa2,          %esi
    shr %cl,                %esi
    mov %esi,               mantissa2

end_shift:
    mov %al,                exponentout
    mov $0,                 %al
# SPRAWDZANIE ZNAKOW PRZED DODANIEM MANTYS
    mov sign1,              %bl
    mov sign2,              %cl
    
    mov mantissa1,          %esi
    mov mantissa2,          %edi

# (+a) + (+b) = a + b
# (-a) + (+b) = b - a = n(nb + a)  
# (-a) + (-b) = -(a + b)
# (+a) + (-b) = a - b = n(na + b)

    cmp %bl,                %cl
    jg negate_sign2
    je adder

    neg %edi
    inc %edi
    jmp adder

negate_sign2:
    neg %esi
    inc %esi
adder:
# DODAWANIE MANTYS I NEGACJA JESLI INNE ZNAKI
# (PRZERABIANIE ODEJMOWANIA NA DODAWANIE)
    add %esi,               %edi
    
    cmp %bl,                %cl
    je check_shift
    cmp $1,                 signout
    jne check_shift
negate:
    neg %edi
    inc %edi
check_shift:
# CZY JEST ZEREM (JESLI TAK TO NIE WYKONUJ NIC)
    cmp $0,                 %edi
    je end

# SPRAWDZAM CZY JEST JEDYNKA Z PRZODU
    mov %edi,               mantissaout
    shr $24,                %edi
    cmp $1,                 %edi
    jl decrement_exp
    je end
# INKREMENTACJA EXPONENTY RAZ (PRZY DODAWANIU WYSTARCZY)
    inc %al
    mov mantissaout,        %esi
    shr $1,                 %esi
    mov %esi,               mantissaout
    jmp end

# DEKREMENTACJA EXPONENTY AZ DO UZYSKANIA JEDYNKI Z PRZODU
decrement_exp:
    dec %al
    mov mantissaout,        %esi
    shl $1,                 %esi
    mov %esi,               mantissaout
    mov %esi,               %edi
    shr $24,                %edi
    cmp $1,                 %di
    jl decrement_exp
end:
    add %al,                exponentout
    mov mantissaout,        %esi
    shl $8,                 %esi
    mov %esi,               mantissaout
# KONIEC
    mov $EXIT,              %eax
    mov $0,                 %ebx
    int $SYSCALL
    