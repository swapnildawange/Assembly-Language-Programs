;-----------------------------------------------------------------------------------------
;------Sandip Institute of Engineering and Management
;------(Department of Computer Engineering)
;------Class: S.E.Comp				Sub:Microprocessor Lab

;------Asignment No : 1
;------WRITE AN ALP TO COUNT NO OF POSITIVE AND NEGATIVE NUMBERS FROM 32-BIT ARRAY

;**************************** DATA SECTION **********************************
section    .data
	new_line	db	10,10
	new_line_len:	equ	$-new_line
	
	array		dd	-11111111H, 22222222H, -33333333H, 44444444H, 55555555H
	count:		equ	5

	pmsg		db	10,10,"The no. of Positive elements in 32-bit array :	"
	pmsg_len:	equ	$-pmsg

	nmsg		db	10,10,"The no. of Negative elements in 32-bit array :	"
	nmsg_len:	equ	$-nmsg

;---------------------------------------------------------------------
Section   .bss
	p_count		resb	1		
	n_count		resb	1
    	num_ascii resb 2
;---------------------------------------------------------------------

;***************MACRO TO PRINT MESSAGE*******************

%macro cout 2
	mov rax,01				;SYSCALL cout MACRO
	mov rdi,01
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

;****************MACRO TO EXIT *******************
%macro exit	0
	mov rax,60		;SYSCALL EXIT FUNCTION
	mov rbx,0
	syscall
%endmacro

;**************************** CODE/TEXT SECTION ******************************
section    .text
	global   _start
_start:
	
	;------------------LOGIC TO FIND COUNT ---------------------------

	mov	esi, array			;POINT ESI TO BEGINNING OF ARRAY 
	mov	cl, count		
	
	mov	bl,0;				; INITIALISE p_count(+VE) TO 0
	mov	dl,0;				; INITIALISE n_count(-VE) TO 0

next_num:
	mov	eax,[esi]			; COPY 1st NUMBER IN EAX (Accumulator)
	RCL	eax,1				; ROTATE LEFT BY 1 BIT TO CHECK SIGN BIT
	jc	negative			; IF CARRY (1) THEN NO IS NEGATIVE
positive:
	inc	bl				; ELSE (CARRY=0) NO IS POSITIVE INCREMENT +VE COUNT
	jmp	next				; GO TO NEXT NUMBER
negative:
	inc	dl				; NO IS -VE SO INCREMENT -VE COUNT
next:
	add 	esi,4				; 32 BIT NO i.e. 4 bytes SO INCREMENT BY 4   
	dec 	cl				; DECREMENT THE COUNT 
	jnz  	next_num			; JUMP TO NEXT NUMBER VALIDATION

;------------------HOW TO DISPLAY THE COUNT ------------------------

	mov	[p_count], bl		; Temparary store positive count in p_count
	mov	[n_count], dl		; Temparary store negative count in n_count

	;------------------DISPLAY POSITIVE COUNT ------------------------
	cout	pmsg, pmsg_len
	mov 	bl,[p_count]		; load value of p_count in rax
	call display_proc_8_bit		; display p_count

	;------------------DISPLAY NEGATIVE COUNT ------------------------
	cout	nmsg, nmsg_len
	mov 	bl,[n_count]		; load value of n_count in rax
	call display_proc_8_bit		; display n_count

	cout	new_line, new_line_len
	exit
;********************** DISPLAY 8 BIT NUMBER **********************************
	
display_proc_8_bit:
	mov cl,2			;Number of digits to display
	mov edi,num_ascii	;Temp buffer to store ASCII value
up1:
	rol bl,4			;Rotate number from bl to get MSB digit to LSB digit
	mov al,bl			;Temporary copy rotated number to AL
	and al,0fh			;Mask/Delete upper digit
	cmp al,09			;Compare the result with 9
	jbe skip_07		;If number below or equal to 9 go to add only 30h
	add al,07h			;Else first add 07h and then 30h
skip_07:	
	add al,30h			;Add 30h Common in both cases  (So either 30h OR 37h) 
	mov [edi],al		;Store the ASCII code in num_ascii variable
	inc edi			;Increment pointer to next location in num_ascii

	dec cl			;repeat till counter CL becomes zero
	jnz up1

	cout num_ascii,2	;display the value from num_ascii
	ret				;return to calling program
;*******************************************************************************

