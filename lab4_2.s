;----------------------------------------------------------------------------------
;-- (c) Rajesh Panicker
;--	License terms :
;--	You are free to use this code as long as you
;--		(i) DO NOT post it on any public repository;
;--		(ii) use it only for educational purposes;
;--		(iii) accept the responsibility to ensure that your implementation does not violate any intellectual property of ARM Holdings or other entities.
;--		(iv) accept that the program is provided "as is" without warranty of any kind or assurance regarding its suitability for any particular purpose;
;--		(v) send an email to rajesh.panicker@ieee.org briefly mentioning its use (except when used for the course CG3207 at the National University of Singapore);
;--		(vi) retain this notice in this file or any files derived from this.
;----------------------------------------------------------------------------------

	AREA    MYCODE, CODE, READONLY, ALIGN=9 
   	  ENTRY
	  
; ------- <code m  emory (ROM mapped to Instruction Memory) begins>
; Total number of instructions should not exceed 127 (126 excluding the last line 'halt B halt').

;	STR R5,[R11];      ;stores data of R5 in the address of R11 .i.e it displays it in led
GOTO
 	LDR R3,DELAY_VAL;
	LDR R11,LEDS;
	LDR R4,DELAY_VAL1; ;Loads the data at the address or DELAY_vaL1 into R4
	LDR R0,DELAY_VAL4;
	NOP;
	NOP;
	NOP;
	AND R0,R4,R3;
	ORR R1,R4,R3;
	ADD R5,R4,R3;
	SUB R6,R4,R3;
	NOP;
	NOP;
	NOP;
	CMN R6,R5;
	CMP R6,R5;
	LDR R10,DELAY_VAL2;
	ADD R0,R4,R3,LSL #05;
	NOP;
	LDR R11,LEDS;
	ADD R0,R4,R3,LSR #05;
	ADD R0,R4,R3,ASR #05;
	ADD R0,R4,R3,ROR #05;
	ADC R0,R4,R3;
	LDR R2,DELAY_VAL3;
;	MUL R6,R4,R3;
;	MLA R6,R4,R3,R2;

	BIC R0,R4,R3;
	EOR R0,R4,R3;
	MOV R0,R4;
	MVN R0,R4;
	RSB R0,R4,R3;
	NOP;
	NOP;
	NOP;
	RSC R0,R4,R3;
	SBC R0,R4,R3;
	TEQ R4,R3;
	TST R4,R3;
	STR R0,[R11];
	STR R0,[R11];
	B GOTO


halt	
		B    halt           ; infinite loop to halt computation. // A program should not "terminate" without an operating system to return control to
							; keep halt	B halt as the last line of your code.
; ------- <\code memory (ROM mapped to Instruction Memory) ends>


	AREA    CONSTANTS, DATA, READONLY, ALIGN=9 
; ------- <constant memory (ROM mapped to Data Memory) begins>
; All constants should be declared in this section. This section is read only (Only LDR, no STR).
; Total number of constants should not exceed 128 (124 excluding the 4 used for peripheral pointers).
; If a variable is accessed multiple times, it is better to store the address in a register and use it rather than load it repeatedly.

;Peripheral pointers
LEDS
		DCD 0x00000C00		; Address of LEDs. //volatile unsigned int * const LEDS = (unsigned int*)0x00000C00;  
DIPS
		DCD 0x00000C04		; Address of DIP switches. //volatile unsigned int * const DIPS = (unsigned int*)0x00000C04;
PBS
		DCD 0x00000C08		; Address of Push Buttons. Used only in Lab 2
CONSOLE
		DCD 0x00000C0C		; Address of UART. Used only in Lab 2 and later
CONSOLE_IN_valid
		DCD 0x00000C10		; Address of UART. Used only in Lab 2 and later
CONSOLE_OUT_ready
		DCD 0x00000C14		; Address of UART. Used only in Lab 2 and later
SEVENSEG
		DCD 0x00000C18		; Address of 7-Segment LEDs. Used only in Lab 2 and later

; Rest of the constants should be declared below.
ZERO
		DCD 0x00000000		; constant 0
LSB_MASK
		DCD 0x000000FF		; constant 0xFF
DELAY_VAL
		DCD 0x0000000A		; delay time.
DELAY_VAL1
		DCD 0x00000009
DELAY_VAL2
		DCD 0x00000005
DELAY_VAL3
		DCD 0x00000000
DELAY_VAL4
		DCD 0x00000000
variable1_addr
		DCD variable1		; address of variable1. Required since we are avoiding pseudo-instructions // unsigned int * const variable1_addr = &variable1;
constant1
		DCD 0xABCD1234		; // const unsigned int constant1 = 0xABCD1234;
string1   
		DCB  "\r\nWelcome to CG3207..\r\n",0	; // unsigned char string1[] = "Hello World!"; // assembler will issue a warning if the string size is not a multiple of 4, but the warning is safe to ignore
stringptr
		DCD string1			;
		
; ------- <constant memory (ROM mapped to Data Memory) ends>	


	AREA   VARIABLES, DATA, READWRITE, ALIGN=9
; ------- <variable memory (RAM mapped to Data Memory) begins>
; All variables should be declared in this section. This section is read-write.
; Total number of variables should not exceed 128. 
; No initialization possible in this region. In other words, you should write to a location before you can read from it (i.e., write to a location using STR before reading using LDR).

variable1
		DCD 0x00000000		;  // unsigned int variable1;
; ------- <variable memory (RAM mapped to Data Memory) ends>	

		END	
		
;const int* x;         // x is a non-constant pointer to constant data
;int const* x;         // x is a non-constant pointer to constant data 
;int*const x;          // x is a constant pointer to non-constant data
		