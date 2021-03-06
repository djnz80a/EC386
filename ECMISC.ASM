#INCLUDE <FLOAT30.CLB>


IS_FUNC_NAME:
	CMP	EBX,100H
	JB	MAKE_NZ
	MOV	EBX,[EBX+2*4]
	CMP	EBX,100H
	JB	MAKE_NZ
	MOV	EBX,[EBX+2*2]

	MOV	AX,[EBX]
	CMP	AX,'('
	RET

;
IS_ARRAY_NAME:
	CMP	EBX,100H
	JB	MAKE_NZ

	MOV	EBX,[EBX+2*4]
	CMP	EBX,100H
	JB	MAKE_NZ
IS_ARRAY:
	MOV	EBX,[EBX+2*2]

	MOV	AX,[EBX]
	CMP	AX,'['
	RET

;

IS_STRUCT:

IS_STRUCT_NAME:
	CMP	EBX,100H
	JB	MAKE_NZ
	MOV	EBX,[EBX+2*4]
	CMP	EBX,100H
	JB	MAKE_NZ
	MOV	EBX,[EBX+2*2]

	MOV	AX,[EBX]
	CMP	AX,'{'
	RET

;	let
IS_OPT1:
	PUSH	EAX
	MOV	EAX,[FLG.OPT]
	NOT	EAX
	TEST	EAX,1
	POP	EAX
	RET

;	if
IS_OPT2:
	PUSH	EAX
	MOV	EAX,[FLG.OPT]
	NOT	EAX
	TEST	EAX,2
	POP	EAX
	RET

;	add sub and or xor
IS_OPT4:
	PUSH	EAX
	MOV	EAX,[FLG.OPT]
	NOT	EAX
	TEST	EAX,4
	POP	EAX
	RET

;	mul
IS_OPT8:
	PUSH	EAX
	MOV	EAX,[FLG.OPT]
	NOT	EAX
	TEST	EAX,8
	POP	EAX
	RET
;use [EBX+offset]
IS_OPT10:
	PUSH	EAX
	MOV	EAX,[FLG.OPT]
	NOT	EAX
	TEST	EAX,10H
	POP	EAX
	RET
;shl shr
IS_OPT20:
	PUSH	EAX
	MOV	EAX,[FLG.OPT]
	NOT	EAX
	TEST	EAX,20H
	POP	EAX
	RET

;
IS_CPP:
	CMP	BYTE [FLG.CPP],0FFH
	RET

;

IS_OPT:
	CMP	BYTE [FLG.OPT],0FFH
	RET

IS_L:
	CMP	BYTE [FLG.L],0FFH
	RET

;

IS_OCTCHR:
	CMP	AL,'0'
	JB	MAKE_NZ
	CMP	AL,'7'
	JBE	MAKE_ZR

	JMP	MAKE_NZ

;

IS_HEXCHR:
	CMP	AL,'0'
	JB	MAKE_NZ
	CMP	AL,'F'
	JA	MAKE_NZ

	CMP	AL,'9'
	JBE	MAKE_ZR
	CMP	AL,'A'
	JAE	MAKE_ZR

	JMP	MAKE_NZ

;

HEXCHRTO:
	SUB	AL,'0'
	CMP	AL,10
	JB	HEXCHRTO.10
	SUB	AL,7
HEXCHRTO.10:
	RET


;
;
;
TOLOWER:
	CMP	AL,'A'
	JB	_RET
	CMP	AL,'Z'
	JA	_RET
	ADD	AL,20H
	RET

;
;
;
TOUPPER:
	CMP	AL,'a'
	JB	_RET
	CMP	AL,'z'
	JA	_RET
	SUB	AL,20H
	RET


;
;	>ZF:(1:[A-Za-z])
;

IS_ALPHA:
	CMP	AL,'A'
	JB	IS_ALPHA.NE
	CMP	AL,'Z'
	JBE	IS_ALPHA.E
	CMP	AL,'a'
	JB	IS_ALPHA.NE
	CMP	AL,'z'
	JBE	IS_ALPHA.E

IS_ALPHA.NE:
	JMP	MAKE_NZ

IS_ALPHA.E:
	JMP	MAKE_ZR


;
;
;
IS_COND:
	MOV	EBX,[ESI+2*2]
	MOV	AX,[EBX]

