;ACLARACION
;siendo el codigo de ejemplo
;mov rax, 24
;mov rbx, 2
;div rbx

;el resultado esperado es que rax = 12
;sin embargo, el rdx tiene un efecto sobre la operación, y es que si éste no es cero, entonces "se unirá" o "será concatenado" al rax para formar una especie de registro único de 128 bits, que luego formará parte de la división.
;por tanto si no queremos que suceda eso y sólo queremos dividir al rax, debemos poner en cero el rdx ANTES de la operacion, con lo cual quedaría así:
;mov rax, 24
;mov rbx, 2
;mov rdx, 0
;div rbx

;OTRA ACLARACION
;una vez que la división se efectúa, el rdx contiene el resto de la division. Por ejemplo si dividimos 25 sobre 2, rax contendría el valor 12, y rdx el valor 1

section .bss
    digitSpace resb 100         ;reservamos 100 bytes pues vamos a estar imprimiendo varios digitos en lugar de uno. Va a almacenar el string que queremos imprimir
    digitSpacePosition resb 8   ;8 bytes es suficiente para almacenar el valor de un registro (máx 64 bits). Es el puntero con el cual nos movemos a traves del espacio reservado anteriormente

section .text
    global _start

_start:

    mov rax, 123                ;el valor que queremos imprimir
    call _printRAX

    mov rax, 60
    mov rdi, 0
    syscall

_printRAX:
    mov rcx, digitSpace         ;en digitSpace vamos almacenando AL REVÉS los digitos que queremos imprimir, porque luego recorreremos el espacio de memoria de atrás para adelante, con lo cual queda bien (por eso insertamos un newline al inicio del espacio reservado, pues va a ser lo último en ser impreso).
    mov rbx, 10                 ;newline
    mov [rcx], rbx              ;insertamos un newline
    inc rcx                     ;nos movemos al byte siguiente
    mov [digitSpacePosition], rcx   ;digitSpacePosition direcciona al byte a través del cual se mueve por el espacio de memoria de digitSpace

_printRAXLoop:
    mov rdx, 0                  ;para que rdx no participe en la division
    mov rbx, 10                 ;no es un newline, es para dividir y obtener el digito menos significativo
    div rbx                     ;rax/rbx --> 123/10 = 12 RESTO 3, rax almacena el 12, rdx almacena el 3
    push rax                    ;guardamos el valor de rax de momento
    add rdx, 48                 ;convertimos a ascii el resto de la division (o sea el 3)
    
    mov rcx, [digitSpacePosition]   ;en rcx guardamos la direccion en donde estamos parados en el espacio de memoria del digitSpace
    mov [rcx], dl               ;dl es el registro de 8 bits menos significativos del rdx. Guardamos en M[rcx] el valor del resto de la division
    inc rcx                     
    mov [digitSpacePosition], rcx   ;avanzamos al próximo byte direccionado en el espacio de memoria del digitSpace

    pop rax                     ;recuperamos el valor de rax (que por no haber pusheado nada a la pila, sabemos que es el valor del rax que guardamos antes)
    cmp rax, 0                  ;vemos si es cero, o sea, si ya dividimos todos los digitos por 10 o si nos faltan todavia
    jne _printRAXLoop           ;si no es cero volvemos al loop y seguimos dividiendo y obteniendo los digitos

;una vez que rax es cero, significa que ya obtuvimos todos los digitos y los pusimos de forma reversa en el espacio de memoria de digitspace
;ilustracion
;NOTA: "\" al lado de un valor, string, lo que sea, significa que ese valor fue reemplazado por el que está inmediatamente a la derecha (sirve para hacer trazas)

;                Memoria
;------------------------------------------
; digitSpace (0000h)|   10
; 0001h             |   3
; 0002h             |   2
; 0003h             |   1
; 0004h             |   ?
;  ...              |  ...
; 0100h             |   ?
; digitSpacePosition| 0000h\0001h\0002h\0003h
;
;

_printRAXLoop2:
    mov rcx, [digitSpacePosition]   ;metemos en rcx el ultimo valor que tomo nuestro puntero (0003h)

    mov rax, 1
    mov rdi, 1
    mov rsi, rcx
    mov rdx, 1
    syscall                         ;imprimimos lo que esta en esa direccion (recordar que ya habiamos metido en la memoria el valor convertido a ascii, asi que no hace falta volver a convertirlo)

    mov rcx, [digitSpacePosition]   ;volvemos a meter en rcx el valor del puntero por las dudas de que la syscall haya alterado el registro
    dec rcx                         
    mov [digitSpacePosition], rcx   ;actualizamos el puntero con lo que vale ahora rcx: 0002h. En otras palabras nos movemos al byte direccionado anterior (de 0003h a 0002h)

    cmp rcx, digitSpace             ;llegamos al inicio del espacio reservado? (rcx ya contiene la addr del comienzo del espacio reservado, osea, digitSpace?)
    jge _printRAXLoop2              ;si no son iguales, volvemos al loop2 y seguimos imprimiendo de forma inversa

    ret