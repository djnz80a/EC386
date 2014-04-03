#if 1
#define _EC_MAIN_
#endif

/*
#define float long
#define double long
*/

#ifndef _EC_MAIN_

int fcomp();
int fsgn();
long ftol();
int ftoi();
float ltof();
float itof();
float fabs();
float fneg();
float fnormal();
float fadd();
float fsub();
float fmul();
float fdiv();
float get_f();
int set_f();

#else

/*char v_pi2[]={0x03,0xed,0x87,0x64};*/

asm{
fpostADD_:
		push	esi
	push	dword [ebx]

	push	ebx

	push	40000000h
	push	dword [ebx]
	call	_fadd
	add	esp,8

	pop	eax
	mov	[eax],ebx

	pop	ebx
		pop	esi
	ret

fpostSUB_:
		push	esi
	push	dword [ebx]

	push	ebx

	push	40000000h
	push	dword [ebx]
	call	_fsub
	add	esp,8

	pop	eax
	mov	[eax],ebx

	pop	ebx
		pop	esi
	ret


fadd_:		push	esi
	push	eax
	push	ebx
	call	_fadd
	add	esp,8
		pop	esi
	ret

fsub_:		push	esi
	push	eax
	push	ebx
	call	_fsub
	add	esp,8
		pop	esi
	ret

fmul_:		push	esi

	push	eax
	push	ebx
	call	_fmul
	add	esp,8
		pop	esi
	ret

fdiv_:		push	esi
	push	eax
	push	ebx
	call	_fdiv
	add	esp,8
		pop	esi
	ret

fneg_:
		push	esi
	push	ebx
	call	_fneg
	add	esp,4
		pop	esi
	ret

fcomp_:
		push	esi
	;push	eax
	;push	ebx

	push	ebx
	push	eax
	call	_fcomp
	add	esp,8
	or	ebx,ebx
		pop	esi
	ret

ultof_:
		push	esi
	push	ebx
	call	_ultof
	add	esp,4
		pop	esi
	ret

ltof_:		push	esi
	push	ebx
	call	_ltof
	add	esp,4
		pop	esi
	ret

ftol_:		push	esi
	push	ebx
	call	_ftol
	add	esp,4
		pop	esi
	ret

}

int fcomp(float x,float y)
{
asm{
	mov	ebx,[ebp+8]	;4]
	mov	ecx,[ebp+0ch]	;8]
	call	fcomp
	}
}

asm{
fcomp:
		push	esi
	call	fsub
	or	ebx,ebx
	mov	ebx,0
	je	fcomp.r

	mov	ebx,1
	jns	fcomp.r
	neg	ebx
fcomp.r:
		pop	esi
	ret
	}

int fsgn(float x)
{
	int i;
	i=fcomp(x,(float)0);
	if(i>0)return 1;
	else if(i<0)return -1;
	else return 0;
}

int frexp(float x)
{
asm{
	mov	eax,[ebp+0ch]

	mov	ebx,[ebp+8]
	push	ebx
	movsx	ebx,bl
	mov	[eax],ebx
	pop	ebx
	and	ebx,0ffffff00h
	call	fnormal
	}
}

float ldexp(float x,int n)
{
asm{
	mov	ebx,[ebp+8]
	add	bl,[ebp+0ch]
	call	fnormal
	}
}

long ftol(float x)
{
asm{
		push	esi
	mov	ebx,[ebp+8]	;4]
	call	ftol
		pop	esi
	}
}

asm{
ftol:
	mov	dh,bl
	mov	bl,0

	cmp	dh,0
	jle	ftol.zero
	cmp	dh,32
	jge	ftol.over

	or	ebx,ebx
	pushf
	mov	cl,31
	sub	cl,dh
	and	ebx,7fffff00h	;7fffffffh
	shr	ebx,cl
	popf
	jns	ftol.r
	neg	ebx
	jmp	ftol.r

ftol.zero:
	mov	ebx,0
	jmp	ftol.r

ftol.over:
	or	ebx,ebx
	mov	ebx,7fffffffh
	jns	ftol.r
	neg	ebx
	jmp	ftol.r

ftol.r:
	ret
	}

