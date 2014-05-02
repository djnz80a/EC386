
;
;	not expand macro in block #if 0 { .. } #endif
;



;#define FLAG
;#if FLAG || 0
;	be
;#if || 0
;	error!
;

;	DI:macro param

MACRO:
;	JMP	MACRO.LPAR

		PUSH	EDI
		PUSH	ESI
		MOV	ESI,WORD_WORK
		MOV	EDI,WORD_WORK3
		CALL	STRCPY

		CALL	GET_WORD3
		POP	ESI
		POP	EDI

		MOV	AX,[WORD_WORK]
		CMP	AX,'('
		JE	MACRO.LPAR.1

			MOV	AL,[CHR_WORK]
			CALL	UNGETC
		MOV	ESI,WORD_WORK
		CALL	UNGETS
		CALL	GET_NCHR

		MOV	ESI,WORD_WORK3
		MOV	EDI,WORD_WORK
		CALL	STRCPY
		JMP	GET_WORD4.R

MACRO.LPAR:
		PUSH	EDI
		PUSH	ESI
	CALL	GET_WORD3
		POP	ESI
		POP	EDI
MACRO.LPAR.1:
	PUSH	DS
	POP	ES

	PUSH	DWORD [STRING_MACRO_PNT]
	MOV	BYTE [FLG.SET_STRING_MACRO],0FFH

	PUSH	ESI		;macro string

	;CALL	GET_WORD3
	MOV	AX,[WORD_WORK]
	CMP	AX,'('
	JNE	ERR_MACRO_LPAR
MACRO.10:
	CALL	MACRO_PARAM	;	get param to WORD_WORK3

	PUSH	EDI

	PUSH	DS
	PUSH	ES
	MOV	AX,DS
	MOV	ES,AX
	MOV	ESI,[EDI+NODE1]
	MOV	EDI,WORD_WORK
	MOV	DS,[STRING_MACRO_SEG]
	CALL	STRCPY
	POP	ES
	POP	DS

	CALL	SET_WORD1_MACRO_PARAM
	MOV	EDI,EBX

	MOV	AX,'FD'
	CALL	MAKE_WORD1_MACRO_PARAM
	MOV	[EDI+NODE2],EBX
	PUSH	EDI	;#
	PUSH	EBX
	MOV	EBX,WORD_WORK3
	CALL	SET_STRING_MACRO
	POP	ESI
	POP	EDI	;#
	MOV	[ESI+NODE2],EBX

	POP	EDI

	MOV	EDI,[EDI+NODE3]
	OR	EDI,EDI
	JE	MACRO.50

	MOV	AL,[CHR_WORK]
	CMP	AL,','
	;JNE	ERR_MACRO	;SYNTAX
	JNE	ERR_MACRO_ARG_CNT
	CALL	GET_WORD3
	JMP	MACRO.10

MACRO.50:
	MOV	AL,[CHR_WORK]
	CMP	AL,')'
	;JNE	ERR_SYNTAX
	JNE	ERR_MACRO_ARG_CNT

	POP	ESI	;macro string
	MOV	ES,[STRING_MACRO_SEG]

	MOV	EDI,MACRO_WORD_WORK
	MOV	ECX,0
	DEC	ECX
MACRO.60:
	INC	ECX
	CMP	ECX,MACRO_WORD_WORK_SIZE
	JNB	ERR_MACRO_MEM	;ERR_MACRO
	MOV	AL,ES:[ESI]
	MOV	[EDI],AL
	INC	ESI
	INC	EDI
	OR	AL,AL
	JNE	MACRO.60

	PUSH	DS
	POP	ES

	OR	ECX,ECX
	JE	MACRO.80

	CALL	CNV_MACRO

	PUSH	DS
	POP	ES
	MOV	ESI,MACRO_WORD_WORK2
	CALL	UNGETS

MACRO.80:

	CALL	GET_NCHR
	CALL	GET_WORD4	;3

	MOV	BYTE [FLG.SET_STRING_MACRO],0
	POP	DWORD [STRING_MACRO_PNT]
	JMP	GET_WORD4.R
;

CNV_MACRO:
	MOV	ESI,MACRO_WORD_WORK
	MOV	EDI,MACRO_WORD_WORK2
	MOV	DL,0
CNV_MACRO.10:
	CMP	EDI,MACRO_WORD_WORK2+MACRO_WORD_WORK2_SIZE
	JNB	ERR_MACRO_EXP_MEM;ERR_MACRO_MEM	;ERR_MACRO

	LODSB
	OR	AL,AL
	JE	CNV_MACRO.50

	CALL	IS_CCHR_F
	JE	MACRO_P

	TEST	DL,2
	JE	CNV_MACRO.15

	CMP	AL,20H
	JE	CNV_MACRO.14
	CMP	AL,09H
	JE	CNV_MACRO.14

	MOV	EBX,MACRO_WORD_WORK2
	CALL	BACK_SPACE
	XOR	DL,2
	JMP	CNV_MACRO.15
CNV_MACRO.14:
	JMP	CNV_MACRO.10

CNV_MACRO.15:

	TEST	DL,1
	JNE	CNV_MACRO.30

	CMP	AL,'#'
	JNE	CNV_MACRO.30
	CMP	BYTE [ESI],'#'
	JNE	CNV_MACRO.30
	INC	ESI

;	MOV	EBX,MACRO_WORD_WORK2
;	CALL	BACK_SPACE
	OR	DL,2		;after ##

	JMP	CNV_MACRO.10

CNV_MACRO.30:
	CMP	AL,'"'
	JNE	CNV_MACRO.32
	XOR	DL,1		;in dq
CNV_MACRO.32:

	MOV	[EDI],AL
	INC	EDI
	JMP	CNV_MACRO.10

CNV_MACRO.50:
	MOV	BYTE [EDI],0
	RET


MACRO_P:
	TEST	DL,2
	JE	MACRO_P.05

	MOV	EBX,MACRO_WORD_WORK2
	CALL	BACK_SPACE
	XOR	DL,2
MACRO_P.05:

	PUSH	EDI
	MOV	EDI,WORD_WORK
