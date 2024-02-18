
.model small
.stack 100h

.data      

;user details 
acc_one db '4321'
len equ ($-acc_one) 

acc_two db '1234'
len equ ($-acc_two)

acc_pass db '9876'
len1 equ ($-acc_pass)   

acc2_pass db '6789'
len1 equ ($-acc2_pass)

;messages
msg1 db 10,13,'Enter your Account Number : $'
msg2 db 10,13,'Account found$'
msg3 db 10,13,'Incorrect Password, Please try again!$'
msg4 db 10,13 , 'Account number Not Found$' 
msg5  DW  " Enter Your Password $" 
msg6  DW 13,10, "Incorrect Password Try again $" 
msg7  DW 13,10, "Enter Account Number OF Receiver $" 
currentbal_msg DW 13,10," The Balance is Ksh $"
new db 10,13 , "$" 
WITH_PROMPT DB 0AH, 0AH, 0DH, " Enter amount to withdraw: Ksh. $"
WITH_AMT DW 0H 
welcome DW 13,10," ATM SERVICES $"
ch_bal	DW 13,10," 1 Check Balance $"
With_draw DW 13,10," 2 WithDraw Cash from Account $"    
De_posit DW 13,10," 3 Deposit Cash to account $"   
T_msg DW 13,10, " 4 Cash Transfer $"
With_draw1 DW 13,10,"   WithDraw    $" 
cash  DW 13,10, " You have KSH$"
invalid DW 13,10, "invalid entry try again$"
dev DW 13,10, "Amount be greater than 1000 Press one to enter amount$"  
exit DW 13,10, " 5 Exit$"  
MAX_LIM DW 5000   
LIM_EXCEED DB 0AH, 0AH, 0DH, " Limit exceeded (Maximum amount = Ksh. 5000)$"
BAL_LOW DB 0AH, 0AH, 0DH, " Insufficient balance$"
balance DW 10000
balance2 DW 20000
SUCCESS DB 0AH, 0AH, 0DH, " Transaction successful$"
CUR_BAL_MSG DB 0AH, 0AH, 0DH, " Current balance = Ksh. $"
DEP_PROMPT DB 0AH, 0AH, 0DH, " Enter amount to deposit: Ksh. $"        
SEND_PROMPT DB 0AH, 0AH, 0DH, " Enter amount to send: Ksh. $"
TransferMSG DW 13,10, "Can only send in the range below$"
  ;Digit place
    TH DW 1000
    H DB 100
    T DB 10 
 ;Amount options
    ABOVE1000 DB 0AH, 0AH, 0DH, " 1. Ksh.1000 - Ksh.5000$"
    ABOVE100 DB 0AH, 0DH, " 2. Ksh.100 - Ksh.999$"
CHOOSE DB 0AH, 0AH, 0DH, " Enter option: $" 
DEP_AMT DW 0H  
SEND_AMT DW 0H  

;inputs
inst db 10 dup(0)   

.code
mov cx,len

start:
mov ax,@data
mov ds,ax  

nxt:
lea dx,msg1   ; calculates the effective address of a memory operand and stores it in a register, without actually accessing the memory.
mov ah,09h
int 21h
mov si,00


up1:
mov ah,08h
int 21h
cmp al,0dh
je down
mov [inst+si],al
mov dl,'*'
mov ah,02h
int 21h
inc si
jmp up1


down:
mov bx,00
mov cx,len
dec cx


check:
mov al,[inst+bx]
mov dl,[acc_one+bx]
cmp al,dl
jnz check2         
inc bx
loop check


correct:
lea dx,msg2
mov ah,09h
int 21h
jmp pass1  


hint:
mov ah,09h
lea dx,msg4
int 21h
jmp start
loop hint                                                  
jmp fail

check2:
mov al,[inst+bx]
mov dl,[acc_two+bx]
cmp al,dl
jnz hint         
inc bx
loop check2 

correct2:
lea dx,msg2
mov ah,09h
int 21h
jmp pass2

                      

fail:
lea dx,msg3
mov ah,09h
int 21h
jmp start 

pass2:
lea dx,msg5
mov ah,09h
int 21h
mov si,00
jmp passcode2 