IS_COND_WORD:
	CMP	AX,'!'
	JE	IS_COND.Y
	CMP	AX,'=='
	JE	IS_COND.Y
	CMP	AX,'=!'
	JE	IS_COND.Y
	CMP	AX,'&&'
	JE	IS_COND.Y
	CMP	AX,'||'
	JE	IS_COND.Y
	CMP	AX,'>'
	JE	IS_COND.Y
	CMP	AX,'>='
	JE	IS_COND.Y
	CMP	AX,'=>'
	JE	IS_COND.Y
	CMP	AX,'<'
	JE	IS_COND.Y
	CMP	AX,'<='
	JE	IS_COND.Y
	CMP	AX,'=<'
	JE	IS_COND.Y

IS_COND.N:
	JMP	MAKE_NZ

IS_COND.Y:
	JMP	MAKE_ZR



;

MAKE_ZR:
	;	CMP	AX,AX
	PUSH	EAX
	XOR	AX,AX
	POP	EAX
	RET

MAKE_NZ:
	PUSH	EAX	;or	esp,esp
	XOR	AX,AX
	INC	AX
	POP	EAX
	RET


;
;
;
IS_CCHR_F:
	CALL	IS_ALPHA
	JE	IS_CCHR_F.Y
	CMP	AL,'_'
	JE	IS_CCHR_F.Y

	JMP	MAKE_NZ

IS_CCHR_F.Y:
	JMP	MAKE_ZR

;

IS_CCHR.0:
	CALL	IS_ALPHA
	JE	IS_CCHR.Y
	CALL	IS_NUMBER
	JE	IS_CCHR.Y
	CMP	AL,'_'
	JE	IS_CCHR.Y

	JMP	MAKE_NZ

IS_CCHR.Y:
	JMP	MAKE_ZR

;
;	AL:chr
;	>ZF=1:'0'~'9'
;

IS_NUMBER:
	CMP	AL,'0'
	JB	MAKE_NZ
	CMP	AL,'9'
	JA	MAKE_NZ

	JMP	MAKE_ZR


;
;
;

IS_SEPARATOR.0:
	CMP	AL,' '
	JE	IS_SEPARATOR.E
	CMP	AL,09H
	JE	IS_SEPARATOR.E
	CMP	AL,0DH
	JE	IS_SEPARATOR.E
	CMP	AL,0AH
	JE	IS_SEPARATOR.E

		CMP	AL,0CH
		JE	IS_SEPARATOR.E	;###

IS_SEPARATOR.E:
	RET


;
;
;
	ALIGN	4

STRCMP:
	MOV	AL,[ESI]
	CMP	AL,[EDI]
	JE	SHORT STRCMP.0
	RET

STRCMP.0:
	PUSH	ESI
	PUSH	EDI

	;DEC	ESI
	DEC	EDI
STRCMP.10:
	;INC	ESI
	INC	EDI
	;MOV	AL,[ESI]
		LODSB
	;MOV	AH,ES:[EDI]
		MOV	AH,[EDI]
	OR	AL,AL
	JE	SHORT STRCMP.20
	CMP	AL,AH
	JE	SHORT STRCMP.10

STRCMP.20:
	OR	AH,AL

	POP	EDI
	POP	ESI
	RET

;
;
;

STRCPY2:
	CLD
STRCPY2.10:
	LODSB
	CMP	AL,20H
	JE	STRCPY2.20
	CMP	AL,'/'
	JE	STRCPY2.20
	STOSB
	OR	AL,AL
	JNE	STRCPY2.10
	RET
STRCPY2.20:
	XOR	AL,AL
	STOSB
	RET

;
;
;

STRCPY:	CLD
STRCPY.10:
	LODSB
	STOSB
	OR	AL,AL
	JNE	STRCPY.10
	RET

STRCPY.20:
	XOR	AL,AL
	STOSB
	RET

;
;
STRCAT:
	LODSB
	OR	AL,AL
	JNE	STRCAT
	DEC	ESI

	XCHG	ESI,EDI
STRCAT.10:
	LODSB
	STOSB
	OR	AL,AL
	JNE	STRCAT.10
	RET

;
STRCHR:
	MOV	AH,[ESI]
	CMP	AH,AL
	JE	STRCHR.Y
	OR	AH,AH
	JE	STRCHR.N
	INC	ESI
	JMP	STRCHR

