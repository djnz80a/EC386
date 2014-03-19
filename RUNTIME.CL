
	EXTRN	IAT_GetStdHandle
	EXTRN	IAT_WriteFile
	EXTRN	IAT_ReadFile
	EXTRN	IAT_CreateFileA
	EXTRN	IAT_CloseHandle
	EXTRN	IAT_ExitProcess
	EXTRN	IAT_GetCommandLineA
	EXTRN	IAT_SetFilePointer
	EXTRN	IAT_SetEndOfFile
	EXTRN	IAT_GlobalAlloc
	EXTRN	IAT_GlobalFree

	EXTRN	_RDATA
	EXTRN	_RDATA_FILL:
	EXTRN	_RDATA_END

	EXTRN	_DATA
	EXTRN	_DATA_FILL
	EXTRN	_DATA_END

	EXTRN	ENTRY_IAT
	EXTRN	ENTRY_IMPORT

	EXTRN	STR_HELLO
	EXTRN	FILENAME_TEST1

	EXTRN	N_WROTE
	EXTRN	HDL_STDIN
	EXTRN	HDL_STDOUT
	EXTRN	HDL_STDERR

	EXTRN	HDL_OUTFILE

	EXTRN	N_READ
	EXTRN	PUTCHR_BUF
	EXTRN	CMDLINE
	EXTRN	READ_BUF

	PUBLIC	_TEXT_RVA
	PUBLIC	_RDATA_RVA
	PUBLIC	_DATA_RVA

	PUBLIC	BASE


;FIXED? : make handle -> dword
;OP.TBL pnt WORD -> DWORD
;TODO:
;ERR_CONT:
;	CALL	ERRSUB
;	MOV	ESP,[STACK]	<- ok?
;

;remove ".reloc" section

	;;ORG	00400000h

BASE:

;http://msdn.microsoft.com/en-us/library/ms809762.aspx
;HelloWorld_Con.exe

PE_OFFSET EQU	000000C0H

;must be aligned
DATA_ADD EQU 8000h+8000h+8000h+20000h	;read buffer level 0 + write buffer + read buffer level 1~ + rest

;TODO: get ride of ".reloc" section?
;TODO: make same alignment
;FILE_ALIGN EQU	200h
FILE_ALIGN EQU	1000h	;##
SECTION_ALIGN EQU	1000h
;SECTION_ALIGN EQU	200h	;##

;_TEXT_RVA EQU	1000h
;_RDATA_RVA EQU	2000h
;_DATA_RVA EQU	3000h
;_RELOC_RVA EQU	4000h

_TEXT_RVA EQU	_TEXT-BASE
_RDATA_RVA EQU	_RDATA-BASE
_DATA_RVA EQU	_DATA-BASE
;_RELOC_RVA EQU	_RELOC-BASE+DATA_ADD


_RDATA_SIZE EQU	_RDATA_END-_RDATA
_DATA_SIZE EQU	_DATA_END-_DATA+DATA_ADD
;_RELOC_SIZE EQU _RELOC_END-_RELOC
_RELOC_SIZE EQU 0

CODE_SIZE EQU	_TEXT_END-_TEXT
INIT_DATA_SIZE EQU	_RDATA_SIZE+_DATA_SIZE+_RELOC_SIZE
UNINIT_DATA_SIZE EQU	0

;BASE_SIZE EQU	_RELOC_RVA+SECTION_ALIGN	;_RELOC_SIZE
BASE_SIZE EQU	_DATA_RVA+_DATA_SIZE	;SECTION_ALIGN	;_RELOC_SIZE

ENTRY_RVA EQU	_TEXT_RVA


HEADER:
	DB	'M','Z'
	DW	0090h	;Bytes on last page of file
	DW	0003h	;Pages in file
	DW	0000h	;Relocations
	DW	0004h	;Size of header in paragraphs
	DW	0000h	;Minimum extra paragraphs needed
	DW	0FFFFh	;Maximum extra paragraphs needed
	DW	0000h	;Initial (relative) SS value

;+10
	DW	00B8h	;Initial SP value
	DW	0000h	;Checksum
	DW	0000h	;Initial IP value
	DW	0000h	;Initial (relative) CS value
	DW	0040h	;File address of relocation table
	DW	0000h	;Overlay number
	DW	0000h	;Reserved words
	DW	0000h	;Reserved words

;+20
	DW	0000h	;Reserved words
	DW	0000h	;Reserved words
	DW	0000h	;OEM identifier (for e_oeminfo)
	DW	0000h	;OEM information; e_oemid specific
	DW	0000h	;Reserved words
	DW	0000h	;Reserved words
	DW	0000h	;Reserved words
	DW	0000h	;Reserved words
;+30
	DW	0000h	;Reserved words
	DW	0000h	;Reserved words
	DW	0000h	;Reserved words
	DW	0000h	;Reserved words
	DW	0000h	;Reserved words
	DW	0000h	;Reserved words
;+3c
	DD	PE_OFFSET	;000000C0H	;DW	00C0H, 0000h	;File address of new exe header
;+40
	DB	0Eh, 1Fh,0BAh, 0Eh, 00h,0B4h, 09h,0CDh
	DB	21h,0B8h, 01h, 4Ch,0CDh, 21h, 54h, 68h
	DB	69h, 73h, 20h, 70h, 72h, 6Fh, 67h, 72h
	DB	61h, 6Dh, 20h, 63h, 61h, 6Eh, 6Eh, 6Fh
	DB	74h, 20h, 62h, 65h, 20h, 72h, 75h, 6Eh
	DB	20h, 69h, 6Eh, 20h, 44h, 4Fh, 53h, 20h
	DB	6Dh, 6Fh, 64h, 65h, 2Eh, 0Dh, 0Dh, 0Ah
	DB	24h, 00h, 00h, 00h, 00h, 00h, 00h, 00h


	;PUSH	CS
	;POP	DS
	;MOV	DX,MES_DUMMY-HEADER-40H
	;MOV	AH,9
	;INT	21H
	;MOV	AX,4C01H
	;INT	21H
