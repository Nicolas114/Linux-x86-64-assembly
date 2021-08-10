;Para leer un archivo:

;1. Abrirlo
;sys_open: igual que al querer escribir
;la única diferencia entre el proceso de Escribir y Leer en un archivo, es que el flag que vamos a usar ahora es O_RDONLY (value: 0).
;Código de ejemplo:

;mov rax, SYS_OPEN
;mov rdi, filename
;mov rsi, O_RDONLY
;mov rdx, 0644o             ;permisos de archivo, pero no importan si solo estamos leyendo el archivo
;syscall

;La operatoria es la misma: la llamada al sistema retorna el file descriptor del archivo abierto al rax, o el error en caso de haberlo

;2. Proceso de lectura
;sys_read: ID: 0, tres argumentos
;Argumento 1: el file descriptor retornado por la llamada del sys_open
;Argumento 2: el puntero a la memoria alocada para guardar la informacion leída
;Argumento 3: cantidad de bytes a leer

;Código de ejemplo:

;mov rdi, rax
;mov rax, SYS_READ
;mov rsi, text
;mov rdx, 17
;syscall

;3. Cerrarlo
;Al igual que antes, debemos cerrar el archivo con sys_close
;sólo toma el file descriptor
;Código de ejemplo:

;mov rax, SYS_CLOSE
;pop rdi                    ;asume que está en el tope de la pila del sistema, con lo que deberiamos haber pusheado el file descriptor antes
;syscall


;Código completo para abrir, leer informacion de un archivo y cerrarlo.

%include "linux64.inc"

section .data
    filename db "file.txt",0
    newline db 10

section .bss
    text resb 18            ;los bytes que vamos a leer (17) + el 0 con el que termina el string

section .text
    global _start

_start:
    mov rax, SYS_OPEN
    mov rdi, filename
    mov rsi, O_RDONLY
    mov rdx, 0644o
    syscall

    push rax
    mov rdi, rax
    mov rax, SYS_READ
    mov rsi, text
    mov rdx, 17
    syscall

    mov rax, SYS_CLOSE
    pop rdi
    syscall

    print text
    print newline

    exit