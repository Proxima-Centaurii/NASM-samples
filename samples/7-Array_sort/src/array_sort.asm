;----------------------------------------------------------;
;  This program allows the user to input the numbers of an ;
;array then sort the array in ascending order.             ;
;----------------------------------------------------------;

section .data
	prompt1 db "How many numbers to read? (max 20)", 10, 0
	prompt1_len equ $ - prompt1

	msg db "Original: "
	msg_len equ $ - msg

	msg1 db "Sorted: "
	msg1_len equ $ - msg1

	err_msg db "Input value is invalid!" , 10, 0
	err_msg_len equ $ - err_msg

	nl db 10

	int_buff_max equ 11	; stdin buffer for integers

	to_read_val dq 0	; how many values to read

section .bss
	int_buff resb 11
	num_array resq 20

section .text
	global _start

_start:
	; ask user how many numbers to read
	mov rax, 1
	mov rdi, 1
	mov rsi, prompt1
	mov rdx, prompt1_len
	syscall


	; read a number; the result will be stored in RAX
	mov rsi, int_buff
	mov rdx, int_buff_max
	call read_num


	; convert stdin string -> long (qword)
	mov rcx, int_buff_max
	mov rsi, int_buff
	call strtoint

	; check the number is not 0
	cmp rax, 0
	je exit

	; check the number is not greater than 20
	cmp rax, 20
	jg exit

	; save the value
	mov qword [to_read_val], rax	; update the current value

	; read loop
	mov rcx, rax
	mov rsi, num_array
	call read_nums

	mov rax, 1
	mov rdi, 1
	mov rsi, msg
	mov rdx, msg_len
	syscall

	; print the array
	mov rcx, [to_read_val]
	mov rsi, num_array
	call write_nums

	;print a new line
	mov rax, 1
	mov rdi, 1
	mov rsi, nl
	mov rdx, 1
	syscall

	mov rcx, [to_read_val]
	mov rsi, num_array
	call bubble_sort

	mov rax, 1
	mov rdi, 1
	mov rsi, msg1
	mov rdx, msg1_len
	syscall

	; print the array
	mov rcx, [to_read_val]
	mov rsi, num_array
	call write_nums

	;print a new line
	mov rax, 1
	mov rdi, 1
	mov rsi, nl
	mov rdx, 1
	syscall

	; exiting
	jmp exit


;args
;rsi - the address of the array to be sorted
;rcx - the size of the array
bubble_sort:
	dec rcx

	.bs_loop:
		xor rbx, rbx	;rbx - tells if the array is sorted or not (0 = sorted)

		push rcx
		push rsi
		.bs_loop_array:
			mov rax, [rsi]
			mov rdi, [rsi + 8]
			cmp rax, rdi
			jg .bs_loop_swap	; if you change 'jg' to 'jl' the array will be sorted in descending order
			jmp .bs_loop_continue

			.bs_loop_swap:
			mov rbx, 1
			push qword [rsi]
			push qword [rsi + 8]
			pop qword [rsi]
			pop qword [rsi + 8]

			.bs_loop_continue:
			add rsi, 8
			loop .bs_loop_array
		pop rsi
		pop rcx

		cmp rbx, 0
		jne .bs_loop

	ret


;args
;rcx - the length of the array
;rsi - the address of the array
write_nums:

	; exit the function if the amount to write is 0 (or less)
	cmp rcx, 0
	jle .write_nums_exit

	.write_nums_loop:
		push rcx
		push rsi

		; integer -> string
		mov rax, [rsi]
		mov rsi, int_buff
		call inttostr

		add rsi, rdx
		mov byte [rsi], ' '
		inc rdx

		; write to stdout
		mov rax, 1
		mov rdi, 1
		mov rsi, int_buff
		syscall

		pop rsi
		add rsi, 8

		pop rcx
		loop .write_nums_loop

	.write_nums_exit:
	ret


;args
;rcx - how many numbers to read
;rsi - the address of the array
read_nums:
	mov rdx, 1	; used to count and show the current insertion index in the array

	;exit function if the amount to read is 0 (or less)
	cmp rcx, 0
	jle .read_nums_exit

	.read_nums_loop:
		push rcx
		push rsi
		push rdx

		; the instructions below will print the current reading index
		; e.g. "1)", "15)"
		mov rax, rdx
		mov rsi, int_buff
		call inttostr

		add rsi, rdx
		mov byte [rsi], ')'
		inc rdx

		mov rax, 1
		mov rdi, 1
		mov rsi, int_buff
		syscall

		; read value
		mov rsi, int_buff
		mov rdx, int_buff_max
		call read_num

		pop rdx
		inc rdx

		; retrieve the address of the array from the stack
		; and update the current slot with the input value
		pop rsi
		mov [rsi], rax
		add rsi, 8

		; retrieve the current iteration value from the stack
		pop rcx
		loop .read_nums_loop

	.read_nums_exit:
	ret

;args
;rsi - the buffer to read into
;rdx - the maximum length of the buffer
;On return: rax will contain the number as a value
read_num:
	push rsi

	mov rax, 0
	mov rdi, 0
	syscall

	dec rax
	add rsi, rax
	mov rbx, 10  ;new line
	cmp byte [rsi], bl
	jne .too_large

	pop rsi
	inc rax
	mov rcx, rax
	call strtoint

	ret

	.too_large:
		mov byte [rsi], 0
		pop rsi
		inc rax
		mov rcx, rax
		call strtoint

		push rax ; push result in to the stack

		.flush_input:
			mov rax, 0
			mov rdi, 0
			mov rdx, int_buff_max
			syscall

			; if the characters read are equal to max size of buffer repeat loop
			mov rbx, int_buff_max
			cmp rax, rbx	;check if read len < max len
			jl .flush_exit

			dec rax
			add rsi, rax
			mov rbx, 10
			cmp byte [rsi], bl
			je .flush_exit

			; restore original
			sub rsi, rax
			jmp .flush_input

		.flush_exit:
			pop rax
			ret


; args
; rax - the number to convert
; rsi - the address of the buffer where to write the int to
; On return: rdx will contain new length of the string (does not actually resize the buffer)
inttostr:
	push rsi
	xor rcx, rcx
	mov rbx, 10

	.inttostr_loop1:
		xor rdx,rdx
		div rbx

		push rdx
		inc rcx

		cmp rax, 0
		je .inttostr_next_loop

		cmp rcx, rbx
		jne .inttostr_loop1

	.inttostr_next_loop:
		mov rdx, rcx

	.inttostr_loop2:
		pop rax
		add al, '0'
		mov [rsi], al

		add rsi, 1
		loop .inttostr_loop2

	pop rsi
	ret


; args
; rsi - the address of the string buffer
; rcx - the maximum size of the buffer
; On return: rax will contain the converted value
strtoint:
	xor rax, rax
	push rsi

	.strtoint_loop:
		mov bl, byte [rsi]

		cmp bl, 10
		je .strtoint_exit

		cmp bl, 0
		je .strtoint_exit

		sub bx, '0'

		cmp bx, 0
		jl .strtoint_invalid_val

		cmp bx, 9
		jg .strtoint_invalid_val

		mov rdx, 10
		mul rdx
		add rax, rbx

		add rsi, 1
		loop .strtoint_loop

	jmp .strtoint_exit

	.strtoint_invalid_val:
		mov rax, 1
		mov rdi, 1
		mov rsi, err_msg
		mov rdx, err_msg_len
		syscall

		mov rax, 0

	.strtoint_exit:
		pop rsi
		ret


exit:
	mov rax, 60
	mov rdi, 0
	syscall
