section .data
  msg db "Number is :"
  len equ $-msg
  no db 48h




section.bss
  no_ascii resb 2


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

cout msg,len
call display



 
mov rax,60
mov rdi,0
syscall


;.................................................
display:
  
  mov cl,2
  mov esi,no_ascii
  
  mov bl,[no]
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
  
  cout no_ascii,2
 
  ret
 ;.................................................
