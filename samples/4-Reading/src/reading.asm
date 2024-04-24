;--------------------------------------------------------------------------------;
;  Greet the user of the application. This application reads an input from stdin ;
;which represents a name and outputs a greeting using the input name.		 ;
;--------------------------------------------------------------------------------;

section .data
	message db "Hello "
	len equ 6

section .bss
	buffer resb 25

section .text
	global _start

_start:
	; read input
	mov rax, 0	; value for sys_read (Linux)
	mov rdi, 0	; file handle, 0 = stdin
	mov rsi, buffer	; load the address of the char* buffer
	mov rdx, 25	; how many bytes to read
	syscall


	;push onto the stack what to write
	push 25
	push buffer
	push len
	push message

	mov rcx, 2	; initialising the a counter (2 strings)

	; NOTE: despite having the intended effect, having syscalls in a loop
	; is not efficient.
	.writeloop:
		mov rax, 1
		mov rdi, 1
		pop rsi		; address of char*
		pop rdx		; how many bytes to write

		push rcx	; syscall will modify rcx so temporarily push rcx into the stack
		syscall
		pop rcx

		dec rcx		; decrease counter by 1

		cmp rcx, rbx	; cmp compares the values of 2 registers
		jne .writeloop	; if counter (rcx) is not 0 the jump back to writeloop


	; exiting
	mov rax, 60
	mov rdi, 0
	syscall
