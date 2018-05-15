;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;----- Your Sorting lab starts here -------------------------------------------
;Memory allocation of Arrays must be done before the RESET and StopWDT
ARY1 	.set 0x0200 ;Memory allocation ARY1
ARY1S 	.set 0x0210 ;Memory allocation ARYS
ARY2 	.set 0x0220 ;Memory allocation ARY2
ARY2S 	.set 0x0230 ;Memory allocation AR2S

		clr R4 ;clearing all register being use is a good
		clr R5 ;programming practice
		clr R6

SORT1	mov.w #ARY1, R4 ;initialize R4 as a pointer to array1
		mov.w #ARY1S, R6 ;initialize R6 as a pointer to array1 sorted
		call #ArraySetup1;then call subroutine ArraySetup1
		call #COPY ;Copy elements from ARY1 to ARY1S space
		call #SORT ;Sort elements in ARAY1

		clr R4 ;clearing all register being use is a good
		clr R5 ;programming practice
		clr R6

SORT2 	mov.w #ARY2, R4 ;initialize R4 as a pointer to array2
		mov.w #ARY2S, R6 ;initialize R6 as a pointer to array2 sorted
		call #ArraySetup2;then call subroutine ArraySetup2
		call #COPY ;Copy elements from ARY2 to ARY2S space
		call #SORT ;Sort elements in ARAY2

Mainloop jmp Mainloop ;Infinite Loop

ArraySetup1 mov.b #10, 0(R4) ; Array element initialization Subroutine
			mov.b #17, 1(R4) ;First start with the number of elements
			mov.b #75, 2(R4) ;and then fill in the 10 elements.
			mov.b #-67, 3(R4) ;and then fill in the 10 elements.
			mov.b #23, 4(R4) ;and then fill in the 10 elements.
			mov.b #36, 5(R4) ;and then fill in the 10 elements.
			mov.b #-7, 6(R4) ;and then fill in the 10 elements.
			mov.b #44, 7(R4) ;and then fill in the 10 elements.
			mov.b #8, 8(R4) ;and then fill in the 10 elements.
			mov.b #-74, 9(R4) ;and then fill in the 10 elements.
			mov.b #18, 10(R4) ;and then fill in the 10 elements.
			ret

ArraySetup2 mov.b #10, 0(R4) ; Array element initialization Subroutine
			mov.b #54, 1(R4) ;First start with the number of elements
			mov.b #-4, 2(R4) ;and then fill in the 10 elements.
			mov.b #-23, 3(R4) ;and then fill in the 10 elements.
			mov.b #-19, 4(R4) ;and then fill in the 10 elements.
			mov.b #-72, 5(R4) ;and then fill in the 10 elements.
			mov.b #-7, 6(R4) ;and then fill in the 10 elements.
			mov.b #36, 7(R4) ;and then fill in the 10 elements.
			mov.b #62, 8(R4) ;and then fill in the 10 elements.
			mov.b #0, 9(R4) ;and then fill in the 10 elements.
			mov.b #39, 10(R4) ;and then fill in the 10 elements.
			ret

COPY 		mov.b @R4, R5
			mov.w R6, R7
			incd.b R5
copy		mov.w @R4+, 0(R7)
			incd.w R7
			decd.w R5
			jnz copy
			ret

SORT		mov.b @R6+, R5; cache value of n
outer		mov.w R6, R7; iterate from begining of array
			mov.b R5, R11; reset counter bcuz we start from begining
inner		dec.b R11; dec the counter
			jz done
			mov.w R7, R8; prep val for cmp
			inc.w R7
			mov.w R7, R9; prep val for cmp
			cmp.b @R9, 0(R8)
			jl inner
			call #SWAP; swap
			jmp outer
done		ret



SWAP		mov.b @R9, R10
			mov.b @R8, 0(R9)
			mov.b R10, 0(R8)
			ret

;----- Your Sorting lab ends here -------------------------------------------

;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