STRCHR.N:
	XOR	ESI,ESI

STRCHR.Y:
	RET

;

_RET:	RET

;
;
;

DOS09:	MOV	AH,09H
	INT	21H
	RET


;	esi:adrs of decimal string
;	<eax:#
;	<esi:next of decimal char
;
;	?edx
;
GETDEC:
	PUSH	EBX
	XOR	EDX,EDX
GETDEC.10:
	XOR	EAX,EAX
	LODSB
	CALL	TOUPPER
	SUB	AL,'0'
	JB	GETDEC.E
	CMP	AL,10
	JNB	GETDEC.E
GETDEC.20:
	MOV	EBX,EDX
	SHL	EDX,2
	ADD	EDX,EBX
	SHL	EDX,1
	ADD	EDX,EAX
	JMP	GETDEC.10

GETDEC.E:
	DEC	ESI
	MOV	EAX,EDX
	POP	EBX
	RET

;
;	ESI:string
;	>EAX:no
;

GETOCT:
	XOR	EDX,EDX
GETOCT.10:
	XOR	EAX,EAX
	LODSB
	SUB	AL,'0'
	JB	GETOCT.E
	CMP	AL,7
	JA	GETOCT.E
	SHL	EDX,3
	OR	DL,AL
	JMP	GETOCT.10
GETOCT.E:
	DEC	ESI
	MOV	EAX,EDX
	RET


;	esi:adrs of hex string
;	>eax:#
;	>esi:next of hex char
;
;	?edx
;
GETHEX:
	XOR	EDX,EDX
GETHEX.10:
	XOR	EAX,EAX
	LODSB
	CALL	TOUPPER
	SUB	AL,'0'
	JB	GETHEX.E
	CMP	AL,10
	JB	GETHEX.20
	SUB	AL,7
	CMP	AL,10
	JB	GETHEX.E
	CMP	AL,10H
	JNB	GETHEX.E
GETHEX.20:
	SHL	EDX,4
	ADD	EDX,EAX
	JMP	GETHEX.10

GETHEX.E:
	DEC	ESI
	MOV	EAX,EDX
	RET

;
;
;

GETCLINE:
	JMP	GETCLINE_win

	PUSH	DS
	MOV	AX,DS
	MOV	ES,AX

	MOV	AX,4
	MOV	DS,AX

	MOV	ESI,0080H
	MOV	EDI,CLINE
	MOV	ECX,80H
	CLD
	REP
	MOVSB
	POP	DS

	MOV	ESI,CLINE
	MOV	EDI,ESI
	CLD
	LODSB
	XOR	ECX,ECX
	MOV	CL,AL
	INC	EDI
	ADD	EDI,ECX

	XOR	EAX,EAX
	STOSB
	RET

GETCLINE_win:
	PUSH	DS
	MOV	AX,DS
	MOV	ES,AX

	;MOV	AX,4
	;MOV	DS,AX

	MOV	ESI,[CMDLINE]
GETCLINE_win.10:
	MOV	AL,[ESI]
	OR	AL,AL
	JE	GETCLINE_win.20
	CMP	AL,' '
	JBE	GETCLINE_win.20
	INC	ESI
	JMP	GETCLINE_win.10

GETCLINE_win.20:

;	;MOV	ESI,0080H
;	MOV	EDI,CLINE
;	MOV	ECX,80H
;	CLD
;	REP
;	MOVSB

	MOV	EDI,CLINE
GETCLINE_win.30:
	MOV	AL,[ESI]
	CMP	AL,20h
	JB	GETCLINE_win.40
	MOV	[EDI],AL
	INC	ESI
	INC	EDI
	OR	AL,AL
	JMP	GETCLINE_win.30

GETCLINE_win.40:
	MOV	AL,0
	MOV	[EDI],AL

	INC	EDI
	MOV	[EDI],AL
	INC	EDI
	MOV	[EDI],AL

	POP	DS

	RET

	MOV	ESI,CLINE
	MOV	EDI,ESI
	CLD
	LODSB
	XOR	ECX,ECX
	MOV	CL,AL
	INC	EDI
	ADD	EDI,ECX

	XOR	EAX,EAX
	STOSB
	RET



