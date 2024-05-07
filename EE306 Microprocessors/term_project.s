// Dice machine for the De1SoC, switches are mapped to the dice_sides_array directive.
// By: Bogdan Itsam Dorantes-Nikolaev, Onur Keles, Omer Mert Yildiz

.global _start
_start:
    LDR R0, =0xFF200050         // Base address for push button
    LDR R1, =0xFF200040         // Base address for switches
    LDR R2, =0xFF200020         // Base address for HEX displays
    LDR R3, =0xFFFEC600         // Base address for private timer
    LDR R6, =dice_sides_array   // Base address of sides array
    LDR R5, =2000000			//
    
	BL display_start
	
	STR R5, [R3]                // Store the timer's value to the timer
    MOV R7, #0x0003
    STR R7, [R3, #8]            // Activate auto reload and enable

	

loop:
    LDR R5, [R0, #0xC]          // Read push button state
    CMP R5, #0
    BEQ loop
    B button_pressed

button_pressed:
    // Acknowledge that button is pressed
    STR R5, [R0, #0xC]

    LDR R4, [R1]                // Read switch state
    CMP R4, #0                  // Check if no switch is activated
    BEQ display_SL              // If no switch, display SL
    MOV R9, R4                  // Copy switch state to R9 for counting
    BL count_bits               // Count the number of bits set in R4
    CMP R8, #1                  // Check if more than one switch is activated
    BGT display_error           // Display error if more than one switch is toggled

    // Now we know exactly one switch is pressed, we continue
    BL which_switch
	BL random_number              // Get the random number and save it to R4
    BL delay_result
	B display_result

display_start:
	LDR R5, =0x50DEEE			        // Load "rdY" patterm for HEX displays
	STR R5, [R2]				          // Displaying "rdY" pattern
	BX LR

display_error:
    LDR R5, =0x7950             // Load "Er" pattern for HEX displays
    STR R5, [R2]			        	// Displaying "ER" pattern
    B loop

display_SL:
    LDR R5, =0x6D38             // Load "SL" pattern for HEX displays
    STR R5, [R2]				        // Displaying "SL" pattern
    B loop

display_result:
    LDR R11, =seven_seg_table   // Base address of 7-segment lookup table

    // Check if the number is a single digit or two digits
    CMP R10, #10
    BGE display_two_digits	  	// Seperate function to display more than one digit

    // Single Digit Display
    LDR R5, [R11, R10, LSL #2]  // Load corresponding 7-segment code
    STR R5, [R2]                // Store to HEX0
    MOV R5, #0                  // Clear HEX1
    STR R5, [R2, #4]            // Clear HEX1
    B loop

display_two_digits:
	//second digit display
	PUSH {R2, R6, R7}
	MOV R5, #1
	loopDigits: SUB R10, R10, #10		
	CMP R10, #10
	ADDGE R5 ,R5, #1			      // If the random number is 20, 30 etc. R5++
	BGE loopDigits
	
	LDR R7, [R11, R10, LSL #2]	// Load corresponding 7-segment code
	
	MOV R12, R5					//this is the second digit
	LDR R6, [R11, R12, LSL #2]	// Load corresponding 7-segment code
	LSL R6, R6, #8			      	//
	
	ORR R6, R7, R6			      	//
	STR R6, [R2]			        	//
	
	//AND R12, R10, #0x9 //0b1001 DEBUGGING PURPOSES ONLY!
	POP {R2, R6, R7}		      	//
	B loop

delay_result:
	LDR R5, =0x080808		      	// Load the display-loading pattern
	STR R5, [R2]				        // Display loading pattern on HEX Displays
	
	LDR R5, =0x00300000		    	// delay counter
	wait_loop: SUBS R5, R5, #1	//
	BNE wait_loop				        //
	BX LR
	


count_bits:				        		// Brian Kernighan's Algorithm to count bits
    MOV R8, #0				      	// R8 will store the count of bits
	
count_loop:
    CMP R9, #0
    BEQ end_count
    MOV R10, R9
    AND R10, R10, #1
    ADD R8, R8, R10
    LSR R9, R9, #1
    B count_loop
	
end_count:
    BX LR

which_switch:
    CMP R4, #0x1
    MOVEQ R4, #1
    CMP R4, #0x2
    MOVEQ R4, #2
    CMP R4, #0x4
    MOVEQ R4, #3
    CMP R4, #0x8
    MOVEQ R4, #4
    CMP R4, #0x10
    MOVEQ R4, #5
    CMP R4, #0x20
    MOVEQ R4, #6
    CMP R4, #0x40
    MOVEQ R4, #7
    CMP R4, #0x80
    MOVEQ R4, #8
    CMP R4, #0x100
    MOVEQ R4, #9
    CMP R4, #0x200
    MOVEQ R4, #10
    CMP R4, #0x400
    MOVEQ R4, #11
    BX LR

random_number:
    // Simple LFSR random number generator
    LDR R8, [R3, #4]            // Get current value from the timer
    LDR R9, [R6, R4, LSL #2]    // Aligned it to have the number for sides
    AND R10, R8, R9             // Module Operation (?)
    ADD R10, R10, #1            // To exclude 0
    BX LR                       // Return to the calling function


seven_seg_table:				        // 7-Segment HEX Display "Translation" Table
    .word 0x3F                  // 0
    .word 0x06                  // 1
    .word 0x5B                  // 2
    .word 0x4F                  // 3
    .word 0x66                  // 4
    .word 0x6D                  // 5
    .word 0x7D                  // 6
    .word 0x07                  // 7
    .word 0x7F                  // 8
    .word 0x6F                  // 9
    .word 0x79                  // E
    .word 0x50                  // r
    .word 0x6D                  // S
    .word 0x38                  // L
	
dice_sides_array:               // "Array" storing the dice values mapped to the toggle switches
    .word 0                     // Dummy value
    .word 1                     // 2-sided (coin)
    .word 3                     // 4-sided
    .word 5                     // 6-sided
    .word 7                     // 8-sided
    .word 9                     // 10-sided
    .word 11                    // 12-sided
    .word 19                    // 20-sided
    .word 31                    // 32-sided
    .word 63                    // 64-sided
    .word 98                    // 99-sided
