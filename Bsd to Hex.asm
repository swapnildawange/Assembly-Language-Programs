section .data



section .bss
  no resb 2
  n resb 2
  dis resb 2
 %macro write 2
   mov rax,1
   mov rdi,1
   mov rsi,%1
   mov rdx,%2
   syscall
  %endmacro
  
  %macro read 2
  mov rax,0
  mov rdi,0
  mov rsi,%1
  mov rdx,%2
  syscall 
  %endmacro
  
  
 global _start
 section .text
 _start:
   read no,2
   ;call remove_ascii
   write n,2
   call display_fun
   
   
   
   
   
   
   
   mov rax,60
   mov rdi,0
   
  ;.............................................................

  remove_ascii:
  mov esi,no
   mov cx,2
   ;mov bl,[esi]
up1:
  rol bl,4
  mov al,[esi]
  cmp al,39h
  jle skip
  sub al,07h
skip:
  sub al,30h
  add bl,al
  inc esi
  dec cx
  jnz up1
  mov [n],bl
  ret
  
;...............................................................................................
display_fun:
  mov bl,[no]
up2:
  rol bl,4
  mov al,bl
  and al,0fh
  add al,30h
  cmp al,39h
  jle skip2
  add al,07h
skip2:
  mov [dis],al
  
  write dis,2
  ret  
   
