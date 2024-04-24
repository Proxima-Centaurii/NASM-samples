;----------------------------------------------------;
;  Prints "Hello Assembly!" to the screen and exits. ;
;----------------------------------------------------;

section .data
	txt db "Hello assembly!", 10,0
	txt_len equ $ - txt

section .text
	global _start

_start:
	mov rax, 1		; value for sys_write (Linux)
	mov rdi, 1		; file handle, 1 = stdout
	mov rsi, txt		; load the address of the char* buffer
	mov rdx, txt_len	; how many bytes to write
	syscall

	mov rax, 60		; value for sys_exit (Linux)
	mov rdi, 0		; exit code
	syscall
