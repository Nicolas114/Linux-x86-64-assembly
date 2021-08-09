;podemos programar varios archivos .asm e incluirlos con %include "filename.asm"
;muchas macros y/o definiciones de constantes EQU son definidas adentro de archivos que se incluyen
;cuando hacemos "include", se inserta el codigo del archivo externo en la posición del include durante la compilacion

%include linux64.inc

section .data
    text db "Hello World", 10, 0
    length equ $ - text

section .text
    global _start

_start:
    print text      ;llamamos a la macro definida en linux64.inc
    exit            ;idem

;nota: el macro 'print' hace uso de un loop para imprimir strings y calcular su longitud
;es mas recomendable definir una constante 'length' cuyo valor sea la resta entre la dirección actual de ensamblado y el tamaño en bytes del string que queremos determinar su longitud