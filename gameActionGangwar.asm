#importonce
/*
Bandenkrieg

Revolverhelden bzw. Wächter: max. 9 pro Seite
würfeln von 1-10
Bei Informanten an der Untergrenze +1

Abfrage von Disastern: Wenn genug Bestechungen: Würfeln für mehr Angreifer bzw. Wächter
dann max 3 Revolverhelden oder 3 Wächter extra, ebenfalls per Zufall


 */




//===============================================================================
// Gangwar - demolish buildings in the process
//
//==============================================================================
gameGangwarMenu:
    jsr CLEAR
    mov #RED : EXTCOL            //  Overscan
    mov #BLACK : BGCOL0              //  Hintergrund
    mov #WHITE : TEXTCOL           //  Schrift

    mov16 #strGangwarTitle : TextPtr // Text: "Überschrift:"
    jsr Print_text

// Prüfe Revolverhelden
gameGangwarCheck:
    ldx currentPlayerNumber
    lda playerGunfighters, x
    bne !skip+
    mov16 #strGangwarMissing : TextPtr
    lda #PET_CR
    jsr BSOUT
    mov16 #strPressKey : TextPtr // Text: Weiter
    jsr Print_text
    jsr Wait_for_key
    rts

// RH vorhanden
!skip:
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
    mov16 #strGangwarCancel : TextPtr
    jsr Print_text

    mov16 #strChoice : TextPtr
    jsr Print_text

//===============================================================================
// gameTransferChoice
//
// Wer bekommt das Geld
//===============================================================================
gameGangwarChoice:
    // Abfrage, welche Position
    // Auswahl holen
    jsr GETIN
    cmp #$30        // sichergehen, dass es eine gültige Ziffer ist <= 0
    bcc gameGangwarChoice
    cmp #$3a        // sichergehen, dass es eine gültige Ziffer ist >= #$3a
    bcs gameGangwarChoice

    cmp #0                          // 0 oder Enter, Abfrage erneut starten
    beq gameGangwarChoice

    sec                             // Konv PetSCII Zeichen zur Zahl
    sbc #$30

    // Auswahl nicht höher als erlaubt
    cmp #0              // Ziffer 0 = Exit
    bne !gameGangwarContinue+
    rts

!gameGangwarContinue:
    sec                            // Spielernummer - 1, so wie sie gespeichert sind
    sbc #$01

    cmp playerCount
    bcc !skip+          // Auswahl < ist okay

    jmp gameGangwarChoice

!skip:
    // Nicht an sich selbst überweisen
    cmp currentPlayerNumber
    bne !gameGangwarContinue+
    mov16 #strGangwarImpossible : TextPtr // Text: "Sie hauen sich eine rein"
    jsr Print_text
    lda #PET_CR
    jsr BSOUT
    mov16 #strPressKey : TextPtr // Text: Weiter
    jsr Print_text
    jsr Wait_for_key
    rts

!gameGangwarContinue:
    rts
