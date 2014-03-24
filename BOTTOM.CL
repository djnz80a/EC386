
FILE_ALIGN EQU	1000h	;##

	PUBLIC	BOTTOM

	PUBLIC	.data

	EXTRN	.text
	PUBLIC	.rdata
	PUBLIC	.data
	PUBLIC	.data_end
	PUBLIC	.ENTRY_IAT
	PUBLIC	.ENTRY_IMPORT

	PUBLIC	__IMAGE_DEBUG_DIRECTORY__

_TEXT_END:

;------------------------------------

.rdata:

_RDATA:

;+600	".rdata" ->2000h-

;<- #c IMAGE_DIRECTORY_ENTRY_IAT
;<- 0:FirstThunk

.ENTRY_IAT:
;Import Address Table
ENTRY_IAT:

IMPOFF	EQU	.rdata-00400000h

IAT_GetStdHandle:
;IAT_GetStdHandle EQU $-_RDATA+_RDATA_RVA+BASE
	DD	ENTRY_GetStdHandle+IMPOFF;-_RDATA+_RDATA_RVA	;0000204ch	;DW	0264h / DB	"GetStdHandle",0
IAT_WriteFile:
	DD	ENTRY_WriteFile+IMPOFF;-_RDATA+_RDATA_RVA	;00002040h	;DW	0525h /	DB	"WriteFile", 0
IAT_ReadFile:
	DD	ENTRY_ReadFile+IMPOFF;-_RDATA+_RDATA_RVA
IAT_CreateFileA:
	DD	ENTRY_CreateFileA+IMPOFF;-_RDATA+_RDATA_RVA
IAT_CloseHandle:
	DD	ENTRY_CloseHandle+IMPOFF;-_RDATA+_RDATA_RVA
IAT_ExitProcess:
	DD	ENTRY_ExitProcess+IMPOFF;-_RDATA+_RDATA_RVA
IAT_GetCommandLineA:
	DD	ENTRY_GetCommandLineA+IMPOFF;-_RDATA+_RDATA_RVA
IAT_SetFilePointer:
	DD	ENTRY_SetFilePointer+IMPOFF;-_RDATA+_RDATA_RVA
IAT_SetEndOfFile:
	DD	ENTRY_SetEndOfFile+IMPOFF;-_RDATA+_RDATA_RVA
;IAT_LoadLibraryA:
;	DD	ENTRY_LoadLibraryA+IMPOFF;-_RDATA+_RDATA_RVA
;IAT_GetProcAddressA:
;	DD	ENTRY_GetProcAddress+IMPOFF;-_RDATA+_RDATA_RVA

	DD	00000000h

ENTRY_IAT_END:

;<- #1 IMAGE_DIRECTORY_ENTRY_IMPORT

.ENTRY_IMPORT:

ENTRY_IMPORT:
;+60c	(200ch)
	;DD	ENTRIES_0-_RDATA+_RDATA_RVA	;00002034h	;Characteristics
	DD	ENTRIES_0+IMPOFF
;+610
	DD	00000000h	;TimeDateStamp
	DD	00000000h	;ForwarderChain
	;DD	DLLNAME_KERNEL32-_RDATA+_RDATA_RVA	;0000205ch	;Name = "KERNEL32.dll", 0
	DD	DLLNAME_KERNEL32+IMPOFF
	;DD	_RDATA_RVA	;00002000h	;FirstThunk
	;DD	_RDATA+IMPOFF
	DD	IMPOFF
						;== ENTRY_IAT-_RDATA+_RDATA_RVA
;+620
	DD	00000000h	;Characteristics
	DD	00000000h
	DD	00000000h
	DD	00000000h
;+630
	DD	00000000h	;FirstThunk
ENTRY_IMPORT_END:

ENTRIES_0:
;+634	(2034h) <- 0:Characteristics
	DD	ENTRY_GetStdHandle+IMPOFF;-_RDATA+_RDATA_RVA	;0000204ch	;DW	0264h / DB	"GetStdHandle",0
	DD	ENTRY_WriteFile+IMPOFF;-_RDATA+_RDATA_RVA	;00002040h	;DW	0525h / DB	"WriteFile", 0
	DD	ENTRY_ReadFile+IMPOFF;-_RDATA+_RDATA_RVA
	DD	ENTRY_CreateFileA+IMPOFF;-_RDATA+_RDATA_RVA
	DD	ENTRY_CloseHandle+IMPOFF;-_RDATA+_RDATA_RVA
	DD	ENTRY_ExitProcess+IMPOFF;-_RDATA+_RDATA_RVA
	DD	ENTRY_GetCommandLineA+IMPOFF;-_RDATA+_RDATA_RVA
	DD	ENTRY_SetFilePointer+IMPOFF;-_RDATA+_RDATA_RVA
	DD	ENTRY_SetEndOfFile+IMPOFF;-_RDATA+_RDATA_RVA
	;DD	ENTRY_LoadLibraryA+IMPOFF;-_RDATA+_RDATA_RVA
	;DD	ENTRY_GetProcAddress+IMPOFF;-_RDATA+_RDATA_RVA

	DD	00000000h