int ftoi(float x)
{
	return (int)ftol(x);
}

float ultof(unsigned long x)
{
asm{
		push	esi
	mov	ebx,[ebp+8]
	call	ultof
		pop	esi
	}
}

float ltof(long x)
{
asm{
		push	esi
	mov	ebx,[ebp+8]	;+4]
	call	ltof
		pop	esi
	}
}

asm{
ultof:
	or	ebx,ebx
	je	ultof.r
	mov	cl,33
ultof.10:
	dec	cl
	shl	ebx,1
	jb	ultof.20
	jmp	ultof.10
ultof.20:
	rcr	ebx,1

	shr	ebx,1

	mov	bl,cl
ultof.r:
	ret
	}

asm{
ltof:
	or	ebx,ebx
	je	ltof.r
	mov	ch,0
	jns	ltof.p
	dec	ch
	neg	ebx
ltof.p:

	mov	cl,33
ltof.10:
	dec	cl
	shl	ebx,1
	jb	ltof.20
	jmp	ltof.10

ltof.20:
	rcr	ebx,1

	add	ch,1
	rcr	ebx,1

	mov	bl,cl

ltof.r:
	ret
	}

float itof(int x)
{
	return ltof((long)x);
}

float fabs(float x)
{
asm{
	mov	ebx,[ebp+8]	;+4]
	and	ebx,7fffffffh
	}
}

float fneg(float x)
{
asm{
	mov	ebx,[ebp+8]	;+4]
	call	fneg_ebx
	}
}

asm{
fneg_ebx:
	or	ebx,ebx
	je	fneg_ebx.r
	xor	ebx,80000000h
fneg_ebx.r:
	ret

	mov	al,bl
	xor	bl,bl
;	not	ebx
	mov	bl,al
	ret

fneg_ecx:
	or	ecx,ecx
	je	fneg_ecx.r
	xor	ecx,80000000h
fneg_ecx.r:
	ret

	mov	al,cl
	xor	cl,cl
	not	ecx
	mov	cl,al
	ret
}

asm{
fnormal:
;	mov	ebx,[ebp+4]

	test	ebx,40000000h
	jne	fnormal.r

	mov	dh,bl
	mov	dl,bl
	mov	bl,0


	or	ebx,ebx
	je	fnormal.zero
	cmp	ebx,80000000h	;-0.0
	je	fnormal.zero

	shl	ebx,1
	pushfd		;cf=sign
fnormal.10:
	shl	ebx,1
	jb	fnormal.20
	or	ebx,ebx
	je	fnormal.20
	dec	dh
	cmp	dh,80h
	jne	fnormal.10
	popfd
	jmp	fnormal.zero

fnormal.20:
	rcr	ebx,1
	popfd
	rcr	ebx,1

;	xor	dl,dh
;	js	fnormal.zero

	mov	bl,dh
	jmp	fnormal.r

fnormal.zero:
	mov	ebx,0
	ret

fnormal.r:
	ret
	}

float fnormal(float x)
{
asm{
	mov	ebx,[ebp+8]	;+4]
	call	fnormal
}
}

float fadd(float x,float y)
{
asm{
	mov	ebx,[ebp+8]	;+4]
	mov	ecx,[ebp+0ch]	;8]
	call	fadd
	}
}

