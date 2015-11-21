/* How to use Syscall 4 to write a string */

	.global  _start
_start:

	MOV R5, #100352
	SUB R5 , R5 , #352
_loop:
	MOV R7, #4	  @ Syscall number
 	MOV R0, #1	  @ Stdout is monitor
	MOV R2, #19	  @ string is 19 chars long
	LDR R1,=string	  @ string located at string:
	SWI 0
	SUBS R5 , R5 , #1
	BNE _loop
	
_exit:
     	@ exit syscall
	MOV R7, #1
	SWI 0

.data
string:
.ascii "Hello World String\n"
