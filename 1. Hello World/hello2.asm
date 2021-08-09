section .data
    text db "Hello, World!", 10
    length equ $ - text

section .text
    global _start   ;OBLIGATORIO

_start:

    call _printHello ;la parte del codigo que imprime hello world es mandada a la subrutina

    mov rax, 60
    mov rdi, 0
    syscall

_printHello:
    mov rax, 1
    mov rdi, 1
    mov rsi, text
    mov rdx, length
    syscall
    ret