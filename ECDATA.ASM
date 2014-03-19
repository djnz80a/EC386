
;------------- EC1.ASM ------------------
REF_DRV:db	'b:\',0


;------------- EC1.ASM end --------------

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

word_defined:db	'defined',0

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

;------------- EC1.ASM ------------------

dump_eax:ds	4
dump_ebx:ds	4

MEM_MAX:DS	4

STACK:	DS	4



FLG.OPT:DS	4;1

FLG.L:	DS	4;1

TYPE_INT:DD	0082H
TYPE_UINT:DD	0002H

FLG.S:	DS	4;1

FLG.3:	DS	4
TYPE_PNT:DD	0002H

FLG.N:	DD	0

FLG.U:	DS	4

FLG.A:	DS	4

FLG.Z:	DS	4
HDLOUT:	DS	4

FLG.B:	DS	4

FLG.CPP:DS	4

TMP_EXP_PNT:DS	4;2

FLG.P:	DS	4;2
FLG.M:	DS	4;2

EXITCODE:DS	4

NODE_CHAR:DS	4;2
NODE_INT:DS	4;2
NODE_LONG:DS	4;2

CASE_WORK_TOP:DS	4
CASE_WORK_PNT:DS	4
CASE_WORK_END:DS	4

SWITCH.L1:DS	4;2
SWITCH.L2:DS	4;2
SWITCH.L3:DS	4;2

SWITCH.TYPE:DS	4;2

IF.TYPE:DS	4;2

IF.CALL:DS	4;2

IF.REV:DS	4;2
IF.NOT:DS	4;2

IF.L1:	DS	4;2
IF.L2:	DS	4;2

IF.FIRST:DS	4;2


LOCAL_LEVEL:DS	4;2
DEF_TYPE:DS	4;2

FUNC_NEXT_ARG:DS	4

FUNC_PNT:DS	4

ARG_LEVEL:DS	4

func_init_exp_top:ds	4
func_init_exp:	ds	4

FUNC_TYPE:DS	4

IN_FUNC:DS	4

BREAK.PNT:DS	4

CONTINUE.PNT:DS	4


;------------- EC1.ASM end --------------


;------------- ECDCL.ASM ------------------

STRUCT_UNION:DS	4;2

FLG.REGISTER:DS	4
FLG.EXTRN:DS	4;2
FLG.STATIC:DS	4;2
FLG.UNSIGNED:DS	4;2


ENUM_NAME:DS	4
ENUM_NO:DS	4


CLASS_NAME:
	DS	300

IS_SAMEOFF:DS	4
IS_BITFIELD:DS	4

;STRUCT_NAME:DS	4;2
STRUCT_LEVEL:DS	4;2

FLG.STRUCT:DS	4



;------------- ECDCL.ASM end ---------------

;------------- ECMK.ASM -------------------

OUTC.BUF:
	DS	1

ADRS_L:	DS	4;2

CHECKT_WORK:
	DS	300

FLG.MK0:DS	4

CALLBYNAME:DS	4
MK_FNC_TYPE:DS	4
MK_FNC_STRUCT_SIZE:DS	4

MK_ARY.ADR:DS	4;2	;DB	0

MK_LET.OP:DS	4;2

PR_LET:
	DB	0

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

USE_OFFSET:DS	4


LOADED_REGISTER_EDI:DS	4

REGISTER_EAX:DS	4
REGISTER_EBX:DS	4
REGISTER_ECX:DS	4
REGISTER_EDX:DS	4
REGISTER_ESI:DS	4
REGISTER_EDI:DS	4

LEVEL_EAX:DS	4
LEVEL_EBX:DS	4
LEVEL_ECX:DS	4
LEVEL_EDX:DS	4
LEVEL_ESI:DS	4
LEVEL_EDI:DS	4

STACKP:	DD	REGISTER_STACK

REGISTER_STACK:
	DS	4*100H

REG_NAME:DS	4;2


;-------------- ECMK2.ASM end --------------

;-------------- ECEXP.ASM ------------------

ARG_CNT:DD	0

TYPE_L:	DS	4
TYPE_R:	DS	4

TYPE_SIGN:DS	4

EXP_2TRM.WORD:DS	4

EXP_MEMBER.T:
	DS	4


;-------------- ECEXP.ASM end --------------

;------------- ECDEF.ASM ------------------

FLG.AN_DEF:DS	4

FLG_ARG2:DS	4

FLG.K:	DS	4

FLG.ARG:DS	4

NODE_A_DEF:DS	4
FLG.A_DEF:DS	4


IS_CLNCLN:DS	4

KR_ARG_CNT:DS	4

DEF_FNC_NAME:DS	4

NEXT_ARG:DS	4

;------------- ECDEF.ASM end ---------------


