section .data
    digit db 0,10
    length equ $ - digit

section .text
    global _start

;definir una macro
;%macro <nombre> <cantidad de args>
;si hay argumentos, serán referenciados como %1 (al primer arg), %2 (al segundo) y así
%macro halt 0       
    mov rax, 60     
    mov rdi, 0
    syscall
%endmacro
; %endmacro

;¿qué pasa si definimos un label dentro de una macro? Cada vez que se expanda en tiempo de compilación, habrá repetidas definiciones del mismo label
;ejemplo:
;%macro example 0
;    _loop:
;        jmp _loop
;%endmacro
;Cuando hagamos uso múltiple de esta macro, obtendremos un error de Redefined Symbol Error
;para evitar esto, podemos reemplazar el "_" por doble %, como sigue:
;%macro example 0
;    %%loop:
;        jmp %%loop
;%endmacro
;y de esta forma el label será único cada vez que es expandido

%macro printDigit 1
    mov rax, %1
    call _printRAXDigit
%endmacro

%macro printDigitSum 2
    mov rax, %1
    add rax, %2
    call _printRAXDigit
%endmacro

_printRAXDigit:
    add rax, 48
    mov [digit], al

    mov rax, 1
    mov rdi, 1
    mov rsi, digit
    mov rdx, length
    syscall

    ret

_start:
    printDigit 3
    printDigit 4
    printDigitSum 3, 9
    halt