passcode2: 
mov ah,08h
int 21h
cmp al,0dh
je accdown1
mov [inst+si],al
mov dl,'*'
mov ah,02h
int 21h
inc si
jmp passcode2

accdown1:
mov bx,00
mov cx,len
dec cx

acccheck2:
mov al,[inst+bx]
mov dl,[acc2_pass+bx]
cmp al,dl
jnz acchint         
inc bx
loop acccheck2

turn2: 
jmp accservices2 

accservices2: 
mov dx,offset welcome 
mov ah,09h   
int  21h
mov dx,offset ch_bal   
mov ah,09h
int 21h
mov dx,offset With_draw  
mov ah,09h
int 21h
mov dx,offset De_posit 
mov ah,09h
int 21h  
mov dx,offset T_msg 
mov ah,09h
int 21h
mov dx,offset exit   
mov ah,09h
int 21h
mov ah,01h
int 21h

cmp al, 49
je CheckBal2
cmp al,050
je withdraw_m2
cmp al,051
je  DEPOSIT2
cmp al, 052
je TRANSFER2
cmp al, 053
je nxt
jmp er_choice
  
jmp finish

CheckBal2:
  MOV AH, 0H ;To check for a keystroke like press any key to continue.
  INT 16H
             
  MOV AH, 09H
  LEA DX, currentbal_msg
  INT 21H
                       
   XOR AX, AX
   MOV AX, balance2
   CALL DISPLAY_NUM
             
   JMP accservices2
   

        RET     
        
withdraw_m2:
        mov dx,offset dev
        mov ah,09h
        int 21h
        MOV AH, 01H
        INT 21H
	    CMP AL, 49
	    JE WITH_2ABOVE1000
        jmp accservices2

WITH_2ABOVE1000: MOV AH, 09H
                LEA DX, WITH_PROMPT
                INT 21H
                                  
                CALL INPUT_4DIGIT_NUM
                MOV WITH_AMT, BX
                    
                CMP BX, MAX_LIM
                JG EXCEED_ERROR2
                JMP WITH_TRANSACT2

EXCEED_ERROR2: MOV AH, 0H
                  INT 16H
                  MOV AH, 09H
                  LEA DX, LIM_EXCEED
                  INT 21H
                  JMP withdraw_m2
                  
WITH_TRANSACT2: CMP BX, balance2
                JG BAL_LOW_ERROR
                   
               MOV BX, balance2
               SUB BX, WITH_AMT
               MOV balance2, BX
                       
               MOV AH, 0H
               INT 16H
               CALL SUCCESS_MSG2
               JMP accservices2 
                
SUCCESS_MSG2 PROC NEAR
        MOV AH, 09H
        LEA DX, SUCCESS
        INT 21H
        
        MOV AH, 09H
        LEA DX, CUR_BAL_MSG
        INT 21H
        
        XOR AX, AX
        MOV AX, balance2
        CALL DISPLAY_NUM 
        JMP accservices2

DEPOSIT2: MOV AH, 0H
             INT 16H
                    
             MOV AH, 09H
             LEA DX, ABOVE1000
             INT 21H
              
                           
             MOV AH, 09H
             LEA DX, CHOOSE
             INT 21H
              
             MOV AH, 01H
             INT 21H
              
             ;Check deposit amount option
             CMP AL, 49
             JE DEP2_ABOVE1000
             CMP AL, 50
             JE accservices
             JMP INP_ERROR 
    
             
    ;If deposit amount is between Rs.1000 and Rs.5000
DEP2_ABOVE1000: MOV AH, 09H
                   LEA DX, DEP_PROMPT
                   INT 21H
                                  
                   CALL INPUT_4DIGIT_NUM
                   MOV DEP_AMT, BX
                    
                   CMP BX, MAX_LIM
                   JG EXCEED_ERROR2
                   JMP DEP_TRANSACT2
                                        
                    

                                 
    
    ;Start the deposit transaction
DEP_TRANSACT2: MOV BX, balance2
                  ADD BX, DEP_AMT
                  MOV balance2, BX
                       
                  MOV AH, 0H
                  INT 16H
                  CALL SUCCESS_MSG2
                  JMP accservices2