;-------------- ECTBL.ASM ------------------

MAKE_WORD10_PROG:DD	MAKE_WORD
MAKE_WORD0_PROG:
	DD	SET_WORD_BX

LABEL_NO:DD	0000H

FLG.SET_STRING_MACRO:DS	4	;2


WORD_WORK_LOCAL_PNT:DS	4;2
WORD_WORK_GLOBAL_PNT:DS	4;2

SEARCH_DEF:DS	4;2
SEARCH_WORD2.PNT:DS	4;2

SEARCH_WORD2.CNT:DS	4

STRING_MACRO_SEG:DD	0C000H	;dummy

	ALIGN	4

;WORD_WORK_MEMBER_INFO:
;	DD	WORD_WORK_MEMBER
;	DD	WORD_WORK_MEMBER_END
;	DD	WORD_WORK_MEMBER
	DD	0
WORD_WORK_LABEL_INFO:
	DD	WORD_WORK_LABEL
	DD	WORD_WORK_LABEL_END
	DD	WORD_WORK_LABEL
	DD	0
WORD_WORK_MACRO_PARAM_INFO:
	DD	WORD_WORK_MACRO_PARAM
	DD	WORD_WORK_MACRO_PARAM_END
	DD	WORD_WORK_MACRO_PARAM
	DD	0
WORD_WORK_MACRO_INFO:
	DD	WORD_WORK_MACRO
	DD	WORD_WORK_MACRO_END
	DD	WORD_WORK_MACRO
	DD	0
WORD_WORK_EXP_INFO:
	DD	WORD_WORK_EXP
	DD	WORD_WORK_EXP_END
	DD	WORD_WORK_EXP
	DD	0
;WORD_WORK_LOCAL_INFO:
;	DD	WORD_WORK_LOCAL
;	DD	WORD_WORK_LOCAL_END
;	DD	WORD_WORK_LOCAL

WORD_WORK_GLOBAL_INFO:
	DD	WORD_WORK_GLOBAL
	DD	WORD_WORK_GLOBAL_END
	DD	WORD_WORK_GLOBAL
	DD	0

;-------------- ECTBL.ASM end ---------------

;-------------- ECPRE.ASM --------------------


WORD_WORK3_SIZE EQU 3000-40
WORD_WORK3:
	DS	3000;1000;160

PREP_EOL:DS	4

IF.LEVEL:	DS	4;2

SUBWRK:	DS	80

FCB:	DD	FCB_WORK

FCB_WORK:DS	800

LIN.NO:	DD	1

LOAD.F:	DS	4;2

INCLUDE_CHR:DS	4

;-------------- ECPRE.ASM end -----------------


;-------------- ECMISC.ASM -------------------

CLINE:	DS	100H

;-------------- ECMISC.ASM end -----------------


;-------------- FLOAT30.CLB ------------------

fsub.sgn:ds	2

set_f.work:ds	100


;-------------- FLOAT30.CLB end --------------

;--------------- ECSUB.ASM ------------------

PRINT.VESP:	DS	4
PRINT.VEIP:	DS	4

ESI_SAVE:DS	4
EBX_SAVE:DS	4

PRINT_ARG:
	DS	4*10h

	ALIGN	4

IS_TBL:	DS	100H

CHR_WORK:
	DS	4

WORD_WORK_GLOBAL_SAVE:DS	4;2

FLG.PRINT_STRING2:DS	4



FLG.PREP:DS	4

FLG.D:	DS	4;2	;Debug
FLG.V:	DS	4;2	;Verbose

S.LEFT:	DS	4;2
S.PNT:	DS	4;2
FL.END:	DS	4;2

W.LEFT:	DS	4;2
W.PNT:	DS	4;2

HDL:	DS	4;2
HDL2:	DS	4;2

FILE1:	DS	80
FILE2:	DS	80



WORD_WORK_SIZE EQU	1800H-40
WORD_WORK:DS	1800H

WORD_WORK2_SIZE EQU	1800H-40
WORD_WORK2:DS	1800H

WORD_PNT:DS	4;2

NAME_PNT:DS	4;2

MACRO_LEVEL:DS	4;2
MACRO_PNT:DS	4;2
MACRO_TBL:DS	80

MACRO_WORD_WORK_SIZE EQU	1800H-40
MACRO_WORD_WORK:DS	1800H

MACRO_WORD_WORK2_SIZE EQU	1800H-40
MACRO_WORD_WORK2:DS	1800H

MACRO_NAME:DS	200H

STRING_PNT:DS	4;2
STRING_MACRO_PNT:DS	4;2

UNGETC_MAX:

	DS	4000;1000;200H	;for ungetc
USRDMA:

;---------------- ECSUB.ASM end ----------------