asm{
fadd:
	push	ebp
	push	ecx
	push	ebx
	mov	ebp,esp

	mov	dh,[ebp+0]
	mov	dl,[ebp+4]

	mov	cl,dh
	sub	cl,dl

	cmp	cl,32
	jge	fadd.left
	cmp	cl,-32
	jle	fadd.right

	or	cl,cl
	jns	fadd.ex.e

	mov	esi,[ebp+0]
	mov	edi,[ebp+4]
	mov	[ebp+0],edi
	mov	[ebp+4],esi

	neg	cl
	xchg	dh,dl

fadd.ex.e:
	mov	esi,[ebp+0]
	mov	edi,[ebp+4]

	or	esi,esi
	je	fadd.right
	or	edi,edi
	je	fadd.left

	or	esi,esi
	js	fadd.m

;fadd.p:

	or	edi,edi
	js	fadd.pm

;fadd.pp:
	and	esi,07fffff00h
	and	edi,07fffff00h

	shr	edi,cl
	add	esi,edi
	jns	fadd.10

	shr	esi,1
	inc	dh

	;if dh>7fh overflow

fadd.10:
	mov	ebx,esi
	mov	bl,dh

	jmp	fadd.r

fadd.pm:
	mov	ebx,[ebp+0]
	mov	ecx,[ebp+4]
	call	fneg_ecx
	call	fsub
	jmp	fadd.r

fadd.m:
	or	edi,edi
	js	fadd.mm

fadd.mp:
	mov	ebx,[ebp+4]
	mov	ecx,[ebp+0]
	call	fneg_ecx
	call	fsub
	jmp	fadd.r

fadd.mm:
	mov	ebx,[ebp+0]
	mov	ecx,[ebp+4]
	call	fneg_ebx
	call	fneg_ecx

	call	fadd
	call	fneg_ebx
	jmp	fadd.r

fadd.left:
	mov	ebx,[ebp+0]
	jmp	fadd.r

fadd.right:
	mov	ebx,[ebp+4]
	jmp	fadd.r


fadd.r:
	call	fnormal

	pop	eax
	pop	eax
	pop	ebp
	ret
	}



float fsub(float x,float y)
{
asm{
	mov	ebx,[ebp+8]	;+4]
	mov	ecx,[ebp+0ch]	;8]
	call	fsub
	}
}

asm{
fsub:
	push	ebp
	push	ecx
	push	ebx
	mov	ebp,esp
		sub	esp,4

	;mov	byte [fsub.sgn],0
		mov	byte [ebp-4],0

	mov	dh,[ebp+0]
	mov	dl,[ebp+4]

	mov	cl,dh
	sub	cl,dl
	cmp	cl,32
	jge	fsub.left
	cmp	cl,-32
	jle	fsub.right

	or	cl,cl
	jns	fsub.ex.e

	mov	esi,[ebp+0]
	mov	edi,[ebp+4]
	mov	[ebp+0],edi
	mov	[ebp+4],esi

	neg	cl
	xchg	dh,dl

	;mov	byte [fsub.sgn],0ffh
		mov	byte [ebp-4],0ffh

fsub.ex.e:
	mov	esi,[ebp+0]
	mov	edi,[ebp+4]

	or	esi,esi
	je	fsub.right
	or	edi,edi
	je	fsub.left

	or	esi,esi
	js	fsub.m
fsub.p:
	or	edi,edi
	js	fsub.pm
fsub.pp:
	and	esi,07fffff00h
	and	edi,07fffff00h

	shr	edi,cl
	sub	esi,edi
	jnb	fsub.10

	neg	esi
	xor	esi,80000000h

fsub.10:
	mov	ebx,esi
	mov	bl,dh
	jmp	fsub.r

fsub.pm:
	mov	ebx,[ebp+0]
	mov	ecx,[ebp+4]
	call	fneg_ecx
	call	fadd
	jmp	fsub.r

fsub.m:
	or	edi,edi
	js	fsub.mm
fsub.mp:
	mov	ebx,[ebp+0]
	mov	ecx,[ebp+4]
	call	fneg_ebx
	call	fadd
	call	fneg_ebx
	jmp	fsub.r

fsub.mm:
	mov	ebx,[ebp+4]
	call	fneg_ebx
	mov	ecx,[ebp+0]
	call	fneg_ecx
	call	fsub
	jmp	fsub.r

fsub.left:
	mov	ebx,[ebp+0]
	jmp	fsub.r
fsub.right:
	mov	ebx,[ebp+4]
	call	fneg_ebx
	jmp	fsub.r

fsub.r:
	;cmp	byte [fsub.sgn],0
		cmp	byte [ebp-4],0
	je	fsub.rr
	call	fneg_ebx
fsub.rr:
	call	fnormal

		add	esp,4
	pop	eax
	pop	eax
	pop	ebp
	ret

fsub.sgn:ds	2
	}