TRANSFER2: 
    MOV AH, 0H
     INT 16H
     
     MOV AH, 09H
     LEA DX, TransferMSG 
     INT 21H
           
     MOV AH, 09H
     LEA DX, ABOVE1000
     INT 21H     
    
      
     MOV AH, 09H
     LEA DX, CHOOSE
     INT 21H
      
     MOV AH, 01H
     INT 21H
      
     ;Check deposit amount option
     CMP AL, 49
     JE T2SEND_ABOVE1000
     CMP AL, 50
     JE accservices2
     JMP INP_ERROR 


T2SEND_ABOVE1000: MOV AH, 09H
                   LEA DX, SEND_PROMPT
                   INT 21H
                                  
                   CALL INPUT_4DIGIT_NUM
                   MOV SEND_AMT, BX
                    
                   CMP BX, MAX_LIM
                   JG EXCEED_ERROR3 
                   CMP BX, balance2
                   JG NO_CASH
                   JMP SEND2_VERIFY 

EXCEED_ERROR3: MOV AH, 0H
                  INT 16H
                  MOV AH, 09H
                  LEA DX, LIM_EXCEED
                  INT 21H
                  JMP T2SEND_ABOVE1000                   
NO_CASH: 
lea dx,BAL_LOW
mov ah,09h
int 21h 
jmp accservices2

SEND2_VERIFY:
lea dx,msg7   ; calculates the effective address of a memory operand and stores it in a register, without actually accessing the memory.
mov ah,09h
int 21h
mov si,00

T2up1:
mov ah,08h
int 21h
cmp al,0dh
je T2down
mov [inst+si],al
mov dl,'*'
mov ah,02h
int 21h
inc si
jmp T2up1


T2down:
mov bx,00
mov cx,len
dec cx


T2check:
mov al,[inst+bx]
mov dl,[acc_one+bx]
cmp al,dl
jnz T2hint         
inc bx
loop T2check


T2correct:
lea dx,msg2
mov ah,09h
int 21h
jmp SEND2_TRANSACT  


T2hint:
mov ah,09h
lea dx,msg4
int 21h
jmp TRANSFER2
loop T2hint                                                  
jmp T2fail

                     

T2fail:
lea dx,msg3
mov ah,09h
int 21h
jmp TRANSFER2 

SEND2_TRANSACT:CMP BX, balance2
              JG BAL_LOW_ERROR
                   
               MOV BX, balance2
               SUB BX, SEND_AMT
               MOV balance2, BX
               MOV BX, balance
              ADD BX, SEND_AMT
              MOV balance, BX
                   
              MOV AH, 0H
              INT 16H
              CALL SUCCESS_MSG2
              JMP accservices2
                                
pass1:
lea dx,msg5
mov ah,09h
int 21h
mov si,00

passcode: 
mov ah,08h
int 21h
cmp al,0dh
je accdown
mov [inst+si],al
mov dl,'*'
mov ah,02h
int 21h
inc si
jmp passcode     

accdown:
mov bx,00
mov cx,len
dec cx


acccheck:
mov al,[inst+bx]
mov dl,[acc_pass+bx]
cmp al,dl
jnz acccheck2         
inc bx
loop acccheck

accservices: 
mov dx,offset welcome 
mov ah,09h   
int  21h
mov dx,offset ch_bal   
mov ah,09h
int 21h
mov dx,offset With_draw  
mov ah,09h
int 21h
mov dx,offset De_posit 
mov ah,09h
int 21h 
mov dx,offset T_msg 
mov ah,09h
int 21h
mov dx,offset exit   
mov ah,09h
int 21h
mov ah,01h
int 21h

cmp al, 49
je CheckBal
cmp al,050
je withdraw_m
cmp al,051
je  DEPOSIT
cmp al, 052
je TRANSFER 
cmp al, 053
je nxt
jmp er_choice
  
jmp nxt

