


;
;	'E'+80H	enum
;	'L'+80H	label
;	'M'+80H	member
;	'S'+80H	struct/union
;	'p'+80H	macro param

;
ADD_POST_ESI:
	PUSH	ESI
	PUSH	EAX
	JMP	ADD_POST.10

;
;
ADD_POST:
	PUSH	ESI
	MOV	ESI,WORD_WORK
	PUSH	EAX
ADD_POST.10:
	LODSB
	OR	AL,AL
	JNE	ADD_POST.10
	POP	EAX
	DEC	ESI		;###
	MOV	[ESI],AL
	INC	ESI
	MOV	BYTE [ESI],0

	POP	ESI
	RET

;
CUT_POST_ESI:
	PUSH	ESI
	JMP	CUT_POST.10

;
;
CUT_POST:
	PUSH	ESI
	MOV	ESI,WORD_WORK
CUT_POST.10:
	LODSB
	OR	AL,AL
	JNE	CUT_POST.10


	DEC	ESI
	DEC	ESI
		MOV	AL,[ESI]
	MOV	BYTE [ESI],0
	POP	ESI
	RET

;
;
;

DECLARE:
	CALL	IS_TYPENAME
	JE	DECLARE.10
	MOV	BYTE [FLG.EXTRN],0
	MOV	BYTE [FLG.STATIC],0
	MOV	BYTE [FLG.UNSIGNED],0
	MOV	EBX,[TYPE_INT]
	JMP	DECLARE.20
DECLARE.10:
	CALL	TYPENAME
DECLARE.20:
	MOV	AX,[WORD_WORK]
	CMP	AX,';'
	JE	DECLARE.R	;for struct abc { } / enum <name> { };
	JMP	_INT.06

DECLARE.R:
	CALL	GET_WORD
	RET



;DECLARE.10:
;	PUSH	EBX
;	CALL	DEF
;	POP	EBX
;	MOV	[ESI+NODE2],EBX
;
;	MOV	AX,[WORD_WORK]
;	CMP	AX,';'
;	JE	DECLARE.50
;	MOV	AX,','
;	CALL	SKIP_WORD
;	JMP	DECLARE.10
;
;DECLARE.50:
;	MOV	AX,';'
;	CALL	SKIP_WORD
;	RET

;
;	>CF=0:typename(>AX:type)
;

IS_TYPENAME:
	MOV	ESI,WORD_WORK

;	MOV	EDI,WORD_ENUM
;	CALL	STRCMP
;	JE	IS_TYPENAME.10

	MOV	EDI,WORD_SHORT
	CALL	STRCMP
	JE	IS_TYPENAME.10

	MOV	EDI,WORD_INT
	CALL	STRCMP
	JE	IS_TYPENAME.10

	MOV	EDI,WORD_CHAR
	CALL	STRCMP
	JE	IS_TYPENAME.10

	MOV	EDI,WORD_LONG
	CALL	STRCMP
	JE	IS_TYPENAME.10

		MOV	EDI,WORD_FLOAT
		CALL	STRCMP
		JE	IS_TYPENAME.10
		MOV	EDI,WORD_DOUBLE
		CALL	STRCMP
		JE	IS_TYPENAME.10

	MOV	EDI,WORD_VOID
	CALL	STRCMP
	JE	IS_TYPENAME.10

	MOV	EDI,WORD_ENUM
	CALL	STRCMP
	JE	IS_TYPENAME.10

	MOV	EDI,WORD_STRUCT
	CALL	STRCMP
	JE	IS_TYPENAME.10

	MOV	EDI,WORD_UNION
	CALL	STRCMP
	JE	IS_TYPENAME.10

		CALL	IS_CPP
		JNE	IS_TYPENAME.NTCPP
		MOV	EDI,WORD_CLASS
		CALL	STRCMP
		JE	IS_TYPENAME.10
IS_TYPENAME.NTCPP:

	MOV	EDI,WORD_EXTRN
	CALL	STRCMP
	JE	IS_TYPENAME.10

	MOV	EDI,WORD_AUTO
	CALL	STRCMP
	JE	IS_TYPENAME.10

	MOV	EDI,WORD_STATIC
	CALL	STRCMP
	JE	IS_TYPENAME.10

	MOV	EDI,WORD_REGISTER
	CALL	STRCMP
	JE	IS_TYPENAME.10

	MOV	EDI,WORD_CONST
	CALL	STRCMP
	JE	IS_TYPENAME.10

	MOV	EDI,WORD_SIGNED
	CALL	STRCMP
	JE	IS_TYPENAME.10

	MOV	EDI,WORD_UNSIGNED
	CALL	STRCMP
	JE	IS_TYPENAME.10

	MOV	AX,[WORD_WORK]
	CALL	IS_CCHR_F
	JNE	IS_TYPENAME.N

	CALL	SEARCH_WORD
	JB	IS_TYPENAME.N	;10

	MOV	ESI,EBX
	MOV	EBX,[EBX+NODE2]
		cmp	ebx,100h
		jb	is_typename.n
	MOV	EBX,[EBX+NODE1]

		;	MOV	AX,[EBX]
		;	CMP	AX,'{'
		;	JNE	IS_TYPENAME.NTCLASS
		;	MOV	EAX,[ESI+NODE2]
		;	CMP	DWORD [EAX+NODE4],1
		;	JNE	IS_TYPENAME.NTCLASS
		;	JMP	IS_TYPENAME.10
IS_TYPENAME.NTCLASS:

	MOV	AX,[EBX]
	CMP	AX,'ty'+8080H
	JE	IS_TYPENAME.10

IS_TYPENAME.N:
	JMP	MAKE_NZ

IS_TYPENAME.10:
	JMP	MAKE_ZR


;
;
;
TYPENAME:
	MOV	BYTE [FLG.EXTRN],0
	MOV	BYTE [FLG.REGISTER],0
	MOV	BYTE [FLG.STATIC],0
	MOV	BYTE [FLG.UNSIGNED],0

	;PUSHAD
	;CALL	DISP
	;DB	'<typename$'
	;POPAD
;	CALL	DISP_WORD
;	JMP	TYPENAME.20