;MES_DUMMY:
	;DB	"This program cannot be run in DOS mode.", 0dh, 0dh, 0ah, '$'

;+80
	

	;DS	HEADER+0c0h-$
	DS	BASE+PE_OFFSET-$

;+c0
	DB	'P','E', 00h, 00h
	DW	014ch		;Machine	= IMAGE_FILE_MACHINE_I386
	DW	0003h	;0004h		;NumberOfSections
	DD	529037aeh	;TimeDateStamp
	DD	00000000h	;PointerToSymbolTable
;+d0
	DD	00000000h	;NumberOfSymbols
	DW	00E0h		;SizeOfOptionalHeader
	DW	0102h		;Characteristics = IMAGE_FILE_32BIT_MACHINE(0x0100)
				;		| IMAGE_FILE_EXECUTABLE_IMAGE(0x0002)
;+d8
	DW	010Bh		;Magic
	DB	09h	;MajorLinkerVersion
	DB	00h	;MinorLinkerVersion
	DD	CODE_SIZE	;00000200h	;SizeOfCode
;+e0
	DD	INIT_DATA_SIZE	;00000600h	;SizeOfInitializedData
	DD	UNINIT_DATA_SIZE	;00000000h	;SizeOfUninitializedData
	DD	ENTRY_RVA	;00001000h	;AddressOfEntryPoint
	DD	_TEXT_RVA	;00001000h	;BaseOfCode
;+f0
	DD	_RDATA_RVA	;00002000h	;BaseOfData
	DD	BASE	;00400000h	;ImageBase
	DD	SECTION_ALIGN	;00001000h	;SectionAlignment

	DD	FILE_ALIGN	;00000200h	;FileAlignment
;+100
	DW	0005h	;MajorOperatingSystemVersion
	DW	0000h	;MinorOperatingSystemVersion
	DW	0000h	;MajorImageVersion
	DW	0000h	;MinorImageVersion
	DW	0005h	;MajorSubsystemVersion
	DW	0000h	;MinorSubsystemVersion
	DD	00000000h	;Win32VersionValue
;+110
	DD	BASE_SIZE	;00005000h	;SizeOfImage
	DD	_TEXT-BASE	;00000400h	;SizeOfHeaders
	DD	00000000h	;CheckSum
	DW	0003h		;Subsystem = IMAGE_SUBSYSTEM_WINDOWS_CUI(3)

;IMAGE_SUBSYSTEM_WINDOWS_GUI          2   // Image runs in the Windows GUI subsystem.
;IMAGE_SUBSYSTEM_WINDOWS_CUI          3   // Image runs in the Windows character subsystem.


	;DW	8540h		;DllCharacteristics
	;DW	8500h
	;DW	8000h
	DW	0
				;
				;IMAGE_DLLCHARACTERISTICS_DYNAMIC_BASE 0x0040     // DLL can move.
				;IMAGE_DLLCHARACTERISTICS_NX_COMPAT    0x0100     // Image is NX compatible
				;IMAGE_DLLCHARACTERISTICS_NO_SEH       0x0400     // Image does not use SEH.  No SE handler may reside in this image
				;IMAGE_DLLCHARACTERISTICS_TERMINAL_SERVER_AWARE     0x8000

;IMAGE_DLLCHARACTERISTICS_FORCE_INTEGRITY    0x0080     // Code Integrity Image


;+120
	DD	00100000h	;SizeOfStackReserve
	DD	00001000h	;SizeOfStackCommit
	DD	00100000h	;SizeOfHeapReserve
	DD	00001000h	;SizeOfHeapCommit
;+130
	DD	00000000h	;LoaderFlags
	DD	00000010h	;NumberOfRvaAndSizes

;+138
	DD	00000000h	;#0
	DD	00000000h
;+140
	DD	ENTRY_IMPORT-_RDATA+_RDATA_RVA	;0000200ch	;#1 IMAGE_DIRECTORY_ENTRY_IMPORT
	DD	ENTRY_IMPORT_END-ENTRY_IMPORT	;00000028h
	DD	00000000h	;#2 IMAGE_DIRECTORY_ENTRY_RESOURCE
	DD	00000000h
;+150
	DD	00000000h	;#3
	DD	00000000h
	DD	00000000h	;#4
	DD	00000000h
;+160
	DD	0	;00004000h	;#5 IMAGE_DIRECTORY_ENTRY_BASERELOC
	DD	0	;00000010h
	DD	00000000h	;#6 IMAGE_DIRECTORY_ENTRY_DEBUG
	DD	00000000h
;+170
	DD	00000000h	;#7
	DD	00000000h
	DD	00000000h	;#8
	DD	00000000h
;+180
	DD	00000000h	;#9
	DD	00000000h
	DD	00000000h	;#a
	DD	00000000h
;+190
	DD	00000000h	;#b
	DD	00000000h
	DD	_RDATA_RVA	;00002000h	;#c IMAGE_DIRECTORY_ENTRY_IAT
	DD	ENTRY_IAT_END-ENTRY_IAT	;0000000ch
;+1a0
	DD	00000000h	;#d
	DD	00000000h
	DD	00000000h	;#e
	DD	00000000h
;+1b0
	DD	00000000h	;#f
	DD	00000000h

;section header
;+1b8	(c0('PE') + f8)
	DB	".text",0,0,0
	DD	_TEXT_FILL-_TEXT	;0000001dh	;adrs/size
	DD	_TEXT_RVA	;00001000h	;VirtualAddress
	DD	_TEXT_END-_TEXT	;00000200h	;SizeOfRawData
	DD	_TEXT-BASE	;00000400h	;PointerToRawData
	DD	00000000h	;PointerToRelocations
	DD	00000000h	;PointerToLinenumbers
	DW	0000h		;NumberOfRelocations
	DW	0000h		;NumberOfLinenumbers
	DD	60000020h	;Characteristics
	;DD	60000020h+80000000h	;Characteristics
	;	IMAGE_SCN_CNT_CODE	(00000020)
	;	| IMAGE_SCN_MEM_EXECUTE	(20000000)
	;	| IMAGE_SCN_MEM_READ	(40000000)
