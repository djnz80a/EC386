
;
;
;
SET_WORD1_N:
	CALL	SET_WORD1
	CALL	GET_WORD
	RET

;

MAKE_LABEL_STATIC:
	MOV	EBX,MAKE_WORD1
	JMP	MAKE_LABEL.0

;
;	>BX:node
;	?none
;

MAKE_LABEL:
	MOV	EBX,MAKE_WORD1_LABEL
MAKE_LABEL.0:
	PUSH	EAX
	MOV	EAX,[LABEL_NO]
	INC	EAX

MAKE_LABEL.20:
	MOV	[LABEL_NO],EAX
	PUSH	EAX
	PUSH	ECX
	MOV	AX,':'
	;CALL	MAKE_WORD1_LABEL	;#
		CALL	EBX

	POP	ECX
	POP	EAX
	MOV	[EBX+2*8],EAX
	POP	EAX
	RET




;


MAKE_WORD1_LABEL:
	MOV	DWORD [MAKE_WORD10_PROG],MAKE_WORD_LABEL
	JMP	MAKE_WORD10

MAKE_WORD1_MACRO_PARAM:
	MOV	DWORD [MAKE_WORD10_PROG],MAKE_WORD_MACRO_PARAM
	JMP	MAKE_WORD10

MAKE_WORD1_MACRO:
	MOV	DWORD [MAKE_WORD10_PROG],MAKE_WORD_MACRO
	JMP	MAKE_WORD10

MAKE_WORD1_EXP:
	MOV	DWORD [MAKE_WORD10_PROG],MAKE_WORD_EXP
	JMP	MAKE_WORD10

MAKE_WORD1:
	MOV	DWORD [MAKE_WORD10_PROG],MAKE_WORD
	JMP	MAKE_WORD10

MAKE_WORD10:
	PUSH	ECX
	MOV	ECX,NODESIZE
		CMP	AX,'*'
		JE	MAKE_WORD10.AST

		JMP	MAKE_WORD10.10

MAKE_WORD10.AST:
	MOV	ECX,NODESIZE_AST
	JMP	MAKE_WORD10.10

MAKE_WORD10.10:

;	CALL	MAKE_WORD
	CALL	[MAKE_WORD10_PROG]
	POP	ECX
	RET



;

MAKE_WORD_LABEL:
	MOV	DWORD [MAKE_WORD0_PROG],SET_WORD_LABEL_BX
	JMP	MAKE_WORD0

MAKE_WORD_MACRO_PARAM:
	MOV	DWORD [MAKE_WORD0_PROG],SET_WORD_MACRO_PARAM_BX
	JMP	MAKE_WORD0

MAKE_WORD_MACRO:
	MOV	DWORD [MAKE_WORD0_PROG],SET_WORD_MACRO_BX
	JMP	MAKE_WORD0

MAKE_WORD_EXP:
	MOV	DWORD [MAKE_WORD0_PROG],SET_WORD_EXP_BX
	JMP	MAKE_WORD0
;
;	>BX adrs
;

MAKE_WORD:
	MOV	DWORD [MAKE_WORD0_PROG],SET_WORD_BX
	JMP	MAKE_WORD0

MAKE_WORD0:
	PUSH	ECX
	PUSH	EDX
	PUSH	ESI
	PUSH	EDI

	MOV	[WORD_WORK2],AX
	XOR	AL,AL
	MOV	[WORD_WORK2+2],AL
	MOV	EBX,WORD_WORK2
;	CALL	SET_WORD_BX
	CALL	[MAKE_WORD0_PROG]

	POP	EDI
	POP	ESI
	POP	EDX
	POP	ECX
	RET



;
;
;
SET_WORD1:
	JMP	SET_WORD1_GLOBAL

	PUSH	CX
	MOV	CX,NODESIZE
	CALL	SET_WORD
	POP	CX
	RET

;
;
;
SET_WORD1_BX:
	JMP	SET_WORD1_GLOBAL_BX

