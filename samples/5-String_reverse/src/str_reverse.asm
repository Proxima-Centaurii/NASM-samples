section .data
	prompt db "Enter a string to reverse: ", 0
	prompt_len equ $ - prompt

	nl db 10	;new line character

	inp_buff_max equ 50
	inp_buff_len dq 0

section .bss
	inp_buff resb 50

section .text
	global _start

_start:

	; writing prompt to scree
	mov rax, 1
	mov rdi, 1
	mov rsi, prompt
	mov rdx, prompt_len
	syscall

	; reading a string from stdin
	mov rax, 0
	mov rdi, 0
	mov rsi, inp_buff
	mov rdx, inp_buff_max
	syscall

	; reverse the string
	mov rcx, inp_buff_max
	mov rsi, inp_buff
	call reverse_string

	inc rax
	mov [inp_buff_len], rax	; update the length of the string

	; write the result to the screen
	mov rax, 1
	mov rdi, 1
	mov rsi, inp_buff
	mov rdx, [inp_buff_len]
	syscall

	jmp exit

reverse_string:

	xor rax, rax
	xor rbx, rbx
	mov rdi, rsi	; save the original address of rsi

	.reverse_string_loop:
		mov bl, byte [rsi]

		cmp bl, 0
		je .reverse_string_reset

		cmp bl, 10
		je .reverse_string_reset

		push rbx
		inc rax

		add rsi, 1
		loop .reverse_string_loop

	.reverse_string_reset:
		mov rcx, rax
		mov rsi, rdi

	.reverse_string_loop2:
		pop rbx
		mov  [rsi], bl

		add rsi, 1
		loop .reverse_string_loop2

	ret


exit:
	mov rax, 60
	mov rdi, 0
	syscall
