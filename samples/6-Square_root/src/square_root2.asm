;-----------------------------------------------------------------------------;
;  Ask the user for a positive integer then calculate the square root of that ;
;number and print the result to the screen. Print an error message if the     ;
;input is invalid and exit the program.                                       ;
;-----------------------------------------------------------------------------;


section .data
	prompt db "Enter a positive integer to calculate its square root: ", 0
	prompt_len equ $ - prompt

	nl db 10

	invalid_val_msg db "You did not enter a valid number!", 10,0
	invalid_val_msg_len equ $ - invalid_val_msg

	inp_num dq 0
	inp_buff_max equ 11

	inp_buff_len dq 0

section .bss
	inp_buff resb 12

section .text
	global _start

_start:
	; writing prompt to screen
	mov rax, 1
	mov rdi, 1
	mov rsi, prompt
	mov rdx, prompt_len
	syscall

	; reading a number as an ascii string
	mov rax, 0
	mov rdi, 0
	mov rsi, inp_buff
	mov rdx, inp_buff_max
	syscall

	; begin converting the ascii to integer
	mov rcx, inp_buff_max	; rcx will be used as a counter
	mov rsi, inp_buff
	call strtoint
	mov qword[inp_num], rax

	; calculate square root
	call sqrt
	mov [inp_num], rax

	; begin converting the input integer to ascii
	mov rsi, inp_buff	; the buffer in which the number will be written into
	call inttostr		; returns the lenght of the string in rax
	mov [inp_buff_len], rdx	;update the input string length

	; print the result to screen
	mov rax, 1
	mov rdi, 1
	mov rsi, inp_buff
	syscall

	; print a new line so the output is clearly visible
	mov rax, 1
	mov rdi, 1
	mov rsi, nl
	mov rdx, 1
	syscall

	jmp exit

inttostr:
	xor rcx, rcx
	mov rbx, 10

	.inttostr_loop1:
		xor rdx, rdx	; must be set to 0 before performing divisions
		div rbx

		push rdx

		inc rcx

		cmp rax, 0
		je .inttostr_next_loop

		cmp rcx, rbx
		jne .inttostr_loop1

	; calculate the number of elements on stack and set last char
	.inttostr_next_loop:
		mov rdx, rcx

	.inttostr_loop2:
		pop rax
		add al, '0'
		mov [rsi], al

		add rsi, 1
		loop .inttostr_loop2

	ret

strtoint:
	xor rax, rax

	.strtoint_loop:
		mov bl, byte [rsi]	; extracting the first character


		;checking if the character is a newline
		cmp bl, 10
		je .strtoint_exit

		;checking if the character is null
		cmp bl, 0
		je .strtoint_exit

		;checking if the character is numeric (i.e. 0 <= c - '0' <= 9)
		sub bl, '0'

		cmp bl, 0
		jl invalid_val

		cmp bl, 9
		jg invalid_val


		; include digit into final value
		mov rdx, 10
		mul rdx
		add rax, rbx

		add rsi, 1		;move to the next character
		loop .strtoint_loop	;decrements rcx and stops when it's 0

	.strtoint_exit:
		ret


sqrt:
	cvtsi2sd xmm1, qword[inp_num]
	sqrtsd xmm0, xmm1
	cvtsd2si eax, xmm0

	ret


invalid_val:
	mov rax, 1
	mov rdi, 1
	mov rsi, invalid_val_msg
	mov rdx, invalid_val_msg_len
	syscall


exit:
	mov rax, 60
	mov rdi, 0
	syscall
