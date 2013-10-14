/*
 Arguments

 First 4 nteger arguments are passed in R0-R4, rest on stack [sp 0] [sp 4].
 shorts/chars are passed zero/sign extended.
 Doubles/longs are passed in aligned locations [R0,R1] [R2,R3] rest on stack.

 Return Values
 32 bit scalars in R0.
 64 bit scalars in R0,R1.

 Return address is in the link register LR/R14 (bx LR).

 R4, R5, R6, R7, R8, R9, R10, and R11 must be saved by the function if used.

 Thumb instruction set http://infocenter.arm.com/help/topic/com.arm.doc.qrc0001m/QRC0001_UAL.pdf
 Procedure call http://infocenter.arm.com/help/topic/com.arm.doc.ihi0042e/IHI0042E_aapcs.pdf
 abi http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.subset.swdev.abi/index.html
*/
        .text
        .global Delay
Delay:
        CMP r0, #0
        BEQ exit
        SUB r0, r0, #1
        B   Delay
exit:
        bx  lr
        .type Delay, function
        .size Delay, .-Delay