float fmul(float x,float y)
{
asm{
	mov	ebx,[ebp+8]	;+4]
	mov	ecx,[ebp+0ch]	;+8]
	call	fmul
	}
}

asm{
fmul:
	push	ebp
	push	ecx
	push	ebx
	mov	ebp,esp

	mov	ebx,[ebp+0]
	mov	ecx,[ebp+4]

	and	ebx,7fffff00h
	and	ecx,7fffff00h

	or	ebx,ebx
	je	fmul.zero
	or	ecx,ecx
	je	fmul.zero

	mov	dh,[ebp+0]
	mov	dl,[ebp+4]
	or	dh,dh
	js	fmul.m
fmul.p:
	or	dl,dl
	js	fmul.pm
fmul.pp:
	add	dh,dl
	jns	fmul.05
	jmp	fmul.over

fmul.pm:
	jmp	fmul.05

fmul.m:
	or	dl,dl
	js	fmul.mm

fmul.mp:
	jmp	fmul.05

fmul.mm:
	add	dh,dl
	js	fmul.05
	mov	ebx,0
	jmp	fmul.r

fmul.05:
	mov	al,[ebp+0+3]
	xor	al,[ebp+4+3]
	push	ax

	mov	eax,ebx
	mul	ecx
	mov	ebx,edx

	shl	eax,1
	rcl	ebx,1

	mov	dh,[ebp+0]
	mov	dl,[ebp+4]
	add	dh,dl

	pop	ax
	or	al,al
	jns	fmul.10
	or	ebx,80000000h
fmul.10:
	mov	bl,dh
	jmp	fmul.r

fmul.zero:
	mov	ebx,0
	jmp	fmul.r

fmul.over:
	mov	ebx,7fffff7fh
	mov	al,[ebp+0+3]
	xor	al,[ebp+4+3]
	jns	fmul.r
	or	ebx,80000000h

fmul.r:
	call	fnormal

	pop	eax
	pop	eax
	pop	ebp
	ret
	}

float fdiv(float x,float y)
{
asm{
	mov	ebx,[ebp+8]	;+4]
	mov	ecx,[ebp+0ch]	;8]
	call	fdiv
	}
}