;+1e0
	DB	".rdata", 0,0
	DD	_RDATA_FILL-_RDATA	;0000006ah
	DD	_RDATA_RVA	;00002000h	;VirtualAddress
	DD	_RDATA_END-_RDATA	;00000200h	;SizeOfRawData
	DD	_RDATA-BASE	;00000600h	;PointerToRawData
	DD	00000000h
	DD	00000000h
	DW	0000h
	DW	0000h
	DD	40000040h
	;	IMAGE_SCN_CNT_INITIALIZED_DATA	(00000040)
	;	| IMAGE_SCN_MEM_READ		(40000000)

;+208
	DB	".data",0,0,0
	DD	DATA_ADD+_DATA_FILL-_DATA	;0000000fh
	DD	_DATA_RVA	;00003000h	;VirtualAddress
	DD	_DATA_END-_DATA	;00000200h	;SizeOfRawData
	DD	_DATA-BASE	;00000800h	;PointerToRawData
	DD	00000000h
	DD	00000000h
	DW	0000h
	DW	0000h
	DD	0c0000040h
	;	IMAGE_SCN_CNT_INITIALIZED_DATA(00000040)
	;	| IMAGE_SCN_MEM_READ	(40000000)
	;	| IMAGE_SCN_MEM_WRITE	(80000000)
;;+230
;	DB	".reloc",0,0
;	DD	_RELOC_FILL-_RELOC	;00000028h
;	DD	_RELOC_RVA	;00004000h	;VirtualAddress
;	DD	_RELOC_END-_RELOC	;00000200h	;SizeOfRawData
;	DD	_RELOC-BASE	;00000a00h	;PointerToRawData
;	DD	00000000h
;	DD	00000000h
;	DW	0000h
;	DW	0000h
;	DD	42000040h
;	;	IMAGE_SCN_CNT_INITIALIZED_DATA	(00000040)
;	;	| IMAGE_SCN_MEM_DISCARDABLE	(02000000)
;	;	| IMAGE_SCN_MEM_READ		(40000000)


;#define IMAGE_SCN_ALIGN_16BYTES              0x00500000  // Default alignment if no others are specified.

;+258



	;ds	HEADER+0400h-$
	ALIGN	FILE_ALIGN

_TEXT:

;+400	".text"

	PUSH	DWORD -10
	CALL	[IAT_GetStdHandle]
	MOV	[HDL_STDIN],EAX

	PUSH	DWORD -11
	CALL	[IAT_GetStdHandle]
	MOV	[HDL_STDOUT],EAX

	PUSH	DWORD -12
	CALL	[IAT_GetStdHandle]
	MOV	[HDL_STDERR],EAX

	CALL	[IAT_GetCommandLineA]
	MOV	[CMDLINE],EAX

	MOV	ESI,EAX
	CALL	_PUTSTR




	;JMP	TEST_HELLO

	;JMP	TEST2
	;JMP	TEST3
	;JMP	TEST4
	;JMP	TEST5
	;JMP	TEST6
	;JMP	TEST7

	;;JMP	A386_MAIN
	JMP	RUNTIME_MAIN

	PUSH	DWORD -12;-11;	PUSH	0FFFFFFF5h
	;CALL	[IAT_GetStdHandle-_RDATA+_RDATA_RVA+BASE]	;CALL	[00402000h]
	CALL	[IAT_GetStdHandle]

	push	eax

	push	0
	push	N_WROTE	;0
	push	0eh
	;push	STR_HELLO-_DATA+_DATA_RVA+BASE	;00403000h
	push	STR_HELLO
	push	EAX
	;CALL	[IAT_WriteFile-_RDATA+_RDATA_RVA+BASE]	;;call	[00402004h]
	CALL	[IAT_WriteFile]

	pop	eax

	push	0
	mov	ebx,esp;	lea	eax,[esp+0]
	push	0
	push	ebx
	push	0eh
	push	STR_HELLO
	push	eax
	call	[IAT_WriteFile]

	pop	eax

;	XOR	EAX,EAX
	RET


TEST2:
	PUSH	DWORD -10
	CALL	[IAT_GetStdHandle]
	MOV	[HDL_STDIN],EAX

	PUSH	DWORD -11
	CALL	[IAT_GetStdHandle]
	MOV	[HDL_STDOUT],EAX


	PUSH	0
	PUSH	N_READ
	PUSH	100
	PUSH	READ_BUF
	PUSH	[HDL_STDIN]
	call	[IAT_ReadFile]

	PUSH	0
	PUSH	N_WROTE
	PUSH	[N_READ]
	PUSH	READ_BUF
	PUSH	[HDL_STDOUT]
	call	[IAT_WriteFile]

	MOV	EAX,[N_READ]

	RET


CREATE_NEW          EQU 1
CREATE_ALWAYS       EQU 2
OPEN_EXISTING       EQU 3
OPEN_ALWAYS         EQU 4
TRUNCATE_EXISTING   EQU 5

GENERIC_READ	EQU	80000000h
GENERIC_WRITE	EQU	40000000h
FILE_ATTRIBUTE_NORMAL EQU	00000080h

TEST3:
	PUSH	0		;templateFile
	PUSH	FILE_ATTRIBUTE_NORMAL
	PUSH	CREATE_ALWAYS	;CREATE_NEW
	PUSH	0		;securityAttribute
	PUSH	0		;shareMode
	PUSH	GENERIC_WRITE
	PUSH	FILENAME_TEST1
	CALL	[IAT_CreateFileA]
	MOV	[HDL_OUTFILE],EAX

	push	0
	push	N_WROTE	;0
	push	0eh
	push	STR_HELLO
	push	EAX
	CALL	[IAT_WriteFile]


	PUSH	[HDL_OUTFILE]
	CALL	[IAT_CloseHandle]

	RET


