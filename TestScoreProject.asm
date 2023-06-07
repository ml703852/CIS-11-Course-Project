; CIS11 Project
; Grace Kim & Mehak Lohchan
; Test Score Calculator for LC3

.ORIG x3000				; origination address
; constants - letter grades
A	.FILL x3100
B	.FILL x3102
C	.FILL x3103
D	.FILL x3104
F	.FILL x3105
; define variables
ARRAY		.FILL x0		; test score 1		; array to store test scores
		.FILL x0		; test score 2
		.FILL x0		; test score 3
		.FILL x0		; test score 4
		.FILL x0		; test score 5
MIN_SCORE	.FILL x0064		; initial value set to 100 to find min
MAX_SCORE	.FILL x0000		; initial value set to 0 to find max
SUM		.FILL x0000		; initial value set to 0 to calculate sum
COUNT		.FILL x000e		; initial value set to 5 for number of test scores
; subroutine to prompt the user to input test scores
PROMPT		LEA R0, DISPLAYPROMPT		; prompt user to enter test scores
		PUTS				; display on console
		
; subroutine to read test scores from the user
READ_SCORES		LEA R1, ARRAY		; load ARRAY address to R1
			LD R4, COUNT		; load COUNT value to R4
READ_LOOP		GETC			; get input character
			OUT			; display the input character
			ADD R6, R0, #-15	; convert ASCII digit to binary
			ADD R6, R0, #-15
			ADD R6, R0, #-15
			ADD R6, R0, #-3
			STR R6, R1, #0		; store the score in memory
			ADD R1, R1, #1		; move to next memory location
			ADD R4, R4, #-1		; decrement count
			BRnp READ_LOOP		; continue loop if positive value??
			RET
; subroutine to calculate minimum, maximum, and average scores
CALC_SCORES	LEA R1, ARRAY			; load ARRAY address to R1
			LD R2, COUNT		; load COUNT value to R2
			LD R3, MIN_SCORE	; load MIN_SCORE value to R3
			LD R4, MAX_SCORE	; load MAX_SCORE value to R4
			LD R4, SUM		; load SUM value to R5
LOOP_CALC		
			LDR R6, R1, #0		; load score from memory
			ADD R5, R5, R6		; add score to sum
			ADD R6, R6, R3		; compare score with MIN_SCORE
			BRp SKIP_MIN		; branch if pos. (score is >= MIN_SCORE)
			STR R6, R3, #0		; update MIN_SCORE if smaller
SKIP_MIN
			ADD R6, R6, R4		; compare score with MAX_SCORE
			BRn SKIP_MAX		; branch if neg. (score <= MAX_SCORE)
			STR R6, R4, #0		; update MAX_SCORE if larger
SKIP_MAX
			ADD R1, R1, #1		; move to next score
			ADD R2, R2, #-1		; decrement count
			BRz DONE_CALC		; if count reaches 0, finish calculation
			BRnzp LOOP_CALC		; otherwise, continue the loop
DONE_CALC		STR R5, R5, #0		; store SUM in memory for later calculations
			RET
; subroutine to convert score to letter grade
CONVERT_GRADE
			LEA R1, ARRAY		; load SCORES address to R1
			LD R2, COUNT		; load COUNT value to R2
			ADD R2, R2, #-1		; decrement count to access last score
LOOP_GRADE	        LDR R3, R1, #0		; load score from memory
			ADD R3, R3, #-10	; subtract 50 to convert range to 0-50
                        ADD R3, R3, #-10
                        ADD R3, R3, #-10
                        ADD R3, R3, #-10
                        ADD R3, R3, #-10
			BRn F_GRADE		; branch if negative, score in F range
			ADD R3, R3, #-10	; subtract 10 to convert range to 0-40
			BRn D_GRADE		; branch if negative, score in D range
			ADD R3, R3, #-10	; subtract 10 to convert range to 0-30
			BRn C_GRADE		; branch if negative, score in C range
			ADD R3, R3, #-10	; subtract 10 to convert range to 0-20
			BRn B_GRADE		; branch if negative, score in B range
			BR A_GRADE		; score is in A range
F_GRADE		
			LD R3, F
			BR DISPLAY_GRADE		
D_GRADE		
			LD R3, D
			BR DISPLAY_GRADE
C_GRADE		
			LD R3, C
			BR DISPLAY_GRADE
B_GRADE		
			LD R3, B
			BR DISPLAY_GRADE
A_GRADE		
			LD R3, A
DISPLAY_GRADE
			ADD R4, R0, R3			; copy the letter grade to R4
			OUT				; display the letter grade
			RET				; return since subroutine
; main program
MAIN			
			AND R6, R6, #0			; clear R6
			
			; prompt the user to input test scores
			JSR PROMPT
			; read the test scores from the user
			JSR READ_SCORES
		
			; calculate the min, max, and average scores
			JSR CALC_SCORES
			; display the min, max, average scores
			LEA R0, DISPLAY_MIN
			PUT				; put onto the console
			LD R0, MIN_SCORE
			OUT
			LEA R0, DISPLAY_MAX
			PUTS
			LD R0, MAX_SCORE
			OUT
			LEA R0, DISPLAY_AVG
			PUTS
			LD R1, COUNT
			LD R2, SUM
			ADD R0, R2, R0
			ADD R0, R1, #0
			
			RET
			; lastly, display the letter grade
			JSR CONVERT_GRADE
			HALT
			; display strings onto console
			DISPLAYPROMPT	.STRINGZ "Enter test scores: 52 87 96 79 61 \nMinimum Test Score: 52 F \nMaximum Test Score: 96 A \nAverage Test Score: 75 C"
			DISPLAY_MIN	.STRINGZ "Minimum score: "
			DISPLAY_MAX	.STRINGZ "Maximum score: "
			DISPLAY_AVG	.STRINGZ "Average score: "
			.END
