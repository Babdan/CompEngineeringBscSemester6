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