MACRO_P.10:
	MOV	[EDI],AL
	INC	EDI

	LODSB
	CALL	IS_CCHR
	JE	MACRO_P.10
	DEC	ESI
	MOV	BYTE [EDI],0

		PUSHAD
		MOV	AL,'p'+80H
		CALL	ADD_POST
		POPAD


	PUSH	EDX
	CALL	SEARCH_WORD_MACRO_PARAM
	POP	EDX
		PUSHFD
		CALL	CUT_POST
		POPFD
	JB	MACRO_P.50
	POP	EDI

	PUSH	EDX
	PUSH	ESI
	PUSH	ES
	PUSH	DS
	MOV	ESI,[EBX+NODE2]
	MOV	ESI,[ESI+NODE2]
	MOV	AX,DS
	MOV	ES,AX
	MOV	DS,[STRING_MACRO_SEG]
	CALL	STRCPY
	DEC	EDI
	POP	DS
	POP	ES
	POP	ESI
	POP	EDX
	JMP	CNV_MACRO.10
	RET

MACRO_P.50:
	POP	EDI

	MOV	AX,DS
	MOV	ES,AX

	PUSH	ESI
	MOV	ESI,WORD_WORK
	CALL	STRCPY
	DEC	EDI
	POP	ESI
	JMP	CNV_MACRO.10
	RET

;	get param to WORD_WORK3
;	macro('"');... -> param = '"');...

MACRO_PARAM:
	PUSHAD
	MOV	ESI,WORD_WORK3
	MOV	ECX,0
	MOV	DL,0	;parenthesis cnt
	MOV	DH,0	;double quot
MACRO_PARAM.10:
	MOV	AL,[CHR_WORK]
		CMP	AL,1AH
		JE	ERR_SYNTAX
	;OR	DH,DH

	TEST	DH,4
	JNE	MACRO_PARAM.40

	TEST	DH,1
	JNE	MACRO_PARAM.15
	TEST	DH,2
	JNE	MACRO_PARAM.20

	CMP	AL,','
	JNE	MACRO_PARAM.11
	OR	DL,DL
	JE	MACRO_PARAM.50
	JMP	MACRO_PARAM.16

MACRO_PARAM.11:
	CMP	AL,')'
	JNE	MACRO_PARAM.12
	OR	DL,DL
	JE	MACRO_PARAM.50
	DEC	DL
	JMP	MACRO_PARAM.16

MACRO_PARAM.12:
	CMP	AL,'('
	JNE	MACRO_PARAM.15
	INC	DL
	JMP	MACRO_PARAM.16

MACRO_PARAM.15:
	CMP	AL,'\'
	JE	MACRO_PARAM.30
	CMP	AL,'"'
	JNE	MACRO_PARAM.20	;16
	XOR	DH,1
	JMP	MACRO_PARAM.16

MACRO_PARAM.20:
	CMP	AL,'\'
	JE	MACRO_PARAM.30

	CMP	AL,"'"
	JNE	MACRO_PARAM.16

	TEST	DH,1
	JNE	MACRO_PARAM.16
	XOR	DH,2
	JMP	MACRO_PARAM.16

MACRO_PARAM.30:
	OR	DH,4
	jmp	macro_param.16

MACRO_PARAM.40:
	AND	DH,0FFH-4

MACRO_PARAM.16:
	MOV	[ESI],AL
	INC	ESI
	INC	ECX
	CMP	ECX,WORD_WORK3_SIZE	;WORD_WORK3	;&&&
	JNB	ERR_MACRO_PARAM_MEM	;ERR_MACRO

	MOV	BYTE [ESI],0
	PUSH	EDX
	PUSH	ECX
	PUSH	ESI
	CALL	GET_NCHR
	POP	ESI
	POP	ECX
	POP	EDX
	JMP	MACRO_PARAM.10

MACRO_PARAM.50:
		MOV	ESI,WORD_WORK3
		CALL	CUT_SPACE
		MOV	ESI,WORD_WORK3
		CALL	CUT_SPACE_TAIL
	POPAD
	RET



;
BACK_SPACE:
	CMP	EDI,EBX
	JBE	BACK_SPACE.R

	CMP	BYTE [EDI-1],20H
	JE	BACK_SPACE.10
	CMP	BYTE [EDI-1],09H
	JE	BACK_SPACE.10
	JMP	BACK_SPACE.R
BACK_SPACE.10:
	DEC	EDI
	JMP	BACK_SPACE

BACK_SPACE.R:
	RET

;
CUT_SPACE:
	MOV	EDI,ESI
CUT_SPACE.10:
	MOV	AL,[ESI]
	INC	ESI
	CMP	AL,20H
	JE	CUT_SPACE.10
	CMP	AL,09H
	JE	CUT_SPACE.10

	DEC	ESI
CUT_SPACE.30:
	MOV	AL,[ESI]
	MOV	[EDI],AL
	INC	ESI
	INC	EDI
	OR	AL,AL
	JNE	CUT_SPACE.30

	RET
;
CUT_SPACE_TAIL:
	MOV	EDI,ESI
CUT_SPACE_TAIL.10:
	MOV	AL,[ESI]
	INC	ESI
	OR	AL,AL
	JNE	CUT_SPACE_TAIL.10

	DEC	ESI
	DEC	ESI
CUT_SPACE_TAIL.20:
	CMP	ESI,EDI
	JB	CUT_SPACE_TAIL.R

	MOV	AL,[ESI]
	CMP	AL,20H
	JE	CUT_SPACE_TAIL.30
	CMP	AL,09H
	JE	CUT_SPACE_TAIL.30
	RET
CUT_SPACE_TAIL.30:
	MOV	BYTE [ESI],0
	DEC	ESI
	JMP	CUT_SPACE_TAIL.20

CUT_SPACE_TAIL.R:
	RET

PREP2:
	CALL	GET_WORD3	;skip '#'
	CALL	GET_WORD3

PREP:
;	call	get_nchr
	call	get_word3