TEST4:
	CALL	[IAT_GetCommandLineA]
	MOV	[CMDLINE],EAX

	MOV	ESI,EAX
	CALL	_PUTSTR

	RET

TEST5:
	MOV	EBX,[IAT_ExitProcess]

	;CLI
	XOR	EAX,EAX
	MOV	AX,CS
	MOV	DS,AX
	MOV	ES,AX
	;MOV	SS,AX
	;MOV	ESP,_TEXT_FILL-4
	;STI

	PUSH	100
	PUSH	EBX
	RET

	MOV	EAX,100
	PUSH	EAX
	CALL	[IAT_ExitProcess]

	RET

TEST6:
	CALL	[IAT_GetCommandLineA]
	MOV	[CMDLINE],EAX

	MOV	ESI,EAX
	CALL	_PUTSTR

	MOV	EAX,[_DATA_FILL]


	MOV	EAX,[_TEXT]

	MOV	[_TEXT],EAX	;exception

	MOV	ESI,[CMDLINE]
	CALL	_PUTSTR

	RET

TEST_HELLO:
	MOV	ESI,STR_HELLO
	CALL	_PUTSTR
	RET

TEST7:
;	MOV	EDI,USRDMA
;	MOV	ECX,10000h
;TEST7.10:
;	MOV	[EDI],AL
;	INC	EDI
;	DEC	ECX
;	JNE	TEST7.10

	CALL	TEST_HELLO
	MOV	AL,'7'
	CALL	_PUTCHR
	CALL	_PUTCRLF
	RET

_PUTCRLF:
	MOV	AL,0Dh
	CALL	_PUTCHR
	MOV	AL,0AH
	CALL	_PUTCHR
	RET

;
_PUTSTR:
	MOV	AL,[ESI]
	OR	AL,AL
	JE	_PUTSTR.R

	CALL	_PUTCHR

	INC	ESI
	JMP	_PUTSTR

_PUTSTR.R:
	RET

_PUTCHR:
	PUSHAD

	MOV	[PUTCHR_BUF],AL

	PUSH	0
	MOV	EAX,ESP

	push	0
	push	EAX	;push	N_WROTE	;0
	push	01h
	push	PUTCHR_BUF
	push	[HDL_STDOUT]
	CALL	[IAT_WriteFile]

	POP	EAX

	POPAD
	RET


GMEM_FIXED	EQU	00000000H
GMEM_ZEROINIT	EQU	00000040H

;	EAX<size
;	>EAX memory address

ALLOC:
	MOV	EBX,GMEM_FIXED+GMEM_ZEROINIT
	PUSH	EAX
	PUSH	EBX
	CALL	[IAT_GlobalAlloc]

	OR	EAX,EAX
	;;JE	ERR_ALLOC

	PUSHAD
	MOV	EBX,EAX
	;;CALL	PUTH4
	POPAD

	RET

;	EAX<memory address

FREE:
	PUSH	EAX
	CALL	[IAT_GlobalFree]

	RET

;################



;	EXTRN	_PUTHEX_L
;	EXTRN	BOTTOM

;	PUBLIC	P1
;	PUBLIC	P2
;	PUBLIC	P3
;	PUBLIC	P4
;	PUBLIC	P5
;	PUBLIC	P6

	;PUBLIC	VRAM_SEG

	PUBLIC	INT0E.0

	PUBLIC	_DS86
	PUBLIC	_ES86
	PUBLIC	_EAX86
	PUBLIC	_EBX86
	PUBLIC	_ECX86
	PUBLIC	_EDX86
	PUBLIC	_ESI86
	PUBLIC	_EDI86

	PUBLIC	PROG86
	PUBLIC	CALL86
	PUBLIC	COPYTO86

	PUBLIC	PROG_INT

	PUBLIC	SIZEOF_FILE
	PUBLIC	FILE_WORK
	PUBLIC	MALLOC_MAX
	PUBLIC	MALLOC_P
	PUBLIC	MEM_MAX

	PUBLIC	_STDIN
	PUBLIC	_STDOUT
	PUBLIC	_STDERR

	PUBLIC	USRDTA

	PUBLIC	TOUPPER
	PUBLIC	END_FILE

;	PUBLIC	_IMOD.L
	PUBLIC	SHR.L
	PUBLIC	SAR.L
	PUBLIC	SHL.L
	PUBLIC	PUSHSTRUCT
	PUBLIC	POPSTRUCT
	PUBLIC	RETSTRUCT

	PUBLIC	TOLOWER
	PUBLIC	TOUPPER

	PUBLIC	_ERRNO

	PUBLIC	_IDIV
	PUBLIC	_IDIV.L
	PUBLIC	_UDIV
	PUBLIC	_UDIV.L

	PUBLIC	_IMOD.L
	PUBLIC	_UMOD.L

	PUBLIC	IDIV_
	PUBLIC	IDIV.L_
	PUBLIC	UDIV_
	PUBLIC	UDIV.L_
	PUBLIC	IMOD.L_
	PUBLIC	UMOD.L_

	PUBLIC	MYDTA

P1	EQU	4*2
P2	EQU	6*2
P3	EQU	8*2
P4	EQU	10*2
P5	EQU	12*2
P6	EQU	14*2

VRAM_SEG EQU	104H

CS#	EQU	2EH
DS#	EQU	3EH
ES#	EQU	26H
SS#	EQU	36H

SIZEOF_FILE EQU	20H
FILES	EQU	20

;USRDMA	EQU	20000H

