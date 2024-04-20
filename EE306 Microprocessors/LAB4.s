// PART ONE
//LAB4 BY: BOGDAN DORANTES, ONUR KELES, OMER MERT YILDIZ
.global start
start:
	// search the list and find the index of the item
	// all items follow this structure:
	// 0x name price 4 digits (16 bits) for name(ID) and price.
	LDR R1,=MENU
	LDR R2,=INDEX
	LDR R4, [R1] // number of items in the menu. R1's first value gives us the count
	
	LDR R0,=ITEM1
	BL Subroutine
	MOV R8, R5
	ADD R0, R0, #4
	// changer the item 
	BL Subroutine
	MOV R9, R5
	ADD R0, R0, #4
	BL Subroutine
	MOV R10, R5
	ADD R0, R0, #4
	BL Subroutine
	mov R11, R5
	end: B end



Subroutine: LDR R3, [R0] // the item you are looking for.
	MOV R5, #0
	STR R5, [R2] // initial assumption, item is not in the list.
Loop: ADD R5,R5,#1
	CMP R5,R4		//If the basket is empty
	BGT Done		//If the item is greater the count of item, jump to done
	LDR R6, [R1, R5, LSL #2]// read item i.
	CMP R6, R3 		//(1.2)IF the item is found: 
	STREQ R5, [R2] 	//Condition to store i? If the R5 and R2 are equal, i will be saved.
	BEQ Done 		//(1.2)THEN break the loop for unnecessary looping
	B Loop 			//(1.2)ELSE keep looking
Done: BX LR

ITEM1: .word 0xF00D0032
ITEM2: .word 0xABCD0018
ITEM3: .word 0xAABB0048
ITEM4: .word 0xBBCC0025
// this is the menu. Do not change the menu.
// The first enty is the number of menu items.
MENU: .word 0x4, 0xABCD0018, 0xAABB0048, 0xF00D0032, 0xBBCC0025
// write only the index of the item here.
INDEX: .word 0
.end


//// PART TWO - Shopping List
//LAB4 BY: BOGDAN DORANTES, ONUR KELES, OMER MERT YILDIZ
//Didn't use "SearchItem" because I don't know what it exactly 

.text
.global main

main:
    LDR R0, =shopping_list   // Get the address of Shopping List
    LDR R1, =budget          // Get the address of the Budget
    LDR R1, [R1]             // Load R1 register with the Budget value
    MOV R2, #0		     // Initilazing a Counter register
    
	BL search_loop
    
	//.. some line of code
	

buy_item_link:
	BL buy_item
	B search_loop

buy_item:
    ADD R2, R2, #1           // Increase the count by one.
    SUB R1, R1, R4           // Subtract the amount of the item from our wallet.
    BX LR            // Jump back to the search_loop.



search_loop: 
LDR R4, [R0], #4         // Get the price of i'th unit. Go to the (i + 1)'th item to be bought for next time.
    //POP {R11}
    CMP R4, #0		         // If current item is 0, it means last item was the last choice in Shopping List.
    BEQ done          // Stop looking process, and jump to the end.
    LSL R4, R4, #8           //
    LSR R4, R4, #8
    
    CMP R4, R1               // Check if the wallet has enough budget the buy the current item.
    BLE buy_item_link             // If so, jump to the buy_item.
    
    BGT done          // else, jump to the end.

done:
	//MOV LR, #0x14
	BX LR
 
price: 
LSL R4, R4, #8           //
LSR R4, R4, #8 
BX LR // This and the line at top is to get last 2 digits (The max digit limit price of an item can get)
// List for prices of the items user will buy
shopping_list: 
	.word 0xF00D0010, 0xAABB0020, 0xABCD0030, 0xAABB0100, 0xF00D0010, 0xBBCC0025   //The Shopping List
										       //The price can only be in last 2 digits
// Budget the user have in their wallet.
budget: 
	.word 0x100    
.end



----------
// PART TWO - Shopping List
//LAB4 BY: BOGDAN DORANTES, ONUR KELES, OMER MERT YILDIZ
//Didn't use "SearchItem" because I don't know what it exactly

.text
.global main

main:
    LDR R0, =shopping_list   // Get the address of Shopping List
    LDR R1, =budget          // Get the address of the Budget
    LDR R1, [R1]             // Load R1 register with the Budget value
	LDR R8,=MENU
	LDR R9,=INDEX
    MOV R2, #0		     // Initilazing a Counter register
 LoopA: 
	BL Subroutine
	LDR R10, [R8, R5, LSL #2]
	LSL R10, R10, #16           //
	LSR R10, R10, #16
	CMP R10, R1               // Check if the wallet has enough budget the buy the current item.
    ADDLE R2, R2, #1           // Increase the count by one.
    SUBLE R1, R1, R10           // Subtract the amount of the item from our wallet.
    ADDLE R0, R0, #4
	BLE LoopA
    BGT end          // else, jump to the end.
	



Subroutine: LDR R3, [R0] // the item you are looking for.
	MOV R5, #0
	STR R5, [R9] // initial assumption, item is not in the list.
	LDR R4, [R8] // number of items in the menu. R8's first value gives us the count
Loop: ADD R5,R5, #1
	CMP R5,R4		//If the basket is empty
	BGT Done		//If the item is greater the count of item, jump to done
	LDR R6, [R8, R5, LSL #2]// read item i.
	
	LSR R6, R6, #16           //
	LSL R6, R6, #16
	
	CMP R6, R3 		//(1.2)IF the item is found: 
	STREQ R5, [R11] 	//Condition to store i? If the R5 and R2 are equal, i will be saved.
	BEQ Done 		//(1.2)THEN break the loop for unnecessary looping
	B Loop 			//(1.2)ELSE keep looking

Done: BX LR



exit:
 B end
end: B end


MENU: .word 0x4, 0xABCD0018, 0xAABB0148, 0xF00D0032, 0xBBCC0025

shopping_list: .word 0xF00D0000, 0xAABB0000, 0xABCD0000, 0xAABB0000, 0xF00D0000, 0xBBCC0000   //The Shopping List
										       //The price can only be in last 2 digits
// Budget the user have in their wallet.
budget: 
	.word 0x100
INDEX: .word 0
.end