;SET_WORD1_MEMBER:
;	PUSH	ECX
;	MOV	ECX,NODESIZE
;	CALL	SET_WORD_MEMBER
;	POP	ECX
;	RET

SET_WORD1_LABEL:
	PUSH	ECX
	MOV	ECX,NODESIZE
	CALL	SET_WORD_LABEL
	POP	ECX
	RET

SET_WORD1_MACRO_PARAM:
	PUSH	ECX
	MOV	ECX,NODESIZE
	CALL	SET_WORD_MACRO_PARAM
	POP	ECX
	RET

SET_WORD1_MACRO:
	PUSH	ECX
	MOV	ECX,NODESIZE
	CALL	SET_WORD_MACRO
	POP	ECX
	RET

SET_WORD1_EXP:
	PUSH	ECX
	MOV	ECX,NODESIZE
	CALL	SET_WORD_EXP
	POP	ECX
	RET


SET_WORD1_GLOBAL:
	PUSH	ECX
	MOV	ECX,NODESIZE
	CALL	SET_WORD_GLOBAL
	POP	ECX
	RET

;

;SET_WORD1_MEMBER_BX:
;	PUSH	ECX
;	MOV	ECX,NODESIZE
;	CALL	SET_WORD_MEMBER_BX
;	POP	ECX
;	RET

SET_WORD1_LABEL_BX:
	PUSH	ECX
	MOV	ECX,NODESIZE
	CALL	SET_WORD_LABEL_BX
	POP	ECX
	RET

SET_WORD1_MACRO_PARAM_BX:
	PUSH	ECX
	MOV	ECX,NODESIZE
	CALL	SET_WORD_MACRO_PARAM_BX
	POP	ECX
	RET

SET_WORD1_MACRO_BX:
	PUSH	ECX
	MOV	ECX,NODESIZE
	CALL	SET_WORD_MACRO_BX
	POP	ECX
	RET

SET_WORD1_EXP_BX:
	PUSH	ECX
	MOV	ECX,NODESIZE
	CALL	SET_WORD_EXP_BX
	POP	ECX
	RET

SET_WORD1_GLOBAL_BX:
	PUSH	ECX
	MOV	ECX,NODESIZE
	CALL	SET_WORD_GLOBAL_BX
	POP	ECX
	RET

;
;SET_WORD_MEMBER:
;	PUSH	ESI
;	MOV	ESI,WORD_WORK_MEMBER_INFO
;	JMP	SET_WORD0

SET_WORD_LABEL:
	PUSH	ESI
	MOV	ESI,WORD_WORK_LABEL_INFO
	JMP	SET_WORD0

SET_WORD_MACRO_PARAM:
	PUSH	ESI
	MOV	ESI,WORD_WORK_MACRO_PARAM_INFO
	JMP	SET_WORD0

SET_WORD_MACRO:
	PUSH	ESI
	MOV	ESI,WORD_WORK_MACRO_INFO
	JMP	SET_WORD0

SET_WORD_EXP:
	PUSH	ESI
	MOV	ESI,WORD_WORK_EXP_INFO
	JMP	SET_WORD0

SET_WORD_GLOBAL:
	PUSH	ESI
	MOV	ESI,WORD_WORK_GLOBAL_INFO
	JMP	SET_WORD0

SET_WORD0:
	MOV	EBX,WORD_WORK
	CALL	SET_WORD2
	POP	ESI
	RET

;
;SET_WORD_MEMBER_BX:
;	PUSH	ESI
;	MOV	ESI,WORD_WORK_MEMBER_INFO
;	JMP	SET_WORD0_BX

SET_WORD_LABEL_BX:
	PUSH	ESI
	MOV	ESI,WORD_WORK_LABEL_INFO
	JMP	SET_WORD0_BX

SET_WORD_MACRO_PARAM_BX:
	PUSH	ESI
	MOV	ESI,WORD_WORK_MACRO_PARAM_INFO
	JMP	SET_WORD0_BX

