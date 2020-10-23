.686                                ; create 32 bit code
.model flat, C                      ; 32 bit memory model
 option casemap:none                ; case sensitive


.data
.code

; QUESTION 1 - POLY() and POW()
public poly
poly:
	;; Prologue
	push ebp
	mov ebp, esp

	;; Main function body
	;push esi ;; Callee preserved ESI register
	; Call pow(), with parameters (int base, int exponent)
	push 2				; exponent = 2
	push [ebp+8]		; base = arg passed to poly
	call pow			; afer this line, EAX will be 'res'
	add esp, 8			; remove the parameters of pow() from the stack
	add eax, [ebp+8]
	inc eax
	;; Epilogue
	mov esp, ebp
	pop ebp
	ret

pow:
	;; Prologue
	push ebp
	mov ebp, esp
	push ebx			; callee needs to save EBX since we're using it

	;; Main function body
	mov eax, 1			; result = 1
	mov ecx, [ebp + 12]	; putting exponent in the counter register
	mov ebx, [ebp + 8]	; base
l1:	imul ebx			; result = result * base
	loop l1

	;; Epilogue
	pop	ebx				; callee restored EBX
	mov esp, ebp
	pop ebp
	ret

; QUESTION 2 - MULTIPLE_K()
public multiple_k_asm
multiple_k_asm:
	;; Prologue
		push ebp
		mov ebp, esp
	;; Main function body
		mov esi, [ebp + 16]		; esi is now pointing to the array
		mov cx, [ebp + 12]		; CX = K
		mov bx, 0				; BX = i
next:	cmp bx, [ebp + 8]		; if i >= N, we're done
		jge done				; jump if above or equal (unsigned) 
		xor dx, dx				; clear EDX as this register is used by IDIV
		movzx eax, bx			; AX = i
		inc ax					; AX = i + 1
		idiv cx					; AL = (i + 1)%k
		cmp dx, 0				; if(i+1)%k (i.e. remaninder) == 0, Note: remainder stored in DX
		jne elsea
		mov [esi], WORD PTR 1
		jmp cont
elsea:	mov [esi], WORD PTR 0
cont:	inc bx
		add esi, 2
		jmp next
done:
	;; Epilogue
		mov esp, ebp
		pop ebp
		ret
	

END