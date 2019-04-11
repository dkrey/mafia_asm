#importonce

// Gefängnisrunden
.label jailRounds = 00

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
