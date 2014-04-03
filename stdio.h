
#define const
#define inline
#define volatile

#ifndef _INCLUDED_STDIO1_
#define _INCLUDED_STDIO1_

#ifdef _EC_MAIN_

#ifndef _INCLUDED_STDIO_
/*
asm{
;#INCLUDE <B:\STDIO.CLB>
	}
*/
#define _INCLUDED_STDIO_
#endif

#endif

#define PROTO(x) ()

#define NULL 0
#define EOF -1

#define BUFSIZ 0x400

#define _IOFBF 1

#define SEEK_SET 0
#define SEEK_CUR 1
#define SEEK_END 2

#define O_RDONLY 1
#define O_WRONLY /*2*/0
#define O_RDWR /*3*/0
#define O_APPEND 4
#define O_CREAT 0x40	/* -> stdio.cl */
#define O_TRUNC 0
#define O_BINARY 0x80
#define O_EXCL 0

#define X_OK 0

typedef unsigned long off_t;

typedef unsigned int size_t;
typedef unsigned long fpos_t;

typedef /*unsigned*/ char u_char;
typedef unsigned short u_short;
typedef unsigned int u_int;
typedef unsigned long u_long;

typedef int mode_t;

typedef struct {
	char use;
	char mode;
	/*int*/short fd;	/* +2 */
	int x;	/* +4 */
	char *bufp;	/* +8 */
	unsigned bufcnt;/* +0c*/
	unsigned bufsize;/*+10*/
	char *buftop;	/*+14*/
	int _ungetc;	/*+18*/
} /* * */FILE;

extern FILE *stdin,*stdout,*stderr;

char* alloca();
int execv();

int getuid();
int geteuid();
int getgid();
int getegid();

int clearerr();/* dummy */
int ungetc();/* dummy */

int sscanf();/* dummy */
int fscanf();/* dummy */

FILE *fdopen();/* dummy */

int freopen();
int fopen();
int fclose();

int popen();
int pclose();

int fflush();/* dummy */

int fread();
int fwrite();

int fflush();

int fseek();
int ftell();
int rewind();

int puts();
int fputs();

int getchar();
int putchar();

int getch();

int putc();
int fputc();

int getc();
int fgetc();

int dup(),dup2();

char *fgets();

int feof();

int vfprintf();/**/

int ferror();/**/

int printf();
int fprintf();
int sprintf();
int snprintf();
int vsprintf();

int perror();

int setbuf();
int setvbu();/**/
int setvbuf();
#define _IONBF 0

/* */
int lseek();

int creat();
int open();
int close();

int read();
int write();

int rename();
int unlink();

int isatty();
int kill();
int getpid();
int mktemp();

int remove();/**/
int chmod();/**/
int chown();/**/
int umask();
char *getwd();/**/
int strerror();

int chdir();/**/
int mkdir();/**/

int fileno();/* FILE *p to fd ? */

int system();

/* */
int dos01();
int dos06();
int dos07();
int dos08();

int in_b();
int out_b();

void puthex_l();

int standout();
int standend();

/* from stdlib.h */
char*malloc();
int free();	/* void */
char*realloc();
int exit();
/**/

typedef char *fd_set;

/* */
int fsetbuf();/*original*/

int isatty();

/*
#define __LINE__ 1
#define __FILE__ "prog.c"
#define __DATE__ "2001/01/01"
#define __TIME__ "01:00:00"
*/

#endif /* _INCLUDED_STDIO1_*/
