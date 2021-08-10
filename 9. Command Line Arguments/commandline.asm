;al ejecutar un programa desde la linea de comandos, podemos parametrizar argumentos en la linea, como sigue:

; $ ./commandline argumento1 argumento2 argumento3 etc

;todos estos argumentos son strings, no enteros, con lo cual si queremos interpretarlos como enteros vamos a tener que convertir los strings a enteros

;los argumentos son cargados automaticamente a la pila del sistema. El tope de la pila termina siendo el NUMERO de argumentos que pasamos, el cual es siempre al menos 1 (por el path)
;los restantes elementos de la pila son punteros a strings terminadas en 0, empezando por el path, y siguiendo por cada argumento individual

;   |   argc       |    ---> entero         Numero de parametros    Ej: n
;   |  *path       |    ---> ./commandline  Primer parametro        Ej: "./commandline"
;   |  *arg[1]     |    ---> argumento1     Segundo parametro       Ej: "argumento1"
;   |  *arg[2]     |    ---> argumento2     Tercer parametro        Ej: "argumento2"
;   |   ...        |            ...                ...                      ...
;   |  *arg[n]     |    ---> argumento n    N-esimo parametro       Ej: "argumento n"
;   ----------------
;   Pila del sistema

;En teoría arg[1] es el primer argumento que puede parametrizar el usuario, sin embargo como está notado, es el segundo parametro en la pila y está en la posición tercera contando desde argc
;Pero como el sistema operativo provee el *path automaticamente, entonces éste no formará parte de los argumentos metidos en la pila con lo cual *arg[1] termina siendo el primer argumento definido por el usuario que se encuentra en la pila, luego del argc (o sea que se encuentra en la segunda posicion de la pila y ya no en la tercera)
;por esta razón argc es 1 incluso si no pasamos argumentos, porque el sistema operativo provee el *path implicitamente


;Ejemplo: muestra por consola el argc

%include "linux64.inc"

section .data
    newline db 10,0

section .text
    global _start

_start:
    pop rax         ;metemos en rax el elemento del tope de la pila --> el argc
    printVal rax    ;macro de linux64.inc
    print newline   ;macro de linux64.inc (recordar que no calcula la length del string de la forma preferida)
    exit