TYPENAME.10:
	MOV	ESI,WORD_WORK

	MOV	EDI,WORD_CONST
	CALL	STRCMP
	JE	TYPENAME.CONST

	MOV	EDI,WORD_SHORT
	CALL	STRCMP
	MOV	EBX,0082H	;0002H
	;JE	TYPENAME.E
	JE	TYPENAME.SHORT

	MOV	EDI,WORD_INT
	CALL	STRCMP
	MOV	EBX,[TYPE_INT]
	JE	TYPENAME.E

	MOV	EDI,WORD_CHAR
	CALL	STRCMP
	MOV	EBX,0001H
	JE	TYPENAME.E

	MOV	EDI,WORD_LONG
	CALL	STRCMP
	MOV	EBX,0084H	;0004H
	JE	TYPENAME.LONG

		MOV	EDI,WORD_FLOAT
		CALL	STRCMP
		JE	TYPENAME.FLOAT
		MOV	EDI,WORD_DOUBLE
		CALL	STRCMP
		JE	TYPENAME.DOUBLE

	MOV	EDI,WORD_VOID
	CALL	STRCMP
	MOV	EBX,0000H
	JE	TYPENAME.E

	MOV	EDI,WORD_ENUM
	CALL	STRCMP
	JE	TYPENAME.ENUM

	MOV	EDI,WORD_STRUCT
	CALL	STRCMP
	JE	TYPENAME.STRUCT

	MOV	EDI,WORD_UNION
	CALL	STRCMP
	JE	TYPENAME.UNION

		CALL	IS_CPP
		JNE	TYPENAME.NTCPP
		MOV	EDI,WORD_CLASS
		CALL	STRCMP
		JE	TYPENAME.CLASS
TYPENAME.NTCPP:

	MOV	EDI,WORD_EXTRN
	CALL	STRCMP
	JE	TYPENAME.EXTRN

	MOV	EDI,WORD_AUTO
	CALL	STRCMP
	JE	TYPENAME.AUTO

	MOV	EDI,WORD_STATIC
	CALL	STRCMP
	JE	TYPENAME.STATIC

	MOV	EDI,WORD_REGISTER
	CALL	STRCMP
	JE	TYPENAME.REGISTER

	MOV	EDI,WORD_SIGNED
	CALL	STRCMP
	JE	TYPENAME.SIGNED

	MOV	EDI,WORD_UNSIGNED
	CALL	STRCMP
	JE	TYPENAME.UNSIGNED
TYPENAME.20:
	CALL	SEARCH_WORD	;typedef name?
	JB	TYPENAME.ERR

	MOV	EBX,[EBX+NODE2]
		cmp	ebx,100h
		jb	typename.25

		;	PUSH	EBX
		;	MOV	EBX,[EBX+NODE1]
		;	MOV	AX,[EBX]
		;	POP	EBX
		;	CMP	AX,'{'
		;	JNE	TYPENAME.NTCLASS
		;	CMP	DWORD [EBX+NODE4],1
		;	JNE	TYPENAME.NTCLASS
		;	;JMP	TYPENAME.30
		;	CALL	GET_WORD
		;	RET
TYPENAME.NTCLASS:

	PUSH	EBX
	MOV	EBX,[EBX+NODE1]
	MOV	AX,[EBX]
	POP	EBX
	CMP	AX,'ty'+8080H
	JE	TYPENAME.30
typename.25:
	RET

TYPENAME.30:
	CALL	GET_WORD
	MOV	EBX,[EBX+NODE2]
	RET

TYPENAME.REGISTER:
	MOV	BYTE [FLG.REGISTER],0FFH
	JMP	TYPENAME.CONST

TYPENAME.EXTRN:
	MOV	BYTE [FLG.EXTRN],0FFH

TYPENAME.CONST:
	CALL	GET_WORD
	CALL	IS_TYPENAME
	JNE	ERR_TYPE

	JMP	TYPENAME.10


TYPENAME.AUTO:
	JMP	TYPENAME.REGISTER

TYPENAME.STATIC:
	MOV	BYTE [FLG.STATIC],0FFH
	;JMP	TYPENAME.REGISTER
	JMP	TYPENAME.CONST

TYPENAME.FLOAT:
TYPENAME.DOUBLE:
	MOV	EBX,00C4H	;sign|real|4byte
	CALL	GET_WORD
	RET

TYPENAME.SHORT:
	CALL	GET_WORD
	MOV	ESI,WORD_WORK
	MOV	EDI,WORD_INT
	CALL	STRCMP
	JE	TYPENAME.SHORTINT
	RET

TYPENAME.SHORTINT:
	CALL	GET_WORD
	MOV	EBX,0082H
	RET

TYPENAME.LONG:
	CALL	GET_WORD
	MOV	ESI,WORD_WORK
	MOV	EDI,WORD_INT
	CALL	STRCMP
	JE	TYPENAME.LONGINT
	RET

TYPENAME.LONGINT:
	CALL	GET_WORD
	MOV	EBX,0084H
	RET

TYPENAME.SIGNED:
	CALL	GET_WORD
		MOV	ESI,WORD_WORK
		MOV	EDI,WORD_CHAR
		CALL	STRCMP
		JE	TYPENAME.SIGNED.CHAR
	JMP	ERR_SYNTAX

TYPENAME.SIGNED.CHAR:
	CALL	GET_WORD
	MOV	EBX,0081H
	RET

TYPENAME.UNSIGNED:
	CALL	GET_WORD
	MOV	ESI,WORD_WORK
	MOV	EDI,WORD_LONG
	CALL	STRCMP
	JE	TYPENAME.UNSIGNED.LONG
	MOV	EDI,WORD_INT
	CALL	STRCMP
	JE	TYPENAME.UNSIGNED.INT
	MOV	EDI,WORD_SHORT
	CALL	STRCMP
	JE	TYPENAME.UNSIGNED.SHORT
	MOV	EDI,WORD_CHAR
	CALL	STRCMP
	JE	TYPENAME.UNSIGNED.CHAR
	MOV	EBX,[TYPE_UINT]
	RET

TYPENAME.UNSIGNED.LONG:
		CALL	GET_WORD
		MOV	ESI,WORD_WORK
		MOV	EDI,WORD_INT
		CALL	STRCMP
		JE	TYPENAME.UNSIGNED.LONG.INT
	MOV	EBX,0004H
	;CALL	GET_WORD
	RET
