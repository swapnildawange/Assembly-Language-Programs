section .data
  p db "Positive number are :" 
  p_len equ $-p
  n db 10,"Negative number are :" 
  n_len equ $-n
  
  a db 01h,-02h,-03h,04h,05h
;...............................................


;...............................................
section.bss
  p_count resb 1
  n_count resb 1
  d_count resb 2


;.............................................
%macro cout 2  
  mov rax,1
  mov rdi,1
  mov rsi,%1            ;macro for print
  mov rdx,%2
  syscall
 %endmacro
;..............................................



global _start
section .text
_start:





call pandn
cout p,p_len
call display_positive
cout n,n_len
call display_negative



 
mov rax,60
mov rdi,0
syscall
;.................................................
pandn:
  mov edi,a
  mov cl,5
  mov bl,0     ;for positive
  mov dl,0     ;for negative
  
up1: 
  mov al,[edi]
  rcl al,2
  jc neg
  inc bl
  jmp next
  
neg:
  inc dl 

next:
  inc edi
  dec cl
  jnz up1
  
  mov [p_count],bl
  mov [n_count],dl
 ret
 




;.................................................
display_positive:
  mov bl,[p_count]
  jmp next1
  
display_negative:  
  mov bl,[n_count]
next1:  
  mov cl,2
  mov esi,d_count
  
  
up:  
  rol bl,4
  mov al,bl
  and al,0fh
  add al,30h
  cmp al,39h
  jle skip
  add al,07h
  
 skip:
   mov [esi],al
   inc esi
   dec cl
   jnz up
  
  cout d_count,2
 
  ret
 ;.................................................
    
