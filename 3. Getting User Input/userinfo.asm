section .data
	question db "What is your name?", 10
	lengthQ equ $ - question
	response db "Hello, "
	lengthR equ $ - response

section .bss		; seccion usada para reservar memoria
	name resb 16	;reservamos 16 bytes con el label 'name'

section .text
	global _start

_start:
	
	call _printQuestion
	call _getName
	call _printResponse
	call _printName


	mov rax, 60
	mov rdi, 0
	syscall

_getName:
	mov rax, 0			;para que el usuario meta informacion
	mov rdi, 0			;codigo de error
	mov rsi, name		;guardamos el input en el espacio de memoria reservado
	mov rdx, 16
	syscall
	ret

_printQuestion:

	mov rax, 1
	mov rdi, 1
	mov rsi, question
	mov rdx, lengthQ
	syscall
	ret

_printResponse:
	
	mov rax, 1
	mov rdi, 1
	mov rsi, response
	mov rdx, lengthR
	syscall
	ret

_printName:

	mov rax, 1
	mov rdi, 1
	mov rsi, name	;queremos mostrar lo que introdujo el usuario
	mov rdx, 16		;16 bytes es todo lo que reservamos. Maximo 16 bytes
	syscall
	ret