TYPENAME.UNSIGNED.LONG.INT:
	CALL	GET_WORD
	MOV	EBX,0004H
	RET

TYPENAME.UNSIGNED.INT:
	MOV	EBX,[TYPE_UINT]
	CALL	GET_WORD
	RET
TYPENAME.UNSIGNED.SHORT:
		CALL	GET_WORD
		MOV	ESI,WORD_WORK
		MOV	EDI,WORD_INT
		CALL	STRCMP
		JNE	TYPENAME.UNSIGNED.SHORT.1
		CALL	GET_WORD
TYPENAME.UNSIGNED.SHORT.1:
	MOV	EBX,0002H
	;CALL	GET_WORD
	RET

TYPENAME.UNSIGNED.CHAR:
	MOV	EBX,0001H
	CALL	GET_WORD
	RET


TYPENAME.ERR:
	CMP	BYTE [FLG.UNSIGNED],0
	JE	TYPENAME.ERR2
	MOV	EBX,0082H
	JMP	TYPENAME.E

TYPENAME.ERR2:
	CMP	EBX,0FFFFFFFFH
	JE	TYPENAME.ERR3
	RET

TYPENAME.ERR3:
	CALL	DISP_CON
	DB	'err:typename$'
	JMP	MAIN_E.ERR

TYPENAME.ENUM:
	CALL	ENUM
	RET

TYPENAME.STRUCT:
	MOV	BYTE [STRUCT_UNION],0
	CALL	STRUCT
	RET

TYPENAME.UNION:
	MOV	BYTE [STRUCT_UNION],0FFH
	CALL	STRUCT
	RET

TYPENAME.CLASS:
	MOV	BYTE [STRUCT_UNION],1
	CALL	STRUCT
	RET

TYPENAME.E:
	CALL	GET_WORD
	RET



;
;
;

ENUM:
;	PUSHAD
;	CALL	DISP_CON
;	DB	'enum$'
;	POPAD

	MOV	DWORD [ENUM_NAME],0

	MOV	DWORD [ENUM_NO],0

	CALL	GET_WORD	;skip 'enum'
	MOV	AX,[WORD_WORK]
	CMP	AX,'{'
	JE	ENUM.20

	MOV	AX,[WORD_WORK]
	CALL	IS_CCHR_F
	JNE	ERR_SYNTAX

	MOV	AL,'E'+80H
	CALL	ADD_POST

	CALL	SEARCH_WORD
	JNB	ENUM.DCL

	CALL	SET_WORD1
	MOV	ESI,EBX
	MOV	AX,'EN'+8080H
	CALL	MAKE_WORD1
	MOV	[ESI+NODE2],EBX

	CALL	GET_WORD
	MOV	AX,[WORD_WORK]
	CMP	AX,'{'
	JE	ENUM.20
	JMP	ERR_SYNTAX

ENUM.DCL:
	MOV	ESI,EBX
	MOV	EBX,[ESI+NODE2]
	CMP	EBX,100H
	JB	ERR_TYPE_ENUM
	MOV	EAX,[EBX+NODE1]
	MOV	AX,[EAX]
	CMP	AX,'EN'+8080H
	JNE	ERR_TYPE_ENUM

	CALL	GET_WORD

	MOV	EBX,[TYPE_INT]
	RET

	JMP	ERR_SYNTAX

ENUM.20:
	MOV	AX,'{'
	CALL	SKIP_WORD
ENUM.30:
	MOV	AL,[WORD_WORK]
	CALL	IS_CCHR_F
	JNE	ERR_SYNTAX

	;CALL	SET_WORD1
		MOV	ECX,NODESIZE_ENUM_NAME
		CALL	SET_WORD1

	PUSH	EBX
	MOV	AX,'{{'
	;CALL	MAKE_WORD1
		MOV	ECX,NODESIZE_ENUM_PARPAR
		CALL	MAKE_WORD
	MOV	ESI,EBX
	POP	EBX
	MOV	[EBX+NODE2],ESI

	CALL	GET_WORD
	MOV	AX,[WORD_WORK]
	CMP	AX,'='
	JNE	ENUM.40

	PUSH	EBX
	MOV	AX,'='
	CALL	SKIP_WORD

	PUSH	ESI
	CALL	EXP_CONST
	POP	ESI

	MOV	EAX,EBX
	POP	EBX
	JMP	ENUM.45

	JMP	ERR_SYNTAX

ENUM.40:
	MOV	EAX,[ENUM_NO]
ENUM.45:
	MOV	[ESI+NODE4],EAX

;	INC	DWORD [ENUM_NO]
	INC	EAX
	MOV	[ENUM_NO],EAX

ENUM.50:
	MOV	AX,[WORD_WORK]
	CMP	AX,'}'
	JE	ENUM.80
	MOV	AX,','
	CALL	SKIP_WORD

	MOV	AX,[WORD_WORK]	;##	allow ,}
	CMP	AX,'}'
	JE	ENUM.80

	JMP	ENUM.30

ENUM.80:
	MOV	AX,'}'
	CALL	SKIP_WORD

	MOV	EBX,[TYPE_INT]
	RET



;
;	:STRUCT
;
;	W1:node '{'
;	W2:node '{'/name1/name2/.. to link
;	W3:name
;	W4:struct level
;	W5:struct/union
;
;	W6:1 if imperfect reference
;
;	W7:bit offset
;	W8:flags
;	&01:bit field
;	&02:last was bit field
;	W9:size
;	W10:class name

STRUCT:
	PUSH	DWORD [FLG.EXTRN]
	PUSH	DWORD [FLG.STATIC]

	PUSH	EBP
	MOV	EBP,ESP
	SUB	ESP,4*10

;	MOV	DWORD [STRUCT_LEVEL],0
	MOV	DWORD [EBP+W4],0	;struct_level

	mov	byte [ebp+W6],0

		MOV	DWORD [EBP+W7],0	;bit offset
		MOV	DWORD [EBP+W8],0	;flags
		MOV	DWORD [EBP+W9],0	;size

	MOV	AL,[STRUCT_UNION]
		MOVZX	EAX,AL
	MOV	[EBP+W5],EAX	;AL

	CALL	GET_WORD	;skip 'struct'
	CMP	AX,'{'
	MOV	ESI,0
	JE	STRUCT.PAR