RUNTIME_MAIN:
	mov	eax,ds
	db	0fh,03h,0c0h	;lsl eax,eax
	mov	[MEM_MAX],eax

	sub	eax,100h
	and	eax,0fffffff0h

	CLI
	MOV	ESP,eax	;40000H
	mov	eax,ds
	mov	ss,eax
	STI

	MOV	EAX,ESP
	SUB	EAX,8000H
	MOV	[MALLOC_MAX],EAX

	call	SETINT	;setint

	;	CALL	EXPAND_SEG
	;	DB	0FH,20H,0D8H	;MOV EAX,CR3
	;	DB	0FH,22H,0D8H	;MOV CR3,EAX

	JMP	START

;
;
;
EXPAND_SEG:
	CLI
	PUSH	DS
	MOV	EAX,30H
	MOV	DS,EAX

	MOV	AX,0FFFFH
	MOV	[10H],AX

	MOV	AL,[10H+6]
	AND	AL,0F0H
	OR	AL,8CH
	MOV	[10H+6],AL

	POP	DS
	STI
	RET



;	dummy

_ASSERT:
	RET

SETINT_SUB:
	MOV	EBX,EDX
	MOV	AX,2504H
	INT	21H
	RET
;

;int ds,es;
;int eax,ebx,ecx,edx,esi,edi;


_DS86:	DS	4
_ES86:	DS	4

_EAX86:	DS	4
_EBX86:	DS	4
_ECX86:	DS	4
_EDX86:	DS	4
_ESI86:	DS	4
_EDI86:	DS	4


;
;	EBX:seg adrs
;

FUNC2510:
	mov	edi,0

	mov	ecx,0
	mov	edx,_work
	mov	ax,2510h
	int	21h

	jmp	r1

_work:	dw	14h	;ds
	dw	14h	;es
	dw	14h	;fs
	dw	14h	;gs
	dw	0C010H	;?

	dd	0	;eax
	dd	0	;ebx
	dd	0	;ecx
	dd	0	;edx

	dd	0	;?
	dd	0	;?

r1:
	RET

;
;	EAX:sector
;
;	BX:cnt
;

CALL86:
	;MOV	EBX,200000H+30000H
	MOV	EBX,200000H+PROG86
	MOV	AX,2509H
	INT	21H
	MOV	[CDPROG],ECX

	mov	ax,[_EAX86]
	mov	[prog_ax],ax
	mov	ax,[_EBX86]
	mov	[prog_bx],bx
	mov	ax,[_ECX86]
	mov	[prog_cx],ax
	mov	ax,[_EDX86]
	mov	[prog_dx],ax
	mov	ax,[_ESI86]
	mov	[prog_si],ax
	mov	ax,[_EDI86]
	mov	[prog_di],ax

	;CALL	COPY_PROG

	MOV	EBX,[CDPROG]
	SHL	EBX,12		;*1000H
	CALL	FUNC2510
	RET

;cdprog:
CDPROG:
	ds	4
;
;
;

COPY_PROG:
	push	ds
	pop	es

	mov	esi,PROG86
	mov	edi,30000H;10000h;[_phyadr]
	mov	ecx,400h
	cld
	rep
	movsb
	jmp	copy_r

;
	ALIGN	16
PROG86:
	jmp	prog86.10

	ds	200h


	NOP		;jmp to here
	NOP
prog86.10:
	push	ds

	mov	ax,cs
	mov	ds,ax
	mov	es,ax

	db	0b8h	;ax
prog_ax:
		dw	05c0h
	db	0b9h	;cx
prog_cx:
		dw	0
	db	0bah	;dx
prog_dx:
		dw	0
	db	0bbh	;bx
prog_bx:
		dw	16;1
	db	0beh	;si
prog_si:
		dw	0
	db	0bfh	;di
prog_di:
		dw	1000h

;	db	9ah
;		dw	0014h,0fffbh
PROG_INT EQU	$+1
	int	21h

	pop	ds

	db	0cbh	;retf
;	ret

copy_r:
	RET

	ds	100h

;
;	ESI:string
;	EDI:offset
;
COPYTO86:
	ADD	EDI,PROG86
COPYTO86.10:
	LODSB
	STOSB
	OR	AL,AL
	JNE	COPYTO86.10

	RET

;
;
;

SETINT:
	PUSH	DS

	CLI
	MOV	AX,CS
	MOV	DS,AX

	MOV	CH,12H
	MOV	CL,0
	MOV	ESI,INT_INFO
SETINT.10:
	PUSH	ECX
	PUSH	ESI
	MOV	EDX,[ESI]
	CALL	SETINT_SUB
	POP	ESI
	POP	ECX
	ADD	ESI,4
	inc	cl
	DEC	CH
	JNE	SETINT.10

	POP	DS

	STI

;	MOV	BYTE [FLG.V],0FFH
;	MOV	BYTE [FLG.D],0FFH

;	MOV	EAX,[80000000H]

;	XOR	EAX,EAX
;	XOR	EDX,EDX
;	DIV	EAX

	RET

INT_INFO:
	DD	INT00,INT01,INT02,INT03
	DD	INT04,INT05,INT06,INT07
	DD	INT08,INT09,INT0A,INT0B
	DD	INT0C,INT0D,INT0E,INT0F
	DD	INT10,INT11

INT01:
INT02:
INT03:
INT04:
INT05:
INT06:
INT07:
INT08:
INT09:
INT0A:
INT0B:
INT0C:
INT0F:
INT10:
INT11:

INT00:
	sti
	push	14h
	pop	ds

	PUSH	DWORD 0		;dummy status

	PUSH	EMES_DIV
	JMP	INT0D.0

	;JMP	INT00

INT0D:
	PUSH	EMES_PROT
INT0D.0:
	CLI
	push	14h
	pop	ds
	mov	[dump_eax],eax
	mov	[dump_ebx],ebx

;	mov	byte [flg.v],0ffh
;	mov	byte [flg.d],0ffh


