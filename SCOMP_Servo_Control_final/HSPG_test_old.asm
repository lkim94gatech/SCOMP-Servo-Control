; HSPG_test.asm

ORG 0
	START:
	IN 		Switches
	OUT 	LEDs
	OUT 	SERVO_CTRL
	JUMP 	START
	
; IO address constants
Switches: 	 EQU 000
LEDs:     	 EQU 001
Timer:    	 EQU 002
Hex0:     	 EQU 004
Hex1:      	 EQU 005
SERVO_CTRL:	 EQU &H0030
