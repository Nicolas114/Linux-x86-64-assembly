section .data
    digit db 0, 10      ;defino 2 bytes en la addr digit: el digito que quiero mostrar, y el newline.
    length db $ - digit


section .text
	global _start

_start:
    add rax, 48         ;meto el codigo ascii del digito cero (7 bits en un registro de 64 bits).
    mov [digit], al     ;muevo el contenido del registro AL a la addr de digit. AL es el registro de 8 bits que forma parte del RAX y manipula los 8 bits menos significativos.
                        ;la operación anterior almacenó 7 bits en rax con lo cual estos bits están presentes en el AL.
                        ;por ende, en esta instrucción cuando movamos la data del AL a la addr de digit, se va a alterar sólo el primer byte de M[digit] definido (el cero) y el newline no va a ser afectado.
                        ;si en cambio metiéramos en M[digit] el contenido del AX (16 bits), SÍ afectaríamos a ambos valores
                        ;si metiéramos el contenido del eax (4 bytes) o del rax directamente (8 bytes), alterarían tanto los 2 bytes del digit como 2 o 6 más respectivamente

    mov rax, 1          ;para mostrar el digito
    mov rdi, 1
    mov rsi, digit
    mov rdx, length     ;length del digit
    syscall

    ret