asm{
fdiv:
	push	ebp
	push	ecx
	push	ebx
	mov	ebp,esp

	mov	ebx,[ebp+0]
	call	fnormal
	mov	[ebp+0],ebx

	mov	ebx,[ebp+4]
	call	fnormal
	mov	[ebp+4],ebx

	mov	ebx,[ebp+0]
	mov	ecx,[ebp+4]

	and	ebx,7fffff00h
	and	ecx,7fffff00h

	or	ebx,ebx
	je	fdiv.zero
	or	ecx,ecx
	je	fdiv.over

	mov	dh,[ebp+0]
	mov	dl,[ebp+4]
	or	dh,dh
	js	fdiv.m
fdiv.p:
	or	dl,dl
	js	fdiv.pm

fdiv.pp:
	jmp	fdiv.05

fdiv.pm:
	sub	dh,dl
	sub	dh,1
	jns	fdiv.05
	jmp	fdiv.over

fdiv.m:
	or	dl,dl
	js	fdiv.mm
fdiv.mp:
	sub	dh,dl
	sub	dh,1
	js	fdiv.05
	jmp	fdiv.zero

fdiv.mm:
	jmp	fdiv.05

fdiv.05:
	mov	al,[ebp+0+3]
	xor	al,[ebp+4+3]
	push	ax

	mov	edx,ebx
	xor	eax,eax
	cmp	edx,ecx
	jnb	fdiv.gt

	div	ecx

	xor	bl,bl
	jmp	fdiv.06

fdiv.gt:
	shl	ecx,1
	div	ecx
	shr	ecx,1
	mov	bl,1
fdiv.06:
	shr	ecx,1
	cmp	eax,ecx
	jb	fdiv.065
	inc	eax
fdiv.065:

	pushf
	mov	dh,[ebp+0]
	mov	dl,[ebp+4]
	sub	dh,dl
	dec	dh
	popf
	add	dh,bl

	or	eax,eax
	jns	fdiv.07

	shr	eax,1
	inc	dh

fdiv.07:
	mov	ebx,eax

	pop	ax
	or	al,al
	jns	fdiv.10
	or	ebx,80000000h
fdiv.10:
	mov	bl,dh
	jmp	fdiv.r

fdiv.zero:
	mov	ebx,0
	jmp	fdiv.r

fdiv.over:
	mov	ebx,4000007fh
	mov	al,[ebp+0+3]
	xor	al,[ebp+4+3]
	jns	fdiv.r
	or	ebx,80000000h
	jmp	fdiv.r

fdiv.r:
	call	fnormal

	pop	eax
	pop	eax
	pop	ebp
	ret
}

/*
int put_f(float x)
{
	puthex_l(x);
}
*/

float get_f(char *s)
{
	int exponent=0;	/*-4*/
asm{
	cld
	mov	byte [get_f.sgn],0
	mov	esi,[ebp+8]	;+4]
	xor	ebx,ebx		;left
	xor	edx,edx		;right
	xor	ecx,ecx
	mov	edi,1	;10
get_f.10:
	lodsb
	or	al,al
	je	get_f.50
	cmp	al,'-'
	jne	get_f.11
	mov	byte [get_f.sgn],0ffh
	jmp	get_f.10
get_f.11:
	cmp	al,'.'
	je	get_f.dot

	cmp	al,'e'
	je	get_f#e
	cmp	al,'E'
	je	get_f#e

	cmp	al,'0'
	jb	get_f.50
	cmp	al,'9'
	ja	get_f.50
	sub	al,'0'
	;	push	edx
	push	ax
	mov	eax,10
	mul	ebx
	mov	ebx,eax		;ebx*=10
	pop	ax
	;	pop	edx
	movzx	eax,al
	add	ebx,eax
	jmp	get_f.10

get_f.dot:
;	lodsb		;skip '.'
get_f.20:
	;cmp	edi,0fffffffh	;1:0000:0000/10
	;jnb	get_f.50
	lodsb
	or	al,al
	je	get_f.49	;50

	cmp	al,'e'
	je	get_f#e
	cmp	al,'E'
	je	get_f#e

	cmp	al,'0'
	jb	get_f.50
	cmp	al,'9'
	ja	get_f.50
	sub	al,'0'

	cmp	edi,0fffffffh	;1:0000:0000/10
	jnb	get_f.20	;50

	push	ax
	;mov	eax,10
	;mul	edx
	;mov	edx,eax		;edx*=10
		push	ebx
		mov	eax,10
		mov	ebx,edx
		mul	ebx
		mov	edx,eax
		pop	ebx
	pop	ax

	movzx	eax,al
	add	edx,eax		;edx+=al

	inc	ch

	push	eax
	push	edx
	mov	eax,10
	mul	edi
	mov	edi,eax		;edi*=10
	pop	edx
	pop	eax
	jmp	get_f.20

get_f#e:
	push	ebx
	push	ecx
	push	edx

	push	esi
	call	F_ATOI	;call	f_atoi
	pop	esi
	mov	eax,ebx

	pop	edx
	pop	ecx
	pop	ebx
	or	eax,eax	;or	ebx,ebx
	je	get_f.50

	mov	[ebp-4],eax;ebx	;exponent
	jmp	get_f.50

get_f.49:
	dec	esi

get_f.50:
	mov	[ebp+4*2],esi
	or	edx,edx
	je	get_f.60	;if ???.0

	xor	esi,esi
	mov	cl,32
get_f.51:
	or	esi,esi
	js	get_f.55

	dec	cl
	shl	esi,1

	shl	edx,1
	cmp	edx,edi
	jb	get_f.52
	sub	edx,edi
	inc	esi
get_f.52:
	jmp	get_f.51


get_f.55:
	push	ebx
	shr	esi,1
	mov	ebx,esi
	mov	bl,cl
	pop	ecx

	push	ebx
	mov	ebx,ecx
	call	ltof
	pop	ecx
	call	fadd

	jmp	get_f.r

;	???.0

get_f.60:
	call	ltof
	jmp	get_f.r

get_f.sgn:ds	4

get_f.r:
	cmp	dword [ebp-4],100
	jge	get_f.err
	cmp	dword [ebp-4],-100
	jle	get_f.err

	push	ebx
	mov	ebx,10
	call	ltof
	mov	edx,ebx
	pop	ebx
get_f.exp1:
	cmp	dword [ebp-4],0
	je	get_f.r.50
	js	get_f.exp2

		push	edx
	push	edx
	push	ebx
	call	_fmul
	add	esp,4*2
		pop	edx
	dec	dword [ebp-4]
	jmp	get_f.exp1

get_f.exp2:
		push	edx
	push	edx
	push	ebx
	call	_fdiv
	add	esp,4*2
		pop	edx
	inc	dword [ebp-4]
	jmp	get_f.exp1

get_f.r.50:
	cmp	byte [get_f.sgn],0
	je	get_f.rr
	call	fneg_ebx
	jmp	get_f.rr

get_f.err:
	

get_f.rr:
	}

}

