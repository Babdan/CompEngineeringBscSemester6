//LAB5 BY: BOGDAN ITSAM DORANTES-NIKOLAEV, ONUR KELES, OMER MERT YILDIZ
//----------------+++++<PART ONE>+++++----------------
.text
.global _start

.equ LED_BASE, 0xFF200000

_start:
    LDR R0, =LED_BASE            @ Load the base address of the LED

    MOV R1, #1                   @ Prepare to turn on the LED
    STR R1, [R0]                 @ Turn on the LED

    @ Delay loop
delay_on:
    LDR R7, =002500000           @ Set delay counter (adjust the value for CPUlator)
sub_loop_on:
    SUBS R7, R7, #1              @ Decrement the counter
    BNE sub_loop_on              @ Continue looping until the counter is 0

    MOV R1, #0                   @ Prepare to turn off the LED
    STR R1, [R0]                 @ Turn off the LED

    @ Delay loop
delay_off:
    LDR R7, =002500000           @ Set delay counter (adjust the value for CPUlator)
sub_loop_off:
    SUBS R7, R7, #1              @ Decrement the counter
    BNE sub_loop_off             @ Continue looping until the counter is 0

    B _start                     @ Loop back to the start
	

//----------------+++++<PART TWO>+++++----------------