;	mov	al,'b'
;	call	putchr_con
;	mov	eax,[dump_ebx]
;	call	disp_ax
;	mov	al,' '
;	call	putchr_con
;
;	MOV	EAX,ESP
;	CALL	DISP_AX
;	MOV	AL,'='
;	CALL	PUTCHR_con
;

	MOV	[INT0D_WORK],EAX
	MOV	EBX,[dump_ebx]
	MOV	[INT0D_WORK+4],EBX
	MOV	[INT0D_WORK+4*2],ECX
	MOV	[INT0D_WORK+4*3],EDX
	MOV	[INT0D_WORK+4*4],ESI
	MOV	[INT0D_WORK+4*5],EDI
	MOV	[INT0D_WORK+4*6],ESP
	MOV	[INT0D_WORK+4*7],EBP

	MOV	EBP,ESP

	;MOV	EDX,EMES_PROT
	POP	EDX
	MOV	AH,9
	INT	21H

		PUSH	[EBP+0]
		;;CALL	_PUTHEX_L
		ADD	ESP,4

	MOV	DL,'<'
	MOV	AH,2
	INT	21H

	PUSH	[EBP+4]
		;PUSH	[_spt]
	;;CALL	_PUTHEX_L
	ADD	ESP,4

	MOV	DL,' '
	MOV	AH,2
	INT	21H

	PUSH	[EBP+8]
	;;CALL	_PUTHEX_L
	ADD	ESP,4

	MOV	DL,' '
	MOV	AH,2
	INT	21H

	PUSH	[EBP+0CH]
	;;CALL	_PUTHEX_L
	ADD	ESP,4

	MOV	DL,' '
	MOV	AH,2
	INT	21H

	PUSH	[EBP+10H]
	;;CALL	_PUTHEX_L
	ADD	ESP,4

	MOV	DL,' '
	MOV	AH,2
	INT	21H

	PUSH	[EBP+14H]
	;;CALL	_PUTHEX_L
	ADD	ESP,4

	MOV	DL,' '
	MOV	AH,2
	INT	21H

	PUSH	[EBP+18H]
	;;CALL	_PUTHEX_L
	ADD	ESP,4

	MOV	DL,0DH
	MOV	AH,2
	INT	21H
	MOV	DL,0AH
	MOV	AH,2
	INT	21H

	MOV	EDX,REGNAMES
	MOV	AH,9
	INT	21H

	MOV	EDX,STR_CRLF
	MOV	AH,9
	INT	21H

	CALL	PUTREGS

	MOV	EDX,STR_CRLF
	MOV	AH,9
	INT	21H

;	push	[_spt_top]
;	call	_puthex_l
;	add	esp,4

;	CALL	DISP_AX
;	MOV	AL,':'
;	CALL	PUTCHR_CON

	MOV	DL,':'
	MOV	AH,2
	INT	21H

		MOV	EAX,[EBP+4]
		PUSH	[EAX]
		;;CALL	_PUTHEX_L
		ADD	ESP,4

;	MOV	EBP,ESP
;	PUSH	[EBP+4]
;	CALL	_PUTHEX_L
;	ADD	ESP,4

;	MOV	AL,':'
;	CALL	PUTCHR_CON
;	MOV	EBP,ESP
;	MOV	EAX,[EBP+8]
;	CALL	DISP_AX

		MOV	AH,1
		INT	21H
		CMP	AL,'@'-40H
		JNE	INT0D.E

		MOV	AX,3C00H
		MOV	EDX,DUMP_FILE
		MOV	ECX,0
		INT	21H

		MOV	BX,AX
		PUSH	EBX
		MOV	AX,4000H
		MOV	ECX,BOTTOM
		MOV	EDX,0
		INT	21H
		POP	EBX
		MOV	AX,3E00H
		INT	21H
INT0D.E:
	;JMP	INT0D
	MOV	AX,4C01H
	INT	21H

;
PUTREGS:
	MOV	ESI,INT0D_WORK
	MOV	ECX,6
PUTREGS.10:
	PUSH	ECX
	PUSH	ESI

	PUSH	[ESI]
	;;CALL	_PUTHEX_L
	ADD	ESP,4

	MOV	AH,2
	MOV	DL,' '
	INT	21H

	POP	ESI
	POP	ECX
	ADD	ESI,4
	LOOP	PUTREGS.10

	RET

STR_CRLF:
	DB	0DH,0AH,'$'

REGNAMES:
	DB	'EAX      EBX      ECX      EDX      ESI      EDI'
	DB	'$'

DUMP_FILE:
	DB	'B:\DUMP.BIN',0

INT0D_WORK:
	DS	100H

INT0E:
	;JMP	PAGEFAULT
INT0E.0:
	CLI

	MOV	AH,09H
	MOV	EDX,EMES_PAGE
	INT	21H

	DB	0FH,20H,0C0H+2*8	;mov eax,cr2
	PUSH	EAX
	;;CALL	_PUTHEX_L
	POP	EAX

	MOV	EBP,ESP
	PUSH	[EBP+0]
	;;CALL	_PUTHEX_L
	POP	EAX

	MOV	EBP,ESP
	PUSH	[EBP+4]
	;;CALL	_PUTHEX_L
	POP	EAX

	PUSH	[EBP+8]
	;;CALL	_PUTHEX_L
	POP	EAX

	PUSH	[EBP+12]
	;;CALL	_PUTHEX_L
	POP	EAX

;	JMP	INT0E
	MOV	AH,4CH
	INT	21H

dump_eax:ds	4
dump_ebx:ds	4

EMES_DIV:
	DB	'divided by 0$'


EMES_PROT:
	DB	'general protection$'

EMES_PAGE:
	DB	'page fault$'

MALLOC_MAX:DS	4
MEM_MAX:ds	4

	CALL	_main

	MOV	AH,4CH
	INT	21H

ARGC:	DS	4	;2
ARGV:	DS	80

ARGV_WORK:DS	100H

NULL_STR:DB	0

PROG_NAME:
	DB	'prog',0
	DS	80H

START:
	CALL	GETCLINE

	MOV	EBX,ARGV
	MOV	EAX,0	;NULL_STR
	MOV	ECX,10H
