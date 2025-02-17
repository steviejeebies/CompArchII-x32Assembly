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
	mov ebx, [ebp + 8]	; base (only have to read from memory once to get the base parameter, instead of doing it every time in the loop)
l1:	
	imul ebx			; result = result * base
	loop l1				; loop

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
		push ebx				; push EBX, callee convention
		push esi				; push ESI, callee convention
	;; Main function body
		mov esi, [ebp + 16]		; esi is now pointing to the array
		mov bx, 0				; BX = i
		mov cx, [ebp + 12]		; CX = K
nextMu:	
		cmp bx, [ebp + 8]		; if i >= N, we're done
		jge endMu				; jump if above or equal (unsigned) 
		xor edx, edx			; clear EDX as this register is used by IDIV
		movzx eax, bx			; AX = i (zero filler)
		inc ax					; AX = i + 1
		idiv cx					; AL = (i + 1)%k
		cmp dx, 0				; --IF-- ((i+1)%k (i.e. remaninder) == 0), Note: remainder stored in DX
		jne elseMu
		mov [esi], WORD PTR 1	; WORD as each element of array is 16-bits
		jmp whileMu
elseMu:							; --ELSE--
		mov [esi], WORD PTR 0	; WORD as each element of array is 16-bits
whileMu:						; continue loop by incrementing i and getting next index of array
		inc bx
		add esi, 2				; incrementing index of array by 2, as each index of array is 2 bytes
		jmp nextMu
;; Epilogue
endMu:	
		pop ebx					; push EBX, callee convention
		pop esi					; push ESI, callee convention					
		mov esp, ebp
		pop ebp
		ret

public factorial
factorial:
;;		Prologue
		push ebp
		mov ebp, esp

;;		Main function
		mov ebx, [ebp+8]	; get parameter, store in EBX
		cmp ebx, 0			; if (N = 0)...
		jne	elseF
		mov eax, 1			; result = 1, return
		jmp endF
elseF:						; if (N != 0)...
		dec ebx				; N-1
		push ebx			; (push N-1 as parameter, and keep it safe as caller) 
		call factorial		; recursive call, result will be in EAX
		pop ebx				; restore EBX (i.e. N).
		inc ebx				; N
		mul ebx			; factorial = N * factorial(N-1) (result stored in EAX)
;;		Epilogue
endF:
		mov esp, ebp
		pop ebp
		ret	
	

END