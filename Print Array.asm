section .data
  arr db "Array is :"
  l_arr equ $-arr
  msg db ' '
  
  
  a db 01,02,03,04,05,0h,0h,0h,0h,0h
  b db 01,02,03,04,05,0h,0h,0h,0h,0h
  

section .bss
  d_count resb 2
  no_ascii resb 2
  array resb 20
%macro cout 2
  mov rax,1
  mov rdi,1
  mov rsi,%1
  mov rdx,%2
  syscall
  
%endmacro

  

global _start
section .text
_start:
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


 cout arr,l_arr
  
  

  ;xor cx,cx
  mov cx,9h
  mov ebp,a
l:
  push cx
  call display_proc
  cout msg,1
  
  add ebp,1
  pop cx
  cmp cx,0h
  loopnz l
  
  mov cx,9h
  mov ebp,b
ll:
  push cx
  call display_proc
  cout msg,1
  
  add ebp,1
  pop cx
  cmp cx,0h
  loopnz ll
  



  mov rax,60
  mov rdi,0
syscall
  

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<   
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  
display_proc:
mov bl,[ebp]
 
p:
  mov dl,2
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
  dec dl
  jnz up
  

  cout d_count,2
  
ret
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  
  
  
  