SET_WORD_MACRO_BX:
	PUSH	ESI
	MOV	ESI,WORD_WORK_MACRO_INFO
	JMP	SET_WORD0_BX

SET_WORD_EXP_BX:
	PUSH	ESI
	MOV	ESI,WORD_WORK_EXP_INFO
	JMP	SET_WORD0_BX

SET_WORD_GLOBAL_BX:
	PUSH	ESI
	MOV	ESI,WORD_WORK_GLOBAL_INFO
	JMP	SET_WORD0_BX

SET_WORD0_BX:
	CALL	SET_WORD2
	POP	ESI
	RET

;
;
;

SET_WORD2:
	PUSH	EAX
	PUSH	ECX
	PUSH	EDX
	PUSH	EDI

	PUSH	ECX
	CMP	BYTE [FLG.SET_STRING_MACRO],0
	JNE	SET_WORD2.10
	CALL	SET_STRING
	JMP	SET_WORD2.20
SET_WORD2.10:
	CALL	SET_STRING_MACRO

SET_WORD2.20:
	POP	ECX

	PUSH	ECX
	PUSH	EBX
	CALL	ALLOC2
	MOV	EDI,EBX
	POP	EBX
	POP	ECX

	;MOV	[EDI],ECX
		MOV	EAX,[ESI+3*4]
		MOV	[EDI],EAX
		MOV	[ESI+3*4],EDI
	MOV	[EDI+2*2],EBX
	MOV	EBX,EDI

	POP	EDI
	POP	EDX
	POP	ECX
	POP	EAX
	RET

;	:INFO
;WORD_WORK_MACRO_PARAM EQU	20000h
;WORD_WORK_MACRO_PARAM_END EQU	2f000h
;
;WORD_WORK_EXP		EQU	30000h
;WORD_WORK_EXP_END	EQU	3F000H
;
;STRING_TBL EQU			40000H
;STRING_TBL_END EQU		57F00H
;
;STRING_MACRO_TBL	EQU	0C9000H
;STRING_MACRO_TBL_END	EQU	0E0000H
;
;WORD_WORK_LABEL		EQU	58000H
;WORD_WORK_LABEL_END	EQU	67F00H
;
;WORD_WORK_MACRO	EQU		68000H
;WORD_WORK_MACRO_END EQU		8F000H

;WORD_WORK_GLOBAL	EQU	090000H
;WORD_WORK_GLOBAL_END	EQU	0C8000H
;

;;WORD_WORK_MEMBER	EQU	0C0000H
;;WORD_WORK_MEMBER_END	EQU	0C8000H
;
;WORK_END	EQU	0E1000H





;

;
;	BX:string
;	CX:bytes(4-)
;
;	>BX:adrs
;

SET_WORD:
	JMP	SET_WORD_GLOBAL

	MOV	BX,WORD_WORK
SET_WORD_BX:
	JMP	SET_WORD_GLOBAL_BX


SEARCH_WORD_LABEL:
	PUSH	ESI
	MOV	EBX,WORD_WORK
	MOV	ESI,WORD_WORK_LABEL_INFO
	CALL	SEARCH_WORD2
	POP	ESI
	RET

SEARCH_WORD_MACRO_PARAM:
	PUSH	ESI
	MOV	EBX,WORD_WORK
	MOV	ESI,WORD_WORK_MACRO_PARAM_INFO
	CALL	SEARCH_WORD2
	POP	ESI
	RET

SEARCH_WORD_MACRO:
	PUSH	ESI
	MOV	EBX,WORD_WORK
	MOV	ESI,WORD_WORK_MACRO_INFO
	CALL	SEARCH_WORD2
	POP	ESI
	RET

SEARCH_WORD_EXP:	;for test
	PUSH	ESI
	MOV	EBX,WORD_WORK
	MOV	ESI,WORD_WORK_EXP_INFO
	CALL	SEARCH_WORD2
	POP	ESI
	RET

