; An empty asm file ...

ORG 0
	START: 
	IN	   Switches
	STORE  Value
	LOAD   Value
    AND    Bit8  		;check if SW8 is up
    JPOS   ANGLE_MODE 	;SW8 not up: pulse time mode
    JUMP   PULSE_MODE	;SW8 up: angle functionality
    
	PULSE_MODE:
	LOADI  0
	STORE  Hex1			;don't output time of day for pulse mode
	JUMP END
	
    ANGLE_MODE:
	LOAD   Value
	AND    Bit7			;mask first 8 bits
	ADDI   -45			;determine time of day based on angle of solar panel
	JZERO  ANGLE_7AM 	
	JNEG   ANGLE_7AM
	ADDI   -15
	JNEG   ANGLE_10AM
	JZERO  ANGLE_10AM
	ADDI   -15
	JNEG   ANGLE_11AM
	JZERO  ANGLE_11AM
	ADDI   -15
	JNEG   ANGLE_12PM
	JZERO  ANGLE_12PM
	ADDI   -15
	JNEG   ANGLE_1PM
	JZERO  ANGLE_1PM
	ADDI   -15
	JNEG   ANGLE_2PM
	JZERO  ANGLE_2PM
	ADDI   -15
	JNEG   ANGLE_3PM
	JZERO  ANGLE_3PM
	JUMP   ANGLE_7PM
	
	ANGLE_7AM: 
	LOADI   7
	STORE  Hex1
	JUMP   END

	ANGLE_10AM: 
	LOADI   10
	STORE  Hex1
	JUMP   END
	
	ANGLE_11AM: 
	LOADI   11
	STORE  Hex1
	JUMP   END
	
	ANGLE_12PM:
	LOADI   12
	STORE  Hex1
	JUMP   END
	
	ANGLE_1PM: 
	LOADI   13
	STORE  Hex1
	JUMP   END
	
	ANGLE_2PM: 
	LOADI   14
	STORE  Hex1
	JUMP   END
	
	ANGLE_3PM:
	LOADI   15
	STORE  Hex1
	JUMP   END
	
	ANGLE_7PM: 
	LOADI   19
	STORE  Hex1
	JUMP   END
	
    END: 
    OUT    Hex1			;output to Hex display
    LOADI  0
	OUT    Hex0
    LOAD   Value
	OUT	   SERVO_CTRL	;output to peripheral
	JUMP   START		;keep looping
	
; IO address constants
Switches:  EQU 000
LEDs:      EQU 001
Timer:     EQU 002
Hex0:      EQU 004
Hex1:      EQU 005
SERVO_CTRL: EQU &H0030	;peripheral address
Value: DW 0
Bit7: DW &B0011111111
Bit8: DW &B0100000000

