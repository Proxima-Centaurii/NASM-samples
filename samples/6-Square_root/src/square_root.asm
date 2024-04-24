;-------------------------------------------------------------------------------;
;  This program calculates the square root of an integer number. The purpose of ;
;this program is to show an example of working with floating point numbers.     ;
;-------------------------------------------------------------------------------;

section .data
	num dq 25

section .text
	global _start

_start:
	cvtsi2sd xmm1, qword [num]	; convert integer in num to double and store it in float register xmm0
	sqrtsd xmm0, xmm1		; calculate the square root and store result in xmm0
	cvtsd2si edi, xmm0		; convert double to integer and store it into edi
	mov qword[num], rdi		; update the variable num with the new value

	; call system exit
	mov  rdi, qword [num]		; set the result as the exit code
	mov rax, 60
	syscall
