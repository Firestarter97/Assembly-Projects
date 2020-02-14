# as -o Proj.o Proj.s
# ld -o a.out Proj.o csc35.o
# a.out
# most importantly "rm Proj.s", plez donnut 4git. ty
# PrintCString was a function from csc35.o library

.data
	Intro:
		.ascii "Welcome to Battlefield 6: World War 3,\n"
		.ascii "jk it's all a lie, our game is a lot worse\n"
		.ascii "This game is based on Slither.io, hence\n"
		.ascii "The snek that slowly grows into a huge\n"
		.ascii "python snek. Plez donnut step on snek. ty\n"
		.ascii "The Secret word(dashes) and the snake are displayed in Green, while\n"
		.ascii "The Guess letter ie(A-Z) and Your secret word: are displayed in Cyan.\n"
		.ascii "Each time you get a letter wrong the snake will appear and start to grow\n"
		.ascii "You'll be given 10 tries to get the word correct, otherwise you lose\n\n\0"
	M1:
		.ascii "User 1 please enter your word: \0"
	Sp:
		.space 100
	Sp2:
		.space 100
	SWord:	
		.ascii"\nYour secret word: "
	GLetter:	
		.ascii"\nGuess a letter: "
	Failed:
		.ascii"Game Over! You guessed wrong too many times!\0"
	NewL:
		.ascii"\n"
	Won1:
		.ascii"Congrats dude! You guessed the secret word: \0"
	Won2:
		.ascii"!\n\0"
	Sk:
		.space 100	
.text

.global _start

_start:

	mov $Intro, %rax	#Prints the introduction of the program
	call PrintCString
	mov $0, %r8		#Number of tries counter.
	mov $0, %rcx		#Counter used for LengthCString.
	mov $9, %r9		#Number of tries counter.
	mov $0, %r10		#counter for CheckIfDashesAreLeft
	mov $0, %r11		#index counter for snake
	mov $1, %r12		#counter for snake
	mov $0, %r13		#counter for when to print snake
	mov $M1, %rax
	call PrintCString
	mov $Sp, %rax
	mov $100, %rbx		#sets buffer of 100.
	call ScanCString
	call LengthCString
	mov %rax, %rdx
	call ClearScreen	#Clears screen, so user 2 doesn't know what the word is. 

Dashes:
				#This label displays the correct number of dashes for
	cmp %rcx, %rdx		#any word user 1 types in.
	jle Reset
	movb $45, Sp2(%rcx)
	add $1, %rcx
	jmp Dashes

Reset:				#This label resets our index counter
				#it also increments r13 to sure the snake isnt printed
	mov $0, %rcx		#when the user gets the correct letter.
	mov $1, %r13
	jmp CheckIfDashesAreLeft

Print:				
				#This label prints out the sentences and changes the color.
	mov $6, %rax
	call SetForeColor
	mov $SWord, %rax
	call PrintCString	
	mov $2, %rax
	call SetForeColor
	mov $Sp2, %rax
	call PrintCString
	mov $7, %rax
	call SetForeColor
	mov $NewL, %rax
	call PrintCString
	mov $GLetter, %rax
	call PrintCString
	mov $6, %rax
	call SetForeColor
	call ScanChar
	jmp NumberOfTries

NumberOfTries:
				#This label makes sure that you get only 10 tries to
	add $1, %r8		#guess the secret word, otherwise you lose.
	cmp %r8, %r9
	jg Compare
	jmp Fail
		
CheckIfDashesAreLeft:
				#This label checks if any dashes are still left.
	cmpb $45, Sp2(%r10)	#If none are left that means you won.
	je Print
	add $1, %r10
	cmp %r10, %rdx
	jge CheckIfDashesAreLeft
	mov $0, %r13
	jmp Won

Compare:			#This label compares users 2's letter to user 1's letters
				#if any are equal they will be replaced in the dashed string.
	cmpb Sp(%rcx), %al
	je Replace
	sub $32, %al
	cmpb Sp(%rcx), %al	
	je Replace	
	add $64, %al		
    cmpb Sp(%rcx), %al      
    je Replace              
    sub $32, %al		
	add $1, %rcx		
	cmp %rcx, %rdx
	jg Compare
	cmp $1, %r13
	je Snake
	jmp Reset
Snake:				

	mov $2, %rax
	call SetForeColor	#This label prints out the snake.
	movb $61, Sk(%r11)
	add $1, %r11
	cmp %r11, %r12
	jg Snake
	add $1, %r12
	mov $NewL, %rax
	call PrintCString
	movb $62, Sk(%r11)
	mov $Sk, %rax
	call PrintCString
	mov $NewL, %rax
	call PrintCString
	jmp Reset

Replace:
	
	mov $0, %r13		#This label replaces the dashes with the correct letter at that index 
	movb %al, Sp2(%rcx)
	add $1, %rcx
	cmp %rcx, %rdx		#checks if we are at the end of the string or not.
	jg Compare
	jmp Reset
Fail:	

	mov $NewL, %rax		#This label is used when you have reached your limit of 10 tries
	call PrintCString	#and thus you get the game over message.	
	mov $1, %rax
	call SetForeColor
	mov $Failed, %rax
	call PrintCString
	mov $7, %rax
	call SetForeColor
	call EndProgram

Won:
	
	mov $6, %rax		#This label prints out the congrats message when the user wins the game.
	call SetForeColor	
	mov $SWord, %rax
	call PrintCString
	mov $2, %rax
	call SetForeColor
	mov $Sp2, %rax
	call PrintCString
	mov $NewL, %rax
	call PrintCString
	mov $NewL, %rax
	call PrintCString
	mov $7, %rax
	call SetForeColor
	mov $Won1, %rax
	call PrintCString
	mov $2, %rax
	call SetForeColor
	mov $Sp2, %rax
	call PrintCString
	mov $Won2, %rax
	call PrintCString
	mov $7, %rax
	call SetForeColor
	call EndProgram
