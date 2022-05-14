.include "name.s"
.include "id.s"
.data

MFmsg: .asciz "Main Function\n"
printAllmsg: .asciz "*****Print All*****\n"
@teamMsg: .asciz "Team %d\n"
stuidfofmt: .asciz "%d\t"
stuNamefmt: .asciz "%s"
@idSumMsg: .asciz "\nID summation = %d\n"
@endMsg: .asciz "*****END PRINT*****\n"
msgF1: .asciz "Function1: Name\n"
msgF2: .asciz "Function2: ID\n"

    .text

    .globl main

main:
    stmfd sp!,{lr}
    @ call NAME
    ldr r0, =msgF1
    bl printf

    bl NAME

    @ call ID
    ldr r0, =msgF2
    bl printf

    bl ID

    ldr r0, =MFmsg   @  "Main Function"
    bl printf
    ldr r0, =printAllmsg   @ "*****Print All*****"
    bl printf
    ldr r0, =teamMsg   @ print team num "Team %d\n"
    ldr r1, =team
    ldr r1, [r1]
    bl printf

    ldr r0, =stuidfofmt  @ 1st student
    ldr r1, =id1
    ldr r1, [r1]
    bl printf
    ldr r0, =stuNamefmt
    ldr r1, =name1
    bl printf

    ldr r0, =stuidfofmt  @ 2nd student
    ldr r1, =id2
    ldr r1, [r1]
    bl printf
    ldr r0, =stuNamefmt
    ldr r1, =name2
    bl printf

    ldr r0, =stuidfofmt  @ 3rd student
    ldr r1, =id3
    ldr r1, [r1]
    bl printf
    ldr r0, =stuNamefmt
    ldr r1, =name3
    bl printf

    ldr r0, = idSumMsg   @print id summation
    ldr r1, =sumNum
    ldr r1, [r1]
    bl printf

    ldr r0, =endMsg   @ endMsg: .asciz "*****END PRINT*****"
    bl printf
    ldmfd sp!,{lr}
    mov pc,lr


