.model small
.stack 100H

; Data segment
.data   ; if there is nothing in the data segment, you can omit this line.

welcome DW 13,10," ATM SERVICES $"
ch_bal	DW 13,10," 1 Check Balance $"
With_draw DW 13,10," 2 WithDraw Cash from Account $" 
With_draw1 DW 13,10,"   WithDraw    $" 
cash  DW 13,10, " You have KSH$"
message_1  DW "Correct Password $"
message_2  DW "Incorrect Password Try again $"
message_3  DW 13,10,"Enter Your Account Name $"     
message_4  DW 13,10,"    Hello $"
user_1 DB "John$"
pass_1 DW 1234H
bal_1  DW 100H
user_2 DB "Mark$"
pass_2 DW 4568H
num_1  DB 01H  
num_2  DB 02H



buffer_sel DB 5,?,2 dup(?)
buffer_name DB 5,?,5 dup(?)
buffer_pass DB 5,?,5 dup(?)
buffer_cash DB 13,10,5,?,5 dup(?)


input_char DB ?
; Code segment
.code

main PROC
    ; Write your code here     
    MOV AX, @data
    MOV DS, AX   
    
    ; Output a string
    MOV AH, 9
    LEA DX, welcome
    INT 21H  
    MOV AH, 9
    LEA DX, ch_bal
    INT 21H

    MOV AH, 9
    LEA DX, With_draw
    INT 21H 
    
    MOV AH, 1
    LEA DX, buffer_sel
    INT 21H   
    
    MOV AH, num_2
    MOV CH, buffer_sel
    CMP AH,CH
    JE L1
    ;JB L2
    ;JA L3
    
    L1:
    MOV DX,OFFSET With_draw1
    MOV AH ,09H
    INT 21H
    MOV DX,OFFSET message_3
    MOV AH ,09H
    INT 21H
    
    MOV DX,OFFSET buffer_name
    MOV AH,0AH
    INT 21H   
    
    LEA SI, user_1
    LEA DI, buffer_name
    
    MOV CX,4
    MOV BX,0
    
COMPARE_LOOP:
    MOV AL,[SI]
    MOV BL,[DI]
    
    CMP AL,BL
    
    JNE STRING_NOT_EQUAL 
    
    INC SI
    INC DI
    INC BX
    
    CMP BX, CX
    JE STRINGS_EQUAL 
    
    JMP COMPARE_LOOP
    
STRINGS_EQUAL:
    MOV AH,0AH
    LEA DX,buffer_pass
    INT 21H
    
    LEA AX, pass_1
    MOV CH, buffer_pass           
    CMP AX, CX
    
    JE L11  
    L11: 
    MOV AH,9
    MOV DX,message_4
    INT 21H   
    
    MOV AH,09H
    LEA DX,user_1
    INT 21H  
    
    MOV AH,09H
    MOV DX,cash
    INT 21H 
    
    MOV AH,09H
    MOV DX,bal_1
    INT 21H  
    RET

STRING_NOT_EQUAL:
    
    
    
    
    
    
    
    
    
    
    
    
    
    RET
    
    
   

    exit:
    MOV AH, 4CH
    INT 21H
    main ENDP
END main