asm{
;
;
;
F_ATOL:
F_ATOI:
	PUSH	EBP
	MOV	EBP,ESP
	MOV	ESI,[EBP+8]
	CALL	FSKIP_WHITE
;	CALL	FGETDEC
	CALL	FGETDEC2
		MOV	[EBP+8],ESI
	MOV	EBX,EAX
	POP	EBP
	RET

;
;

FSKIP_WHITE:
	MOV	AL,[ESI]
	INC	ESI
	CALL	FIS_WHITE
	JE	FSKIP_WHITE
	DEC	ESI
	RET

FIS_WHITE:
	CMP	AL,20H
	JE	FIS_WHITE.Y
	CMP	AL,09H
	JE	FIS_WHITE.Y

FIS_WHITE.Y:
	RET


;
;
;
FGETDEC2:
	CMP	BYTE [ESI],'+'
	JNE	FGETDEC2.05
	INC	ESI
FGETDEC2.05:
	CMP	BYTE [ESI],'-'
	JNE	FGETDEC2.10
	INC	ESI
	CALL	FGETDEC
	NEG	EAX
	RET

FGETDEC2.10:
	CALL	FGETDEC
	RET


;	esi:adrs of decimal string
;	<eax:#
;	<esi:next of decimal char
;
;	?edx
;
FGETDEC:
	PUSH	EBX
	XOR	EDX,EDX
	CLD
FGETDEC.10:
	XOR	EAX,EAX
	LODSB
	;CALL	TOUPPER
	SUB	AL,'0'
	JB	FGETDEC.E
	CMP	AL,10
	JNB	FGETDEC.E
FGETDEC.20:
	MOV	EBX,EDX
	SHL	EDX,2
	ADD	EDX,EBX
	SHL	EDX,1
	ADD	EDX,EAX
	JMP	FGETDEC.10

FGETDEC.E:
	DEC	ESI
	MOV	EAX,EDX
	POP	EBX
	RET

}

