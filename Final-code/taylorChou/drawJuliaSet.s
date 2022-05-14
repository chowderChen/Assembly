	.data
    
d: 		.asciz "%d\n"
tryText: .asciz "This thing prints\n"
px: .asciz "x: %d\n"
py: .asciz "y: %d\n"
pheight: .asciz "height: %d\n"
pwidth: .asciz "width: %d\n"
pzx: .asciz "zx: %d\n"
pzy: .asciz "zy: %d\n"
pi: .asciz "i: %d\n"	

	.text
	.global drawJuliaSet
    
drawJuliaSet:
	stmfd	sp!, {r4-r6, fp, lr}
    
	@int cX, int cY, int width, int height, int16_t (*frame)[FRAME_WIDTH] 
	@ r0: cX       r1: cY      r2: width     r3:height   
	@ sp: stored on stack
	
	
	@[sp,#0]: cX, [sp,#4]:cY,[sp,#8]:width, [sp,#12]:height
	@[sp,#16]:maxIterxy, [sp,#20]:zx, [sp,#24]:zy, [sp,#28]:tmp, 
	@[sp,#32]:i, [sp,#36]:x, [sp,#40]:y, [sp,#44],color(hword)
	@ total: 46
	
	add fp,sp,#20
    sub sp, sp, #52        		@ allocate 
	str r0, [sp, #0]			@ store cX at sp, #0 (4byte)
	str r1, [sp, #4]			@ store cY at sp, #4 (4byte)
	str r2, [sp, #8]			@ store width at sp, #8 (4byte)
	str r3, [sp, #12]			@ store height at sp, #12 (4byte)
    @mov r4, fp                @ store address of "frame" in fp
    
    mov r0, #255				@ maxIter
	str r0, [sp, #16]			@ store maxIter at sp, #16 (4byte)
	mov r0, #0					@ zx
	str r0, [sp, #20]			@ store zx at sp, #20 (4byte)
	mov r0, #0					@ zy
	str r0, [sp, #24]			@ store zy at sp, #24 (4byte)
	mov r0, #0					@ tmp
	str r0, [sp, #28]			@ store tmp at sp, #28 (4byte)
	mov r0, #0					@ i
	str r0, [sp, #32]			@ store i at sp, #32 (4byte)
	mov r0, #0					@ x
	str r0, [sp, #36]			@ store x at sp, #36 (4byte)
	mov r0, #0					@ y
	str r0, [sp, #40]			@ store y at sp, #40 (4byte)
	mov r0, #0					@ color
	strb r0, [sp, #44]			@ store color at sp, #44 (2byte)
    
forWidth:
    ldr r0, [sp, #36]            @ x
    ldr r1, [sp, #8]              @ width
    cmp r0, r1                     @ if ge -> out loop; if less than -> do nothing 
    bge endForWidth
	mov r0, #0
	str r0, [sp, #40]					@2for ( y=0)
    
forHeight:
    ldr r0, [sp, #40]            @ y
    ldr r1, [sp, #12]            @ height
    cmp r0, r1
    bge endForHeight
    
    ldr r3, [sp, #8]			    @ r3 = width
	mov r5, r3, asr#1			@ r5 = width >> 1
    ldr r2, [sp, #36]			@ r2 = x
    sub r0, r2, r5				    @ r0 = x - width >> 1
    ldr r1, =1500                @ r1 = 1500
    mul r0, r0, r1				@ r0 = 1500*(x - width >> 1)
    mov r1, r5                     @ r1 = r5 = width >> 1
	bl __aeabi_idiv			    @ r0 = r0 / r1 = 1500 * (x - (width >> 1))/(width>>1)
    str r0, [sp, #20]			@ store in zx
    
    ldr r3, [sp, #12]			@ height
	mov r5, r3, asr#1			@ r5 = height >> 1
    ldr r2, [sp, #40]			@ y
    sub r0, r2, r5				    @ r0 = y - height >> 1
    ldr r1, =1000                @ r1 = 1000
    mul r0, r0, r1
    mov r1, r5
    bl __aeabi_idiv 
    str r0, [sp, #24]
    
    @ i = maxIter
    ldr r0, [sp, #16]           @ r0 = maxIter
    str r0, [sp, #32]           @ i = maxIter
    
whileLoop:
    ldr r0,[sp,#20]  @zx
    ldr r1,[sp,#24]  @zy
    mul r5,r0,r0  @zx*zx
    mul r6,r1,r1  @zy*zy
    adds r3,r5,r6  @zx * zx + zy * zy
    
    ldr r4, =4000000
    cmp r3,r4   @ if zx * zx + zy * zy < 4000000, continue
    bge endWhileLoop @ else endwhile
    ldr r2,[sp,#32]  @ get i
    cmp r2,#0      @ if i>0,contine
    bls endWhileLoop @ else endwhile
    
    @int tmp = (zx * zx - zy * zy)/1000 + cX;
    sub r0,r5,r6  @r5:zx^2, r6:zy^2
    ldr r1,=1000  
    bl __aeabi_idiv   @ (zx * zx - zy * zy)/1000 
    ldr r1,[sp,#0]  @ get cX
    adds r0,r0,r1  @ that thing+cX
    str r0,[sp,#28]  @ store result in tmp
 
    @zy = (2 * zx * zy)/1000 + cY;
    ldr r0,[sp,#20]  @ get zx from stack
    ldr r1,[sp,#24]  @ get zy from stack
    mov r3, #2
    mul r0,r0,r3
    mul r0,r0,r1   @ (2 * zx * zy)
    ldr r1,=1000
    bl __aeabi_idiv   @ divide by 1000
    ldr r1,[sp,#4]  @ get cY
    adds r0,r0,r1  @ that thing + cY
    str r0,[sp,#24]  @ store result in zy
 
 
	@mov r1,r0
	@ldr r0,=d
	@bl printf
	
    @ zx = tmp;
    ldr r0,[sp,#28]
    str r0,[sp,#20]
    
    @ i--;
    ldr r0,[sp,#32]
    sub r0,r0,#1
    str r0,[sp,#32]

    b whileLoop
endWhileLoop:
    
    @ color = ((i&0xff)<<8) | (i&0xff);
    ldr r0, [sp, #32]			@ i
	and r0, r0, #0xff			@ r0 = i&0xff
	mov r1, r0, asl#8			@ r1 = (i&0xff)<<8
	orr r0, r0, r1				@ ((i&0xff)<<8) | (i&0xff)
    strh r0, [sp, #44]          @ color is int_16 == halfword, store color on stack
    
    @ color = (~color)&0xffff;
    mvn r0, r0                     @ ~color 
    ldr r1, =0xffff
    and r0, r0, r1                 @ (~color)&0xffff
    strh r0, [sp, #44]          @ color = (~color)&0xffff
    
	@mov r1,r0
	@ldr r0,=d
	@bl printf
	
    @ frame[y][x] = color;
    @ calculate how many bytes to shift in "frame"
    ldr r0, [sp, #40]       	@ r0 = y
    ldr r2, =1280             	@ frameWidth(640) * int_16(2 bytes) = 1280
    mul r0, r0, r2           	@ y * 1280 bytes
    ldr r1, [sp, #36]           @ r1 = x
    mov r1, r1, asl#1         	@ x * 16 bits(int_16) == x * 2 bytes
    add r0, r0, r1              @ r0 = total shift
    
	
    ldr r3, [fp]            @ r1 = fp = starting address of "frame"
	add r0,r0,r3  			@ target =total shift + stack shift
	ldrh r1, [sp, #44]    	@ r1 = color
    strh r1, [r0]      		@ store color in starting address of frame + total shift
    
	
	
	@ y++
    ldr r0,[sp,#40]  @get y from stack
    add r0,r0,#1
    str r0,[sp,#40]
 
    b forHeight
	
endForHeight:

    @ x++
    ldr r0,[sp,#36]  @get x from stack
    add r0,r0,#1
    str r0,[sp,#36]
    
    b forWidth
endForWidth:
    add sp, sp, #52     @ release local variable 
    ldmfd sp!, { r4-r6, fp, lr }
    mov pc, lr
	
	