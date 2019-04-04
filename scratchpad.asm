// 16 Bit Vergleich mit größer und kleiner

lda lobyte1
cmp lobyte2
lda hibyte1
sbc hibyte2
bcc .wert1_kleiner_als_wert2
bne .skip
lda lobyte1
cmp lobyte2
beq .wert1_ungleich_wert2
.skip

// 16 Bit Vergleich = !=
lda lo1
eor lo2
bne ungleich
lda hi1
eor hi2
bne ungleich
beq gleich

// Warum nicht eine Tabelle mit den Low (und Hi)-Bytes der Adressen anlegen, das sind vier (8) fixe Bytes. Dann y = gewünschter Player (0-3) und Adresse aus der Tabelle lesen - fertig.

//    txa
//    tay
//    lda address_tbl,y
//    sta pointer_lo
//    ...
//    address_tbl:
//    !byte $08,$08+1*32,$08+2*32,$08+3*32

// ldy #0 ; Name 1
// lda Table_Address,y ; get Address of Name
// sta Temp
//
//===============================================================================
//wait for keypress
//
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
Filtered_input:
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
  beq input_done

  //Not yet.
  jmp input_get

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
    .text " ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890.,-+!#$%&'()*"
    .byte 0

filter_numeric:
    .text "1234567890"
    .byte 0

//=================================================
maxchars:
  .byte $00

lastchar:
  .byte $00

input_y:
  .byte $00

got_input:
  .byte 39