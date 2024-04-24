//LAB5 BY: BOGDAN ITSAM DORANTES-NIKOLAEV, ONUR KELES, OMER MERT YILDIZ
//----------------+++++<PART ONE>+++++----------------

//-------------------------VARIANT "A"
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

//-------------------------VARIANT "B"
.text
.global _start

.equ LED_BASE, 0xFF200000  @ Define the base address for the LED

_start:
    LDR R0, =LED_BASE      @ Load the base address of the LED

    @ Main loop starts here
loop:
    MOV R1, #1             @ Prepare to turn on the LED
    STR R1, [R0]           @ Turn on the LED

    @ Delay loop for ON state
    LDR R7, =0250000       @ Set delay counter for approximately 0.25 seconds
sub_loop_on:
    SUBS R7, R7, #1        @ Decrement the counter
    BNE sub_loop_on        @ Continue looping until the counter hits 0

    MOV R1, #0             @ Prepare to turn off the LED
    STR R1, [R0]           @ Turn off the LED

    @ Delay loop for OFF state
    LDR R7, =0250000       @ Set delay counter for approximately 0.25 seconds
sub_loop_off:
    SUBS R7, R7, #1        @ Decrement the counter
    BNE sub_loop_off       @ Continue looping until the counter hits 0

    B loop                 @ Repeat the main loop
    
//----------------+++++<PART TWO>+++++----------------
.text
.global _start

.equ LED_BASE, 0xFF200000  
.equ TIMER_BASE, 0xFFFEC600

_start:
    LDR R0, =LED_BASE            @ Load LED base address
    LDR R2, =TIMER_BASE          @ Load Timer base address

    @ Set the timer for a 0.25 second interval (50,000,000 counts at 200 MHz)
    LDR R3, =50000000            @ Load the correct delay count into R3
    STR R3, [R2]                 @ Store this value in the Load register

    @ Set up the control register: enable timer and auto-reload
    MOV R3, #0b011               @ 0b011 = Enable + Auto-reload
    STR R3, [R2, #8]             @ Store this in the Control register

loop:
    @ Turn on LED
    MOV R1, #1
    STR R1, [R0]

    @ Wait for timer interrupt flag
wait0_25sec:
    LDR R3, [R2, #12]            @ Read the Interrupt status register
    ANDS R3, R3, #1              @ Check the F bit
    BEQ wait0_25sec                 @ If F bit is not set, keep waiting

    @ Reset timer interrupt flag by writing 1 to the F bit
    MOV R3, #1
    STR R3, [R2, #12]

    @ Turn off LED
    MOV R1, #0
    STR R1, [R0]

    @ Wait for timer again (redundant due to auto-reload but good for clarity)
wait0_25sec_off:
    LDR R3, [R2, #12]
    ANDS R3, R3, #1
    BEQ wait0_25sec_off

    MOV R3, #1
    STR R3, [R2, #12]

    @ Loop back
    B loop

//----------------+++++<PART THREE>+++++----------------
.text
.global _start

.equ LED_BASE, 0xFF200000       @ Base address for the LEDs
.equ KEY_BASE, 0xFF200050       @ Base address for the KEYs (Edgecapture register)

_start:
    LDR R0, =LED_BASE            @ Load LED base address
    LDR R1, =KEY_BASE            @ Load KEY base address

    @ Initialize LED state: turn on the rightmost LED
    MOV R2, #0x01                @ Rightmost LED pattern
    STR R2, [R0]

loop:
    @ Poll the Edgecapture register to detect button press
    LDR R3, [R1]
    ANDS R3, R3, #0x01           @ Check if KEY0 (the first bit) is pressed
    BEQ loop                     @ If not pressed, continue polling

    @ Clear the Edgecapture register by writing 0b1111
    MOV R4, #0x0F
    STR R4, [R1]

    @ Shift the LED pattern to the left
    LSL R2, R2, #1               @ Shift left operation on LED pattern
    CMP R2, #0x00                @ Compare if the pattern is 0 (all LEDs are off)
    MOVEQ R2, #0x01              @ If pattern is 0, reset to rightmost LED
    STR R2, [R0]                 @ Update LEDs

    @ Debounce delay (simple delay loop for demonstration)
    LDR R5, =300000
debounce:
    SUBS R5, R5, #1              @ Decrement delay counter
    BNE debounce                 @ Continue delay loop until counter is 0

    @ Return to polling loop
    B loop
