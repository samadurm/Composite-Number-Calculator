TITLE Program 4     (template.asm)

; Author: Micah Samaduroff
; Course / Project ID  Program 4               Date: 2/13/2019
; Description: Calculates componsite numbers. Prompts user to enter number of composites to display between 1 and 400, 
;		  validates data,  calculates and displays up to the nth composite, displayed as 10 composites per line with 3 spaces between

INCLUDE Irvine32.inc

UPPER_LIM	  EQU	400
LOWER_LIM	  EQU	1

.data

greeting		 BYTE	   "Hello my name is Micah Samaduroff",0
instructions	 BYTE	   "Enter the number of composites to display between 1 and 400: ",0
outOfRange	 BYTE	   "Number entered was out of range. Please try again: ",0
goodbye		 BYTE	   "Goodbye!",0
whitespace	 BYTE	   "   ",0
index		 WORD	   0
.code
main PROC

call introduction
call getUserData
call showComposites
call	farewell

	exit	; exit to operating system
main ENDP

;=============================================
;=Introduces author and displays instructions=
;=============================================
introduction PROC
mov edx, OFFSET greeting
call	   WriteString
call CrLf
mov edx, OFFSET instructions
call	   WriteString
ret
introduction ENDP

;=================================================================
;=Prompts for user input and calls validation procedure to ensure=
;=entered data is in the specified range					=   
;=================================================================
getUserData PROC
call	   ReadInt
call	   CrLf
call	   validate
ret
getUserData ENDP

;============================================================
;=validates that user data is in the range of [1, 400] and  =
;=displays error message if not and reprompts for user input= 
;============================================================
validate	  PROC
push	   eax		    ;makes sure eax doesnt get changed by validation program
cmp	   eax, 1
jl	   range_error
cmp	   eax, 400
jg	   range_error
jmp	   validate_end    ;else statement

;out of range segment
range_error:
mov	   edx, OFFSET outOfRange
call	   WriteString
call	   CrLf
call	   getUserData	    ;see if this works
jmp	   validate_end

validate_end:
pop	   eax		 ;restores eax
ret
validate	  ENDP

;=============================================================
;=Calculates and displays all composite numbers up to the nth=
;=number entered									 =
;=============================================================
showComposites	 PROC
push	   eax
push	   ecx
mov	   ecx, eax

top_of_loop:
call	   isComposite
call	   WriteDec
inc	   eax
inc	   index
mov	   edx, OFFSET whitespace
call	   WriteString

;check if new line is needed
cmp	   index, 10
jne	   bottom_loop
call	   CrLf
mov	   index, 0

;else
bottom_loop:
loop	   top_of_loop

call	   CrLf
pop	   eax
pop	   ecx
ret
showComposites	 ENDP

;===========================================
;=Checks if the current number is composite=
;===========================================
isComposite PROC
ret
isComposite ENDP

;===========================
;=Displays farewell message=
;===========================
farewell	  PROC
mov edx, OFFSET goodbye
call	   WriteString
ret
farewell	  ENDP

END main
