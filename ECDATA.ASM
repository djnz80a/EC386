
;------------- EC386.ASM ------------------
REF_DRV:db	'b:\',0


;------------- EC386.ASM end --------------

;------------- ECDCL.ASM ------------------
STR_DB:	DB	'DB	',0
STR_DW:	DB	'DW	',0
STR_DD:	DB	'DD	',0

;------------- ECDCL.ASM end ---------------


;------------- ECMK.ASM --------------------

STR_ADD:DB	'ADD',0
STR_INC:DB	'INC',0
STR_SUB:DB	'SUB',0
STR_DEC:DB	'DEC',0

PR_MINUS.W:
	DB	'	NEG	BX',0DH,0AH,0
PR_MINUS.L:
	DB	'	NEG	EBX',0DH,0AH,0
PR_MINUS.F:
	DB	'	call	fneg_',0DH,0AH,0


;------------- ECMK.ASM end ----------------


;-------------- ECMK2.ASM ------------------

STR_BL:	DB	'BL',0
STR_BX:	DB	'BX',0
STR_EBX:DB	'EBX',0
STR_AX:	DB	'AX',0

STR_EDI:DB	'EDI',0

STR_BYTE:DB	'BYTE',0
STR_WORD:DB	'WORD',0

WORD_ADD:DB	'ADD',0
WORD_SUB:DB	'SUB',0
WORD_AND:DB	'AND',0
WORD_OR:DB	'OR',0
WORD_XOR:DB	'XOR',0

;-------------- ECMK2.ASM end --------------

;-------------- ECEXP.ASM ------------------

WORD_CLASSX:DB	'classx',0

;-------------- ECEXP.ASM end --------------

;------------- ECDEF.ASM ------------------

WORD_ATAT:DB	'@@_',0

WORD_THIS:DB	'this',0

;------------- ECDEF.ASM end ---------------

;-------------- ECTBL.ASM ------------------

SHARE_STR_00:
	DB	'00',0


;-------------- ECTBL.ASM end ---------------

;-------------- ECPRE.ASM --------------------

WORD_LINE:DB	'line',0

WORD_DEFINE:DB	'define',0
WORD_UNDEF:DB	'undef',0
WORD_IFDEF:DB	'ifdef',0
WORD_IFNDEF:DB	'ifndef',0
WORD_ENDIF:DB	'endif',0
WORD_ELIF:DB	'elif',0
WORD_INCLUDE:DB	'include',0

WORD_DEFINED:DB	'DEFINED',0

DUMMY_STR:DB	'--',0

WORD__LINE__:
	DB	'__LINE__',0

WORD__FILE__:
	DB	'__FILE__',0

WORD__TIME__:
	DB	'__TIME__',0


;-------------- ECPRE.ASM end -----------------

;-------------- ECMISC.ASM -------------------

;-------------- ECMISC.ASM end -----------------

;-------------- FLOAT30.CLB ------------------



;-------------- FLOAT30.CLB end --------------


;------------- ECSUB.ASM ------------------

EMES_TYPE:DB	'type error!!$'

EMES_SYNTAX:DB	'syntax error$'

EMES_UNDEF:DB	'undefined$'


EMES_ALLOC:
	DB	'allocate failed$'

EMES_OPEN:
	DB	'open failed$'

EMES_MEM:
	DB	'memory over$'

EMES_MEM_CASE:
	DB	'memory over(case)$'

EMES_TBL:
	DB	'table size > 10000H$'

EMES_RECNO:
	DB	'illegal record#$'

EMES_MAKE:
	DB	'make failed$'

EMES_WRITE:
	DB	'write error$'

EMES_INCLUDE:
	DB	'too many include$'

EMES_MACRO:
	DB	'macro error$'

EMES_MACRO_LPAR:
	DB	'macro name without lpar$'

EMES_MACRO_MEM:
	DB	'macro memory full$'

EMES_MACRO_EXP_MEM:
	DB	'macro expand memory full$'