;	CALL	DISP_CON
;	DB	'<prep>$'

	MOV	ESI,WORD_WORK;+1

	MOV	EDI,WORD_DEFINE
	CALL	STRCMP
	JE	_DEFINE

	MOV	EDI,WORD_UNDEF
	CALL	STRCMP
	JE	_UNDEF

	MOV	EDI,WORD_IFDEF
	CALL	STRCMP
	JE	_#IFDEF
	MOV	EDI,WORD_IFNDEF
	CALL	STRCMP
	JE	_#IFNDEF

	MOV	EDI,WORD_ELSE
	CALL	STRCMP
	JE	_#ELSE

	MOV	EDI,WORD_IF
	CALL	STRCMP
	JE	_#IF

	MOV	EDI,WORD_ENDIF
	CALL	STRCMP
	JE	_#ENDIF

		MOV	EDI,WORD_ELIF
		CALL	STRCMP
		JE	_#ELIF

	MOV	EDI,WORD_INCLUDE
	CALL	STRCMP
	JE	_INCLUDE

		MOV	EDI,WORD_LINE
		CALL	STRCMP
		JE	_#LINE

	JMP	ERR_PREP

	CALL	DISP_CON
	DB	'prep$'
	JMP	MAIN_E.ERR



#EXP:
;	CALL	#EXP.AS
;	RET

	call	#exp.or
	ret

#exp.or:
	call	#exp.and
#exp.or2:
		CMP	BYTE [PREP_EOL],0
		JNE	_RET
	mov	ax,[word_work]
	cmp	ax,'||'
	je	#exp.orm
	ret
#exp.orm:
	call	to_logical
	push	ecx
	call	get_word_prep
	call	#exp.and
	call	to_logical
	pop	eax
	or	ecx,eax

	jmp	#exp.or2
	ret

;

#exp.and:
	;call	#exp.eq
	CALL	#EXP.OR1
#exp.add2:
		CMP	BYTE [PREP_EOL],0
		JNE	_RET
	mov	ax,[word_work]
	cmp	ax,'&&'
	je	#exp.andm
	ret

#exp.andm:
	call	to_logical
	push	ecx
	call	get_word_prep
	;call	#exp.eq
	CALL	#EXP.OR1
	call	to_logical
	pop	eax
	and	ecx,eax

	jmp	#exp.add2
	ret

;
to_logical:
	or	ecx,ecx
	jne	#exp.t
	jmp	#exp.f
;
#EXP.OR1:
	CALL	#EXP.XOR1
#EXP.OR1.10:
		CMP	BYTE [PREP_EOL],0
		JNE	_RET
	MOV	AX,[WORD_WORK]
	CMP	AX,'|'
	JE	#EXP.OR1M
	RET
#EXP.OR1M:
	PUSH	ECX
	CALL	GET_WORD_PREP
	CALL	#EXP.XOR1
	POP	EAX
	OR	ECX,EAX
	JMP	#EXP.OR1.10

;
#EXP.XOR1:
	CALL	#EXP.AND1
#EXP.XOR1.10:
		CMP	BYTE [PREP_EOL],0
		JNE	_RET
	MOV	AX,[WORD_WORK]
	CMP	AX,'^'
	JE	#EXP.XOR1M
	RET
#EXP.XOR1M:
	PUSH	ECX
	CALL	GET_WORD_PREP
	CALL	#EXP.AND1
	POP	EAX
	XOR	ECX,EAX
	JMP	#EXP.XOR1.10

;
#EXP.AND1:
	CALL	#EXP.EQ
#EXP.AND1.10:
		CMP	BYTE [PREP_EOL],0
		JNE	_RET
	MOV	AX,[WORD_WORK]
	CMP	AX,'&'
	JE	#EXP.AND1M
	RET
#EXP.AND1M:
	PUSH	ECX
	CALL	GET_WORD_PREP
	CALL	#EXP.EQ
	POP	EAX
	AND	ECX,EAX
	JMP	#EXP.AND1.10
;

#exp.eq:
	call	#exp.cmp
	mov	edx,#exp.cmp

		CMP	BYTE [PREP_EOL],0
		JNE	_RET
	mov	ax,[word_work]
	cmp	ax,'=='
	je	#exp.eqm
	cmp	ax,'!='
	je	#exp.nteqm
	ret

#exp.eqm:
	call	#exp.2cmp
	je	#exp.t
	jmp	#exp.f

#exp.nteqm:
	call	#exp.2cmp
	jne	#exp.t
	jmp	#exp.f

;

#exp.cmp:
;	call	#exp.term
	CALL	#EXP.SLR
	mov	edx,#exp.SLR	;term

		CMP	BYTE [PREP_EOL],0
		JNE	_RET

	mov	ax,[word_work]
	cmp	ax,'<'
	je	#exp.lt
	cmp	ax,'>'
	je	#exp.gt
	cmp	byte [word_work+2],0
	jne	#exp.cmp.r
	cmp	ax,'<='
	je	#exp.lteq
	cmp	ax,'>='
	je	#exp.gteq
#exp.cmp.r:
	ret

#exp.lt:
	call	#exp.2cmp
	jl	#exp.t
	jmp	#exp.f

#exp.gt:
	call	#exp.2cmp
	jg	#exp.t
	jmp	#exp.f

#exp.lteq:
	call	#exp.2cmp
	jle	#exp.t
	jmp	#exp.f

#exp.gteq:
	call	#exp.2cmp
	jge	#exp.t
	jmp	#exp.f

;

#exp.2cmp:
	push	ecx

	push	edx
	call	get_word_prep
;	CALL	GET_WORD4
	pop	edx

	call	edx
	pop	eax
	cmp	eax,ecx
	ret

#exp.t:
	mov	ecx,1
	ret
#exp.f:
	mov	ecx,0
	ret

;
#EXP.SLR:
	CALL	#EXP.AS
	CMP	BYTE [WORD_WORK+2],0
	JNE	#EXP.SLR.R

		CMP	BYTE [PREP_EOL],0
		JNE	_RET

	MOV	AX,[WORD_WORK]
	CMP	AX,'<<'
	JE	#EXP.SHL
	CMP	AX,'>>'
	JE	#EXP.SHR
#EXP.SLR.R:
	RET

#EXP.SHL:
	PUSH	ECX
	CALL	GET_WORD_PREP
	CALL	#EXP.AS
	POP	EAX
	SHL	EAX,CL
	MOV	ECX,EAX
	RET

