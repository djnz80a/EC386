%IF OS_WIN
;
;	EDX:filename
;	AL:mode(unused)
;	>EAX:handle
;
SYS_open:
	CALL	INT21_open
	RET

;	EDX:filename
;	AL:mode(unused)
;	>EAX:handle
SYS_create:
	CALL	INT21_create
	RET

;	AL:0(from top)/1(from current)/2(from bottom)
;	EBX:handle
;	CX:DX:distance
SYS_seek:
	CALL	INT21_seek
	RET

;	EBX:handle
;	ECX:bytes
;	EDX:address

SYS_read:
	CALL	INT21_read
	RET

;	EBX:handle
;	ECX:bytes
;	EDX:address

SYS_write:
	CALL	INT21_write
	RET

;	EBX:handle
SYS_truncate:
	CALL	INT21_truncate
	RET

;	EBX:handle
SYS_close:
	CALL	INT21_close
	RET

SYS_exit:
	CALL	INT21_exit
	RET

SYS_putchr:
	CALL	INT21_putchr
	RET

;	EDX:pnt to string (ends with '$')
SYS_putstr:
	CALL	INT21_putstr
	RET




SYS_gettime:
	CALL	INT21_gettime
	RET


SYS_stdin_status:
	CALL	INT21_stdin_status
	RET

SYS_getchr:
	CALL	INT21_getchr
	RET

;#define INVALID_HANDLE_VALUE ((HANDLE)(LONG_PTR)-1)

INVALID_HANDLE_VALUE EQU -1




;
;3d00	open
;	edx=filename
;	>ax handle
;	>cf=1 : error
INT21_open:

	PUSHAD
	MOV	AL,'['
	CALL	DOS02
	MOV	ESI,EDX
	CALL	_PUTSTR
	MOV	AL,']'
	CALL	DOS02
	CALL	_PUTCRLF
	POPAD

	PUSH	0		;templateFile
	PUSH	FILE_ATTRIBUTE_NORMAL
	PUSH	OPEN_EXISTING	;CREATE_ALWAYS	;CREATE_NEW
	PUSH	0		;securityAttribute
	PUSH	0		;shareMode
	PUSH	GENERIC_READ
	PUSH	EDX		;FILENAME_TEST1
	CALL	[IAT_CreateFileA]
	CMP	EAX,INVALID_HANDLE_VALUE
	JE	INT21_open.ERR

	;MOV	[HDL_INFILE],EAX

	CLC
	RET
INT21_open.ERR:
	STC
	RET

;
;3c00	create
;	edx=filename
;	>ax handle
;	>cf=1 : error

;
INT21_create:

	PUSHAD
	MOV	AL,'['
	CALL	DOS02
	MOV	ESI,EDX
	CALL	_PUTSTR
	MOV	AL,']'
	CALL	DOS02
	CALL	_PUTCRLF
	POPAD

	PUSH	0		;templateFile
	PUSH	FILE_ATTRIBUTE_NORMAL
	PUSH	CREATE_ALWAYS	;CREATE_NEW
	PUSH	0		;securityAttribute
	PUSH	0		;shareMode
	PUSH	GENERIC_WRITE
	PUSH	EDX		;FILENAME_TEST1
	CALL	[IAT_CreateFileA]
	CMP	EAX,INVALID_HANDLE_VALUE
	JE	INT21_create.ERR

	;MOV	[HDL_OUTFILE],EAX

	CLC
	RET
INT21_create.ERR:
	STC
	RET


;#define FILE_BEGIN           0
;#define FILE_CURRENT         1
;#define FILE_END             2

;4200	seek
;	bx=handle
;	cx : dx offset
;
;	> dx : ax current pointer

INT21_seek:
	SHL	ECX,10h
	MOV	CX,DX

	MOVZX	EAX,AL

	PUSH	EAX
	PUSH	0	;size<2GB
	PUSH	ECX
	PUSH	EBX
	CALL	[IAT_SetFilePointer]

	MOV	EDX,EAX
	SHR	EDX,10H
	MOVZX	EAX,AX

	CLC

;erro check?

	RET

INT21_getfilepointer:
	


;
;3f00	read
;	bx=handle
;	edx=buf
;	ecx=bytes
;	>eax read bytes

INT21_read:
	
	PUSH	0
	PUSH	N_READ
	PUSH	ECX
	PUSH	EDX	;READ_BUF
	PUSH	EBX	;[HDL_STDOUT]
	CALL	[IAT_ReadFile]
	OR	EAX,EAX
	JE	INT21_read.ERR

	MOV	EAX,[N_READ]
	CLC
	RET
INT21_read.ERR:
	XOR	EAX,EAX
	STC
	RET

;4000	write
;	bx=handle
;	edx=buf
;	ecx=bytes
;	>eax wrote bytes
;	cf=1 : error	
;
;4000	write/truncate
;	ecx=edx=0
;	bx=handle

INT21_write:
	XOR	EAX,EAX
	MOV	AX,CX
	OR	AX,DX
	JE	INT21_truncate

	PUSH	0
	PUSH	N_WROTE
	PUSH	ECX
	PUSH	EDX	;READ_BUF
	PUSH	EBX	;[HDL_STDOUT]
	CALL	[IAT_WriteFile]
	OR	EAX,EAX
	JE	INT21_write.ERR

	MOV	EAX,[N_WROTE]

	CLC
	RET

