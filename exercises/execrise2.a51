;Hao QIN & Yu LIU
; Ex5

$include(t89c51cc01.inc)
	
;Boot Code
ORG 0000h
LJMP init
ORG 000bh   ; THE INTERRUPT ENTERANCE
LJMP timer0int

init:
	MOV TMOD, #01H  ;SET TIMER MODE 1
	MOV TH0,#0FBH	;set initial timer number 
	MOV TL0,#08FH
	SETB ET0        ;Timer 0 overflow interrupt Enable bit
	SETB EA			;Enable All interrupt bit
	SETB TR0        ;set run control bit
	MIAN: LJMP $

timer0int:
			CPL P2.2
			Hz440: MOV TH0,#0FBH  ;set timer number again
				   MOV TL0,#08FH
				   LJMP ENDINT

			ENDINT: RETI
	
END