EMES_MACRO_PARAM_MEM:
	DB	'macro param memory full$'

EMES_MACRO_ARG_CNT:
	DB	'macro arg cnt$'

EMES_DEFINE_MEM:
	DB	'define memory full$'

EMES_EOF:
	DB	'unexpected EOF$'

EMES_INFUNC:
	DB	'eof in func$'

EMES_ARG:
	DB	'arg error$'

EMES_NUMBER:
	DB	'number error$'

EMES_SIZEOF0:
	DB	'sizeof==0$'

EMES_OTHERS:
	DB	'other error$'

EMES_PREP:
	DB	'prep error$'

EMES_WORK:
	DB	'work error$'

EMES_TYPE_ENUM:
	DB	'type of enum$'

STR_ASM:DB	'.ASM',0

STR_C:DB	'.C',0

;--------------- ECSUB.ASM end ------------

;--------------------------------------------

;------------- EC386.ASM ------------------

;;MEM_MAX:	DD	0

STACK:	DD	0



FLG.OPT:DD	0

FLG.L:	DD	0

TYPE_INT:	DD	0082H
TYPE_UINT:	DD	0002H

FLG.S:	DD	0

FLG.3:	DD	0
TYPE_PNT:	DD	0002H

FLG.N:	DD	0

FLG.U:	DD	0

FLG.A:	DD	0

FLG.Z:	DD	0
HDLOUT:	DD	0

FLG.B:	DD	0

FLG.CPP:DD	0

TMP_EXP_PNT:	DD	0

FLG.P:	DD	0
FLG.M:	DD	0

EXITCODE:	DD	0

NODE_CHAR:	DD	0
NODE_INT:	DD	0
NODE_LONG:	DD	0

CASE_WORK_TOP:	DD	0
CASE_WORK_PNT:	DD	0
CASE_WORK_END:	DD	0

SWITCH.L1:	DD	0
SWITCH.L2:	DD	0
SWITCH.L3:	DD	0

SWITCH.TYPE:	DD	0

IF.TYPE:	DD	0

IF.CALL:	DD	0

IF.REV:	DD	0
IF.NOT:	DD	0

IF.L1:	DD	0
IF.L2:	DD	0

IF.FIRST:	DD	0


LOCAL_LEVEL:	DD	0
DEF_TYPE:	DD	0

FUNC_NEXT_ARG:	DD	0

FUNC_PNT:	DD	0

ARG_LEVEL:	DD	0

FUNC_INIT_EXP_TOP:	DD	0
FUNC_INIT_EXP:		DD	0

FUNC_TYPE:	DD	0

IN_FUNC:	DD	0

BREAK.PNT:	DD	0

CONTINUE.PNT:	DD	0


;------------- EC386.ASM end --------------


;------------- ECDCL.ASM ------------------

STRUCT_UNION:	DD	0

FLG.REGISTER:	DD	0
FLG.EXTRN:	DD	0
FLG.STATIC:	DD	0
FLG.UNSIGNED:	DD	0


ENUM_NAME:	DD	0
ENUM_NO:	DD	0


CLASS_NAME:	TIMES	300	DB 00h

IS_SAMEOFF:	DD	0
IS_BITFIELD:	DD	0

;STRUCT_NAME:	DD	0
STRUCT_LEVEL:	DD	0

FLG.STRUCT:	DD	0



;------------- ECDCL.ASM end ---------------

;------------- ECMK.ASM -------------------

OUTC.BUF:	DB	0

ADRS_L:	DD	0

CHECKT_WORK:	TIMES	300	DB 00h

FLG.MK0:	DD	0

CALLBYNAME:	DD	0
MK_FNC_TYPE:	DD	0
MK_FNC_STRUCT_SIZE:	DD	0

MK_ARY.ADR:	DD	0

MK_LET.OP:	DD	0

PR_LET:	DB	0

;-------------- ECMK.ASM end ---------------

