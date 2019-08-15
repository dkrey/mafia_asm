#importonce

//===============================================================================
// wait for keypress
// Warten auf den Tastendruck
//===============================================================================

Wait_for_key:
    jsr GETIN
    beq Wait_for_key
    rts

//===============================================================================
// Delay
// Wartet einen Moment
//===============================================================================
addDelay:
        ldy #$00        // Counter reset
        sei             // enable interrupts

!loop1:
        lda #$fb        // wait for vertical retrace
!loop2:
        cmp $d012       // until it reaches 251th raster line ($fb)
        bne !loop2-     // which is out of the inner screen area

        iny             // increase frame counter
        cpy delayVal    // reached 50
        bne !out+       // if not, continue
        rts             // End wait
!out:
        lda $d012       // make sure we reached
!loop3:
        cmp $d012      // the next raster line so next time we
        beq !loop3-    // should catch the same line next frame

        jmp !loop1- // jump to main loop

delayVal:
    .byte $1e

.pseudocommand addDelay duration {
    lda duration
    sta delayVal
    jsr addDelay
}

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
//  .text "234567890."
//  .byte 0
filter_num_players:
    .text "2345678"
    .byte 0

filter_alphanumeric:
    .text " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890.,-+!#$%&'()*"
    .byte 0

filter_numeric:
    .text "1234567890"
    .byte 0
filter_yesno:
    .text "JNjn"
    .byte 0
//=================================================
minchars:

maxchars:
    .byte $00

lastchar:
    .byte $00

input_y:
    .byte $00

got_input:
    .fill 128,0

//===============================================================================
// Move_input_to_TextPtr
// Schiebt got_input an die Adresse von TextPtr aber nur 16 Stellen
// Y - Register = Offset
//===============================================================================
Move_input_to_TextPtr:
        ldx #$00            // Init x-Register
                            // Das Y-Register muss schon mit dem Offset vorgeladen sein
!loop:
        lda got_input, x    // Got Input byte-weise laden
        beq !end+           // 0 Terminiterter String bedeutet Ende
        sta (TextPtr), y    // und indirekt Y-indiziert speichern

        inx                 // Bytezähler für Quelle
        iny                 // Bytezähler für Ziel
        cpx playerNameLength             // Sofern 0 nicht im Akku steht, weiter
        bne !loop-
!end:
        rts

inputToHex32:
    ldx #$00
!loop:
    lda got_input, x        // Got Input byte-weise laden
    beq !end+               // 0 Terminiterter String bedeutet Ende
    sec
    sbc #$30                // von PetSCII nach
!end:


//===============================================================================
// Move_input_to_Hex32
// Konvertiert got_input zu hex32 Zahl
// X Register wird verwendet
//===============================================================================
Move_input_to_Hex32:
    clear32 strToHex32_source
    clear32 strToHex32_result
    ldx #0

!loop:
    lda got_input, x // Zeichen aus der Eingabe holen
    beq !done+      // Schluss bei 0
    pha             // Zeichen erstmal weglegen
    jsr mul32by10   // zwischenergebnis * 10
    pla             // Zeichen wiederholen
    sec             // um PETSCII bereinigen
    sbc #$30
    sta ZeroPageTemp // Zahl in ZP zwischenspeichern
    clc

    add8To32 ZeroPageTemp : strToHex32_result : strToHex32_result  // Zahl zum Zwischenergebnis addieren
    mov32 strToHex32_result : strToHex32_source // Zwischenergebnis ist neues Gesamtergebnis
    inx
    cpx #$0A    // 10 Stellen max.
    bne !loop-

!done:
    rts

mul32by10:
    // Source * 2
    lda strToHex32_source
    asl
    sta strToHex32_result
    lda strToHex32_source +1
    rol
    sta strToHex32_result +1
    lda strToHex32_source +2
    rol
    sta strToHex32_result +2
    lda strToHex32_source +3
    rol
    sta strToHex32_result +3
    // strToHex32_result * 2
    jsr mul2
    // + strToHex32_source
    clc
    lda strToHex32_result
    adc strToHex32_source
    sta strToHex32_result
    lda strToHex32_result +1
    adc strToHex32_source +1
    sta strToHex32_result +1
    lda strToHex32_result +2
    adc strToHex32_source +2
    sta strToHex32_result +2
    lda strToHex32_result +3
    adc strToHex32_source +3
    sta strToHex32_result +3
mul2:
    // target *2
    asl strToHex32_result
    rol strToHex32_result +1
    rol strToHex32_result +2
    rol strToHex32_result +3
    rts

strToHex32_result:
    .dword $00000000

strToHex32_source:
    .dword $00000000