int set_f(char *s,float x)
{
asm{
	mov	ax,ds
	mov	es,ax

	xor	eax,eax
	push	eax
	xor	eax,eax
	push	eax

	cld
	mov	edi,[ebp+8]	;+4]
	mov	ebx,[ebp+0ch]	;6]
	test	ebx,40000000h
	je	set_f.zero

	mov	dl,bl
	and	ebx,0ffffff00h
	or	ebx,ebx
	jns	set_f.p

	mov	al,'-'
	stosb
	and	byte [ebp+6*2+3],7fh
	and	ebx,7fffffffh
set_f.p:
	cmp	dl,0
	je	set_f.z
	jl	set_f.lt

	cmp	dl,32
	jge	set_f.high

	push	ebx
	push	edx

	mov	cl,31
	sub	cl,dl
	shr	ebx,cl
	mov	eax,ebx
	push	edi
	mov	edi,set_f.work
	push	edi
;	call	set_hex_l
	call	set_dec_l
	pop	edi
;	mov	cx,8
	mov	ecx,10	;mov	cx,10
	mov	al,'0'
	repe
	scasb
	dec	edi
	mov	esi,edi
	inc	ecx	;inc	cx
	pop	edi
	rep
	movsb

	pop	edx
	pop	ebx
	mov	cl,dl
	shl	ebx,cl

	and	ebx,7fffff00h
	mov	byte [ebp+6*2],0

	shr	ebx,8
	mov	edx,0
	jmp	set_f.eq

set_f.lt:
	mov	cl,dl
	cmp	cl,-32
	jle	set_f.low

	mov	byte [ebp+6*2],0
set_f.lt.10:
	neg	cl

	add	cl,8
	mov	edx,0
set_f.lt.20:
	or	cl,cl
	je	set_f.lt.30
	dec	cl
	shr	ebx,1
	rcr	edx,1
	jmp	set_f.lt.20
set_f.lt.30:
	jmp	set_f.eq

set_f.z:
	shr	ebx,8
	mov	edx,0

set_f.eq:
	and	ebx,007fffffh
	mov	[ebp-4],ebx
	mov	[ebp-8],edx

	mov	al,'.'
	stosb

	mov	cl,0
	mov	ch,20
set_f.10:
	cmp	cl,10
	jae	set_f.50
	or	ch,ch
	je	set_f.50
	dec	ch

	mov	ebx,[ebp-4]
	or	ebx,[ebp-8]
	je	set_f.50

	shl	dword [ebp-8],1
	rcl	dword [ebp-4],1	;*2
	mov	ebx,[ebp-8]
	mov	edx,[ebp-4]
	shl	dword [ebp-8],1
	rcl	dword [ebp-4],1
	shl	dword [ebp-8],1
	rcl	dword [ebp-4],1	;*8
	add	[ebp-8],ebx
	adc	[ebp-4],edx	;*10

	mov	ebx,[ebp-4]
	mov	eax,ebx

	cmp	ebx,00800000h
	jb	set_f.20
	shr	eax,23
	add	al,'0'
	stosb

	sub	al,'0'
	or	cl,cl
	jne	set_f.16
	or	al,al
	je	set_f.17
set_f.16:
	inc	cl
set_f.17:
	mov	ah,0
	push	ax
	xor	eax,eax
	pop	ax
	mov	edx,00800000h
	mul	edx		;eax=00800000h*al
	sub	[ebp-4],eax

	jmp	set_f.10
set_f.20:
	mov	al,'0'
	stosb
	jmp	set_f.10

;	exp<-32

set_f.low:
	jmp	set_f.low2

	shr	ebx,8
	mov	ch,0
set_f.low.10:
	push	ebx
	or	ebx,ebx
	je	set_f.low.15

	push	edx
	mov	eax,10
	mul	ebx
	pop	edx
	mov	ebx,eax
	cmp	ebx,00800000h
	jnb	set_f.low.12

	pop	eax	;dummy
	jmp	set_f.low.10

set_f.low.12:
	shr	ebx,1	;*10/2=*5

	dec	ch
	inc	dl
	cmp	dl,-2
	jg	set_f.low.15
	pop	eax
	jmp	set_f.low.10

