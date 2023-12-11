@ Setup C Runtime Environment
@ Where this code belongs in the compiled binary, ref would be _start
.section ".text.boot"

.global _start

@ Tells 3 out of 4 cores to halt
_start:
#ifndef MODEL_1
    mrc p15, #0, r1, c0, c0, #5
    and r1, r1, #3
    cmp r1, #0
    bne halt
#endif

    @ C stack should start at 0x8000
    mov sp, #0x8000

    @ Loads addresses of the start end end of the BSS section into registers
    @ BSS is where C global variables are not initialized at compile time are stored
    ldr r4, =__bss_start
    ldr r9, =__bss_end

@ This is when we start to 0 out the BSS section, First loads 0 into four consecutive registers (r5, r6, r7, r8) then checks if the address stored in r4 is less than the one in r9
    mov r5, #0
    mov r6, #0
    mov r7, #0
    mov r8, #0
    b       2f

@ If r4 < r9, stm instruction stores second operand into address contained in the first.
@ -ia means increment after (post r4 to the end of r5-r8).
@ ! store that address back in r4, instead of throwing it out.
1:
    stmia r4!, {r5-r8}

2:
    cmp r4, r9
    blo 1b
@ Loads address of C function called kernel_main into a register and jumps to that location. When C returns, it enters the halt procedure where it loops forever
    ldr r3, =kernel_main
    blx r3

halt:
    wfe
    b halt