ENTRY_GlobalFree:
	DW	0
	DB	"GlobalFree",0
	ALIGN	4

ENTRY_GlobalAlloc:
	DW	0
	DB	"GlobalAlloc",0
	ALIGN	4

ENTRY_SetEndOfFile:
	DW	0
	DB	"SetEndOfFile", 0
	ALIGN	4

ENTRY_SetFilePointer:
	DW	0
	DB	"SetFilePointer", 0
	ALIGN	4

ENTRY_GetCommandLineA:
	DW	0
	DB	"GetCommandLineA", 0
	ALIGN	4

ENTRY_ExitProcess:
	DW	0
	DB	"ExitProcess",0
	ALIGN	4

ENTRY_CloseHandle:
	DW	0
	DB	"CloseHandle", 0
	ALIGN	4

ENTRY_CreateFileA:
	DW	0
	DB	"CreateFileA", 0
	ALIGN	4

ENTRY_ReadFile:
	DW	0
	DB	"ReadFile", 0
	ALIGN	4

;+640	(2040h)
ENTRY_WriteFile:
	DW	0525h
	DB	"WriteFile", 0

;+64c	(204ch)
ENTRY_GetStdHandle:
	DW	0264h
	DB	"GetStdHandle",0
	DB	0

;+65c	(205ch)
DLLNAME_KERNEL32:
	DB	"KERNEL32.dll", 0
	DB	0,0,0


;//
;// Debug Format
;//
;
;typedef struct _IMAGE_DEBUG_DIRECTORY {
;    DWORD   Characteristics;
;    DWORD   TimeDateStamp;
;    WORD    MajorVersion;
;    WORD    MinorVersion;
;    DWORD   Type;
;    DWORD   SizeOfData;
;    DWORD   AddressOfRawData;
;    DWORD   PointerToRawData;
;} IMAGE_DEBUG_DIRECTORY, *PIMAGE_DEBUG_DIRECTORY;

IMAGE_DEBUG_TYPE_COFF	EQU             1

	ALIGN	32

ENTRY_DEBUG:
__IMAGE_DEBUG_DIRECTORY__:
	DD	0	;Characteristics
	DD	529037aeh	;TimeDateStamp
	DW	0	;MajorVersion
	DW	0	;MinorVersion
	DD	IMAGE_DEBUG_TYPE_COFF	;Type

	;DD	_DEBUG_END-_DEBUG_HEADER1 ;-18	;SizeOfData;
	;DD	_DEBUG_FILL-_DEBUG_HEADER1 ;-18	;SizeOfData;
	DD	_DEBUG_NAME_END-_DEBUG_HEADER1

	DD	0  ;_DEBUG_HEADER1-_DEBUG+_DEBUG_RVA	;AddressOfRawData
	;DD	_DEBUG_HEADER1-_DEBUG;-BASE	;PointerToRawData
	DD	_DEBUG_HEADER1-BASE
	;DD	0ff000000h

;
;http://msdn.microsoft.com/en-us/library/windows/desktop/ms680307%28v=vs.85%29.aspx
;
;SizeOfData
;    The size of the debugging information, in bytes. This value does not include the debug directory itself.
;
;AddressOfRawData
;    The address of the debugging information when the image is loaded, relative to the image base.
;
;PointerToRawData
;    A file pointer to the debugging information.


;IMAGE_DEBUG_DIRECTORY	size=1ch

;---------



_RDATA_FILL:
	;ds	HEADER+0800h-$
	ALIGN	FILE_ALIGN	;200h

_RDATA_END:

;-----------------------

.data:

_DATA:


STR_HELLO:
	DB	"Hello, World!", 0ah, 0

FILENAME_TEST1:
	DB	"CreateFileTest.txt", 0

	ALIGN	4

N_WROTE:DD	0

HDL_STDIN:DD	0
HDL_STDOUT:DD	0
HDL_STDERR:DD	0

HDL_OUTFILE:DD	0

N_READ:DD	0

PUTCHR_BUF:DS	1

CMDLINE:ds	4

READ_BUF:	ds	200

;USRDMA:



_DATA_FILL:
	;ds	HEADER+0a00h-$
	ALIGN	FILE_ALIGN	;200h

_DATA_END:

HEADER_END:

.data_end:



;	CLI
;	mov	esp,40000h
;	STI
;	CLD

;	CALL	GETCLINE

;	MOV	EAX,DS
;	MOV	ES,EAX

;	MOV	ESI,CLINE+1
;	MOV	EDI,FILE1
;	CALL	STRCPY




	ALIGN FILE_ALIGN




;NumberOfSymbols
;    The number of symbols.
;LvaToFirstSymbol
;    The virtual address of the first symbol.
;NumberOfLinenumbers
;    The number of line-number entries.
;LvaToFirstLinenumber
;    The virtual address of the first line-number entry.
;RvaToFirstByteOfCode
;    The relative virtual address of the first byte of code.
;RvaToLastByteOfCode
;    The relative virtual address of the last byte of code.
;RvaToFirstByteOfData
;    The relative virtual address of the first byte of data.
;RvaToLastByteOfData
;    The relative virtual address of the last byte of data.

