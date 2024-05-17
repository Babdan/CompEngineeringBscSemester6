//LAB7 BY: BOGDAN ITSAM DORANTES-NIKOLAEV, ONUR KELES, OMER MERT YILDIZ
//----------------+++++<PART ONE>+++++----------------
// Print a one digit number on the seven segment displays (HEX0-3).

.data
HEXTABLE:
    .word 0b00111111  @ 0
    .word 0b00000110  @ 1
    .word 0b01011011  @ 2
    .word 0b01001111  @ 3
    .word 0b01100110  @ 4
    .word 0b01101101  @ 5
    .word 0b01111101  @ 6
    .word 0b00000111  @ 7
    .word 0b01111111  @ 8
    .word 0b01101111  @ 9
    
    .text
    .global _start
    
_start:
    LDR R1, =HEXTABLE       @ Load address of HEXTABLE into R1
    LDR R2, =0xFF200020     @ Load address of seven-segment display base into R2
    LDR R3, =0xFF200040     @ Load address of switches into R3
    LDR R4, =0x3FF          @ Load the constant 0x3FF into R4
    MOV R0, #0              @ Initialize counter to 0

main_loop:
    LSL R5, R0, #2          @ Shift R0 left by 2 to get the index for HEXTABLE
    LDR R5, [R1, R5]        @ Load the corresponding 7-segment code into R5
    STR R5, [R2]            @ Display the 7-segment code on the seven-segment display

    BL delay                @ Call delay function

    ADD R0, R0, #1          @ Increment counter
    CMP R0, #10             @ Compare counter with 10
    MOVGE R0, #0            @ If counter >= 10, reset counter to 0

    B main_loop             @ Repeat the process

delay:
    LDR R7, =002000000      @ Load delay counter ++DURATION++

delay_loop:
    SUBS R7, R7, #1         @ Decrement delay counter
    BNE delay_loop          @ If delay counter is not zero, repeat delay loop

    BX LR                   @ Return from delay function
	
//----------------+++++<PART TWO>+++++----------------
// Print a four digit number on the seven segment displays (HEX0-3).

.data
HEXTABLE:
    .word 0b00111111  @ 0
    .word 0b00000110  @ 1
    .word 0b01011011  @ 2
    .word 0b01001111  @ 3
    .word 0b01100110  @ 4
    .word 0b01101101  @ 5
    .word 0b01111101  @ 6
    .word 0b00000111  @ 7
    .word 0b01111111  @ 8
    .word 0b01101111  @ 9
TESTWORD:
    .word 0x0000      @ Test word to be displayed

.text
.global _start

_start:
    LDR R1, =HEXTABLE       @ Load address of HEXTABLE into R1
    LDR R2, =0xFF200020     @ Load address of seven-segment display register into R2
    LDR R10, =TESTWORD      @ Load address of TESTWORD
    LDR R10, [R10]          @ Load the actual number from TESTWORD

    @ Extract digits
    MOV R5, R10, LSR #12    @ Get thousands digit
    AND R5, R5, #0x000F     @ Mask out the lower 4 bits
    MOV R4, R10, LSR #8     @ Get hundreds digit
    AND R4, R4, #0x000F     @ Mask out the lower 4 bits
    MOV R3, R10, LSR #4     @ Get tens digit
    AND R3, R3, #0x000F     @ Mask out the lower 4 bits
    AND R0, R10, #0x000F    @ Get units digit

    @ Display the digits
    LSL R6, R5, #2
    LDR R6, [R1, R6]
    LSL R7, R4, #2
    LDR R7, [R1, R7]
    LSL R8, R3, #2
    LDR R8, [R1, R8]
    LSL R9, R0, #2
    LDR R9, [R1, R9]

    @ Combine digits into one register
    ORR R12, R9, R8, LSL #8
    ORR R12, R12, R7, LSL #16
    ORR R12, R12, R6, LSL #24

    STR R12, [R2]           @ Output the result to the 7-segment display register

    B end_loop              @ Jump directly to end loop