set_f.low.15:
	pop	ebx
	shl	ebx,8
	mov	edx,0
	mov	byte [ebp+6*2],ch
	jmp	set_f.eq

set_f.high:
	mov	ebx,[ebp+6*2]
	mov	ch,0
set_f.high.10:
;	cmp	bl,-3
;	jle	set_f.high.15
	push	ebp
	push	ebx
	push	ecx
	push	edx
	push	edi
	mov	ecx,40000001h	;1.0
	call	fcomp
	cmp	bx,-1
	pop	edi
	pop	edx
	pop	ecx
	pop	ebx
	pop	ebp
	je	set_f.high.15

	push	ebp
	push	edx
	push	ecx
	push	edi
	mov	ecx,50000004h
	call	fdiv
	pop	edi
	pop	ecx
	pop	edx
	pop	ebp
	inc	ch
	jmp	set_f.high.10

set_f.high.15:
	mov	byte [ebp+6*2],ch
	mov	dl,bl
	mov	cl,bl

;	shr	ebx,8
;	mov	edx,0
;	jmp	set_f.eq
	jmp	set_f.lt.10

;

set_f.low2:
	mov	ebx,[ebp+6*2]
	mov	ch,0
set_f.low2.10:
	push	ebp
	push	edx
	push	ecx
	mov	ecx,50000004h	;10.0
	call	fmul
	pop	ecx
	pop	edx
	pop	ebp
	dec	ch
	cmp	bl,0fdh
	jl	set_f.low2.10

set_f.low2.20:
	mov	byte [ebp+6*2],ch
	mov	dl,bl
	mov	cl,bl

	mov	bl,0
	jmp	set_f.lt.10


set_f.zero:
	mov	byte [ebp+6*2],0
	mov	al,'0'
	stosb
set_f.50:
	mov	bl,[ebp+6*2]
	or	bl,bl
	je	set_f.51

	mov	al,'e'
	stosb

	mov	al,'+'
	or	bl,bl
	jns	set_f.52

	mov	al,'-'
	neg	bl
set_f.52:
	stosb

	;mov	al,[ebp+6*2]
	;call	set_hex
		movzx	eax,bl
		;call	set_dec_l100
		call	set_dec_b
set_f.51:
	xor	al,al
	stosb
	jmp	set_f.r

set_f.work:ds	100

set_f.r:
	pop	eax
	pop	eax
	}

}

asm{
set_hex_l:
	push	eax
	shr	eax,16
	call	set_hex_w
	pop	eax
	call	set_hex_w
	ret

;
set_dec_b:
	cmp	al,100
	jnb	set_dec_l100
	cmp	al,10
	jnb	set_dec_l10
	jmp	set_dec_l1
;
set_dec_l:
	mov	ebx,1000000000	;ulong
	call	set_dec
	mov	ebx,100000000	;long
	call	set_dec
	mov	ebx,10000000
	call	set_dec
	mov	ebx,1000000
	call	set_dec
	mov	ebx,100000
	call	set_dec
	mov	ebx,10000
	call	set_dec
	mov	ebx,1000
	call	set_dec
set_dec_l100:
	mov	ebx,100
	call	set_dec
set_dec_l10:
	mov	ebx,10
	call	set_dec
set_dec_l1:
	mov	ebx,1
	call	set_dec
	ret

set_dec:
	xor	edx,edx
	div	ebx
	add	al,'0'
	stosb
	mov	eax,edx
	ret

;
set_hex_w:
	push	ax
	mov	al,ah
	call	set_hex
	pop	ax
	call	set_hex
	ret
;

set_hex:
	push	ax
	shr	al,4
	call	set_hex.10
	pop	ax
set_hex.10:
	and	al,0fh
	cmp	al,10
	jb	set_hex.20
	add	al,7
set_hex.20:
	add	al,'0'
	stosb

	ret

	end
}
#endif
