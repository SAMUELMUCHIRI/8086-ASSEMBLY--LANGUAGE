; Sample program 1
; Confirm the segment initialization and usage 
.MODEL  SMALL   ; Specifies the memory model the program will use
;               in the simplified segment definition. In this case,
;               64KB for code and 64KB of data memory is reserved.
.STACK          ; Allocate stack. Needs to be initialized.
.CODE           ; Directive to start code segment
START:          ; Entry point of the program, commonly named MAIN by some programmers

JMP BEGIN       ; Jump to label BEGIN

welcome DB  "Hello Prospective Engineers. This is a message.",'$'
                ; Terminating a string with the '$' sign  

BEGIN:          ; Code starts here
mov dx, OFFSET welcome
;               ; Puts the offset of message in DX
mov ax, SEG welcome
;               Puts the segment that the message is in AX
mov ds, ax      ; Copy AX to DS
mov ah, 09h     ; Move 09 into AH to call function 09 of interrupt
int 21h         ; Interrupt 21h displays string on a screen
mov ax, 4c00h   ; Move value 4c00h into AX
int 21h         ; Call interrupt 21h, subroutine which returns control to DOS. 
                ; 00h is an error level returned to DOS

END START       ; End program here
