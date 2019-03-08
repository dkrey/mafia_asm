//===============================================================================
// wait for keypress
// Warten auf den Tastendruck
//===============================================================================

Wait_for_key:
    jsr GETIN
    beq Wait_for_key
    rts

//======================================================================
// Input a string and store it in GOTINPUT, terminated with a null byte.
// x:a is a pointer to the allowed list of characters, null-terminated.
// max # of chars in y returns num of chars entered in y.
//======================================================================

// Example usage
//filtered_text:
//  lda #>text
//  ldx #<text
//  ldy #38
//  Drop through

// Main entry
Get_filtered_input:
    sty maxchars
    stx checkallowed+1
    sta checkallowed+2

    //Zero characters received.
    lda #$00
    sta input_y

//Wait for a character.
input_get:
    jsr GETIN
    beq input_get

    sta lastchar

    cmp #PET_DELETE         //Delete
    beq delete

    cmp #PET_CR            //Return
    beq input_done

    //Check the allowed list of characters.
    ldx #$00
checkallowed:
    lda $FFFF,x           //Overwritten
    beq input_get         //Reached end of list (0)

    cmp lastchar
    beq inputok           //Match found

    //Not end or match, keep checking
    inx
    jmp checkallowed

inputok:
    lda lastchar          //Get the char back
    ldy input_y
    sta got_input,y        //Add it to string
    jsr BSOUT             //Print it

    inc input_y           //Next character

    //End reached?
    lda input_y
    cmp maxchars
    //beq input_done
    beq input_last_char
    //Not yet.
    jmp input_get

// Wait for Return or Delete on last character
input_last_char:
    jsr GETIN
    beq input_last_char

    cmp #PET_DELETE         //Delete
    beq delete

    cmp #PET_CR            //Return
    beq input_done
    jmp input_last_char

input_done:
    ldy input_y
    lda #$00
    sta got_input,y   //Zero-terminate
    rts

// Delete last character.
delete:
    //First, check if we're at the beginning.  If so, just exit.
    lda input_y
    bne delete_ok
    jmp input_get

  //At least one character entered.
delete_ok:
    //Move pointer back.
    dec input_y

    //Store a zero over top of last character, just in case no other characters are entered.
    ldy input_y
    lda #$00
    sta got_input,y

    //Print the delete char
    lda #PET_DELETE
    jsr BSOUT

    //Wait for next char
    jmp input_get


//=================================================
//Some example filters
//=================================================

//IPADDRESS
//  .text "1234567890."
//  .byte 0
filter_num_players:
    .text "12345678"
    .byte 0

filter_alphanumeric:
    .text " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890.,-+!#$%&'()*"
    .byte 0

filter_numeric:
    .text "1234567890"
    .byte 0

//=================================================
minchars:

maxchars:
    .byte $00

lastchar:
    .byte $00

input_y:
    .byte $00

.pc = * "GotInput"
got_input:
    .fill 128,0

//===============================================================================
// Move_input_dst
// Schiebt
//===============================================================================
Move_input_dst:
