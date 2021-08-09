section .data
    digit db 0,10      ;defino 2 bytes en la addr digit: el digito que quiero mostrar, y el newline.
    length equ $ - digit

section .text
	global _start

_start:
    ;mov rax, 6
    ;mov rbx, 2
    ;div rbx         ;el primer argumento ES EL RAX, el segundo es el RBX. Similar en otras instrucciones

    push 4
    push 8
    push 3

    pop rax
    call _printRAXDigit
    pop rax
    call _printRAXDigit
    pop rax
    call _printRAXDigit

;sys_exit(0)
    mov rax, 60
    mov rdi, 0
    syscall

_printRAXDigit:
    add rax, 48         ;le sumo el ascii 0 al rax y de esta forma transformo su contenido en ascii. De otra forma no podríamos visualizarlo correctamente
    mov [digit], al

    ;pasos para el sys_write(1)
    mov rax, 1
    mov rdi, 1
    mov rsi, digit
    mov rdx, length
    syscall

    ret