CheckBal:
  MOV AH, 0H ;To check for a keystroke like press any key to continue.
  INT 16H
             
  MOV AH, 09H
  LEA DX, currentbal_msg
  INT 21H
                       
   XOR AX, AX
   MOV AX, balance
   CALL DISPLAY_NUM
             
   JMP accservices



turn:
jmp accservices 


DISPLAY_NUM PROC NEAR
        XOR CX, CX ;To count the digits
        MOV BX, 10 ;Fixed divider
        
        DIGITS:
        XOR DX, DX ;Zero DX for word division
        DIV BX
        PUSH DX ;Remainder (0,9)
        INC CX
        TEST AX, AX
        JNZ DIGITS ;Continue until AX is empty
        
        NEXT:
        POP DX
        ADD DL, 30H
        MOV AH, 02H
        INT 21H
        LOOP NEXT
        
        RET 
        
withdraw_m:
        mov dx,offset dev
        mov ah,09h
        int 21h
        MOV AH, 01H
        INT 21H
	    CMP AL, 49
	    JE WITH_ABOVE1000
        jmp accservices

WITH_ABOVE1000: MOV AH, 09H
                LEA DX, WITH_PROMPT
                INT 21H
                                  
                CALL INPUT_4DIGIT_NUM
                MOV WITH_AMT, BX
                    
                CMP BX, MAX_LIM
                JG EXCEED_ERROR
                JMP WITH_TRANSACT
WITH_TRANSACT: CMP BX, balance
                JG BAL_LOW_ERROR
                   
               MOV BX, balance
               SUB BX, WITH_AMT
               MOV balance, BX
                       
               MOV AH, 0H
               INT 16H
               CALL SUCCESS_MSG
               JMP accservices    

    ;Deposit money to account
DEPOSIT: MOV AH, 0H
             INT 16H
                    
             MOV AH, 09H
             LEA DX, ABOVE1000
             INT 21H
              
           
              
             MOV AH, 09H
             LEA DX, CHOOSE
             INT 21H
              
             MOV AH, 01H
             INT 21H
              
             ;Check deposit amount option
             CMP AL, 49
             JE DEP_ABOVE1000
             CMP AL, 50
             JE accservices
             JMP INP_ERROR 
    
             
    ;If deposit amount is between Rs.1000 and Rs.5000
DEP_ABOVE1000: MOV AH, 09H
                   LEA DX, DEP_PROMPT
                   INT 21H
                                  
                   CALL INPUT_4DIGIT_NUM
                   MOV DEP_AMT, BX
                    
                   CMP BX, MAX_LIM
                   JG EXCEED_ERROR
                   JMP DEP_TRANSACT
                                        
TRANSFER: 
    MOV AH, 0H
     INT 16H
     
     MOV AH, 09H
     LEA DX, TransferMSG 
     INT 21H
           
     MOV AH, 09H
     LEA DX, ABOVE1000
     INT 21H     
    
      
     MOV AH, 09H
     LEA DX, CHOOSE
     INT 21H
      
     MOV AH, 01H
     INT 21H
      
     ;Check deposit amount option
     CMP AL, 49
     JE TSEND_ABOVE1000
     CMP AL, 50
     JE accservices
     JMP INP_ERROR 


TSEND_ABOVE1000: MOV AH, 09H
                   LEA DX, SEND_PROMPT
                   INT 21H
                                  
                   CALL INPUT_4DIGIT_NUM
                   MOV SEND_AMT, BX
                    
                   CMP BX, MAX_LIM
                   JG EXCEED_ERROR4 
                   CMP BX, balance
                   JG NO_CASH2      
                   JMP SEND_VERIFY 
                   
EXCEED_ERROR4: MOV AH, 0H
                  INT 16H
                  MOV AH, 09H
                  LEA DX, LIM_EXCEED
                  INT 21H
                  JMP T2SEND_ABOVE1000                   
NO_CASH2: 
lea dx,BAL_LOW
mov ah,09h
int 21h 
jmp accservices

SEND_VERIFY:
lea dx,msg7   ; calculates the effective address of a memory operand and stores it in a register, without actually accessing the memory.
mov ah,09h
int 21h
mov si,00