SEARCH_WORD_GLOBAL:
	PUSH	ESI
	MOV	EBX,WORD_WORK
	MOV	ESI,WORD_WORK_GLOBAL_INFO
	CALL	SEARCH_WORD2
	POP	ESI
	RET

SEARCH_WORD_GLOBAL_BX:
	PUSH	ESI
	MOV	ESI,WORD_WORK_GLOBAL_INFO
	CALL	SEARCH_WORD2
	POP	ESI
	RET

;
;
;
DEL_LABEL:
	MOV	ESI,WORD_WORK_LABEL_INFO
	MOV	EBX,[ESI]

	MOV	[ESI+2*4],EBX	;ESI ####
		MOV	DWORD [ESI+3*4],0
	RET

DEL_LABEL.10:
	CMP	EBX,[ESI+2*4]	;end
	JE	DEL_LABEL.20

	MOV	EDI,[EBX+2*2]
	MOV	AX,[EDI]
	CMP	AX,':'
	JNE	DEL_LABEL.15
	MOV	BYTE [EDI],':'+80H
DEL_LABEL.15:
	ADD	EBX,[EBX]
	JMP	DEL_LABEL.10

DEL_LABEL.20:
	RET

;
;
;	SI:INFO
;
SEARCH_WORD2:
	PUSH	EDX
	PUSH	ESI
	MOV	EDX,EBX
	MOV	DWORD [SEARCH_WORD2.PNT],0

	MOV	DWORD [SEARCH_WORD2.CNT],0

	PUSH	DS
	POP	ES

	CMP	BYTE [FLG.SET_STRING_MACRO],0
	JE	SEARCH_WORD2.05

	;MOV	ES,[STRING_MACRO_SEG]

SEARCH_WORD2.05:

	;MOV	EBX,[ESI]		;top
		MOV	EBX,[ESI+3*4]
SEARCH_WORD2.10:
	;CMP	EBX,[ESI+2*4]	;end
		OR	EBX,EBX
	JE	SEARCH_WORD2.N

		MOV	EAX,[EBX+2*2]
		MOV	AL,[EAX]
		CMP	AL,[EDX]
		JNE	SEARCH_WORD2.20

	PUSH	ESI
	PUSH	EDI
	PUSH	EBX
	MOV	ESI,EDX
	MOV	EDI,[EBX+2*2]
	CALL	STRCMP
	POP	EBX
	POP	EDI
	POP	ESI
	JNE	SEARCH_WORD2.20	;Y

	MOV	[SEARCH_WORD2.PNT],EBX
	INC	DWORD [SEARCH_WORD2.CNT]
		JMP	SEARCH_WORD2.N	;###13
SEARCH_WORD2.20:
	;ADD	EBX,[EBX]
		MOV	EBX,[EBX]
	JMP	SEARCH_WORD2.10

SEARCH_WORD2.N:
	MOV	EBX,[SEARCH_WORD2.PNT]
	OR	EBX,EBX
	JNE	SEARCH_WORD2.Y
	STC
	JMP	SEARCH_WORD2.R

SEARCH_WORD2.Y:
;	JMP	SEARCH_WORD2.Y.10

	CMP	DWORD [SEARCH_WORD2.CNT],1
	JBE	SEARCH_WORD2.Y.10


	jmp	SEARCH_WORD2.Y.10	;supress dup:..

	PUSHAD

	PUSH	ESI
	CALL	DISP_CON
	DB	1BH,'[32m',' dup:$'
	POP	ESI

	MOV	EAX,[ESI]
	SHR	EAX,10H
	CMP	AL,10
	JB	SEARCH_WORD2.01
	ADD	AL,7
SEARCH_WORD2.01:
	ADD	AL,'0'
	CALL	PUTCHR_CON

	MOV	ESI,WORD_WORK
	CALL	DISP_STR_CON

	CALL	DISP_CON
	DB	1BH,'[37m','$'


	POPAD