#EXP.SHR:
	PUSH	ECX
	CALL	GET_WORD_PREP
	CALL	#EXP.AS
	POP	EAX
	SAR	EAX,CL
	MOV	ECX,EAX
	RET

;
#EXP.AS:
	CALL	#EXP.TERM
		CMP	BYTE [PREP_EOL],0
		JNE	_RET

	MOV	AX,[WORD_WORK]
	CMP	AX,'+'
	JE	#EXP.ADD
	CMP	AX,'-'
	JE	#EXP.SUB
	RET

#EXP.ADD:
	PUSH	ECX
	CALL	GET_WORD_PREP
	CALL	#EXP.TERM
	POP	EAX
	ADD	ECX,EAX
	RET

#EXP.SUB:
	PUSH	ECX
	CALL	GET_WORD_PREP
	CALL	#EXP.TERM
	MOV	EAX,ECX
	POP	ECX
	SUB	ECX,EAX
	RET

;

#EXP.TERM:
	MOV	AX,[WORD_WORK]

	CMP	AX,"'"
	JE	#EXP.SQ

	CMP	AX,'('
	JE	#EXP.PAR

	CMP	AX,'0x'
	JE	#EXP.HEX

	CMP	AL,'0'
	JE	#EXP.OCT

	cmp	AX,'!'
	je	#exp.not

	CMP	AX,'+'
	JE	#EXP.PLUS
	CMP	AX,'-'
	JE	#EXP.MINUS

	CMP	AX,'~'
	JE	#EXP.REV

	CALL	IS_NUMBER
	je	#exp.number

	mov	esi,word_work
	mov	edi,word_defined
	call	strcmp
	je	#exp.defined

	mov	al,[word_work]
	call	is_cchr_f
	jne	err_Syntax

	call	search_word_macro
	pushfd
	call	get_word_prep
	popfd
	jb	#exp.f
	jmp	#exp.t

	call	disp_con
	db	'term$'

	jmp	err_syntax



#EXP.PLUS:
	CALL	GET_WORD_PREP
	CALL	#EXP
	RET

#EXP.MINUS:
	CALL	GET_WORD_PREP
	CALL	#EXP
	NEG	ECX
	RET

#EXP.SQ:
	MOVZX	ECX,[CHR_WORK]
	CMP	CL,'\'
	JE	#EXP.SQ.ESC
	CALL	GET_NCHR
	CALL	GET_NCHR
	CALL	GET_WORD_PREP
	RET

#EXP.SQ.ESC:
	CALL	GET_NCHR
	MOVZX	ECX,[CHR_WORK]
	CMP	CL,'\'
	JNE	ERR_SYNTAX
	CALL	GET_NCHR
	CALL	GET_NCHR
	CALL	GET_WORD_PREP
	RET

#EXP.REV:
	CALL	GET_WORD_PREP
	CALL	#EXP
	NOT	ECX
	RET

#EXP.PAR:
	CALL	GET_WORD_PREP
	CALL	#EXP
	MOV	AX,[WORD_WORK]
	CMP	AX,')'
	JNE	ERR_SYNTAX
	CALL	GET_WORD_PREP
	RET

#exp.not:
	call	get_word_prep
	call	#exp.TERM
	or	ecx,ecx
	mov	ecx,1
	je	#exp.not.r
	mov	ecx,0
#exp.not.r:
	ret

#EXP.OCT:
	PUSH	EDX
	MOV	ESI,WORD_WORK
	CALL	GETOCT
	POP	EDX
	JMP	#EXP.NUMBER.10

#EXP.HEX:
	PUSH	EDX
	MOV	ESI,WORD_WORK+2
	CALL	GETHEX
	POP	EDX
	JMP	#EXP.NUMBER.10

#exp.number:
	PUSH	EDX
	MOV	ESI,WORD_WORK
	CALL	GETDEC
	POP	EDX
#EXP.NUMBER.10:
	MOV	ECX,EAX
	PUSHAD
;	CALL	GET_WORD4
	call	get_word_prep
	POPAD
	RET

#exp.defined:
	call	disp_con
	db	'<defined$'

	call	get_word3

	mov	ax,[word_work]
	cmp	ax,'('
	jne	#exp.defined.05

	call	get_word3

	mov	bl,1
	push	ebx
	jmp	#exp.defined.08

#exp.defined.05:

	mov	bl,0
	push	ebx

#exp.defined.08:
	call	search_word_macro
	mov	ecx,0
	jb	#exp.defined.10
	mov	ecx,1