Tup1:
mov ah,08h
int 21h
cmp al,0dh
je Tdown
mov [inst+si],al
mov dl,'*'
mov ah,02h
int 21h
inc si
jmp Tup1


Tdown:
mov bx,00
mov cx,len
dec cx


Tcheck:
mov al,[inst+bx]
mov dl,[acc_two+bx]
cmp al,dl
jnz Thint         
inc bx
loop Tcheck


Tcorrect:
lea dx,msg2
mov ah,09h
int 21h
jmp SEND_TRANSACT  


Thint:
mov ah,09h
lea dx,msg4
int 21h
jmp TRANSFER
loop Thint                                                  
jmp Tfail

                     

Tfail:
lea dx,msg3
mov ah,09h
int 21h
jmp TRANSFER 

SEND_TRANSACT:CMP BX, balance
              JG BAL_LOW_ERROR
                   
               MOV BX, balance
               SUB BX, SEND_AMT
               MOV balance, BX
               MOV BX, balance2
              ADD BX, SEND_AMT
              MOV balance2, BX
                   
              MOV AH, 0H
              INT 16H
              CALL SUCCESS_MSG
              JMP accservices
                                                         
EXCEED2_ERROR: MOV AH, 0H
                  INT 16H
                  MOV AH, 09H
                  LEA DX, LIM_EXCEED
                  INT 21H
                  JMP TSEND_ABOVE1000
                                 
    
    ;Start the deposit transaction
DEP_TRANSACT: MOV BX, balance
                  ADD BX, DEP_AMT
                  MOV balance, BX
                       
                  MOV AH, 0H
                  INT 16H
                  CALL SUCCESS_MSG
                  JMP accservices
SUCCESS_MSG PROC NEAR
        MOV AH, 09H
        LEA DX, SUCCESS
        INT 21H
        
        MOV AH, 09H
        LEA DX, CUR_BAL_MSG
        INT 21H
        
        XOR AX, AX
        MOV AX, balance
        CALL DISPLAY_NUM
        
        RET
BAL_LOW_ERROR: MOV AH, 0H
                   INT 16H
                   MOV AH, 09H
                   LEA DX, BAL_LOW
                   INT 21H
                   JMP withdraw_m 

 EXCEED_ERROR: MOV AH, 0H
                  INT 16H
                  MOV AH, 09H
                  LEA DX, LIM_EXCEED
                  INT 21H
                  JMP withdraw_m
   INP_ERROR: MOV AH, 09H
               LEA DX, invalid
               INT 21H
               JMP withdraw_m

INPUT_4DIGIT_NUM PROC NEAR
        MOV AH, 01H
        INT 21H
        
        ;Check whether character is a digit
        CMP AL, 30H
        JL INP_ERROR
        CMP AL, 39H
        JG INP_ERROR 
        
        SUB AL, 30H
        MOV AH, 0
        MUL TH ;1st digit
        MOV BX, AX
        
        MOV AH, 01H
        INT 21H
        
        ;Check whether character is a digit
        CMP AL, 30H
        JL INP_ERROR
        CMP AL, 39H
        JG INP_ERROR
        
        SUB AL, 30H
        MUL H ;2nd digit
        ADD BX, AX
        
        MOV AH, 01H
        INT 21H
        
        ;Check whether character is a digit
        CMP AL, 30H
        JL INP_ERROR
        CMP AL, 39H
        JG INP_ERROR
        
        SUB AL, 30H
        MUL T ;3rd digit
        ADD BX, AX               
        
        MOV AH, 01H
        INT 21H
        
        ;Check whether character is a digit
        CMP AL, 30H
        JL INP_ERROR
        CMP AL, 39H
        JG INP_ERROR
        
        SUB AL, 30H ;4th digit
        MOV AH, 0
        ADD BX, AX
        
        RET
          
         
        
        
er_choice:
        mov dx,invalid
        mov ah,09h
        int 21h
        jmp accservices
        




acchint:
mov ah,09h
lea dx,msg6
int 21h
jmp pass1
loop acchint
jmp accfail
                       

accfail:
lea dx,msg3
mov ah,09h
int 21h
jmp start






finish:
mov ah,4ch
int 21h


end start
