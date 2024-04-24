;----------------------------------------------------------------------;
;  This is an example of creating and iterating over an array in NASM. ;
;The array is of type 'long'(8 bytes, QWORD)  and has 5 elements. The  ;
;program returns the result as the exit code.                          ;
;----------------------------------------------------------------------;

section .data:
	numbers dq 3,7,23,6,1
	len equ 5

section .text

	global _start

_start:
	xor rax,rax	; initialise rax with 0

	mov rcx, len
	mov rsi, numbers

	; iterate through the array and sum up the numbers
	.loop_array:
		; sum the value of the elements
		mov rbx, [rsi]
		add rax, rbx

		add rsi, 8
		loop .loop_array

    ;move the result into rdi where it will be used as the exit code of the program
	mov rdi, rax

	; exits the program
	mov rax, 60
	syscall
