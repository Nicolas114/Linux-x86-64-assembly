;sys_write y sys_read se usan para mostrar y leer informacion de la salida y entrada estándar. También se pueden usar para escribir o leer informacion en un archivo siempre y cuando tengamos el 'file descriptor' de un archivo dado.

;Cómo escribir o leer informacion de un archivo

;1. Hay que abrir el archivo con sys_open
;sys_open --> ID: 2, tres argumentos
;Argumento 1: puntero al nombre del archivo (0-terminated string).
;Argumento 2: flags: cómo queremos abrir el archivo.
;Argumento 3: filemode: un numero de 4 digitos octales. Los 3 digitos menos significativos son para los permisos del Owner, del Grupo y Otros (de izq a derecha). El más significativo es para indicar permisos especiales, que usualmente no usaremos.

;flags: podemos combinar flags sumandolas juntas. Por ejemplo, si queremos usar las flags O_WRONLY y O_CREAT (para crear el archivo en caso de que no exista), debemos sumarlos: O_CREAT+O_WRONLY
;ejemplo:

;mov rax, SYS_OPEN          ;ID de la call (2)
;mov rdi, filename          ;puntero al nombre del archivo
;mov rsi, O_CREAT+O_WRONLY  ;las flags de create(64) y write(1) según tabla
;mov rdx, 0644o             ;permisos de archivos. En este caso es que el Owner pueda leer y escribir, y el resto sólo leer
;syscall

;IMPORTANTE
;sys_open retorna el descriptor de archivo del archivo abierto dentro del rax.
;de haber un error, el mismo se almacena en el rax (con lo cual siempre antes de proseguir habría que chequear si rax no contiene código de error alguno).


;2. Ya podemos escribir en el archivo
;sys_write --> ID: 1, tres argumentos
;Se utiliza exactamente igual que cuando lo usabamos para escribir en la consola, solo que ahora, el primer argumento cambia al descriptor de archivo retornado por sys_open (asumiendo que no hubo error).
;Ejemplo de escribir en un archivo que acabamos de abrir:

;mov rdi, rax               ;metemos en rdi el file descriptor que está en rax antes de meter el ID de la llamada al sistema en rax
;mov rax, SYS_WRITE         
;mov rsi, text              ;puntero al string
;mov rdx, 17                ;length del string
;syscall

;3. Cerrar el archivo.
;sys_close --> ID: 3, un argumento
;Argumento 1: file descriptor
;Ejemplo de cerrar un archivo abierto:

;mov rax, SYS_CLOSE         
;pop rdi                    ;asume que el file descriptor está en el tope de la pila (para esto habría que pushear el y sólo el rax despues del sys_open).
;syscall

;Código para escribir en un archivo:

%include "linux64.inc"

section .data
    filename db "file.txt",0                ;recordar que es 0-terminated string
    text db "Escribiendo a un archivo!!."
    length equ $ - text

section .text
    global _start

_start:
    ;Parte 1: abrir el archivo
    mov rax, SYS_OPEN
    mov rdi, filename
    mov rsi, O_CREAT+O_WRONLY
    mov rdx, 0644o
    syscall
    ;EndParte1

    ;Parte 2: escribir en el archivo
    push rax                                ;metemos el file descriptor en la pila
    mov rdi, rax
    mov rax, SYS_WRITE
    mov rsi, text
    mov rdx, length
    syscall
    ;EndParte2

    ;Parte 3: cerrar el archivo
    mov rax, SYS_CLOSE
    pop rdi                                 ;sacamos el file descriptor del tope de la pila y lo metemos en rdi que es donde se especifica el argumento 1
    syscall
    ;EndParte3

    exit