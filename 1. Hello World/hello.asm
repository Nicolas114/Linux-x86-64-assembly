section .data
	text db "Hello, world!", 10	;labeleamos una addr 'text' que tiene X bytes. Ese X lo calculamos en el length
	length equ $ - text			;length de text se calcula como la direccion actual de ensamblado disminuido en la addr de text

section .text					;OBLIGATORIO
	global _start

_start:
	mov rax, 1			;ID de la llamada al so
	mov rdi, 1			;1er param: EN ESTE CASO es el file descriptor
	mov rsi, text		;2do param: buffer, la address del string
	mov rdx, length		;3er param: longitud del buffer
	syscall				;sys_write

	mov rax, 60			;ID del exit
	mov rdi, 0
	syscall				;sys_exit --> similar al hlt en OCUNS
