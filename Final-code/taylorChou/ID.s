.data
    msg1: .asciz "*****INPUT ID*****\n"
    msg2: .asciz "** Please Enter Member1 ID:**\n"
    msg3: .asciz "** Please Enter Member2 ID:**\n"
    msg4: .asciz "** Please Enter Member3 ID:**\n"
    .globl id1,id2, id3
    id1: .word 0
    id2: .word 0
    id3: .word 0
	.globl sumNum
    sumNum: .word 0

    cmdMsg: .asciz "** Please Enter Command **\n"
    printMsg: .asciz "*****Print Team Member ID and ID summation*****\n"
    idSumMsg: .asciz "\nID summation = %d\n"
    endMsg: .asciz "*****END PRINT*****\n"
    inputcmd: .word 0
    
    chfmt: .string "%s"
    intfmt: .string "%d"
    printIdFmt: .string "%d\n"
    num: .word 0
.text
    .globl ID
    
ID:
    stmfd sp!, {lr}
    
    ldr r0, =msg1
    bl printf
    
    ldr r0, =msg2  @ ask 1st id
    bl printf
    ldr r0, =intfmt
    ldr r1, =id1
    bl scanf

    ldr r0, =msg3   @ ask 2nd id
    bl printf
    ldr r0, =intfmt
    ldr r1, =id2
    bl scanf

    ldr r0, =msg4   @ get 3rd id
    bl printf
    ldr r0, =intfmt
    ldr r1, =id3
    bl scanf   

    @ load 3 ids to register
    ldr r0, =id1
    ldr r0,[r0]
    ldr r1, =id2
    ldr r1,[r1]
    ldr r2, =id3
    ldr r2, [r2]

    @ sum
    adds r0,r0,r1 
    mov r0, r0,lsl #1  @ r0= r0*2
	addvc r0,r2,r0, lsr #1   @ r0=r2+r0/2
    ldr r1, =sumNum 
    str r0, [r1]  @ store to mem
   
askCmd: 
    @ ask for cmd
    ldr r0,=cmdMsg
    bl printf
    
    @scan cmd
    ldr r0, =chfmt
    ldr r1, =inputcmd
    bl scanf
    
    @ load cmd
    ldr r1, =inputcmd
    ldr r1,[r1]
    
    @ check if cmd is p
    cmp r1, #112
    bne askCmd    @ if not equal p, run again
    
printSum:
    @ print printMsg
    ldr r0, =printMsg
    bl printf
    
    @ print each id
    ldr r0, =printIdFmt
    ldr r1, =id1
    ldr r1, [r1]
    bl printf
    
   ldr r0, =printIdFmt
    ldr r1, =id2
    ldr r1, [r1]
    bl printf
    
    ldr r0, =printIdFmt
    ldr r1, =id3
    ldr r1, [r1]
    bl printf
    
    @ print sum
    ldr r0, =idSumMsg
    ldr r1, =sumNum
    ldr r1,[r1]
    bl printf  
    
    ldr r0, =endMsg
    bl printf
    
    ldmfd sp!, {lr}  
    mov pc, lr      
    
