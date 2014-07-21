
all:
	yasm -f elf EC386.ASM
	ld -m elf_i386 -e BASE EC386.o

lib:
	yasm -f elf32 RUNTIME.CL
	yasm -f elf32 STDIO.CL
	yasm -f elf32 STDLIB.CL
	yasm -f elf32 STRING.CL
	yasm -f elf32 BOTTOM.CL

dummy:	lib
	./a.out dummy.c
	yasm -f elf32 dummy.ASM
	ld -m elf_i386 -e RUNBASE RUNTIME.o STDIO.o STDLIB.o STRING.o dummy.o BOTTOM.o -o dummy
