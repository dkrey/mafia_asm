#importonce

// Gefängnisrunden
.label jailRounds = 00


//===============================================================================
// gameJailStay
//
// Spieler sitzt im Knast
//===============================================================================
gameJailStay:
    jsr CLEAR
    mov #BLACK  : EXTCOL            // Schwarzer Overscan
    mov #BLACK  : BGCOL0            // Schwarzer Hintergrund
    mov #YELLOW : TEXTCOL           // Gelbe Schrift

    // Eine Gefängnisrunde abziehen
    ldx currentPlayerNumber
    dec playerJailTotal,x

    set_cursor_position #8 : #2

    // Spielernamen anzeigen
    ldy currentPlayerOffset_16      // Offset für Spielernamen 16 Byte

    mov16 #playerNames : TextPtr
    jsr Print_text_offset           // Schreibe den Spielernamen

    lda #','
    jsr BSOUT
    lda #PET_CR                     // Zeilenumbruch
    jsr BSOUT
    jsr BSOUT

    // Ausbruch?
    getRandomRange8 #0 : #100   // Zufall
    cmp #90                     // Sollte die Zahl unter 90 sein
    bcc gameJailNoEscape        // Ausbruch erfolglos

    ldx currentPlayerNumber     // Nochmal Spielernummer
    lda #00
    sta playerJailTotal,x       // Gefängnisrunden tilgen

    mov16 #strJailEscape : TextPtr  // Text: Ausbruch gelungen
    jsr Print_text
    mov16 #strPressKey : TextPtr    // Text: Weiter
    jsr Print_text
    jsr Wait_for_key

    // Darf in der selben Runde weitermachen
    ldx currentPlayerNumber
    jmp mainNextPlayerLoop

gameJailNoEscape:
    // Nuttenflucht
    ldx currentPlayerNumber
    lda playerProstitutes,x
    cmp #0                      // Sind Prostituierte beschäftigt?

    beq gameJailNoProtitutes
    // Anzahl Prostituierten * 4 + 30
    // Faktor auf 100 ($64) begrenzt, damit zumindest geringe Chance besteht
    clc
    asl
    cmp #$64
    bcs gameJailProstitutesMax
    asl
    cmp #$64
    bcs gameJailProstitutesMax
    sta randomFactor
    clc
    adc #$1e
    sta randomFactor
    cmp #$64
    bcs gameJailProstitutesMax
    jmp !continue+
gameJailProstitutesMax:
    lda #$64
    sta randomFactor

!continue:
    getRandomRange8 #0 : #110   // neuer Zufall

    lda rnd8_result
    cmp randomFactor
    bcs gameJailNoProtitutes    // Wenn Zufall größer Randomfactor

    // Neuer Zuhälter
    // eine Dame abziehen
    ldx currentPlayerNumber
    dec playerProstitutes, x
    mov16 #strJailProstitute : TextPtr
    jsr Print_text

gameJailNoProtitutes:

    // Anwalt könnte Spieler rausholen
    ldx currentPlayerNumber
    lda playerAttorneys,x
    cmp #0
    bne gameJailAttorney  // Sind Anwälte beschäftigt?
    jmp gameJailNoAttorney

    // 90 / sqrt(1+Anwälte)
    gameJailAttorney:
    adc #01 // Ein Extra-Anwalt als Basis
    sta randomFactor
    sqrt16 randomFactor
    sty randomFactor
    divide8 #90 : randomFactor

    lda divResult
    sta randomFactor
    getRandomRange8 #0 : #100   // neuer Zufall

    lda rnd8_result
    cmp randomFactor
    bcc gameJailNoAttorney

    ldx currentPlayerNumber     // Nochmal Spielernummer
    lda #00
    sta playerJailTotal,x       // Gefängnisrunden tilgen

    mov16 #strJailAttorney : TextPtr    // Text: Ausbruch gelungen
    jsr Print_text
    mov16 #strPressKey : TextPtr        // Text: Weiter
    jsr Print_text
    jsr Wait_for_key

    // Darf in der selben Runde weitermachen
    ldx currentPlayerNumber
    jmp mainNextPlayerLoop

gameJailNoAttorney:
    ldx currentPlayerNumber     // Sind noch Knastrunden übrig?
    lda playerJailTotal,x
    cmp #00
    bne gameJailNoEscape2       // Zeige die Knastrunden an
    mov16 #strJailAlmostFree : TextPtr
    jsr Print_text
    jmp !exit+

gameJailNoEscape2:
    mov16 #strJailWait1 : TextPtr  // Text: Sie sitzen ein
    jsr Print_text

    lda #' '                    // Leerschritt vor der Rundenzahl
    jsr BSOUT

    ldx currentPlayerNumber     //Knastrunden anzeigen
    print_int8 playerJailTotal,x

    lda currentPlayerNumber     // Runde oder Runden
    cmp #1
    bne gameJailPlural
    mov16 #strRound : TextPtr
    jsr Print_text
    jmp gameJailNoEscape3
gameJailPlural:
    mov16 #strRounds : TextPtr
    jsr Print_text

gameJailNoEscape3:
    mov16 #strJailWait2 : TextPtr
    jsr Print_text

!exit:
    mov16 #strPressKey : TextPtr // Text: Weiter
    jsr Print_text
    jsr Wait_for_key
    jmp mainContinue


//===============================================================================
// gameJailEvade
//
// Dem Geföngnis noch einmal entronnen
//===============================================================================
gameJailEvade:
    mov16 #strTheftEscape : TextPtr // Text: "Entkommen"
    jsr Print_text
    mov16 #strPressKey : TextPtr // Text: Weiter
    jsr Print_text
    jsr Wait_for_key
    rts

//===============================================================================
// gameJailBusted
//
// Ab in den Knast, Gefängnisrunden werden dem Spieler angelastet
//===============================================================================
gameJailBusted:
    // Ab in den Knast
    mov16 #strTheftJail1 : TextPtr  // Text: Sie erhielten
    jsr Print_text

    print_int8 jailRounds       // Gefängnisrunden
    lda jailRounds

    cmp #01
    bne !showPlural+
    mov16 #strRound : TextPtr   // Text: RundE
    jsr Print_text
    jmp !strJail+
!showPlural:
    mov16 #strRounds : TextPtr  // Text: RundeN
    jsr Print_text
!strJail:
    mov16 #strTheftJail2 : TextPtr  // Text : Knast
    jsr Print_text

    // Gefängnisrunden setzen
    ldy currentPlayerNumber
    mov jailRounds : playerJailTotal,y

    mov16 #strPressKey : TextPtr // Text: Weiter
    jsr Print_text
    jsr Wait_for_key
    rts
