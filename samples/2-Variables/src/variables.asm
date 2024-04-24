;--------------------------------------------------------------------------------;
; This calculates ((160*2)+80)/2 = 200, then exits the program setting the result;
;as the exit code. After running the program (on Linux) this code can be viewed  ;
;by running the command "echo $?".                                               ;
;--------------------------------------------------------------------------------;

section .data
	a DB 160
	b DB 80

section .text
	global _start

_start:		; this is the entry point of the program

	;adding 2 numbers
	mov rax, [a]
	mov rbx, [b]
	mov rcx, 2
	mul rcx
	add rax, rbx

	;divide by 2 to obtain the average of 'a' and 'b'

	mov rdx, 0	; this register must be initialised with 0 before performing a division
	mov rbx, 2
	div rbx

	;exiting the program
	mov rdi, rax 	; set the result as the exit code
	mov rax, 60	; 60 is the value for system exit
	syscall
