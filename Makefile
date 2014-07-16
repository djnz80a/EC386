
all:
	yasm -f elf EC386.ASM
	ld -m elf_i386 -e BASE EC386.o