;-------------- ECMK2.ASM ------------------

LOAD_REG:
	DB	'BX',0	;DB	'BX$'
STORE_REG:	DB	'SI',0

STORE_REG.BT1:
	DB	'SI',0

STORE_REG.BT2:
	DB	'SI',0

LOAD_REG.BT:
	DB	'BX',0

LOAD_XREG.V:
	DB	'SX',0	;MOVSX / MOVDX
LOAD_XREG:
	DB	'BX',0

USE_OFFSET:	DD	0


LOADED_REGISTER_EDI:	DD	0

REGISTER_EAX:	DD	0
REGISTER_EBX:	DD	0
REGISTER_ECX:	DD	0
REGISTER_EDX:	DD	0
REGISTER_ESI:	DD	0
REGISTER_EDI:	DD	0

LEVEL_EAX:	DD	0
LEVEL_EBX:	DD	0
LEVEL_ECX:	DD	0
LEVEL_EDX:	DD	0
LEVEL_ESI:	DD	0
LEVEL_EDI:	DD	0

STACKP:	DD	REGISTER_STACK

REGISTER_STACK:	TIMES	4*100H	DB 00h

REG_NAME:	DD	0


;-------------- ECMK2.ASM end --------------

;-------------- ECEXP.ASM ------------------

ARG_CNT:DD	0

TYPE_L:	DD	0
TYPE_R:	DD	0

TYPE_SIGN:	DD	0

EXP_2TRM.WORD:	DD	0

EXP_MEMBER.T:	DD	0


;-------------- ECEXP.ASM end --------------

;------------- ECDEF.ASM ------------------

FLG.AN_DEF:	DD	0

FLG_ARG2:	DD	0

FLG.K:	DD	0

FLG.ARG:	DD	0

NODE_A_DEF:	DD	0
FLG.A_DEF:	DD	0


IS_CLNCLN:	DD	0

KR_ARG_CNT:	DD	0

DEF_FNC_NAME:	DD	0

NEXT_ARG:	DD	0

;------------- ECDEF.ASM end ---------------


;-------------- ECTBL.ASM ------------------

MAKE_WORD10_PROG:	DD	MAKE_WORD
MAKE_WORD0_PROG:	DD	SET_WORD_BX

LABEL_NO:	DD	0000H

FLG.SET_STRING_MACRO:	DD	0


WORD_WORK_LOCAL_PNT:	DD	0
WORD_WORK_GLOBAL_PNT:	DD	0

SEARCH_DEF:		DD	0
SEARCH_WORD2.PNT:	DD	0

SEARCH_WORD2.CNT:	DD	0

STRING_MACRO_SEG:	DD	0C000H	;dummy

	ALIGN	4

;WORD_WORK_MEMBER_INFO:
;	DD	WORD_WORK_MEMBER
;	DD	WORD_WORK_MEMBER_END
;	DD	WORD_WORK_MEMBER
	DD	0
WORD_WORK_LABEL_INFO:
	DD	0;WORD_WORK_LABEL
	DD	0;WORD_WORK_LABEL_END
	DD	0;WORD_WORK_LABEL
	DD	0
WORD_WORK_MACRO_PARAM_INFO:
	DD	0;WORD_WORK_MACRO_PARAM
	DD	0;WORD_WORK_MACRO_PARAM_END
	DD	0;WORD_WORK_MACRO_PARAM
	DD	0
WORD_WORK_MACRO_INFO:
	DD	0;WORD_WORK_MACRO
	DD	0;WORD_WORK_MACRO_END
	DD	0;WORD_WORK_MACRO
	DD	0
WORD_WORK_EXP_INFO:
	DD	0;WORD_WORK_EXP
	DD	0;WORD_WORK_EXP_END
	DD	0;WORD_WORK_EXP
	DD	0
;WORD_WORK_LOCAL_INFO:
;	DD	WORD_WORK_LOCAL
;	DD	WORD_WORK_LOCAL_END
;	DD	WORD_WORK_LOCAL