INT21_write.ERR:
	XOR	EAX,EAX
	STC
	RET


INT21_truncate:
	PUSH	EBX
	CALL	[IAT_SetEndOfFile]
	RET


;3e00	close
;	bx=handle
;	cf=1 : error
INT21_close:
	PUSH	EBX
	CALL	[IAT_CloseHandle]
	OR	EAX,EAX
	JE	INT21_close.ERR

	CLC
	RET

INT21_close.ERR:
	STC
	RET


;4c	exit
;	al=code

INT21_exit:
	MOVZX	EAX,AL
	PUSH	EAX
	CALL	[IAT_ExitProcess]

	RET


INTE4_putchr:
	MOV	DL,AL
	JMP	INT21_putchr

INT21_putchr:
	MOV	AL,DL
	CALL	_PUTCHR
	RET

INT21_putstr:
	;JMP	_DOS09


	PUSHAD
INT21_putstr.1:
	MOV	AL,[EDX]
	CMP	AL,'$'
	JE	INT21_putstr.2
	PUSH	EDX
	;CALL	DOS02
	MOV	DL,AL
	CALL	INT21_putchr
	POP	EDX
	INC	EDX
	JMP	INT21_putstr.1

INT21_putstr.2:
	POPAD
	RET

;2c
;>ch : hour
;>cl : minute
;>dl : 1/100 seconds

INT21_gettime:

	;TODO
	MOV	CH,0
	MOV	CL,0
	MOV	DL,0

	RET

;0b
;>al 0 : no chr available / ff : chr available
INT21_stdin_status:
	;TODO

	MOV	AL,0
	RET

;01
;>al : chr
INT21_getchr:
	;TODO readfile from hdl_stdin

	MOV	AL,0
	ret

;25
INT21_setinterrupt:

	;dummy

	RET

_DOS09:
;	PUSH	EAX
;	MOV	AH,09H
;	INT	21H
;	POP	EAX

	PUSHAD
_DOS09.1:
	MOV	AL,[EDX]
	CMP	AL,'$'
	JE	_DOS09.R
	PUSH	EDX
	CALL	DOS02
	POP	EDX
	INC	EDX
	JMP	_DOS09.1

_DOS09.R:
	POPAD
	RET

;
;
;
;DOS02:
;	DB	60H
;	MOV	AH,02H
;	MOV	DL,AL
;	INT	21H
;	DB	61H

;	PUSHAD
;	CALL	_PUTCHR
;	POPAD
;	RET
%ELSE

;
;	EDX:filename
;	AL:mode(unused)
;	>EAX:handle
;

	global	SYS_open
SYS_open:
	MOV	EDX,0	;mode
	MOV	ECX,0	;flags O_RDONLY=0
	MOV	EBX,EDX	;filename
	MOV	EAX,5	;sys_open
	int	80h
	CMP	EAX,0
	JLE	SYS_open.ERR
	CLC
	RET
SYS_open.ERR:
	STC
	ret

;	EDX:filename
;	AL:mode(unused)
;	>EAX:handle

SYS_create:
	MOV	ECX,448	;0700
	MOV	EBX,EDX
	MOV	EAX,8	;sys_creat
	int	80h
	ret

;	AL:0(from top)/1(from current)/2(from bottom)
;	EBX:handle
;	CX:DX:distance

SYS_seek:
	MOVZX	EDX,AL

	SHL	ECX,10h
	MOV	CX,DX

	MOV	EAX,19	;sys_lseek
	int	80h
	ret

;	EBX:handle
;	ECX:bytes
;	EDX:address

SYS_read:
	XCHG	ECX,EDX
	MOV	EAX,3	;sys_read
	int	80h
	RET

;	EBX:handle
;	ECX:bytes
;	EDX:address

SYS_write:
	XCHG	ECX,EDX
	MOV	EAX,4	;sys_write
	int	80h
	ret

SYS_truncate:
	;MOV	EBX,	;size
	MOV	EAX,93	;sys_ftruncate
	RET
;
;	EBX:handle
;

SYS_close:
	MOV	EAX,6	;sys_close
	int	80h
	RET

;
;	al=code
;

SYS_exit:
	MOVZX	EAX,AL
	MOV	EBX,EAX
	MOV	EAX,1	;sys_exit
	int	80h
	RET

;
;
;

SYS_putchr:
	MOV	AL,DL
	CALL	_PUTCHR
	RET
%IF 0
;_PUTCHR:
        PUSHAD

        MOV     [PUTCHR_BUF],AL

        MOV     EDX,1           ;len
        MOV     ECX,PUTCHR_BUF  ;address
        MOV     EBX,1           ;stdout
        MOV     EAX,4           ;sys_write
        INT     80H

        POPAD
        RET
%ENDIF


SYS_putstr:

	PUSHAD
sys_putstr.1:
	MOV	AL,[EDX]
	CMP	AL,'$'
	JE	sys_putstr.2
	PUSH	EDX
	;CALL	DOS02
	MOV	DL,AL
	CALL	SYS_putchr
	POP	EDX
	INC	EDX
	JMP	sys_putstr.1

sys_putstr.2:
	POPAD
	RET


SYS_gettime:
SYS_stdin_status:
SYS_getchr:
	RET
INTE4_putchr:
	RET

%ENDIF

