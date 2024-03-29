//LAB3 BY: BOGDAN DORANTES, ONUR KELES, OMER MERT YILDIZ
//PART 1
.global _start

_start:
    	LDR R0, =ASCII_NUM// pseudo-inst.    // To avoid using unnecessary amount of memory size.
	LDR R3, =PACKED2 // pseudo-inst. // concating two different words and keeping them in one register.
	LDR R1, [R0] // read the first word
	LDR R2, [R0,#4] // read the second word
	// Packing in 3 steps:
	// 1. A mask is applied on R2, so that all bits
	// of R2 except for the last 4 bits becomes 0:
	AND R2,R2, #15  //#15 = 1111
	// 2. Shift the first word towards left,
	// so that its least significant bit (d0)
	// becomes d4.
	MOV R4, R1, LSL #4
	// 3. Combine the masked word (the second)
	// and the shifted word (the first) to make
	// a packed digit.
	ORR R5, R2,R4
	STRB R5, [R3] // write one BYTE packed digit

END: B END
ASCII_NUM: .word 0x00000035, 0x00000034
PACKED2: .word 0x0
.end

//PART 1.5
.global _start

_start:
    LDR R0, =ASCII_NUM// pseudo-inst.    // To avoid using unnecessary amount of memory size.
	LDR R3, =PACKED2 // pseudo-inst. // concating two different words and keeping them in one register.
	LDR R1,[R0], #4 // read the first word
	LDR R2,[R0] // read the second word
	SUB R0, R0, #4 //to reset the index if necessary
	// Packing in 3 steps:
	// 1. A mask is applied on R2, so that all bits
	// of R2 except for the last 4 bits becomes 0:
	AND R2,R2, #15  //#15 = 1111
	// 2. Shift the first word towards left,
	// so that its least significant bit (d0)
	// becomes d4.
	MOV R4, R1, LSL #4
	// 3. Combine the masked word (the second)
	// and the shifted word (the first) to make
	// a packed digit.
	ORR R5, R2,R4					//is it ORR ?
	STRB R5, [R3] // write one BYTE packed digit

END: B END
ASCII_NUM: .word 0x00000035, 0x00000034
PACKED2: .word 0x0
.end

// Part 1.6
.global _start

_start:
    LDR R0, =ASCII_NUM// pseudo-inst.    // To avoid using unnecessary amount of memory size.
	LDR R3, =PACKED2 // pseudo-inst. // concating two different words and keeping them in one register.
	LDR R1, [R0] // read the first word
	LDR R2, [R0,#4] // read the second word
	// Packing in 3 steps:
	// 1. A mask is applied on R2, so that all bits
	// of R2 except for the last 4 bits becomes 0:
	AND R2,R2, #15  //#15 = 1111
	// Perform a bitwise OR operation
	// between the masked word (R2) and
	// the shifted word (R1, left-shifted by 4)
	// to form a packed digit in R4.
	ORR R4, [R2, R1, LSL #4]! //Solution (new version)
	STRB R4, [R3] // write one BYTE packed digit

END: B END
ASCII_NUM: .word 0x00000035, 0x00000034
PACKED2: .word 0x0
.end

//Part 1.7
.global _start

_start:
    LDR R0, =ASCII_NUM// pseudo-inst.    // To avoid using unnecessary amount of memory size.
	LDR R3, =PACKED2 // pseudo-inst. // concating two different words and keeping them in one register.
	LDR R1, [R0] // read the first word
	LDR R2, [R0,#4] // read the second word
	// Packing in 3 steps:
	// 1. A mask is applied on R2, so that all bits
	// of R2 except for the last 4 bits becomes 0:
	AND R2,R2, #15  //#15 = 1111
	// 2. Shift the first word towards left,
	// so that its least significant bit (d0)
	// becomes d4.
	MOV R1, R1, LSL #4
	//If we can clear R0, we can avoid one more register at ADD R4, R2, R1 instead of R4.
	// 3. Combine the masked word (the second)
	// and the shifted word (the first) to make
	// a packed digit.
	ADD R1, R2,R1					//is it ORR ?	
	STRB R1, [R3] // write one BYTE packed digit

END: B END
ASCII_NUM: .word 0x00000035, 0x00000034
PACKED2: .word 0x0
.end


//LAB3 BY: BOGDAN DORANTES, ONUR KELES, OMER MERT YILDIZ
// PART TWO
//LAB3 BY: BOGDAN DORANTES, ONUR KELES, OMER MERT YILDIZ
// PART TWO
.global _start

_start:
    // Load the memory address of 'binary' into register R1
    LDR R1, = binary
    // Load the value stored at the memory address pointed by R1 into R2
    LDR R2, [R1]
    // Initialize register R3 to store the count of ones
    MOV R3, #0

// Loop to count the number of ones in the binary representation of the number
CountOne:
    // Bitwise AND operation to isolate the least significant bit of R2, storing the result in R4
    AND R4, R2, #1
    // Add the result (0 or 1) to the count stored in R3 (amount of 1's)
    ADD R3, R3, R4
    // Shift the binary representation of R2 one bit to the right (remove last digit)
    LSRS R2, R2, #1
    // Compare R2 with 0 to check if all bits have been processed
    CMP R2, #0
    // Branch to CountOne if R2 is not equal to 0
    BNE CountOne

   
    // Checking last digit with 1, if lsb has 0->even parity check if lsb has 1->odd parity check
    AND R5, R3, #1
    // Initializing R7 to 1 (default value)
    MOV R7, #1
	// Initializing R8 result in MSB/LSB
	MOV R8, #0x50
    // Compare R5 with 0 to check if the number of ones is even
    CMP R5, #0
    // Move 0 to R4 if the number of ones is even LSB
    MOVEQ R5, #1
    // Move 7 to R4 if the number of ones is odd MSB
    MOVNE R5, R5, LSL #28
    // Store the value of R7 into memory at the address specified by R8 plus the offset specified by R4
    STR R5, [R8]
END: B END
    // Define the binary number to be processed
    binary: .word 0b111
    // End of the program
    .end