SEARCH_WORD2.Y.10:
	CLC
	JMP	SEARCH_WORD2.R

SEARCH_WORD2.R:
	PUSH	DS
	POP	ES

	POP	ESI
	POP	EDX
	RET


;
;	BX:string
;
;	>BX:adrs
;

SEARCH_WORD:
	JMP	SEARCH_WORD_GLOBAL

	MOV	BX,WORD_WORK
SEARCH_WORD_BX:
	JMP	SEARCH_WORD_GLOBAL_BX

	PUSH	ESI

	MOV	ESI,EBX
	MOV	EBX,[WORD_PNT]
SEARCH_WORD.10:
	OR	EBX,EBX
	JE	SEARCH_WORD.20
	PUSH	EBX
	MOV	EDI,[EBX+2*2]
	CALL	STRCMP
	POP	EBX
	JE	SEARCH_WORD.OK

	MOV	EBX,[EBX]
	JMP	SEARCH_WORD.10

SEARCH_WORD.20:
	POP	ESI
	STC
	RET
SEARCH_WORD.OK:
	CLC
	POP	ESI
	RET

;
;
;
SET_STRING_MACRO:
	PUSH	ESI
	MOV	ESI,EBX
	MOV	EBX,[STRING_MACRO_PNT]
	PUSH	EBX
	;MOV	ES,[STRING_MACRO_SEG]

		PUSH	EDX
		;MOV	EDX,STRING_MACRO_TBL_END
		MOV	EDX,[STRING_MACRO_TBL_INFO+1*4]
SET_STRING_MACRO.10:
	;CMP	EBX,STRING_MACRO_TBL_END
	CMP	EBX,EDX
	JNB	SET_STRING_MACRO.ERR_MEM

	MOV	AL,[ESI]
	;MOV	ES:[EBX],AL
		MOV	[EBX],AL	;<- ebx=00076100
	INC	ESI
	INC	EBX
	OR	AL,AL
	JNE	SHORT SET_STRING_MACRO.10

		POP	EDX

	MOV	[STRING_MACRO_PNT],EBX
	POP	EBX

	PUSH	DS
	POP	ES

	POP	ESI
	RET



;
;	BX:string
;	>BX:pnt to string
;

SET_STRING:
	PUSH	ESI

	;	MOV	ESI,[EBX]
	;	AND	ESI,0FFFFFFH
	;	CMP	ESI,'00'
	;	JE	SET_STRING#00

	MOV	ESI,EBX
	MOV	EBX,[STRING_PNT]
	PUSH	EBX

		PUSH	EDX
		;;MOV	EDX,STRING_TBL_END
		MOV	EDX,[STRING_TBL_INFO+1*4]

SET_STRING.10:
	;CMP	EBX,STRING_TBL_END
	CMP	EBX,EDX
	JNB	SET_STRING.ERR_MEM

	MOV	AL,[ESI]
	MOV	[EBX],AL
	INC	ESI
	INC	EBX

		CMP	AL,0FFH
		JNE	SET_STRING.10A
		MOV	AL,[ESI]
		MOV	[EBX],AL
		INC	ESI
		INC	EBX
		JMP	SET_STRING.10
SET_STRING.10A:
	OR	AL,AL
	JNE	SHORT SET_STRING.10

		POP	EDX

	MOV	[STRING_PNT],EBX
	POP	EBX
	JMP	SET_STRING.E

SET_STRING#00:
	MOV	EBX,SHARE_STR_00

SET_STRING.E:
	POP	ESI
	RET

;


SET_STRING_MACRO.ERR_MEM:

SET_STRING.ERR_MEM:
	MOV	BYTE [FLG.D],0FFH
	MOV	BYTE [FLG.V],0FFH
	CALL	DISP
	DB	'memory over[string}$'
	JMP	ERR_MEM

;STRING_PNT:DS	2