end_loop:
    B end_loop              @ Stay here indefinitely
	
//----------------+++++<PART THREE>+++++----------------
// 0-5999 Counter on HEX0-3 (using timer), format SS:DD, where SS are seconds and DD are hundredths of a second.

.data
.align 4                @ Ensure the data section is aligned to 4 bytes
HEXTABLE:
    .word 0b00111111    @ 0
    .word 0b00000110    @ 1
    .word 0b01011011    @ 2
    .word 0b01001111    @ 3
    .word 0b01100110    @ 4
    .word 0b01101101    @ 5
    .word 0b01111101    @ 6
    .word 0b00000111    @ 7
    .word 0b01111111    @ 8
    .word 0b01101111    @ 9

COUNT: .word 0

.text
.global _start

_start:
    LDR R1, =HEXTABLE       @ Load address of HEXTABLE into R1
    LDR R2, =0xFF200020     @ Load address of seven-segment display register into R2
    MOV R0, #0              @ Initialize counter for HEX0
    MOV R3, #0              @ Initialize counter for HEX1
    MOV R4, #0              @ Initialize counter for HEX2
    MOV R5, #0              @ Initialize counter for HEX3

    LDR R11, =COUNT
    
    @ Initialize A9 Private Timer
    LDR R6, =0xFFFEC600     @ Load base address of A9 Private Timer
    LDR R7, =2000000        @ Load value for 0.01 second delay (200 MHz * 0.01 sec)
    STR R7, [R6]            @ Write value into Load register
    MOV R7, #3              @ Set enable bit (E) to 1 
    STR R7, [R6, #8]        @ Write back to Control register

main_loop:
    @ Poll for interrupt status
    LDR R7, [R6, #0xC]      @ Read Interrupt status register
    ANDS R7, #1             @ Test if F bit is set
	BEQ main_loop
    BNE counter_increase      @ If not set, skip incrementing COUNT
	
counter_increase:
    @ Increment COUNT
    LDR R8, [R11]
    LDR R12, =5999 
    CMP R8, R12             @ Check if COUNT is 5999
    BEQ IDLE
	ADD R8, R8, #1          @ Increment COUNT
    STR R8, [R11]           @ Store back COUNT

    @ Reset interrupt status bit (F)
    
	//B main_loop

skip_increment: 
    @ Preserve R6 and R8
    PUSH {R6, R8}

    @ Update each digit and manage rollover
    ADD R0, R0, #1          @ Increment HEX0
    CMP R0, #10             @ Check if HEX0 needs to rollover
    MOVGE R0, #0            @ Reset HEX0
    ADDGE R3, R3, #1        @ Increment HEX1 on rollover of HEX0
    CMP R3, #10             @ Check if HEX1 needs to rollover
    MOVGE R3, #0            @ Reset HEX1
    ADDGE R4, R4, #1        @ Increment HEX2 on rollover of HEX1
    CMP R4, #10             @ Check if HEX2 needs to rollover
    MOVGE R4, #0            @ Reset HEX2
    ADDGE R5, R5, #1        @ Increment HEX3 on rollover of HEX2
    CMP R5, #10             @ Check if HEX3 needs to rollover
    MOVGE R5, #0            @ Reset HEX3

    @ Display the digits
    LSL R6, R0, #2
    LDR R6, [R1, R6]
    LSL R7, R3, #2
    LDR R7, [R1, R7]
    LSL R8, R4, #2
    LDR R8, [R1, R8]
    LSL R9, R5, #2
    LDR R9, [R1, R9]

    @ Combine digits into one register
    ORR R12, R6, R7, LSL #8
    ORR R12, R12, R8, LSL #16
    ORR R12, R12, R9, LSL #24

    STR R12, [R2]           @ Output the result to the 7-segment display register

    @ Restore R6 and R8
    POP {R6, R8}
	
	MOV R7, #1
    STR R7, [R6, #0xC]      @ Write 1 to F bit to reset
	
    B main_loop             @ Continue looping



IDLE: B IDLE
