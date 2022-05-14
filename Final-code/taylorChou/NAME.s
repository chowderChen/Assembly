
    .data
    .global team, name1, name2, name3
team:   .word 0
teamMsg: .asciz "Team %d\n"
name1:  .asciz "Peter Chen\n"
name2:  .asciz "Chowder Chen\n"
name3:  .asciz "Taylor Chou\n"
str1:   .asciz "*****Print Name*****\n"
str2:   .asciz "*****End Print******\n"
    .text

    .globl NAME

NAME:
    stmfd sp!,{lr}
    ldr r0, =str1
    bl printf    @  "*****Print Name*****\n"
    mov r1, #40
    mov r2, #0
    mov r4, r13
    adcs r13, r1, r2   @ 7th line
    sublo r13,r13,#1
    ldr r1, =team
    str r13,[r1]
    movpl r13, r4   @ restore sp

    ldr r0, =teamMsg
    ldr r1, =team
    ldr r1,[r1]
    bl printf
    ldr r0, =name1
    bl printf
    ldr r0, =name2
    bl printf
    ldr r0, =name3
    bl printf
    ldr r0, =str2
    bl printf
    ldmfd sp!,{lr}
    mov pc,lr