WORD_WORK_GLOBAL_INFO:
	DD	0;WORD_WORK_GLOBAL
	DD	0;WORD_WORK_GLOBAL_END
	DD	0;WORD_WORK_GLOBAL
	DD	0


;STRING_TBL EQU			WORD_WORK_EXP_END+1000h		;40000H
;STRING_TBL_END EQU		STRING_TBL+6f00h		;57F00H

;STRING_MACRO_TBL	EQU	WORD_WORK_GLOBAL_END+1000h	;0C9000H
;STRING_MACRO_TBL_END	EQU	STRING_MACRO_TBL+20000h		;0E0000H


STRING_TBL_INFO:
	DD	0	;STRING_TBL
	DD	0	;STRING_TBL_END
	DD	0	;not used
	DD	0	;not used

STRING_MACRO_TBL_INFO:
	DD	0	;STRING_MACRO_TBL
	DD	0	;STRING_MACRO_TBL_END
	DD	0	;not used
	DD	0	;not used

;-------------- ECTBL.ASM end ---------------

;-------------- ECPRE.ASM --------------------


WORD_WORK3_SIZE EQU 3000-40
WORD_WORK3:	TIMES	3000	DB	00h

PREP_EOL:	DD	0

IF.LEVEL:	DD	0

SUBWRK:	TIMES	80	DB 00h

FCB:	DD	FCB_WORK

FCB_WORK:	TIMES	800	DB 00h

LIN.NO:	DD	1

LOAD.F:	DD	0

INCLUDE_CHR:	DD	0

;-------------- ECPRE.ASM end -----------------


;-------------- ECMISC.ASM -------------------

CLINE:	TIMES	100H	DB 00h

;-------------- ECMISC.ASM end -----------------


;-------------- FLOAT30.CLB ------------------

fsub.sgn:	DW	0

;set_f.work:	TIMES	100	DB 00h


;-------------- FLOAT30.CLB end --------------

;--------------- ECSUB.ASM ------------------

PRINT.VESP:	DD	0
PRINT.VEIP:	DD	0

ESI_SAVE:	DD	0
EBX_SAVE:	DD	0

PRINT_ARG:	TIMES	4*10h	DB 00h

	ALIGN	4

IS_TBL:	TIMES	100H	DB 00h

CHR_WORK:	DD	0

WORD_WORK_GLOBAL_SAVE:	DD	0

FLG.PRINT_STRING2:	DD	0



FLG.PREP:	DD	0

FLG.D:	DD	0	;Debug
FLG.V:	DD	0	;Verbose

S.LEFT:	DD	0
S.PNT:	DD	0
FL.END:	DD	0

W.LEFT:	DD	0
W.PNT:	DD	0

HDL:	DD	0
HDL2:	DD	0

FILE1:	TIMES	80	DB 00h
FILE2:	TIMES	80	DB 00h



WORD_WORK_SIZE EQU	1800H-40
WORD_WORK:	TIMES	1800H	DB 00h

WORD_WORK2_SIZE EQU	1800H-40
WORD_WORK2:	TIMES	1800H	DB 00h

WORD_PNT:	DD	0

NAME_PNT:	DD	0

;MACRO_LEVEL:	DD	0
;MACRO_PNT:	DD	0
;MACRO_TBL:	TIMES	80	DB 00h

MACRO_WORD_WORK_SIZE EQU	1800H-40
MACRO_WORD_WORK:	TIMES	1800H	DB 00h

MACRO_WORD_WORK2_SIZE EQU	1800H-40
MACRO_WORD_WORK2:	TIMES	1800H	DB 00h


MACRO_NAME:	TIMES	200H	DB 00h

STRING_PNT:		DD	0
STRING_MACRO_PNT:	DD	0

UNGETC_MAX:	TIMES	4000	DB 00h;for ungetc
USRDMA:

;---------------- ECSUB.ASM end ----------------

