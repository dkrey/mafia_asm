#importonce


gameTransferHead:
    jsr CLEAR
    mov #BLACK : EXTCOL            //  Overscan
    mov #RED : BGCOL0              //  Hintergrund
    mov #BLACK : TEXTCOL           //  Schrift

    mov16 #strTransferTitle : TextPtr // Text: "Geldtransfer:"
    jsr Print_text

    // Spielernamen anzeigen
    ldy currentPlayerOffset_16      // Offset für Spielernamen 16 Byte

    mov16 #playerNames : TextPtr
    jsr Print_text_offset           // Schreibe den Spielernamen

    lda #','
    jsr BSOUT

    mov16 #strYouHave : TextPtr // Text: "Sie haben"
    jsr Print_text

    ldy currentPlayerOffset_4       // Offset für dword holen: 4 Byte

    // Vermögen mit Offset in Dez anzeigen lassen
    mov32 playerMoney,y : hex32dec_value
    jsr Print_hex32_dec_signed

    // mit Einheit $
    lda #' '
    jsr BSOUT
    lda #'$'
    jsr BSOUT
    lda #PET_CR
    jsr BSOUT
    lda #PET_CR
    jsr BSOUT
    rts

gameTransferMenu:
    jsr gameTransferHead
    mov16 #strTransferWho : TextPtr // Text: "An wen soll das Geld fließen:"
    jsr Print_text
    lda #PET_CR
    jsr BSOUT

// Spielernamen anzeigen
    ldx #00                         // Durch die Spielernamen mit X zählen
    mov16 #playerNames : TextPtr    // Beginn der Spielernamen

!loop:
// Spielernummer +1 anzeigen
    lda #' '
    jsr BSOUT
    txa                             // X nach A
    pha                             // A auf Stack sichern
    clc
    adc #$01                        // um 1 erhöhen, weil ab 0 gezählt wird
    sta hex8dec_value               // Wert anzeigen

    jsr Print_hex8_dec
    lda #'.'
    jsr BSOUT
    lda #' '

    jsr BSOUT

    pla                             // Alten X-Wert vom Stack holen
    tax                             // und nach X schieben
    .for (var i = 0; i < 4; i++) {  // *2^4 = *16
        asl
    }
    tay                             // Offset aus Akku nach Y
    jsr Print_text_offset           // Schreibe den Spielernamen
    lda #PET_CR                     // Zeilenumbruch
    jsr BSOUT
    inx
    cpx playerCount                 // Solange x< Spieleranzahl
    bne !loop-                      // weiter mit Schleife

    lda #PET_CR
    jsr BSOUT
    mov16 #strBack : TextPtr
    jsr Print_text

    mov16 #strChoice : TextPtr
    jsr Print_text

//===============================================================================
// gameTransferChoice
//
// Wer bekommt das Geld
//===============================================================================
gameTransferChoice:
    // Abfrage, welche Position
    // Auswahl holen
    jsr GETIN
    cmp #$30        // sichergehen, dass es eine gültige Ziffer ist <= 0
    bcc gameTransferChoice
    cmp #$3a        // sichergehen, dass es eine gültige Ziffer ist >= #$3a
    bcs gameTransferChoice

    cmp #0                          // 0 oder Enter, Abfrage erneut starten
    beq gameTransferChoice

    sec                             // Konv PetSCII Zeichen zur Zahl
    sbc #$30

    // Auswahl nicht höher als erlaubt
    cmp #0              // Ziffer 0 = Exit
    bne !gameTransferContinue+
    rts

!gameTransferContinue:
    sec                            // Spielernummer - 1, so wie sie gespeichert sind
    sbc #$01

    cmp playerCount
    bcc !skip+          // Auswahl < ist okay

    jmp gameTransferChoice

!skip:
    // Nicht an sich selbst überweisen
    cmp currentPlayerNumber
    bne gameTransferAmount
    mov16 #strTransferImpossible : TextPtr // Text: "Sie machen wohl Witze"
    jsr Print_text
    lda #PET_CR
    mov16 #strPressKey : TextPtr // Text: Weiter
    jsr Print_text
    jsr Wait_for_key
    jmp gameTransferMenu

gameTransferAmount:
    pha                     // Spielernummer auf dem Stack sichern
    jsr gameTransferHead
    mov16 #strTransferAccountant : TextPtr
    jsr Print_text
    mov16 #playerNames : TextPtr
    // 4 mal weiterschieben für 16 bit: Namensoffset
    pla
    tax                     // Spielernummer in X sichern
    asl
    asl
    asl
    asl
    tay
    jsr Print_text_offset   // Text:  <Spielername> CR CR
    lda #'.'
    jsr BSOUT
    lda #PET_CR
    jsr BSOUT
    lda #PET_CR
    jsr BSOUT

    mov16 #strTransferAmount : TextPtr // Text: "Wieviel"
    jsr Print_text

    // Spielernummer wieder auf den Stack
    txa
    pha

    ldy #$0A                    // Anzahl Zeichen für die Input Routine: 10
    ldx #<filter_numeric        // Filter setzen LSB: Zahlen
    lda #>filter_numeric        // Filter setzen MSB: Zahlen

    jsr Get_filtered_input          // Input holen und speichern
    lda got_input                   // Ergebnis holen
    cmp #0                          // Prüfen, ob Spieleranzahl stimmt
    beq gameTransferAmount          // Wenn einfach nur Enter gedrückt wurde,
                                    //  nochmal von vorn

    jsr Move_input_to_Hex32         // Eingabe als Zahl konvertieren

    lda #PET_CR
    jsr BSOUT

    // Prüfen ob das Geld überhaupt reicht
    ldy currentPlayerOffset_4       // Offset für dword holen: 4 Byte

    compare32 playerMoney,y  : strToHex32_result

    bcs gameTransferAmount2     // Hat genug Geld, sonst exit
    pla                         // Ziel-Spielernummer trotzdem vom Stack holen, auch wenn sie nicht mehr benutzt wird
    mov16 #strTransferNotEnough : TextPtr // Text: "So viel haben sie nicht"
    jsr Print_text

    mov16 #strPressKey : TextPtr // Text: Weiter
    jsr Print_text

    jsr Wait_for_key
    rts
    // Überweisung tätigen
gameTransferAmount2:

    ldy currentPlayerOffset_4

    sub32 playerMoney, y : strToHex32_result : playerMoney, y


/*
    lda #' '
    jsr BSOUT
    mov32 playerMoney,y : hex32dec_value
    jsr Print_hex32_dec_signed
    lda #' '
    jsr BSOUT
    mov32 strToHex32_result: hex32dec_value
    jsr Print_hex32_dec_signed
*/
    pla // Ziel-Spielernummer vom Stack holen
    asl
    asl
    tax // und nach X schieben

    add32 playerMoney, x : strToHex32_result : playerMoney, x

    mov16 #strTransferDone : TextPtr // Text: "Überweisung erfolgt"
    jsr Print_text

    mov16 #strPressKey : TextPtr // Text: Weiter
    jsr Print_text
    jsr Wait_for_key
    rts

!exit:
    rts

gameTransferInput:
    .dword $00000000