CLEAR.ARGV:
	MOV	[EBX],EAX
	ADD	EBX,4
	LOOP	CLEAR.ARGV

	CALL	GET_PROGNAME

	MOV	EAX,PROG_NAME
	MOV	[ARGV],EAX	;argv[0]=prog_name

	MOV	ESI,CLINE+1	;0081H
	MOV	EDI,ARGV+4	;2
	MOV	EBX,ARGV_WORK
	MOV	ECX,1
	CLD

LINE.10:
	MOV	[EDI],EBX
	ADD	EDI,4	;2
LINE:	LODSB
	OR	AL,AL
	JE	LINE.E
	CMP	AL,09H
	JE	LINE
	CMP	AL,20H
	JE	LINE

	INC	ECX
LINE.20:
	MOV	[EBX],AL
	INC	EBX
	LODSB
	OR	AL,AL
	JE	LINE.27
	CMP	AL,09H
	JE	LINE.25
	CMP	AL,20H
	JE	LINE.25
	JMP	LINE.20

LINE.25:
	MOV	BYTE [EBX],0
	INC	EBX
	JMP	LINE.10

LINE.27:
	MOV	BYTE [EBX],0

LINE.E:
;	MOV	DWORD [EDI],0

	pushad
	call	INIT_FILE

	CALL	OPEN_DEBUG

	JMP	NOTV

		PUSH	7FF00H/8-11000H/8
		PUSH	80000000H-200000H+11000H
		;;CALL	__ADD_FREE
		ADD	ESP,4*2

	;	PUSH	1FF00H/8
	;	PUSH	81000000H-200000H
	;	CALL	__ADD_FREE
	;	ADD	ESP,4*2

	;	MOV	EBX,16
	;	PUSH	EBX
	;	CALL	_MALLOC
	;	POP	EBX

	;	MOV	EBX,80000000H-200000H
	;	MOV	DWORD [EBX],0
	;	MOV	DWORD [EBX+4],7FF00H/8;3F000H/8
	;	ADD	EBX,8
	;	PUSH	EBX
	;	CALL	_FREE
	;	POP	EBX

	;	MOV	EBX,81000000H-200000H
	;	MOV	DWORD [EBX],0
	;	MOV	DWORD [EBX+4],1FF00H/8
	;	ADD	EBX,8
	;	PUSH	EBX
	;	CALL	_FREE
	;	POP	EBX
NOTV:
	popad

;	PUSH	DWORD ARGV
	mov	eax,ARGV	;argv
	push	eax
	PUSH	ECX
	CALL	_main
	ADD	ESP,8	;4

		PUSH	EBX
		CALL	INT21_exit	;CALL	_EXIT
		ADD	ESP,4

;	PUSH	EBX
;	CALL	END_FILE
;	POP	EBX
	MOV	AL,BL
	MOV	AH,4CH
	INT	21H

CLINE:	DS	100H

;
GET_PROGNAME:
	PUSH	DS
	PUSH	ES

	MOV	EAX,DS
	MOV	ES,EAX
	MOV	EAX,2CH		;env
	MOV	DS,EAX

	MOV	ESI,0
	CLD
GET_PROGNAME.10:
	LODSB
	OR	AL,AL
	JNE	GET_PROGNAME.10
	LODSB
	OR	AL,AL
	JNE	GET_PROGNAME.10

	LODSW		;01 00

	MOV	EDI,PROG_NAME
GET_PROGNAME.20:
	LODSB
	STOSB
	OR	AL,AL
	JNE	GET_PROGNAME.20

	POP	ES
	POP	DS
	RET

;
;
;

GETCLINE:
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

;

INIT_FILE:
	MOV	ECX,SIZEOF_FILE

	MOV	EBX,FILE_WORK
	MOV	[_STDIN],EBX
	MOV	BYTE [EBX],1
	MOV	BYTE [EBX+1],01H+80H
	MOV	WORD [EBX+2],0
	MOV	DWORD [EBX+8],0
	MOV	DWORD [EBX+0CH],0
	MOV	DWORD [EBX+10H],0

	ADD	EBX,ECX

	MOV	[_STDOUT],EBX
	MOV	BYTE [EBX],1
	MOV	BYTE [EBX+1],02H+80H
	MOV	WORD [EBX+2],1
	MOV	DWORD [EBX+8],0
	MOV	DWORD [EBX+0CH],0
	MOV	DWORD [EBX+10H],0

	ADD	EBX,ECX

	MOV	[_STDERR],EBX
	MOV	BYTE [EBX],1
	MOV	BYTE [EBX+1],02H+80H
	MOV	WORD [EBX+2],2
	MOV	DWORD [EBX+8],0
	MOV	DWORD [EBX+0CH],0
	MOV	DWORD [EBX+10H],0

	;MOV	[MALLOC_P],EBX

		PUSHAD
		MOV	BX,4		;PRN
		MOV	AX,3E00H
		INT	21H
		POPAD
	RET

;
END_FILE:
	MOV	EDI,FILE_WORK
	MOV	ECX,FILES	;8
END_FILE.10:
	PUSH	ECX
	PUSH	EDI

	CMP	BYTE [EDI+0],0
	JE	END_FILE.20

	PUSH	EDI
	;;CALL	_FCLOSE
	ADD	ESP,4
END_FILE.20:

	POP	EDI
	POP	ECX
	ADD	EDI,SIZEOF_FILE
	LOOP	END_FILE.10
	RET

;
OPEN_DEBUG:
	RET

	PUSH	DEBUG_OPENMODE
	PUSH	DEBUG_FILENAME
	;;CALL	_FOPEN
	ADD	ESP,4*2
	OR	EBX,EBX
	JE	OPEN_DEBUG.R

	MOV	[DEBUG_FD],EBX
OPEN_DEBUG.R:
	RET

DEBUG_OPENMODE:
	DB	'w',0
