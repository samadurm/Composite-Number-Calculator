TITLE Program 4     (program4.asm)

; Author: Micah Samaduroff
; Course / Project ID  Program 4               Date: 2/13/2019
; Description: Calculates componsite numbers. Prompts user to enter number of composites to display between 1 and 400, 
;		  validates data,  calculates and displays up to the nth composite, displayed as 10 composites per line with 3 spaces between

INCLUDE Irvine32.inc

UPPER_LIM	  EQU	400
LOWER_LIM	  EQU	1

.data

greeting		 BYTE	   "Program 4 by Micah Samaduroff",0
instructions	 BYTE	   "Enter the number of composites to display between 1 and 400: ",0
outOfRange	 BYTE	   "Number entered was out of range. Please try again: ",0
goodbye		 BYTE	   "Goodbye!",0
whitespace	 BYTE	   "   ",0
divisor	  	 DWORD	   2
index		 WORD	   0
incorrectRange	 WORD	   0
dividend		 DWORD	   ?
compositeNum	 DWORD	   0

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
;modifies edx register				     =
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
;=entered data is in the specified range. Modifies eax.		=   
;=================================================================
getUserData PROC
try_again:
call	   ReadInt
call	   CrLf
call	   validate
cmp	   incorrectRange, 1
je	   try_again
ret
getUserData ENDP

;============================================================
;=validates that user data is in the range of [1, 400] and  =
;=displays error message if not and reprompts for user input= 
;=Uses eax and modifies edx register					=
;============================================================
validate	  PROC
mov	   incorrectRange, 0	  ;initially set the out of range to false
push	   eax				  ;makes sure eax doesnt get changed by validation program
cmp	   eax, LOWER_LIM
jl	   range_error
cmp	   eax, UPPER_LIM
jg	   range_error
jmp	   validate_end		  ;else statement

;out of range segment
range_error:
mov	   edx, OFFSET outOfRange
call	   WriteString
call	   CrLf
mov	   incorrectRange, 1	  ;set incorrectRange to true
jmp	   validate_end

validate_end:
pop	   eax		 ;restores eax
ret	   ;try returning a value.
validate	  ENDP

;=============================================================
;=Calculates and displays all composite numbers up to the nth=
;=number entered									 =
;=Accepts value in eax, modifies and restores ecx			 =
;=============================================================
showComposites	 PROC
push	   eax
push	   ecx
mov	   ecx, eax
mov	   eax, 4			   ;start at first composite number

top_of_loop:
call	   isComposite		   ;check if current number is composite
cmp	   compositeNum, 1	   
jne	   not_composite	   ;if compositeNum is false then skip printing it

call	   WriteDec
inc	   index
mov	   edx, OFFSET whitespace
call	   WriteString

;check if new line is needed, checks every 10th index
cmp	   index, 10
jne	   bottom_loop
call	   CrLf
mov	   index, 0		   ;reset index
jmp	   bottom_loop

not_composite:			   ;if number is not composite, increment loop counter to account for the checked non-composite number
inc	   ecx

bottom_loop:
inc	   eax
loop	   top_of_loop

call	   CrLf
pop	   eax
pop	   ecx
ret
showComposites	 ENDP

;===========================================
;=Checks if the current number is composite=
;=Accepts value in eax, modifies edx	   =
;===========================================
isComposite PROC
push	   eax
mov	   dividend, eax
mov	   compositeNum, 0	   ;set composite number to false at start of loop
mov	   divisor, 2		   ;start the divisor at 2

while_loop:
cdq
div	   divisor
mov	   eax, dividend	   ;restore eax to original value
cmp	   edx, 0			   ;check if divisor divided evenly into dividend
je	   out_of_loop
inc	   divisor		   ;else increment divisor and try again
cmp	   divisor, eax
jl	   while_loop
jmp	   else_descision

out_of_loop:
mov	   compositeNum, 1	   ;1 if composite
	   
else_descision:
pop	   eax
ret
isComposite ENDP

;===========================
;=Displays farewell message=
;=Modifies edx			  =
;===========================
farewell	  PROC
mov edx, OFFSET goodbye
call	   WriteString
ret
farewell	  ENDP

END main
