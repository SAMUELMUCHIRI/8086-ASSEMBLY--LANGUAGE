name    password mode_2024
; Microprocessor II example

include 'emu8086.inc'

.model small

.stack  100h

.data

; Define testdata table containing 10 words, each of 4 characters
testdata    db  'loap'     ; Test data table
            db  'rest'
            db  'fool'
            db  'iill'
            db  'rewa'
            db  'jkty'
            db  'reta'
            db  'gear'
            db  'near'
            db  'fear'
                    
inp     db  13,10,'enter four letter password',13,10,00, '$' ; Input message
opt     db  13,10,'You entered.$'    ; Message for successful entry
tryagn  db  13,10,'try again',13,10,'$'   ; Message for incorrect entry
thk     db  13,10,'Thank you',13,10,'$'   ; Thank you message

buffer_pos   DB 5,?,5 dup (?)    ; Buffer to store the user input

.code

main:

;setting the segments
mov ax,@data
mov ds,ax
mov es,ax
   
mainloop:       
mov dx,offset inp
call display
        
;key_in characters and setting the storage location
mov dx,offset buffer_pos
mov ah,0aH
int 21H
call delay
mov si, offset testdata 
mov cx,0aH

;Initialize index pointers       
mov di,0000H
push di
mov si,0000h
push si
mov cx, 3h

minloop:
; Compares the user input with each word in the testdata table
; If the input matches, it displays a success message and exits

mov di, offset buffer_pos +2
push cx
mov cx,4
repe cmpsb
je equals
pop cx
pop si
pop di
inc di
push di
push si
mov ax,di
mov bl,4
mul bl
add si,ax
loop minloop

; Incorrect password message        
mov dx, offset tryagn
call display
loop mainloop
        
equals:
; Success message        
mov dx, offset thk
call display
jmp ending
        
; Display message module        
display proc near
mov ah,9
int 21h
ret
display endp

; Timer module    
delay proc near 
mov cx,001EH
mov dx,8480H
mov ah,86H
int 15H 
ret
delay endp

; Exit program        
ending:
mov ah,4ch
int 21h
        
end main