DEBUG_FILENAME:
	DB	'D:\$DEBUG',0


DEBUG_FD:DS	4

	DB	'@@malloc_p@@'
;

MALLOC_P:DD	BOTTOM

;
;	EBX<<EAX
;
SHL.L:
	;		MOV	CL,AL
	;		SHL	EBX,CL
	;		RET

		or	eax,eax
		je	shl.l.r
	CMP	EAX,20H
	JNB	SHL.L.OV
	MOV	CL,AL
	SHL	EBX,CL
	RET

SHL.L.OV:
	XOR	EBX,EBX
shl.l.r:
	RET

;
SAR.L:
	;		MOV	CL,AL
	;		SAR	EBX,CL
	;		RET

		or	eax,eax
		je	sar.l.r
	CMP	EAX,20H
	JNB	SAR.L.OV
	MOV	CL,AL
	SAR	EBX,CL
	RET

SAR.L.OV:
	OR	EBX,EBX
	JS	SAR.L.OV.F
	XOR	EBX,EBX
sar.l.r:
	RET

SAR.L.OV.F:
	XOR	EBX,EBX
	DEC	EBX
	RET

;
SHR.L:
	;		MOV	CL,AL
	;		SHR	EBX,CL
	;		RET

		or	eax,eax
		je	shr.l.r
	CMP	EAX,20H
	JNB	SHR.L.OV
	MOV	CL,AL
	SHR	EBX,CL
	RET

SHR.L.OV:
	XOR	EBX,EBX
shr.l.r:
	RET


;
;	BX / AX

_IDIV:
IDIV_:
	XCHG	BX,AX
	DB	66H
	DB	99H	;CWD
	IDIV	BX
	MOV	BX,AX
	RET

_IDIV.L:
IDIV.L_:
	XCHG	EBX,EAX

IDIV.L_.10:

	DB	99H	;CDQ
	IDIV	EBX

	OR	EDX,EDX
	JNS	IDIV.L_.R

	OR	EBX,EBX
	JE	IDIV.L_.2
	MOV	EDX,1
	JS	IDIV.L_.3
	NEG	EDX
IDIV.L_.3:
	ADD	EAX,EDX
IDIV.L_.2:

IDIV.L_.R:
	MOV	EBX,EAX
	RET

IDIV.L_.20:
	OR	EDX,EDX
	JE	IDIV.L_.R
	INC	EAX
	JMP	IDIV.L_.R

_UDIV:
UDIV_:
	XCHG	BX,AX
	XOR	DX,DX
	DIV	BX
	MOV	BX,AX
	RET

;	EBX/=EAX

_UDIV.L:
UDIV.L_:
	DEC	EAX
	JE	SHORT _UDIV.L#1
	INC	EAX

	XCHG	EBX,EAX
	XOR	EDX,EDX
	DIV	EBX
	MOV	EBX,EAX
	RET

_UDIV.L#1:
	RET

;

_IMOD.L:
IMOD.L_:
	XCHG	EBX,EAX

;	OR	EBX,EBX
;	JNS	IMOD.L_.1
;	NEG	EAX
;	NEG	EBX
IMOD.L_.1:
	DB	99H	;CDQ

	IDIV	EBX
	MOV	EAX,EDX
	OR	EAX,EAX

	JNS	_IMOD.L.10

	OR	EBX,EBX
	JNS	_IMOD.L.2
	NEG	EBX
_IMOD.L.2:
	ADD	EAX,EBX
_IMOD.L.10:
	MOV	EBX,EAX
	RET


_UMOD:
UMOD_:
	PUSH	AX
	XCHG	BX,AX
	XOR	DX,DX
	DIV	BX
	MOV	AX,DX
	POP	BX
	MOV	BX,AX
	RET

_UMOD.L:
UMOD.L_:
	PUSH	EAX
	XCHG	EBX,EAX
	XOR	EDX,EDX
	DIV	EBX
	MOV	EAX,EDX
	POP	EBX
	MOV	EBX,EAX
	RET

PUSHSTRUCT:
	POP	EDX

	MOV	ESI,EBX

	SUB	ESP,ECX
	MOV	EDI,ESP

	MOV	EAX,DS
	MOV	ES,EAX
	JCXZ	PUSHSTRUCT.10

	CLD
	REP
	MOVSB

PUSHSTRUCT.10:
	JMP	EDX

;
POPSTRUCT:
	POP	EDX
	;MOV	ESI,ESP

	MOV	EBX,EDI

	MOV	EAX,DS
	MOV	ES,EAX
	JCXZ	POPSTRUCT.10

	CLD
	REP
	MOVSB

	MOV	ESP,ESI
POPSTRUCT.10:
	JMP	EDX

;
RETSTRUCT:
	MOV	ESI,EBX

	MOV	EAX,DS
	MOV	ES,EAX
	JCXZ	RETSTRUCT.10

	CLD
	REP
	MOVSB
RETSTRUCT.10:
	RET

;
;
;
TOLOWER:
	CMP	AL,'A'
	JB	TOLOWER.R
	CMP	AL,'Z'
	JA	TOLOWER.R
	ADD	AL,20H
TOLOWER.R:
	RET

;
;
;
TOUPPER:
	CMP	AL,'a'
	JB	TOUPPER.R
	CMP	AL,'z'
	JA	TOUPPER.R
	SUB	AL,20H
TOUPPER.R:
	RET



;4c	exit
;	al=code

INT21_exit:
	MOVZX	EAX,AL
	PUSH	EAX
	CALL	[IAT_ExitProcess]

	RET

;
;
;

_STDIN:	DS	4
_STDOUT:DS	4
_STDERR:DS	4

FILE_WORK:
	DS	SIZEOF_FILE*FILES	;10H

_ERRNO:	DS	4

USRDTA:
MYDTA:
	DS	100H


_main:
	CALL	TEST_HELLO
	XOR	EAX,EAX
	CALL	INT21_exit

