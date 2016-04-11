;Hao QIN & Yu LIU
; Ex7 keypad
;--------------------------------------------------------
;      Col 1 Col 2
;Row 1   11    12
;Row 2   21    22 

;--------------------------------------------------------


$include(t89c51cc01.inc)
	
DSEG AT 50h
	keymem1: DS 1
		
;--------------------------------------------------------
 
CSEG
;--------------------------------------------------------
;Boot Code
org 0000h
ljmp INIT

;---------------------------------------------------------
;INIT
;---------------------------------------------------------
INIT:   
		mov keymem1,#00h
		mov R4,#00h
	    ljmp MAIN	


;---------------------------------------------------------
;main
;---------------------------------------------------------
MAIN:  acall KEYINT
	   acall SHOW
	   setb P2.4
	   setb P2.3
	   
	   LJMP main

;---------------------------------------------------------
;functions
;---------------------------------------------------------

;----------------------------------------------------------------------------------
; keyint
;   interacting with 4x4 keypad
KEYINT: ;P0.0 - P0.3 INPUT
		;P0.4 - P0.7 OUTPUT
		mov P0,#00001111b ; setting the input output pins
K1:		mov P0,#01111111b ; check 1st row
		mov A,P0;
		anl A,#00001111b ; mask to get the inputs
		cjne A,#00001111b,ROW1
		mov P0,#10111111b ; check 2st row
		mov A,P0;
		anl A,#00001111b ; mask to get the inputs
		cjne A,#00001111b,ROW2
		mov P0,#11011111b ; check 3st row
		mov A,P0;
		anl A,#00001111b ; mask to get the inputs
		cjne A,#00001111b,ROW3
		mov P0,#11101111b ; check 4st row
		mov A,P0;
		anl A,#00001111b ; mask to get the inputs
		cjne A,#00001111b,ROW4
		ljmp K1           ; false pressing jump back to debouncing	
;---------------------------------------------------------------------------		
ROW1:   mov keymem1, #10H  ; mark XXh the first X as row
        jnb P0.3, COL1
		jnb P0.2, COL2
		jnb P0.1, COL3
		jnb P0.0, COL4
		ret					
ROW2:	mov keymem1, #20H
		jnb P0.3, COL1
		jnb P0.2, COL2
		jnb P0.1, COL3
		jnb P0.0, COL4
		ret
ROW3:	mov keymem1, #30H
		jnb P0.3, COL1
		jnb P0.2, COL2
		jnb P0.1, COL3
		jnb P0.0, COL4
		ret
ROW4:	mov keymem1, #40H
		jnb P0.3, COL1
		jnb P0.2, COL2
		jnb P0.1, COL3
		jnb P0.0, COL4
		ret
;---------------------------------------------------------------------------		
COL1:	mov A,#01H
		add A,keymem1
		mov keymem1,A
        ret
COL2:   mov A,#02H
		add A,keymem1
		mov keymem1,A
        ret
COL3:   mov A,#03H
		add A,keymem1
		mov keymem1,A
        ret
COL4:   mov A,#04H
		add A,keymem1
		mov keymem1,A
        ret
;----------------------------------------------------------------------------------

; DELAY
;  delay 1ms
DELAY:   MOV R6,#250D
         MOV R7,#250D
LABEL1:  DJNZ R6,LABEL1
LABEL2:  DJNZ R7,LABEL2
         RET

;----------------------------------------------------------------------------------
; SHOW
;   show the effect of interacting with Keypad
SHOW: 	mov R1 ,keymem1
		cjne R1,#31h,SLAB1
		clr  P2.4
		ret
SLAB1:  cjne R1,#21h,SLAB2
		clr  P2.3
		ret
SLAB2:  cjne R1,#00h,SLAB3
		ret
SLAB3:  CPL P2.2
		ret

;----------------------------------------------------------------------------------
; Sound
SOUND:  CPL P2.2
		ret

END