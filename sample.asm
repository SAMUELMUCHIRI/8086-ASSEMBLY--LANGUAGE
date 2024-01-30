.model small
.stack 100h

.data
    userBalance dw 1000          ; Initial user account balance
    buffer      db 6             ; Buffer for input
    msgDeposit  db 'Please Insert the money$'
    msgWithdraw db 'Enter amount to withdraw$'
    msgNotEnough db 'Not ENOUGH money in the account$'
    msgBalance  db 'Your account balance is: $'
    msgBack     db 'Press any key to go back to main menu$'

.code
    main proc
        mov ax, @data
        mov ds, ax

        call displayMenu         ; Display the main menu

    mainLoop:
        mov ah, 01h              ; Wait for a keypress
        int 21h

        cmp al, '1'              ; Check user input
        je depositCash
        cmp al, '2'
        je withdrawCash
        cmp al, '3'
        je checkBalance
        jmp mainLoop             ; Repeat if invalid input

    depositCash:
        call clearScreen
        mov ah, 09h              ; Display message
        lea dx, msgDeposit
        int 21h

        ; Here you would handle deposit logic
        ; Update user account balance
        ; Return to main menu
        call backToMenu

    withdrawCash:
        call clearScreen
        mov ah, 09h              ; Display message
        lea dx, msgWithdraw
        int 21h

        ; Here you would handle withdrawal logic
        ; Compare with actual money in the account
        ; If enough money, subtract from balance, else display error
        ; Return to main menu
        call backToMenu

    checkBalance:
        call clearScreen
        mov ah, 09h              ; Display message
        lea dx, msgBalance
        int 21h

        ; Display user account balance
        ; Return to main menu
        call backToMenu

    displayMenu:
        call clearScreen
        ; Display welcome message and menu options
        ; Return control back to main program
        ret

    clearScreen:
        mov ah, 06h              ; Scroll screen function
        mov al, 0                ; Clear entire screen
        mov bh, 07h              ; Display attribute (white on black)
        mov cx, 0                ; Upper left corner
        mov dx, 184Fh            ; Lower right corner
        int 10h
        ret

    backToMenu:
        mov ah, 09h              ; Display message
        lea dx, msgBack
        int 21h

        mov ah, 01h              ; Wait for a keypress
        int 21h
        jmp mainLoop             ; Return to main menu

    main endp
end main
