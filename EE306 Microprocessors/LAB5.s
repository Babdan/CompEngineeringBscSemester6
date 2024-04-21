//LAB5 BY: BOGDAN ITSAM DORANTES-NIKOLAEV, ONUR KELES, OMER MERT YILDIZ
//PART ONE

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
    
read_switches:
    LDR R0, [R3]            @ Read switches into R0
    AND R0, R0, R4          @ Keep only the 10 least significant bits (switches SW9-SW0)
    CMP R0, #10             @ Compare R0 with 10
    MOVGE R0, #9            @ If R0 >= 10, set R0 to 9
    
convert_to_7_segment:
    LSL R0, R0, #2          @ Shift R0 left by 2 to get the index for HEXTABLE
    LDR R0, [R1, R0]        @ Load the corresponding 7-segment code into R0
    
display_on_7_segment:
    STR R0, [R2]            @ Display the 7-segment code on the seven-segment display
    
    B read_switches         @ Repeat the process
	
//PART TWO
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

//PART THREE
Part III ou will be given a number between 1000 and 9999. Save this number to a memory location called
TESTWORD using .word directive. Write an assembly program that reads that number from the memory
location and displays it on 4-digit 7-segment display. You can use the division subroutin (de1soc)

//PART FOUR
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
    LDR R2, =0xFF200020     @ Load address of seven-segment display register into R2
    MOV R0, #0              @ Initialize counter for HEX0
    MOV R3, #0              @ Initialize counter for HEX1
    MOV R4, #0              @ Initialize counter for HEX2
    MOV R5, #0              @ Initialize counter for HEX3

main_loop:
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

    BL delay                @ Call delay function
    @ Check if the maximum number is reached
    CMP R5, #5              @ Changed this from 9 to 5 for pt.4
    CMPEQ R4, #9
    CMPEQ R3, #9
    CMPEQ R0, #9
    BEQ end_loop            @ End loop if 9999 is reached
    B main_loop             @ Continue looping

delay:
    LDR R10, =002000        @ Load a practical delay counter (clock)
delay_loop:
    SUBS R10, R10, #1       @ Decrement delay counter
    BNE delay_loop          @ If delay counter is not zero, repeat delay loop
    BX LR                   @ Return from delay function

end_loop:
    B end_loop              @ Stay here indefinitely
