//LAB2 BY: BOGDAN DORANTES, ONUR KELES, OMER
//PART 1
/* Program for store */
// Pre-indexed addressing mode

.global _start

start:
    LDR R0, =LOC     // pseudo-inst.
    MOV R1, #1       // write 1 to register 1
    MOV R2, #2       // write 2 to register 2
    MOV R3, #3       // write 3 to register 3
    MOV R4, #4       // write 4 to register 4

    // Now, store these words into memory starting from the location LOC
    STR R1, [R0]

    // Now, store the content of R2 to the next location:
    ADD R0, R0, #4   // watch the content of R0!
    STR R2, [R0]

    // Store the content of R3 to the next location:
    ADD R0, R0, #8   // watch the content of R0!
    STR R3, [R0]

    // Finally, store the content of R4 to the next location:
    ADD R0, R0, #12   // watch the content of R0!
    STR R4, [R0]

END: 
    B END

LOC: 
    .word 0xA

.end

// Post-indexed with write-back addressing mode

.global _start

start:
    LDR R0, =LOC     // pseudo-inst.
    MOV R1, #1       // write 1 to register 1
    MOV R2, #2       // write 2 to register 2
    MOV R3, #3       // write 3 to register 3
    MOV R4, #4       // write 4 to register 4

    // Now, store these words into memory starting from the location LOC
    STR R1, [R0]

    // Now, store the content of R2 to the next location:
    ADD R0, R0, #4   // watch the content of R0!
    STR R2, [R0]

    // Store the content of R3 to the next location:
    ADD R0, R0, #4   // watch the content of R0!
    STR R3, [R0]

    // Finally, store the content of R4 to the next location:
    ADD R0, R0, #4   // watch the content of R0!
    STR R4, [R0]

END: 
    B END

LOC: 
    .word 0xA

.end


// Pre-indexed with write-back addressing mode
.global _start

start:
    LDR R0, =LOC     // pseudo-inst.
    MOV R1, #1       // write 1 to register 1
    MOV R2, #2       // write 2 to register 2
    MOV R3, #3       // write 3 to register 3
    MOV R4, #4       // write 4 to register 4

    // Now, store these words into memory starting from the location LOC
    STR R1, [R0, #4]!

    // Now, store the content of R2 to the next location:
    STR R2, [R0, #4]!

    // Store the content of R3 to the next location:
    STR R3, [R0, #4]!

    // Finally, store the content of R4 to the next location:
    STR R4, [R0, #4]!

END: 
    B END

LOC: 
    .word 0xA

.end


//PART 2
/* Program for word swap */
.global start

start:
    // Use register addressing or pre-indexed addressing modes
    LDR R0, =LOCA // pseudo-inst.
    LDR R1, [R0]
    LDR R2, [R0, #4]
    STR R1, [R0, #4]
    STR R2, [R0]

    // Use register addressing or post-indexed addressing modes
    LDR R0, =LOCA // pseudo-inst.
    LDR R1, [R0], #4
    LDR R2, [R0]
    STR R1, [R0]
    STR R2, [R0, #-4]

    // Use register addressing or pre-indexed with write-back addressing modes
    LDR R0, =LOCA // pseudo-inst.
    LDR R1, [R0, #4]!
    LDR R2, [R0]
    STR R1, [R0]
    STR R2, [R0, #-4]

END: 
    B END

LOCA: 
    .word 0xA

LOCB: 
    .word 0xB

.end

//PART 3
/* Program for byte swap */
.global start

start:
    LDR R0, =LOC     // pseudo-inst.
    LDRB R1, [R0]    // Load the first byte
    LDRB R2, [R0, #1]// Load the second byte
    STRB R1, [R0, #1]// Store the first byte into the second byte's location
    STRB R2, [R0]    // Store the second byte into the first byte's location

END: 
    B END

LOC: 
    .word 0x12AB0000

.end
