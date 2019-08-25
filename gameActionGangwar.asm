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
gameGangwarHeader:
    jsr CLEAR
    mov #BLACK : EXTCOL            //  Overscan
    mov #BROWN : BGCOL0              //  Hintergrund
    mov #BLACK : TEXTCOL           //  Schrift

    mov16 #strGangwarTitle1 : TextPtr // Text: "Überschrift:"
    jsr Print_text
    rts

gameGangwarMenu:
    jsr gameGangwarHeader

// Prüfe Revolverhelden
gameGangwarCheck:
    ldx currentPlayerNumber
    lda playerGunfighters, x
    sta gameGangwarAttackers    // schon mal Angreifer speichern
    bne !skip+
    mov16 #strGangwarMissing : TextPtr
    jsr Print_text
    lda #PET_CR
    jsr BSOUT
    mov16 #strPressKey : TextPtr // Text: Weiter
    jsr Print_text
    jsr Wait_for_key
    rts

// RH vorhanden
!skip:
    mov16 #strGangwarTitle2 : TextPtr // Text: "Überschrift2"
    jsr Print_text
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
    sta gameGangwarVictim
    pha
    jsr gameGangwarHeader
    mov16 #strGangwarSummary1 : TextPtr // Text: "Sie wollen bei"
    jsr Print_text
    mov16 #playerNames : TextPtr
    pla
    asl
    asl
    asl
    asl
    tay
    jsr Print_text_offset   // Text:  <Spielername> CR CR
    mov16 #strGangwarSummary2 : TextPtr // Text: "Aufräumen"
    jsr Print_text


// Der Angreifer hat
!gameGangwarAttackerSummary:
    mov16 #strYouHave : TextPtr
    jsr Print_text
    lda gameGangwarAttackers
    pha
    Print_hex8_dec gameGangwarAttackers
    lda #PET_CR
    jsr BSOUT
    mov16 #strFinancesGunfighters : TextPtr
    jsr Print_text

    pla
    cmp #$0A                    // max 9 Angreifer
    bcc !skip+                  // also bcc < 10
    lda #$09
    sta gameGangwarAttackers
    lda #PET_CR
    jsr BSOUT
    mov16 #strGangwarAttackersAmount : TextPtr
    jsr Print_text
!skip:
    // Angriffbonus durch Bestechungen
    mov16 #$0000 : disasterTotalFactor
    mov currentPlayerNumber : disasterPlayer
    jsr gameCalcTotalFactor
    lda #PET_CR
    jsr BSOUT
    Print_hex16_dec disasterTotalFactor

    compare16 disasterTotalFactor : #$00C9   // über 200 Bestechungspunkte +3
    bcc !skip+
    clc
    lda gameGangwarAttackers
    adc #03
    sta gameGangwarAttackers
    jmp gameGangwarDefenderSummary
!skip:
    compare16 disasterTotalFactor : #$0064   // über 100 Bestechungspunkte +2
    bcc !skip+
    clc
    lda gameGangwarAttackers
    adc #02
    sta gameGangwarAttackers
    jmp gameGangwarDefenderSummary
!skip:
    compare16 disasterTotalFactor
     : #$0032  // über 50 Bestechungspunkte +1
    bcc gameGangwarDefenderSummary
    clc
    lda gameGangwarAttackers
    adc #01
    sta gameGangwarAttackers
    jmp gameGangwarDefenderSummary

gameGangwarDefenderSummary:
    Print_hex8_dec gameGangwarAttackers
    mov16 #strPressKey : TextPtr // Text: Weiter
    jsr Print_text
    jsr Wait_for_key

    rts

// Spielernummer des angegriffenen
gameGangwarVictim:
    .byte 0
// Anzahl Angreifer
gameGangwarAttackers:
    .byte 0

// Anzahl Verteidiger
gameGangwarDefenders:
    .byte 0
