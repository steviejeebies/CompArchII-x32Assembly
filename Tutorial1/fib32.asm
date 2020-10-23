.686                                ; create 32 bit code
.model flat, C                      ; 32 bit memory model
 option casemap:none                ; case sensitive


	.data

	public bias		;
	bias DWORD 4		;
.code

;
; fib32.asm
;

;
; example mixing C/C++ and IA32 assembly language
;
; use stack for local variables
;
; simple mechanical code generation which doesn't make good use of the registers

public      fib_IA32a               ; make sure function name is exported

fib_IA32a:  push    ebp             ; push frame pointer
            mov     ebp, esp        ; update ebp
            sub     esp, 8          ; space for local variables fi [ebp-4] and fj [ebp-8]
            mov     eax, [ebp+8]    ; eax = n
            cmp     eax, 1          ; if (n <= 1) ...
            jle     fib_IA32a2      ; return n
            xor     ecx, ecx        ; ecx = 0   NB: mov [ebp-4], 0 NOT allowed
            mov     [ebp-4], ecx    ; fi = 0
            inc     ecx             ; ecx = 1   NB: mov [ebp-8], 1 NOT allowed
            mov     [ebp-8], ecx    ; fj = 1
fib_IA32a0: mov     eax, 1          ; eax = 1
            cmp     [ebp+8], eax    ; while (n > 1)
            jle     fib_IA32a1      ;
            mov     eax, [ebp-4]    ; eax = fi
            mov     ecx, [ebp-8]    ; ecx = fj
            add     eax, ecx        ; ebx = fi + fj
            mov     [ebp-4], ecx    ; fi = fj
            mov     [ebp-8], eax    ; fj = eax
            dec     DWORD PTR[ebp+8]; n--
            jmp     fib_IA32a0      ;
fib_IA32a1: mov     eax, [ebp-8]    ; eax = fj
fib_IA32a2: mov     esp, ebp        ; restore esp
            pop     ebp             ; restore ebp
            ret     0               ; return
    
;
; example mixing C/C++ and IA32 assembly language
;
; makes better use of registers and instruction set
;

public      fib_IA32b               ; make sure function name is exported

fib_IA32b:  push    ebp             ; push frame pointer
            mov     ebp, esp        ; update ebp
            mov     eax, [ebp+8]    ; mov n into eax
            cmp     eax, 1          ; if (n <= 1)
            jle     fib_IA32b2      ; return n
            xor     ecx, ecx        ; fi = 0
            mov     edx, 1          ; fj = 1
fib_IA32b0: cmp     eax, 1          ; while (n > 1)
            jle     fib_IA32b1      ;
            add     ecx, edx        ; fi = fi + fj
            xchg    ecx, edx        ; swap fi and fj
            dec     eax             ; n--
            jmp     fib_IA32b0      ;
fib_IA32b1: mov     eax, edx        ; eax = fj
fib_IA32b2: mov     esp, ebp        ; restore esp
            pop     ebp             ; restore ebp
            ret     0               ; return
    

	public array_proc 		; makes the procedure/function visible to C++ file
array_proc:
	;; Prologue
	;;  pushing the base pointer onto the stack
	push ebp
	;; establishing the stack frame
	mov ebp, esp

	;; Main function body
	;; Callee preserved ESI register
	push esi

	;; EAX is the accumulator
	xor eax, eax 		; clearing EAX

	;; Retreiving the arguments
	mov ecx, [ebp+12]
	mov esi, [ebp+8]

	;; the main loop
L1:	add eax, [esi] 		; accessing the array
	add esi, 4		; incrementing the pointer
	loop L1			; looping back to L1

	;; Epilogue
	mov esp, ebp
	pop ebp
	ret
end
