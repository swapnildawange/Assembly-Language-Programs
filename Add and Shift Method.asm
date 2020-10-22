;-----------------------------------------------------------------------------------------
;------Sandip Institute of Engineering and Management
;------(Department of Computer Engineering)
;------Class: S.E.Comp				Sub:Microprocessor Lab
;------Asignment No : 4.2
;------Write an ALP to perform multiplication of two numbers in Add and Shift Method
;------------------------------------------------------------------------------------
;*********************************************************************************

section .data

	msg_enter_no db 10,'Enter two digit Number::'
	msg_enter_no_len equ $-msg_enter_no

	res db 10,'Multiplication of elements is::'
	res_len equ $-res
	
;***************************  BSS SECTION  *******************************
section .bss
	num2 resb 03
	num1 resb 01
	result resb 04	
	num_ascii resb 4
	input_num_ascii resb 03

;************************** ACCEPT / DISPLAY MACRO ****************************
%macro cout 2
	mov rax,1
	mov rdi,1
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

%macro cin 2
	mov rax,0
	mov rdi,0
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

;************************** TEXT SECTION *******************************
section .text

global _start
_start:

	 	
;************************* ADD & SHIFT PROCEDURE *************************

add_and_shift_proc:
	cout msg_enter_no,msg_enter_no_len	;ENTER 1st TWO DIGIT NUMBER
	cin input_num_ascii,3			;ACCEPT FIRST NUMBER

	call remove_ascii_proc			;CALL remove_ascii_proc FOR FIRST NO	
	mov [num1],bl				;STORE 1st remove_ascii_proc INTO num1
	
	cout msg_enter_no,msg_enter_no_len	;ENTER 2nd TWO DIGIT NUMBER
	cin input_num_ascii,3			;ACCEPT SECOND NUMBER
	call remove_ascii_proc			;CALL remove_ascii_proc FOR SECOND NO	

	mov [num2],bl				;MOVE 2nd NO INTO num
	
	mov dl,08				;STORE COUNT 08 INTO DL
	mov al,[num1]				;MOVE 1st NO INTO AL
	mov bl,[num2]				;MOVE 2nd NO INTO BL

	;---------- START THE PROCEDURE ------------------

again:
	shr bx,01				;SHIFT BX(2nd NO) TO RIGHT 
						;To check whether LSB is 0 OR 1
	jnc next				;JUMP IF NOT CARRY (i.e 0 So only SHIFT)
	add cx,ax				;OTHERWISE (i.e.CARRY So ADD and SHIFT)
						;ADD NO1 IN RESULT ANd SHIFT TO LEFT
next:	
	shl ax,01				;SHIFT AX TO LEFT (In both cases)
	dec dl					;DECREMENT DL(COUNT) BY 1
	jnz again				;REPETE TILL DL(COUNT) BECOMES 0

	mov [result],rcx			;MOVE RCX(RESULT) INTO result variable
	cout res,res_len			;MULTIPLICATION IS :

	mov rbx,[result]			;MOVE result INTO RBX TO PRINT
	call display_proc_16_bit		;DISPLAY THE RESULT (Multiplication)

ret
;***************************************************************************
exit:
	mov rax,60 
	mov rdi,0
	syscall
;***************************************************************************
;************************* REMOVE ASCII PROCEDURE *************************
remove_ascii_proc:
	xor rbx,rbx			;INITIALISE RESULT AS 0
	xor rcx,rcx
	xor rax,rax

	mov cl,02			;STORE COUNT CL AS 0	
	mov esi,input_num_ascii		;POINT ESI TO NUMBER IN ASCII FORMAT
up2:
	rol bl,04			;ROTATE THE RESULT BL TO LEFT
	mov al,[esi]			;COPY ASCII DIGITS one by one INTO AL
	cmp al,39h			;CHECK THE DIGIT AS NUMBER OR CHARACTER
	jle skip_sub_07			;IF LESS THEN 39 (It is no) JUMP TO -30
	sub al,07h			;ELSE (It is character) SUBTRACT 07		
skip_sub_07:
 	sub al,30h			;SUBTRACT 30
	add bl,al			;ADD THE SUBTRACTED NUMBER IN BL
	inc esi				;POINT TO NEXT ASCII DIGIT
	loop up2			;REPEATE THE PROCEDURE UNTIL COUNT BECOMES 0
ret
;********************** DISPLAY 16 BIT NUMBER *********************************
display_proc_16_bit:
	mov cl,4			;Number digits to display
	mov edi,num_ascii		;Temp buffer to store ASCII value
up1:
	rol bx,4			;Rotate number from BX to get MSB digit to LSB digit
	mov al,bl			;Temporary copy rotated number to AL
	and al,0fh			;Mask/Delete upper digit
	cmp al,09			;Compare the result with 9
	jbe skip_07			;If number below or equal to 9 go to add only 30h
	add al,07h			;Else first add 07h and then 30h
skip_07:	
	add al,30h			;Add 30h Common in both cases (So either 30h OR 37h) 
	mov [edi],al			;Store the ASCII code in num_ascii variable
	inc edi				;Increment pointer to next location in num_ascii

	dec cl				;repeat till counter CL becomes zero
	jnz up1

	cout num_ascii,4		;display the value from num_ascii
	ret				;return to calling program
;*******************************************************************************