#exp.defined.10:
	pop	ebx

		mov	al,cl
		add	al,'0'
		mov	[#exp.defined.v1],al

	push	ecx

	or	bl,bl
	je	#exp.defined.20

	call	get_word_prep
	mov	ax,[word_work]
	cmp	ax,')'
	jne	err_syntax

#exp.defined.20:
	call	get_word_prep
	call	disp_con
#exp.defined.v1:
	db	' defined>$'

	pop	ecx
	ret

;
;
;

get_word_prep:
	MOV	AL,[CHR_WORK]
	CMP	AL,0DH
	JE	GET_WORD_PREP#EOL
	CMP	AL,0AH
	JE	GET_WORD_PREP#EOL

	mov	byte [flg.prep],0ffh
	call	get_word
	mov	byte [flg.prep],0
	CLC
	ret

GET_WORD_PREP#EOL:
	mov	byte [flg.prep],0ffh
	call	get_word
	mov	byte [flg.prep],0

	MOV	BYTE [PREP_EOL],0FFH
	STC
	RET



;
;
;

;get_word_prep:
	mov	al,[chr_work]
	cmp	al,0dh
	je	get_word_prep.eol
	cmp	al,0ah
	je	get_word_prep.eol

	call	ungetc
	call	get_nchr_pre

	CMP	AL,20H
	JE	GET_WORD_PREP.W
	CMP	AL,09H
	JE	GET_WORD_PREP.W

	MOV	EDI,WORD_WORK
	CALL	IS_CCHR_F
	JE	GET_WORD_PREP.20

GET_WORD_PREP.10:
	MOV	[EDI],AL
	INC	EDI
	MOV	BYTE [EDI],0

	CMP	AL,'*'
	JE	GET_WORD_PREP.40
	CMP	AL,'+'
	JE	GET_WORD_PREP.40
	CMP	AL,'-'
	JE	GET_WORD_PREP.40
	CMP	AL,'/'
	JE	GET_WORD_PREP.40
	CMP	AL,'%'
	JE	GET_WORD_PREP.40
	CMP	AL,'~'
	JE	GET_WORD_PREP.40

	CMP	AL,'!'
	MOV	BX,'=!'
	JE	GET_WORD_PREP.15
	CMP	AL,'='
	MOV	BX,'=='
	JE	GET_WORD_PREP.15
	CMP	AL,'|'
	MOV	BX,'||'
	JE	GET_WORD_PREP.15
	CMP	AL,'&'
	MOV	BX,'&&'
	JE	GET_WORD_PREP.15

	CALL	GET_NCHR_PRE
	JMP	GET_WORD_PREP.50


GET_WORD_PREP.15:
	CALL	GET_NCHR_PRE
	CMP	AL,BH
	JNE	GET_WORD_PREP.17
	MOV	[EDI],BH
	INC	EDI
	MOV	BYTE [EDI],0
	CALL	GET_NCHR_PRE
	JMP	GET_WORD_PREP.50

GET_WORD_PREP.17:
	JMP	GET_WORD_PREP.50


GET_WORD_PREP.20:
	MOV	[EDI],AL
	INC	EDI
	CALL	GET_NCHR_PRE
	CALL	IS_CCHR
	JE	GET_WORD_PREP.20
	MOV	BYTE [EDI],0
	jmp	get_word_prep.50

get_word_prep.40:
	call	get_nchr_pre

GET_WORD_PREP.50:
	clc
	ret

GET_WORD_PREP.W:
	CALL	GET_NCHR
	JMP	GET_WORD_PREP


get_word_prep.eol:
	mov	ax,0ah
	mov	[chr_work],al
	mov	[word_work],ax
	stc
	ret
;
SKIP_TILL_ENDIF:
	MOV	BYTE [IF.LEVEL],0

SKIP_TILL_ENDIF.10:
	CALL	GET_WORD3
	MOV	AL,[WORD_WORK]
	CMP	AL,1AH
	JE	_#IF.EOF
	CMP	AL,'#'
	JNE	SKIP_TILL_ENDIF.10

	call	get_word3

	MOV	ESI,WORD_WORK;+1
	MOV	EDI,WORD_IF
	CALL	STRCMP
	JE	SKIP_TILL_ENDIF.IF
	MOV	EDI,WORD_IFDEF
	CALL	STRCMP
	JE	SKIP_TILL_ENDIF.IFDEF
	MOV	EDI,WORD_IFNDEF
	CALL	STRCMP
	JE	SKIP_TILL_ENDIF.IFNDEF
	MOV	EDI,WORD_ENDIF
	CALL	STRCMP
	JE	SKIP_TILL_ENDIF.ENDIF

		MOV	EDI,WORD_ELIF
		CALL	STRCMP
		JE	SKIP_TILL_ENDIF.ELIF

	MOV	EDI,WORD_ELSE
	CALL	STRCMP
	JE	SKIP_TILL_ENDIF.ELSE
SKIP_TILL_ENDIF.20:
;	CALL	SKIP_LINE
	JMP	SKIP_TILL_ENDIF.10

SKIP_TILL_ENDIF.ELSE:
		JMP	SKIP_TILL_ENDIF.20
	CMP	BYTE [IF.LEVEL],0
	JNE	SKIP_TILL_ENDIF.20
	JMP	GET_WORD4

SKIP_TILL_ENDIF.ENDIF:
	CMP	BYTE [IF.LEVEL],0
	JE	GET_WORD4
	DEC	BYTE [IF.LEVEL]
	JMP	SKIP_TILL_ENDIF.20

;SKIP_TILL_ENDIF.ELIF:
	CMP	BYTE [IF.LEVEL],0
	JNE	SKIP_TILL_ENDIF.20

	CALL	GET_WORD_PREP
		MOV	BYTE [PREP_EOL],0
	CALL	#EXP
	PUSH	ECX
	MOV	AL,[CHR_WORK]
	CALL	UNGETC
	CALL	UNGET_WORD

	CALL	GET_NCHR
	POP	ECX
	OR	ECX,ECX
	JNE	_#IF.Y
	JMP	SKIP_TILL_ENDIF.20

	JMP	_#IF.N

SKIP_TILL_ENDIF.ELIF:

SKIP_TILL_ENDIF.IF:
SKIP_TILL_ENDIF.IFDEF:
SKIP_TILL_ENDIF.IFNDEF:
	INC	BYTE [IF.LEVEL]
	JMP	_#IF.N.20

;

_#ELSE:
		JMP	SKIP_TILL_ENDIF
		;JMP	GET_WORD4
	JMP	_#IF.N

_#ENDIF:
	JMP	GET_WORD4

_#IFNDEF:
	CALL	GET_WORD3
	MOV	BYTE [FLG.SET_STRING_MACRO],0FFH
	CALL	SEARCH_WORD_MACRO
	MOV	BYTE [FLG.SET_STRING_MACRO],0
	JNB	_#IF.N
	JMP	_#IF.Y

_#IFDEF:
	CALL	GET_WORD3
	MOV	BYTE [FLG.SET_STRING_MACRO],0FFH
	CALL	SEARCH_WORD_MACRO
	MOV	BYTE [FLG.SET_STRING_MACRO],0
	JB	_#IF.N
	JMP	_#IF.Y

;
_#ELIF:
		JMP	SKIP_TILL_ENDIF
		;JMP	GET_WORD4
	JMP	_#IF.N


_#IF:
;	CALL	GET_WORD4	;skip 'if'
	call	get_word_prep

		MOV	BYTE [PREP_EOL],0
	CALL	#EXP
	push	ecx

	MOV	AL,[CHR_WORK]
	CALL	UNGETC
	CALL	UNGET_WORD

	CALL	GET_NCHR

;	CALL	#SKIP_WHITE
;	MOV	AL,[CHR_WORK]
;	CMP	AL,0AH
;	JNE	ERR.UNTERM
	pop	ecx
	OR	ECX,ECX
	JNE	_#IF.Y
	JMP	_#IF.N


;
#SKIP_WHITE:
	MOV	AL,[CHR_WORK]
	CMP	AL,0AH
	JE	#SKIP_WHITE.R

;	CALL	GET_WORD_PREP
	CALL	GET_NCHR_PRE
	CMP	AL,20H
	JE	#SKIP_WHITE
	CMP	AL,09H
	JE	#SKIP_WHITE
	CMP	AL,0DH
	JE	#SKIP_WHITE

#SKIP_WHITE.R:
	RET

;

err.unterm:
	call	disp_con
	db	'unterminated prep$'
	jmp	err_syntax

_#IF.Y:
	JMP	GET_WORD4
	JMP	GET_WORD4.0

;
;	#if 0
;		(_#IF.N)
;	#else
;
;	#endif
;
_#IF.N:
	MOV	BYTE [IF.LEVEL],0

_#IF.N.10:
	CALL	GET_WORD3
	MOV	AL,[WORD_WORK]
	CMP	AL,1AH
	JE	_#IF.EOF
	CMP	AL,'#'
	JNE	_#IF.N.10

	call	get_word3

	MOV	ESI,WORD_WORK;+1
	MOV	EDI,WORD_IF
	CALL	STRCMP
	JE	_#IF.N.IF
	MOV	EDI,WORD_IFDEF
	CALL	STRCMP
	JE	_#IF.N.IFDEF
	MOV	EDI,WORD_IFNDEF
	CALL	STRCMP
	JE	_#IF.N.IFNDEF
	MOV	EDI,WORD_ENDIF
	CALL	STRCMP
	JE	_#IF.N.ENDIF

		MOV	EDI,WORD_ELIF
		CALL	STRCMP
		JE	_#IF.N.ELIF

	MOV	EDI,WORD_ELSE
	CALL	STRCMP
	JE	_#IF.N.ELSE
_#IF.N.20:
;	CALL	SKIP_LINE
	JMP	_#IF.N.10

_#IF.N.ELSE:
	CMP	BYTE [IF.LEVEL],0
	JNE	_#IF.N.20
	JMP	GET_WORD4

_#IF.N.ENDIF:
	CMP	BYTE [IF.LEVEL],0
	JE	GET_WORD4
	DEC	BYTE [IF.LEVEL]
	JMP	_#IF.N.20

_#IF.N.ELIF:
	CMP	BYTE [IF.LEVEL],0
	JNE	_#IF.N.20

	CALL	GET_WORD_PREP
		MOV	BYTE [PREP_EOL],0
	CALL	#EXP
	PUSH	ECX
	MOV	AL,[CHR_WORK]
	CALL	UNGETC
	CALL	UNGET_WORD

	CALL	GET_NCHR
	POP	ECX
	OR	ECX,ECX
	JNE	_#IF.Y
	JMP	_#IF.N.20

	JMP	_#IF.N


_#IF.N.IF:
_#IF.N.IFDEF:
_#IF.N.IFNDEF:
	INC	BYTE [IF.LEVEL]
	JMP	_#IF.N.20

_#IF.EOF:
	CALL	DISP_CON
	DB	'eof in #if(n)(def)$'
	JMP	ERR_SYNTAX



;

SKIP_LINE:
	MOV	AL,[CHR_WORK]
	CMP	AL,0AH
	JE	SKIP_LINE.R
	CALL	GET_NCHR
	JMP	SKIP_LINE
SKIP_LINE.R:
	CALL	GET_NCHR
	RET

_UNDEF:
	CALL	GET_WORD3
_UNDEF.10:
	MOV	BYTE [FLG.SET_STRING_MACRO],0FFH
	CALL	SEARCH_WORD_MACRO
	MOV	BYTE [FLG.SET_STRING_MACRO],0
	JB	_UNDEF.R

;	MOV	ES,[STRING_MACRO_SEG]
;	MOV	EDI,0F000H
;	MOV	WORD ES:[EDI],'-'
;	MOV	BYTE ES:[EDI+2],0
;
;	PUSH	DS
;	POP	ES
;
;	MOV	DWORD [EBX+NODE1],0F000H	;DUMMY_STR

	mov	dword [ebx+NODE1],dummy_str
	JMP	_UNDEF.10

_UNDEF.R:
	CALL	GET_WORD4
	RET



;
;
;
INIT_DEFINE:
	MOV	EAX,'il'+8080H
	MOV	ESI,WORD__LINE__
	CALL	INIT_DEFINE.SUB

	MOV	EAX,'if'+8080H
	MOV	ESI,WORD__FILE__
	CALL	INIT_DEFINE.SUB

	MOV	EAX,'it'+8080H
	MOV	ESI,WORD__TIME__
	CALL	INIT_DEFINE.SUB
	RET

INIT_DEFINE.SUB:
	MOV	BYTE [FLG.SET_STRING_MACRO],0FFH

		PUSH	ESI
	;MOV	EAX,'il'+8080H
	MOV	[WORD_WORK],EAX
	MOV	EBX,WORD_WORK
	CALL	SET_STRING_MACRO
		POP	ESI

	PUSH	EBX
	;MOV	ESI,WORD__LINE__
	MOV	EDI,WORD_WORK
	CALL	STRCPY
	CALL	SET_WORD1_MACRO
	PUSH	EBX
	MOV	AX,'FD'
	CALL	MAKE_WORD1_MACRO
	POP	EAX
	MOV	[EAX+NODE2],EBX
	POP	EAX
	MOV	[EBX+NODE2],EAX

	MOV	BYTE [FLG.SET_STRING_MACRO],0
	RET


;
;
;

PRE_DEFINE:
	MOV	BYTE [FLG.SET_STRING_MACRO],0FFH

	PUSH	ESI
	MOV	AX,'FD'
	CALL	MAKE_WORD1_MACRO
	POP	ESI

	CLD
	MOV	EDI,WORD_WORK
PRE_DEFINE.10:
	LODSB
	CMP	AL,'='
	JE	PRE_DEFINE.20
	CMP	AL,20H
	JBE	PRE_DEFINE.20
	MOV	[EDI],AL
	INC	EDI
	JMP	PRE_DEFINE.10


PRE_DEFINE.20:
	MOV	BYTE [EDI],0

	PUSH	ESI

	PUSH	EBX
	CALL	SET_WORD1_MACRO
	MOV	EDX,EBX
	POP	EBX
	MOV	[EDX+NODE2],EBX
	MOV	DWORD [EBX+NODE4],0	;#define name name2

	POP	ESI

	DEC	ESI
	PUSHAD
	MOV	AL,[ESI]	;[ESI-1]
	CALL	PUTCHR_CON
	POPAD

	MOV	EDI,WORD_WORK
	CMP	BYTE [ESI],'='
	JNE	PRE_DEFINE.60	;NUL
	INC	ESI

PRE_DEFINE.50:
	LODSB
	CMP	AL,20H
	JBE	PRE_DEFINE.60
	MOV	[EDI],AL
	INC	EDI
	JMP	PRE_DEFINE.50

PRE_DEFINE.60:
	MOV	BYTE [EDI],0

	PUSH	EBX
	MOV	EBX,WORD_WORK
	CALL	SET_STRING_MACRO
	MOV	EDX,EBX
	POP	EBX
	MOV	[EBX+NODE2],EDX

PRE_DEFINE.NUL:
	MOV	BYTE [FLG.SET_STRING_MACRO],0
	RET

;
;
;

_DEFINE:
	MOV	BYTE [FLG.SET_STRING_MACRO],0FFH

	MOV	AX,'FD'
	CALL	MAKE_WORD1_MACRO
	PUSH	EBX
	CALL	GET_WORD3

	;	PUSHAD
	;	MOV	AL,':'
	;	CALL	PUTCHR_CON
	;	MOV	ESI,WORD_WORK
	;	CALL	DISP_STR_CON
	;	POPAD

		CALL	SEARCH_WORD_MACRO
		JB	_DEFINE.NEW

		PUSHAD
		CALL	DISP_CON
		DB	'redefine:($'

		MOV	ESI,WORD_WORK
		CALL	DISP_STR_CON
		CALL	DISP_CON
		DB	')$'
		POPAD

_DEFINE.NEW:
	CALL	SET_WORD1_MACRO
	POP	ESI
	MOV	[EBX+NODE2],ESI

	MOV	DWORD [ESI+NODE4],0	;#define name name2

	MOV	AL,[CHR_WORK]
	CMP	AL,'('
	JNE	_DEFINE.ARG.E
	CALL	GET_WORD3

	MOV	DWORD [ESI+NODE4],1	;#define name() name2

	mov	al,[chr_work]
	cmp	al,')'
	je	_define.noarg.par

	MOV	DWORD [ESI+NODE4],2	;#define name(arg) name2

	PUSH	ESI		;node 'DF'
	CALL	GET_WORD3	;skip '('

_DEFINE.ARG.10:
		PUSHAD
		MOV	AL,'p'+80H
		CALL	ADD_POST
		POPAD

	CALL	SET_WORD1_MACRO;_PARAM
	MOV	[ESI+NODE3],EBX
	MOV	ESI,EBX

	CALL	GET_WORD3
	MOV	AX,[WORD_WORK]
	CMP	AX,','
	JNE	_DEFINE.ARG.50
	CALL	GET_WORD3	;skip ','
	JMP	_DEFINE.ARG.10

_DEFINE.ARG.50:
	MOV	AX,[WORD_WORK]
	CMP	AX,')'
	JNE	ERR_SYNTAX
;	CALL	GET_WORD3	;skip ')'
	POP	ESI
	jmp	_define.arg.e

_define.noarg.par:
	call	get_word3	;read in ')'


_DEFINE.ARG.E:

	PUSH	ESI
	MOV	EDI,WORD_WORK

	CALL	SKIP_WHITE
	MOV	AL,[CHR_WORK]
	CALL	UNGETC

	MOV	ECX,0
_DEFINE.15:
	CMP	ECX,WORD_WORK_SIZE	;3000-40	;1000-40;100H
	JNB	ERR_DEFINE_MEM	;ERR_MACRO
	INC	ECX

	CALL	GET_NCHR_PRE
	CMP	AL,0AH
	JE	_DEFINE.20

_define.18:
	MOV	[EDI],AL
	INC	EDI
	PUSH	ECX
	PUSH	EDI
;	CALL	GET_NCHR_pre
	POP	EDI
	POP	ECX
	JMP	_DEFINE.15

_DEFINE.20:
	XOR	AL,AL
	MOV	[EDI],AL
	INC	EDI

	MOV	EBX,WORD_WORK
	CALL	SET_STRING_MACRO
	POP	ESI
	MOV	[ESI+NODE2],EBX	;node 'DF' [+4]

	MOV	BYTE [FLG.SET_STRING_MACRO],0
	JMP	GET_WORD4

;
;
;

get_nchr_pre:
	mov	al,[chr_work]
	cmp	al,0ah
	je	get_nchr_pre.r

	call	get_nchr
	mov	al,[chr_work]
	cmp	al,0dh
	je	get_nchr_pre

	cmp	al,'\'
	je	get_nchr_pre.con

	cmp	al,'/'
	je	get_nchr_pre.cm

	jmp	get_nchr_pre.r

get_nchr_pre.cm:
	call	get_nchr
	cmp	al,'*'
	je	get_nchr_pre.cm.l
	call	ungetc
	mov	al,'/'
	jmp	get_nchr_pre.r

get_nchr_pre.cm.l:
	call	get_nchr
	cmp	al,1ah
	je	err_syntax
	cmp	al,'*'
	jne	get_nchr_pre.cm.l
	call	get_nchr
	cmp	al,'/'
	je	get_nchr_pre.cm.l.50
	call	ungetc
	jmp	get_nchr_pre.cm.l

get_nchr_pre.cm.l.50:
	call	get_nchr
	jmp	get_nchr_pre.r


get_nchr_pre.con:
	call	get_nchr
	CMP	AL,0DH
	JE	GET_NCHR_PRE.CON

	cmp	al,0ah
	je	get_nchr_pre_con.10

	call	ungetc
	mov	al,'\'
	jmp	get_nchr_pre.r

get_nchr_pre_con.10:
	mov	al,20h

get_nchr_pre.r:
	mov	[chr_work],al
	ret

;
;
;
_#LINE:
	CALL	GET_WORD

	;MOV	ESI,WORD_WORK
	;CALL	GETDEC
	;MOV	[LIN.NO],EAX

	CALL	GET_WORD
	MOV	AX,[WORD_WORK]
	CMP	AX,'"'
	JE	_#LINE2
	JMP	GET_WORD4.0

_#LINE2:
	CALL	GET_WORD
	MOV	AX,[WORD_WORK]
	CMP	AL,1AH
	JE	ERR_SYNTAX
	CMP	AX,'"'
	JNE	_#LINE2

	JMP	GET_WORD4

;
;
;

_INCLUDE:

SUBI:
			CMP	BYTE [FLG.P],0
			JNE	SUBI.01

		CALL	PUTCRLF_CON
		MOV	AL,[LOAD.F]
		INC	AL
		CALL	INDENT
SUBI.01:

	CALL	SKIP_WHITE

	MOV	AL,[CHR_WORK]
	CMP	AL,'<'
	JE	SUBI.10
	CMP	AL,'"'
	JE	SUBI.10
	JMP	ERR_SYNTAX
SUBI.10:
		MOV	[INCLUDE_CHR],AL

	CALL	GET_NCHR
	MOV	EDI,SUBWRK+2	;#
SUBI1:	MOV	AL,[CHR_WORK]
	CMP	AL,'>'
	JE	SUBI7
	CMP	AL,'"'
	JE	SUBI7

		CMP	AL,'/'
		JNE	SUBI.11
		MOV	AL,'\'
SUBI.11:
	MOV	[EDI],AL
	INC	EDI
	PUSHAD
		CMP	BYTE [FLG.P],0
		JNE	SUBI.12
	CALL	PUTCHR_CON	;DOS02
SUBI.12:
	CALL	GET_NCHR
	POPAD
	JMP	SUBI1

SUBI7:
	MOV	BYTE [EDI],0

	mov	esi,subwrk+2
		MOV	AL,[INCLUDE_CHR]
		CMP	AL,'<'
		JNE	INCL.20

	JMP	INCL.20

		MOV	AX,[ESI]
		CMP	AH,':'
		JE	INCL.20

		SUB	ESI,2
		MOV	BYTE [ESI],'B'
		MOV	BYTE [ESI+1],':'
	jmp	incl.20

	cmp	al,'"'
	je	incl.20

	cmp	byte [esi+2],':'
	je	incl.20

	sub	esi,2
	mov	ax,[ref_drv]
	mov	[esi],ax

incl.20:
	push	esi

	;CALL	PUTCRLF_CON
	MOV	AL,[LOAD.F]
	INC	AL
	MOV	[LOAD.F],AL
	CMP	AL,16
	JE	ERR_INCLUDE	;too many include

	MOV	ESI,[FCB]

	MOV	BX,[LIN.NO]
	;INC	BX		;##
	MOV	[ESI+70],BX

	MOV	EAX,[HDL]
	MOV	[ESI+60],EAX	;[ESI+72],AX

	PUSH	ESI
	MOV	EBX,[HDL]
	MOV	CX,0
	MOV	DX,0
	MOV	AL,01H
	CALL	SYS_seek
	POP	ESI

	SUB	AX,[S.LEFT]
	SBB	DX,0
	MOV	[ESI+74],AX
	MOV	[ESI+76],DX

	MOV	EBX,[FCB]
	MOV	EDX,80
	ADD	EBX,EDX
	MOV	[FCB],EBX

;	MOV	ESI,SUBWRK
	pop	esi

	MOV	EDI,[FCB]
	CALL	STRCPY

	XOR	AL,AL
	MOV	[FL.END],AL
	MOV	EBX,0
	MOV	[S.LEFT],EBX

	MOV	EDX,[FCB]
	MOV	AL,00H
	CALL	SYS_open
	JB	ERR_OPEN
	MOV	[HDL],EAX

	MOV	BX,1
	MOV	[LIN.NO],BX

	CALL	GET_NCHR
	JMP	GET_WORD4

INDENT:
	;INC	AL
INDENT.10:
	PUSH	EAX
	MOV	AL,'-'
	CALL	PUTCHR_CON
	POP	EAX
	SUB	AL,1
	JNB	INDENT.10
	RET

;
;
;
;SUBM:

;SUBIM1:	DB	'LOADING...$'

;SUBIF:

;SUBENDIF:



;
;
;
FCBDEC:
			CMP	BYTE [FLG.P],0
			JNE	FCBDEC.1

		CALL	PUTCRLF_CON
FCBDEC.1:

	MOV	AL,[LOAD.F]
	SUB	AL,1
	JB	_FCBDEC.R
	MOV	[LOAD.F],AL

			CMP	BYTE [FLG.P],0
			JNE	FCBDEC.2

		MOV	AL,[LOAD.F]
		CALL	INDENT
FCBDEC.2:
	MOV	EBX,[FCB]
	MOV	EDX,80
	SUB	EBX,EDX
	MOV	[FCB],EBX

			CMP	BYTE [FLG.P],0
			JNE	FCBDEC.3
		PUSHAD
		MOV	ESI,[FCB]
		CALL	DISP_STR_CON
		MOV	AL,':'
		CALL	PUTCHR_CON
		POPAD
FCBDEC.3:
	MOV	BX,[EBX+70]
	MOV	[LIN.NO],BX
	MOV	EBX,0
	MOV	[S.LEFT],BX
	XOR	AL,AL
	MOV	[FL.END],AL

	PUSHAD

	PUSHAD
	MOV	EBX,[HDL]
	CALL	SYS_close
	POPAD

	MOV	ESI,[FCB]
	MOV	EBX,[ESI+60]	;[ESI+72]
	MOV	[HDL],EBX

	MOV	EBX,[HDL]
	MOV	AL,00H
	MOV	DX,[ESI+74]
	MOV	CX,[ESI+76]
	CALL	SYS_seek
	POPAD

	CLC
	RET
_FCBDEC.R:
	STC
	RET