;			CMP	BYTE [EBP+W5],1
;			JE	STRUCT.03

			CMP	BYTE [EBP+W5],1
			JNE	STRUCT.025
			PUSHAD
			MOV	ESI,WORD_WORK
			MOV	EDI,CLASS_NAME
			CALL	STRCPY
			POPAD
STRUCT.025:
		MOV	AL,'S'+80H
		CALL	ADD_POST
STRUCT.03:

	CALL	SEARCH_WORD
	JB	STRUCT.20

;	struct found_name

	MOV	EDI,EBX		;name
	MOV	EBX,[EBX+NODE2]	;node '{'

	CALL	GET_WORD
	MOV	AX,[WORD_WORK]
	CMP	AX,'{'
	JNE	STRUCT.R

;	struct name {

	mov	esi,edi		;name

	mov	byte [ebp+W6],2
	jmp	struct.par

	CALL	DISP_CON
	DB	'duplicate struct$'
	JMP	MAIN_E.ERR

;	struct new_name

STRUCT.20:
;				struct/union name is global
;	CMP	BYTE [FLG.STRUCT],0
;	JNE	STRUCT.25

	CALL	SET_WORD1_N
;	MOV	[STRUCT_NAME],EBX
		MOV	[EBP+W10],EBX
	MOV	ESI,EBX

;	esi:struct name

	mov	byte [ebp+W6],0

	cmp	byte [word_work],'{'
	je	struct.par

	mov	byte [ebp+W6],1

	JMP	STRUCT.PAR

STRUCT.25:
	;CALL	SET_WORD1_MEMBER
		MOV	AL,'M'+80H
		CALL	ADD_POST
		CALL	SET_WORD1

	CALL	GET_WORD
;	MOV	[STRUCT_NAME],EBX
	MOV	ESI,EBX

	MOV	AX,[WORD_WORK]
	CMP	AX,'{'
	JE	STRUCT.PAR

	MOV	EDI,ESI		;name

	MOV	AX,'{'
	CALL	MAKE_WORD1
	MOV	AL,[EBP+W5]	;[STRUCT_UNION]
	MOV	[EBX+NODE4],AL

	JMP	STRUCT.R

;	struct name {

STRUCT.PAR:
	cmp	byte [ebp+W6],1
	je	struct.par.05

	pushad
	MOV	AX,'{'
	CALL	SKIP_WORD
	popad

	cmp	byte [ebp+W6],2
	je	struct.par.06


struct.par.05:
	MOV	AX,'{'
	CALL	MAKE_WORD1
struct.par.06:
	MOV	AL,[EBP+W5]	;[STRUCT_UNION]
	MOV	[EBX+NODE4],AL

		MOV	EAX,[EBP+W10]
		MOV	[EBX+NODE6],EAX	;class name

	OR	ESI,ESI
	JE	STRUCT.PAR.10
	MOV	[ESI+NODE2],EBX	;name > node '{'
STRUCT.PAR.10:
	MOV	[EBP+W1],EBX
	MOV	[EBP+W2],EBX

	cmp	byte [ebp+W6],1
	je	struct.rpar.05

STRUCT.L1:

	PUSH	DWORD [FLG.STRUCT]
	MOV	BYTE [FLG.STRUCT],0FFH
	CALL	DEF2		;>eax:typename
	MOV	ECX,EAX
	POP	DWORD [FLG.STRUCT]

	MOV	[EBP+W3],EDI	;name


STRUCT.L2:
	MOV	BYTE [IS_SAMEOFF],0
	MOV	BYTE [IS_BITFIELD],0

;	and eax,~2/inc eax/and eax,3 is same

	MOV	EBX,[EBP+W8]	;flags
	MOV	EAX,EBX
	AND	EBX,0FFFFFFFFH-3
	SHL	EAX,1
	AND	EAX,2		;lastwasbitfield=bitfield
	OR	EBX,EAX
	MOV	[EBP+W8],EBX

	PUSHAD
	MOV	AX,[WORD_WORK]
	CMP	AX,':'
	JNE	STRUCT.NBIT
	CALL	GET_WORD

	MOV	AL,[WORD_WORK]
	CALL	IS_NUMBER
	JNE	ERR_SYNTAX

	MOV	EDX,ECX
	AND	EDX,80H

		PUSH	EDX
		CALL	EXP_CONST
		POP	EDX
		CMP	EBX,1
		JL	ERR_NUMBER
		CMP	EBX,32
		JG	ERR_NUMBER

		MOV	EAX,0001H
		CMP	EBX,8
		JBE	STRUCT.BIT.10

		MOV	EAX,0002H
		CMP	EBX,16
		JBE	STRUCT.BIT.10

		MOV	EAX,0004H

STRUCT.BIT.10:
	OR	EDX,EAX

		;	JMP	STRUCT.BIT.20

			CMP	BYTE [FLG.B],0
			JE	STRUCT.BIT.20

			CMP	EDX,0001H
			JNE	STRUCT.BIT.20

		;	MOV	EAX,[EBP+W8]	;flags
		;	TEST	EAX,2
		;	JNE	STRUCT.BIT.13
		;	ADD	DWORD [EBP+W9],1	;size

STRUCT.BIT.13:
			MOV	AX,'bt'+8080H
			CALL	MAKE_WORD1
			MOV	[EBX+NODE2],EDX

			OR	DWORD [EBP+W8],1	;bitfield

			MOV	BYTE [IS_SAMEOFF],1

			MOV	EAX,[EBP+W7]
			INC	DWORD [EBP+W7]
			CMP	EAX,7
			JBE	STRUCT.BIT.15
			MOV	EAX,0
			MOV	DWORD [EBP+W7],0
			ADD	DWORD [EBP+W4],1	;level
			ADD	DWORD [EBP+W9],1	;size

		;	MOV	BYTE [IS_SAMEOFF],0
STRUCT.BIT.15:
			MOV	[EBX+NODE3],EAX		;bit offset

			MOV	EDX,EBX
STRUCT.BIT.20:
	MOV	EAX,[EBP+W3]
	MOV	[EAX+NODE2],EDX

	MOV	BYTE [IS_BITFIELD],1
	JMP	STRUCT.BIT.E

STRUCT.NBIT:

STRUCT.BIT.E:
	POPAD

	MOV	ESI,[EBP+W3]	;name	;[NAME_PNT]	;#
	MOV	EAX,[EBP+W4]	;[STRUCT_LEVEL]
	MOV	[ESI+NODE7],EAX

	;	JMP	STRUCT.LASTWASBITE

		MOV	EAX,[EBP+W8]	;flags
		AND	EAX,3
		CMP	EAX,00B
		JE	STRUCT.LASTWASBITE
		CMP	EAX,01B
		JE	STRUCT.L2.10

		CMP	EAX,10B
		JE	STRUCT.LASTWASBIT
		CMP	EAX,11B
		JE	STRUCT.L2.10
STRUCT.LASTWASBIT:
	;	CMP	DWORD [EBP+W7],8
	;	JE	STRUCT.LASTWASBITE

		ADD	DWORD [EBP+W4],1	;level
		ADD	DWORD [EBP+W9],1	;size
		ADD	DWORD [ESI+NODE7],1
STRUCT.LASTWASBITE:
	MOV	DWORD [EBP+W7],0

	PUSH	ECX
	MOV	ESI,[EBP+W3]	;name	;[NAME_PNT]	;#
		MOV	ESI,[ESI+NODE2]	;#####
	CALL	SIZEOF_DS
	POP	ECX

	CMP	BYTE [EBP+W5],0FFH	;struct/union
	JE	STRUCT.L2.5	;STRUCT.L2.10
	ADD	[EBP+W4],EDX	;level

		ADD	[EBP+W9],EDX	;size
		JMP	STRUCT.L2.10
STRUCT.L2.5:
	CMP	[EBP+W9],EDX
	JNB	STRUCT.L2.10
	MOV	[EBP+W9],EDX

STRUCT.L2.10:

	MOV	EBX,[EBP+W2]	;prev name
	MOV	EAX,[EBP+W3]	;name	;[NAME_PNT]
	MOV	[EBX+NODE3],EAX

	MOV	AX,[WORD_WORK]
	CMP	AX,';'
	JE	STRUCT.L1.E

		CMP	BYTE [IS_BITFIELD],0
		JNE	ERR_SYNTAX

	MOV	AX,','
	CALL	SKIP_WORD

	MOV	EAX,[EBP+W3]	;name	;[NAME_PNT]
	MOV	[EBP+W2],EAX

	PUSH	ECX
	PUSH	DWORD [FLG.STRUCT]
	MOV	BYTE [FLG.STRUCT],0FFH
	CALL	DEF
	POP	DWORD [FLG.STRUCT]
	POP	ECX
	MOV	[ESI+NODE2],ECX	;typename

	MOV	[EBP+W3],EDI	;name

	JMP	STRUCT.L2


STRUCT.L1.E:
	MOV	AX,';'
	CALL	SKIP_WORD

	MOV	AX,[WORD_WORK]
	CMP	AX,'}'
	JE	STRUCT.RPAR

	MOV	EAX,[EBP+W3]	;name	;[NAME_PNT]
	MOV	[EBP+W2],EAX
	JMP	STRUCT.L1


STRUCT.RPAR:
	MOV	AX,'}'
	CALL	SKIP_WORD

		CALL	STRUCT_ADJ
		MOV	EBX,[EBP+W1]
	;	MOV	EAX,[EBP+W4]	;level
		MOV	EAX,[EBP+W9]	;size
		MOV	[EBX+NODE5],EAX

struct.rpar.05:
	MOV	EBX,[EBP+W1]	;node '{'

STRUCT.R:
	CMP	BYTE [EBP+W5],1
	JNE	STRUCT.R.10
		CALL	MAKE_CLASS_TYPEDEF
STRUCT.R.10:

	ADD	ESP,4*10
	POP	EBP

	;MOV	[NAME_PNT],EBX
	POP	DWORD [FLG.STATIC]
	POP	DWORD [FLG.EXTRN]
	RET

;
STRUCT_ADJ:
		MOV	EAX,[EBP+W8]	;flags
		AND	EAX,3

		TEST	EAX,1
		JE	STRUCT.ADJE

	;	CMP	DWORD [EBP+W7],8
	;	JE	STRUCT.ADJ8

	;	ADD	DWORD [EBP+W4],1	;level
		ADD	DWORD [EBP+W9],1	;size
		JMP	STRUCT.ADJE

STRUCT.ADJ8:
;		CMP	DWORD [EBP+W9],0	;size
;		JNE	STRUCT.ADJE
;		MOV	DWORD [EBP+W9],1	;size

STRUCT.ADJE:

		RET
;
MAKE_CLASS_TYPEDEF:
	PUSH	ECX

	PUSH	EBX

	MOV	EBX,CLASS_NAME
	MOV	ECX,NODESIZE
	CALL	SET_WORD_GLOBAL_BX
	PUSH	EBX

	MOV	AX,'ty'+8080H
	CALL	MAKE_WORD1
	POP	ESI
	MOV	[ESI+NODE2],EBX
	MOV	ESI,EBX

	POP	EBX
	MOV	[ESI+NODE2],EBX

	POP	ECX
	RET
;
;	(typename) def
;
;	>EAX:typename
;	[NAME_PNT]:name
;

DEF2:
	CALL	IS_TYPENAME
	JB	ERR_SYNTAX

	CALL	TYPENAME
DEF2.10:
	PUSH	EBX
	CALL	DEF
	POP	EAX
	MOV	[ESI+NODE2],EAX

	RET

;
;REGISTER_EDI:DS	4

;
;
;
;	ebx:type
;

_INT.06:
	PUSH	EBP
	MOV	EBP,ESP
	SUB	ESP,4*8

	MOV	[EBP+W1],EBX	;def_type

_INT.10:
		MOV	DWORD [DEF_FNC_NAME],0

	CALL	DEF		;>edi:name
	MOV	[EBP+W2],EDI	;name

		JMP	_INT.SAMENAME.E

		PUSHAD
		MOV	EBX,[EDI+NODE1]
		PUSH	EBX
		MOV	DWORD [EDI+NODE1],DUMMY_STR
		PUSH	EDI

		PUSH	EDI
		MOV	ESI,WORD_WORK
		MOV	EDI,WORD_WORK2
		CALL	STRCPY
		POP	EDI
		PUSH	EDI
		MOV	ESI,EBX		;[EDI+NODE1]
		MOV	EDI,WORD_WORK
		CALL	STRCPY

		CALL	SEARCH_WORD
		POP	EDI
		JB	_INT.SAMELVL

		CMP	EDI,[WORD_WORK_GLOBAL_SAVE]
		SBB	AH,AH
		CMP	EBX,[WORD_WORK_GLOBAL_SAVE]
		SBB	AL,AL
		CMP	AH,AL
		JNE	_INT.SAMELVL

		POP	EDI
		PUSH	EDI

		MOV	EAX,[EDI+NODE2]
		CMP	EAX,100H
		JB	_INT.SAMELVL.10
		MOV	EAX,[EAX+NODE1]
		MOV	AX,[EAX]
		CMP	AX,'('
		JE	_INT.SAMELVL

_INT.SAMELVL.10:
		PUSHAD
		CALL	DISP_CON
		DB	'same var$'
		POPAD

_INT.SAMELVL:
		MOV	ESI,WORD_WORK2
		MOV	EDI,WORD_WORK
		CALL	STRCPY

		POP	EDI
		POP	DWORD [EDI+NODE1]
		POPAD
_INT.SAMENAME.E:
		OR	DWORD [EDI+NODE9],04H	;referd
		CMP	BYTE [FLG.EXTRN],0
		JNE	_INT.10.01
		OR	DWORD [EDI+NODE9],01H	;defined
_INT.10.01:
		CMP	BYTE [FLG.A],0
		JE	_INT.NOTREG
		CMP	BYTE [FLG.REGISTER],0
		JE	_INT.NOTREG

		CMP	DWORD [REGISTER_EDI],0
		JNE	_INT.NOTREG
		OR	DWORD [EDI+NODE9],100H
		MOV	[REGISTER_EDI],EDI

_INT.NOTREG:
	MOV	EAX,[EBP+W1]
	MOV	[ESI+NODE2],EAX

_INT.10.1:


	cmp	byte [FLG.STATIC],0
	je	_int.10.2

		MOV	EBX,1		;###test for bug
		JMP	_INT.10.10

	CMP	DWORD [EDI+NODE6],0
	JNE	_INT.10.2
	;TEST	DWORD [EDI+NODE6],1
	;JNE	_INT.10.2

	;call	make_label
		CALL	MAKE_LABEL_STATIC	;#####

_INT.10.10:
	mov	[edi+NODE6],ebx

_int.10.2:
	MOV	AX,[WORD_WORK]
	CMP	AX,'{'
	JE	_INT.FUNC

	MOV	EBX,[EDI+NODE2]
	CMP	EBX,100H
	JB	_INT.11

	MOV	EBX,EDI
	CALL	IS_FUNC_NAME
	;JE	_INT.20
	JE	_INT.FUNC.0

_INT.11:
	MOV	EBX,[FUNC_PNT]	;current func
	MOV	[EDI+NODE8],EBX
	OR	EBX,EBX
	JE	_INT.12

		cmp	byte [flg.extrn],0ffh
		je	_int.12		;###

;	local

	MOV	ESI,EDI

	CMP	BYTE [FLG.STATIC],0FFH
	JE	_INT.11.STATIC

	PUSH	EDI
		MOV	ESI,[ESI+NODE2]	;#####
	CALL	SIZEOF_DS
	POP	EDI

	SUB	[LOCAL_LEVEL],EDX
	MOV	EBX,[LOCAL_LEVEL]
	MOV	[EDI+NODE7],EBX

	mov	ax,[word_work]
	cmp	ax,'='
	je	_int.local.init
	JMP	_INT.20

_int.local.init:
		PUSHAD
		MOV	EBX,[EBP+W2]	;name
		MOV	EBX,[EBX+NODE2]
		CMP	EBX,100H
		JB	_INT.LOCAL.INIT.ARY.E
		MOV	EAX,[EBX+NODE1]
		CMP	EBX,100H
		JB	_INT.LOCAL.INIT.ARY.E
		MOV	AX,[EAX]
		CMP	AX,'['
		JE	ERR_TYPE

_INT.LOCAL.INIT.ARY.E:

		POPAD

;	push	DWORD [NAME_PNT]
	PUSH	EDI

	call	get_word	;skip '='
	;call	exp
		CALL	EXP_L	;
	call	cond_to_arith	;#

		pop	eax
		push	eax
		mov	edx,ecx
		mov	ecx,[eax+NODE2]
		call	castif

	mov	ax,'='
	call	make_word1_exp
	mov	[ebx+NODE3],esi
	mov	esi,ebx

	pop	ebx
	mov	[esi+NODE2],ebx

	mov	eax,[func_init_exp_top]
	cmp	eax,-1
	jne	_int.local.init.10

	call	mk
	jmp	_int.20

_int.local.init.10:
	mov	ax,'i='
	call	make_word1

	mov	ecx,[func_init_exp]
	or	ecx,ecx
	je	_int.local.init.20

	mov	[ecx+NODE3],ebx
	mov	[ebx+NODE2],esi
	mov	[func_init_exp],ebx
	jmp	_int.local.init.50

_int.local.init.20:
	mov	[ebx+NODE2],esi
	mov	[func_init_exp],ebx
	mov	[func_init_exp_top],ebx

_int.local.init.50:
	jmp	_int.20

_INT.11.STATIC:

;	global
_INT.12:
	MOV	AX,[WORD_WORK]
	CMP	AX,'='
	jne	_int.15

	MOV	EDI,[EBP+W2]
	call	_init
	jmp	_int.20

_int.15:
	CMP	BYTE [FLG.EXTRN],0
	JNE	_INT.20

	MOV	ESI,[EBP+W2]	;name
	CALL	PRINT_GLOBAL_DS

_INT.20:

	MOV	AX,[WORD_WORK]
	CMP	AX,';'
	JE	_INT.E
	MOV	AX,','
	CALL	SKIP_WORD
	JMP	_INT.10

_INT.FUNC.0:
		PUSHAD
		AND	DWORD [EDI+NODE9],0FFFFFFFFH-01H	;defined
		POPAD

	MOV	ESI,[DEF_FNC_NAME]
	CALL	CLEAR_FUNC2
	JMP	_INT.20

_INT.FUNC:
	CALL	_FUNC
	JMP	_INT.R

_INT.E:
	CALL	GET_WORD	;skip ';'
_INT.R:
	ADD	ESP,4*8
	POP	EBP
	RET

;
;	edi:name
;

_init:
	mov	[name_pnt],edi

	CALL	GET_WORD	;skip '='

		CALL	PRINT_ALIGN4

	PUSH	DWORD [NAME_PNT]
	call	print
	db	'%n:',0dh,0ah,'$'

	MOV	ESI,[NAME_PNT]
	MOV	ESI,[ESI+NODE2]
_init.10:
	CMP	ESI,100H
	JB	_INIT.SIMPLE

	MOV	EBX,[ESI+NODE1]
	MOV	AX,[EBX]
	CMP	AX,'*'
	JE	_INIT.SIMPLE

	CMP	AX,'['
	je	_INIT.ARY.0

	cmp	ax,'{'
	je	_init.struct

	jmp	err_type

;	array

_INIT.ARY.0:
	MOV	ECX,[ESI+NODE2]
	CMP	ECX,0001H
	JE	_INIT.DQ
	CMP	ECX,0081H
	JE	_INIT.DQ

	MOV	AX,[WORD_WORK]
	CMP	AX,'{'
	JE	_init.ary
		jmp	_init.ary	;test
	JMP	ERR_SYNTAX

_INIT.DQ:
	MOV	AX,[WORD_WORK]
	CMP	AX,'"'
	je	_init.dq2
	jmp	_init.ary


_INIT.SIMPLE:
	mov	al,09h
	call	putchr

	PUSH	DWORD [WORD_WORK_EXP_INFO+INFO2]
	PUSH	DWORD [WORD_WORK_EXP_INFO+INFO3]

	push	esi
	push	esi
	mov	eax,esi
	call	print_type
	pop	esi
	CALL	EXP_CONST
	pop	ecx
	CALL	MK_CONST

	POP	DWORD [WORD_WORK_EXP_INFO+INFO3]
	POP	DWORD [WORD_WORK_EXP_INFO+INFO2]

	CALL	PRINT_CRLF
_init.r:
	ret

_init.struct:
	MOV	DL,[ESI+NODE4]	;struct/union

		MOV	DH,0;1
		MOV	AX,[WORD_WORK]
		CMP	AX,'{'
		JNE	_INIT.STRUCT.LPARE

	mov	ax,'{'
	call	skip_word
		MOV	DH,1

_INIT.STRUCT.LPARE:

;	jmp	_init.struct.20
	mov	esi,[esi+NODE3]

_init.struct.10:
	PUSH	EDX
	push	esi
	mov	esi,[esi+NODE2]	;member to type
	call	_init.10
	pop	esi
	POP	EDX
	OR	DL,DL
	JNE	_INIT.STRUCT.80	;if union

	mov	esi,[esi+NODE3]	;from below

	mov	ax,[word_work]
	cmp	ax,'}'
	je	_init.struct.80

_init.struct.20:
	;;mov	esi,[esi+NODE3]	;to above
	or	esi,esi
	je	_init.struct.75	;80

	mov	ax,','
	call	skip_word
	mov	ax,[word_work]
	cmp	ax,'}'
	je	_init.struct.80
	jmp	_init.struct.10

_init.struct.75:
		CMP	DH,0
		JE	_INIT.STRUCT.80
	mov	ax,[word_work]
	cmp	ax,'}'
	je	_init.struct.80
	mov	ax,','
	call	skip_word

_init.struct.80:
		CMP	DH,0
		JE	_INIT.STRUCT.RPARE
	mov	ax,'}'
	call	skip_word
_INIT.STRUCT.RPARE:
		OR	DL,DL
		JNE	_INIT.STRUCT.86

		OR	ESI,ESI
		JNE	_INIT.STRUCT.90
		JMP	_init.r

_INIT.STRUCT.86:
	PUSH	ESI
	MOV	ESI,[ESI+NODE2]
	CALL	SIZEOF
	POP	ESI

	PUSH	EDX
	MOV	ECX,EDX

_INIT.STRUCT.87:
	MOV	ESI,[ESI+NODE3]
	OR	ESI,ESI
	JE	_INIT.STRUCT.88
	PUSH	ECX
	PUSH	ESI
	MOV	ESI,[ESI+NODE2]
	CALL	SIZEOF
	POP	ESI
	POP	ECX
	CMP	EDX,ECX
	JBE	_INIT.STRUCT.871
	MOV	ECX,EDX
_INIT.STRUCT.871:
	JMP	_INIT.STRUCT.87

_INIT.STRUCT.88:
	POP	EDX
	SUB	EDX,ECX
	JNB	_INIT.STRUCT.89

	NEG	EDX
	MOV	EBX,EDX
	CALL	PRINT
	DB	'	DS	%L',0DH,0AH,'$'

_INIT.STRUCT.89:
	jmp	_init.r

_INIT.STRUCT.90:
	PUSH	ESI
	MOV	ESI,[ESI+NODE2]
	CALL	SIZEOF

	MOV	EBX,EDX
	CALL	PRINT
	DB	'	DS	%D',0DH,0AH,'$'
	POP	ESI
	MOV	ESI,[ESI+NODE3]
	OR	ESI,ESI
	JNE	_INIT.STRUCT.90
	JMP	_init.r

;	esi:node '['

_init.ary:
	mov	bl,0
	mov	ax,[word_work]
	cmp	ax,'{'
	jne	_init.ary.05

	mov	ax,'{'
	call	skip_word
	mov	bl,1
_init.ary.05:
	push	ebx

	mov	ebx,[esi+NODE3]	;node '00'
	cmp	ebx,-1
	je	_init.ary.06
	mov	ebx,[ebx+NODE4]	;number
_init.ary.06:

	mov	ecx,0
_init.ary.10:
	push	ebx
	push	ecx
	push	esi
	mov	esi,[esi+NODE2]
	call	_init.10
	pop	esi
	pop	ecx
	pop	ebx
	inc	ecx

	cmp	ecx,ebx
	jnb	_init.ary.50

	mov	ax,[word_work]
	cmp	ax,'}'
	je	_init.ary.50

	mov	ax,','
	call	skip_word
	mov	ax,[word_work]
	cmp	ax,'}'
	je	_init.ary.50

	jmp	_init.ary.10

_init.ary.50:
	pop	ebx
	or	bl,bl
	je	_init.ary.55

	mov	ax,[word_work]
	cmp	ax,'}'
	je	_init.ary.51
	mov	ax,','
	call	skip_word
_init.ary.51:
	mov	ax,'}'
	call	skip_word
_init.ary.55:

	mov	ebx,[esi+NODE3]
	cmp	ebx,-1
	je	_init.ary.set
	mov	ebx,[ebx+NODE4]	;number
	sub	ebx,ecx
	jnb	_init.ary.80

	pushad
	call	disp_con
	db	'array over$'
	popad
;	mov	ebx,0

_init.ary.80:
		PUSH	ESI
	push	ebx
		MOV	ESI,[ESI+NODE2]	;##
	call	sizeof
	mov	eax,edx
	pop	ebx
	mul	ebx
	mov	ebx,eax
		POP	ESI

	call	print_ds
	jmp	_init.r

_init.ary.set:
	push	esi
	mov	edx,ecx
	call	make_word_no
	pop	esi
	mov	[esi+NODE3],ebx
	mov	ebx,0
	jmp	_init.ary.80


_init.dq2:
		PUSH	ESI

	PUSH	DWORD [STRING_PNT]
	PUSH	DWORD [WORD_WORK_EXP_INFO+INFO2]
	PUSH	DWORD [WORD_WORK_EXP_INFO+INFO3]
	PUSH	DWORD [WORD_WORK_GLOBAL_INFO+INFO2]
	PUSH	DWORD [WORD_WORK_GLOBAL_INFO+INFO3]
	CALL	EXP_CONST
	POP	DWORD [WORD_WORK_GLOBAL_INFO+INFO3]
	POP	DWORD [WORD_WORK_GLOBAL_INFO+INFO2]
	POP	DWORD [WORD_WORK_EXP_INFO+INFO3]
	POP	DWORD [WORD_WORK_EXP_INFO+INFO2]
		;MOV	EAX,[STRING_PNT]
	POP	ESI
	MOV	[STRING_PNT],ESI

		;SUB	EAX,ESI
		;NEG	EAX
		;PUSH	EAX

	push	esi
	call	print
	db	'	db	$'
	mov	ebx,esi
	call	print_str
	pop	esi
	;call	strlen
	CALL	STRLEN_PACK
	INC	ECX		;to be cut? for char[4]="abcd" is right
		;POP	ECX

		POP	ESI
	;mov	esi,[name_pnt]
	;mov	esi,[esi+NODE2]	;node '['

	mov	ebx,[esi+NODE3]	;node '00'
	cmp	ebx,-1
	je	_init.dq2.20
	mov	ebx,[ebx+NODE4]	;number

	sub	ebx,ecx
	jae	_init.dq2.10

	pushad
	call	disp_con
	db	'string over array size$'
	popad
	mov	ebx,0

_init.dq2.10:
	call	print_ds
	jmp	_init.r


;	auto set size
;	ecx:len

_init.dq2.20:
	push	esi
	mov	edx,ecx
	call	make_word_no
	pop	esi
	mov	[esi+NODE3],ebx

	mov	ebx,0		;just fit
	jmp	_init.dq2.10


;
;	ebx:size
;

print_ds:
	or	ebx,ebx
	JG	PRINT_DS.10
	JE	PRINT_DS.20

	PUSHAD
	CALL	DISP_CON
	DB	06H,'	ds<=0$'
	JMP	ERR_OTHERS
	POPAD
	JMP	PRINT_DS.E

PRINT_DS.10:
	call	print
	db	0dh,0ah
	db	'	ds	%L',0dh,0ah,'$'
	JMP	PRINT_DS.E

PRINT_DS.20:
	PUSHAD
	CALL	DISP_CON
	DB	'	ds=0$'
	POPAD

print_ds.e:
	ret


;
;	>ecx:len(0~)
;
strlen:
	mov	ecx,0
	cld
strlen.10:
	inc	ecx
	lodsb
	or	al,al
	jne	strlen.10

	ret

;
;
;
TYPE_NAME:
	PUSH	EBX
	MOV	EBX,[EBX+NODE1]
	MOV	AX,[EBX]
	POP	EBX
	CALL	IS_CCHR_F
	JNE	TYPE_NAME.50
	MOV	EBX,[EBX+NODE2]
TYPE_NAME.50:
	RET

;
;
;
TYPE_ARY:
	PUSH	EBX
	MOV	EBX,[EBX+NODE1]
	MOV	AX,[EBX]
	POP	EBX
	CMP	AX,'['
	JNE	TYPE_ARY.50
	MOV	EBX,[EBX+NODE2]
	JMP	TYPE_ARY

TYPE_ARY.50:
	RET

;
;	ESI:type/node
;
PRINT_TYPE:

	CMP	EAX,0001H
	MOV	EBX,STR_DB
	JE	PRINT_TYPE.10
	CMP	EAX,0081H
	JE	PRINT_TYPE.10

	CMP	EAX,0002H
	MOV	EBX,STR_DW
	JE	PRINT_TYPE.10
	CMP	EAX,0082H
	JE	PRINT_TYPE.10

	CMP	EAX,0004H
	MOV	EBX,STR_DD
	JE	PRINT_TYPE.10
	CMP	EAX,0084H
	JE	PRINT_TYPE.10

	MOV	EBX,STR_DD
	CMP	EAX,00C4H
	JE	PRINT_TYPE.10

	MOV	EBX,STR_DW	;pointer
	CALL	IS_L
	JNE	PRINT_TYPE.10
	MOV	EBX,STR_DD

PRINT_TYPE.10:
	PUSH	EAX
	CALL	PUT_STRZ
	POP	EAX
	RET

