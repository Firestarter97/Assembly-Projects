#
# as -o lab5.o lab5.s
# ld -o a.out lab5.o csc35.o
# This program will capitalize anything you type if its not capitalized yet.

.data
	M1:
		.ascii "I'M MR. MEESEEKS. LOOK AT ME!\n\0"
	M2:
		.ascii "? CAN DO!\n\0"
	Sp:
		.space 100

.text

.global _start

_start:
	mov $0, %rcx
	mov $M1, %rax
	call PrintCString
	mov $Sp, %rax
	mov $100, %rbx
	call ScanCString
	mov %rax, %rbx
	call LengthCString
	mov %rax, %rdx
	mov %rbx, %rax
	jmp Loop
Loop:
	cmpb $97, Sp(%rcx)
	jl Keep 
	cmpb $122, Sp(%rcx)
	jg Keep
    jmp Cap
Keep:
	mov Sp(%rcx), %al
	call PrintChar
	add $1, %rcx
	cmp %rcx, %rdx
	jg Loop
	jmp End
Cap:
	subb $32, Sp(%rcx)
	mov Sp(%rcx), %al
	call PrintChar
	add $1, %rcx
	cmp %rcx, %rdx
	jg Loop
	jmp End
End:
	mov $M2, %rax
	call PrintCString
	call EndProgram