;+1c
;IMAGE_COFF_SYMBOLS_HEADER
_DEBUG_HEADER1:
	DD	4	;NumberOfSymbols
	DD	_SYM1-_DEBUG_HEADER1	;LvaToFirstSymbol
	DD	0	;NumberOfLinenumbers
	DD	0	;LvaToFirstLinenumber

	DD	_TEXT_RVA	;RvaToFirstByteOfCode
	DD	_TEXT_END-1-_TEXT+_TEXT_RVA	;RvaToLastByteOfCode
	DD	_DATA_RVA	;RvaToFirstByteOfData
	DD	_DATA_END-1-_DATA+_DATA_RVA	;RvaToLastByteOfData


;	dd	3dh
;	dd	0020h
;	dd	0
;	dd	0

;	dd	00001000h
;	dd	00001200h
;	dd	00002000h
;	dd	00001400h


;//
;// Symbol format.
;//
;
;typedef struct _IMAGE_SYMBOL {
;    union {
;        BYTE    ShortName[8];
;        struct {
;            DWORD   Short;     // if 0, use LongName
;            DWORD   Long;      // offset into string table
;        } Name;
;        DWORD   LongName[2];    // PBYTE [2]
;    } N;
;    DWORD   Value;
;    SHORT   SectionNumber;
;    WORD    Type;
;    BYTE    StorageClass;
;    BYTE    NumberOfAuxSymbols;
;} IMAGE_SYMBOL;
;typedef IMAGE_SYMBOL UNALIGNED *PIMAGE_SYMBOL;

;#define IMAGE_SIZEOF_SYMBOL                  18


;//
;// Section values.
;//
;// Symbols have a section number of the section in which they are
;// defined. Otherwise, section numbers have the following meanings:
;//
;
;#define IMAGE_SYM_UNDEFINED           (SHORT)0          // Symbol is undefined or is common.
;#define IMAGE_SYM_ABSOLUTE            (SHORT)-1         // Symbol is an absolute value.
;#define IMAGE_SYM_DEBUG               (SHORT)-2         // Symbol is a special debug item.
;#define IMAGE_SYM_SECTION_MAX         0xFEFF  

;IMAGE_SYM_UNDEFINED 0 Symbol record is not yet assigned a section. If the value
;is 0 this indicates a references to an external symbol
;defined elsewhere. If the value is non-zero this is a
;common symbol with a size specified by the value.

_SYM1:
	DB	'header',0,0	;ShortName
	DD	0	;Value
	DW	-2	;SectionNumber
	DW	0	;Type
	DB	2	;StorageClass
	DB	0	;NumberOfAuxSymbols
_DEBUG_NAME_END:

	DB	'_start',0,0	;ShortName
	DD	00001000h	;Value
	DW	1	;SectionNumber
	DW	0	;Type
	DB	2	;StorageClass
	DB	0	;NumberOfAuxSymbols

	DB	'hogehoge'
	DD	12345678h;00001000h	;Value
	DW	1	;SectionNumber
	DW	0	;Type
	DB	2	;StorageClass
	DB	0	;NumberOfAuxSymbols



	DB	'end',0, 0,0,0,0
	DD	4000h
	DW	-2
	DW	0
	DB	2
	DB	0


;SYM2_END:

;01B 00000000 DEBUG  notype       External     | header
;01C 00001000 SECT1  notype ()    External     | _start
;03C 00004000 DEBUG  notype       External     | end

	ds	700h



	db	"BOTTOM",0

	ALIGN	FILE_ALIGN


BOTTOM:


	PUBLIC	IAT_GetStdHandle
	PUBLIC	IAT_WriteFile
	PUBLIC	IAT_ReadFile
	PUBLIC	IAT_CreateFileA
	PUBLIC	IAT_CloseHandle
	PUBLIC	IAT_ExitProcess
	PUBLIC	IAT_GetCommandLineA
	PUBLIC	IAT_SetFilePointer
	PUBLIC	IAT_SetEndOfFile
	PUBLIC	IAT_GlobalAlloc
	PUBLIC	IAT_GlobalFree


	PUBLIC	_RDATA
	PUBLIC	_RDATA_FILL
	PUBLIC	_RDATA_END

	PUBLIC	_DATA
	PUBLIC	_DATA_FILL
	PUBLIC	_DATA_END


	PUBLIC	STR_HELLO
	PUBLIC	FILENAME_TEST1

	PUBLIC	N_WROTE
	PUBLIC	HDL_STDIN
	PUBLIC	HDL_STDOUT
	PUBLIC	HDL_STDERR

	PUBLIC	HDL_OUTFILE

	PUBLIC	N_READ
	PUBLIC	PUTCHR_BUF
	PUBLIC	CMDLINE
	PUBLIC	READ_BUF

	PUBLIC	ENTRY_IAT
	PUBLIC	ENTRY_IMPORT

	EXTRN	_TEXT_RVA
	EXTRN	_RDATA_RVA
	EXTRN	_DATA_RVA

	EXTRN	BASE