;
;	CX:bytes
;	BX:adrs
;	DX:end
;	SI:info
;
ALLOC2:
	PUSH	EAX
	PUSH	EDX

	MOV	EDX,[ESI+2*2]	;end
	MOV	EBX,[ESI+2*4]	;pnt

	OR	ECX,ECX
	JE	ALLOC2.E

	MOV	EAX,EBX
	ADD	EAX,ECX
	CMP	EAX,EDX
	JNB	ERR_MEM.ALLOC2

	PUSH	EBX

	XOR	AL,AL
;ALLOC2.10:
;	MOV	[EBX],AL
;	INC	EBX
;	LOOP	ALLOC2.10

	PUSH	ES
	PUSH	EDI

	PUSH	DS
	POP	ES
	MOV	EDI,EBX
	CLD
	REP
	STOSB
	MOV	EBX,EDI

	POP	EDI
	POP	ES

	MOV	[ESI+2*4],EBX	;<- esi=0040b088 ebx=0045601a  edx=0047cff2

	POP	EBX

ALLOC2.E:
	POP	EDX
	POP	EAX
	RET


ERR_MEM.ALLOC2:
	MOV	BYTE [FLG.D],0FFH
	MOV	BYTE [FLG.V],0FFH
	MOV	EBX,[ESI]
	CALL	PUTHEXD

	CALL	PUTSPC
	MOV	EBX,[ESI+2*2]
	CALL	PUTHEXD
	CALL	PUTSPC
	MOV	EBX,[ESI+2*4]
	CALL	PUTHEXD
	CALL	PUTCRLF

	CALL	LIST_WORD_EXP

	JMP	ERR_MEM


;

WORD_WORK_LABEL_SIZE		EQU	10000h
WORD_WORK_MACRO_PARAM_SIZE	EQU	0f000h
WORD_WORK_MACRO_SIZE		EQU	30000h
WORD_WORK_EXP_SIZE		EQU	0f000h
WORD_WORK_GLOBAL_SIZE		EQU	40000h

STRING_TBL_SIZE			EQU	06f00h
STRING_MACRO_TBL_SIZE		EQU	20000h

;

INIT_MEMORY:
	MOV	EDI,WORD_WORK_LABEL_INFO
	MOV	EAX,WORD_WORK_LABEL_SIZE
	CALL	ALLOC_TABLE_INFO_ITEM

	MOV	EDI,WORD_WORK_MACRO_PARAM_INFO
	MOV	EAX,WORD_WORK_MACRO_PARAM_SIZE
	CALL	ALLOC_TABLE_INFO_ITEM

	MOV	EDI,WORD_WORK_MACRO_INFO
	MOV	EAX,WORD_WORK_MACRO_SIZE
	CALL	ALLOC_TABLE_INFO_ITEM

	MOV	EDI,WORD_WORK_EXP_INFO
	MOV	EAX,WORD_WORK_EXP_SIZE
	CALL	ALLOC_TABLE_INFO_ITEM

	MOV	EDI,WORD_WORK_GLOBAL_INFO
	MOV	EAX,WORD_WORK_GLOBAL_SIZE
	CALL	ALLOC_TABLE_INFO_ITEM

	;

	MOV	EDI,STRING_TBL_INFO
	MOV	EAX,STRING_TBL_SIZE
	CALL	ALLOC_TABLE_INFO_ITEM

	MOV	EDI,STRING_MACRO_TBL_INFO
	MOV	EAX,STRING_MACRO_TBL_SIZE
	CALL	ALLOC_TABLE_INFO_ITEM

	RET

;	EDI:pnt to INFO
;	EAX:size

ALLOC_TABLE_INFO_ITEM:
	PUSH	EAX
	PUSH	EDI
	CALL	ALLOC
	POP	EDI
	POP	ECX
	MOV	[EDI],EAX
	MOV	[EDI+8],EAX

	ADD	EAX,ECX
	MOV	[EDI+4],EAX
	RET
;

UNINIT_MEMORY:
	RET
