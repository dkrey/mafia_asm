#importonce
    mov #01 : jailRounds     // 1 Runde Gefängnis

    // Bildschirm leeren und Zeilenumbruch
    jsr CLEAR
    lda #PET_CR
    jsr BSOUT

    // Erfolg oder Misserfolg beim Überfall
    getRandomRange8 #01 : #100
    cmp #20
    bcs smallTheftJobSuccess   // Wenn >= 20 Erfolg
    jmp smallTheftJobFail

smallTheftJobSuccess:
    ldy #00
    // Nach dem Arbeitgeber wird entsprechend der Spieleranzahl gesucht
!loop:
    getRandomRange8 #0 : playerCount
    cmp currentPlayerNumber             // Spielernummer darf nicht gleich sein
    beq !loop-
    sta ZeroPageTemp                    // Spielernummer für den Fall der Fälle weglegen

    // Einkommen unter 5000$ werden geschont
    asl
    asl
    tax

    lda playerMoney,x                   // Pos im Speicher
    compare32 playerMoney,x : #$00001388 // Bei weniger als 5000 $ Einkommen kein Job
    bcs smallTheftJob2

    iny
    cpy playerCount
    bne !loop-
    jmp smallTheftJobContinue    // hat kein Geld

    // Die eigene Spielernummer als Mitarbeiter beim Mitspieler setzen
smallTheftJob2:
    ldx ZeroPageTemp
    lda currentPlayerNumber
    sta playerEmployee, x
    inc playerEmployee, x   // +1 damit auch Spieler 0 eine Chance hat

//
smallTheftJobContinue:
    mov16 #strTheftJobWait : TextPtr // Text: "Sie legen sich auf die Lauer"
    jsr Print_text

    lda #PET_CR
    jsr BSOUT
    jsr BSOUT
    mov16 #strPressKey : TextPtr // Text: Weiter
    jsr Print_text
    jsr Wait_for_key
    jmp !exit+

smallTheftJobFail:
    jsr showMisfortune

    getRandomRange8 #0 : #100  // Zufall Entkommen

    cmp #70                    // 30 % Entkommenswahrscheinlichkeit
    bcs smallTheftJobNoJail

    jsr gameJailBusted
    jmp !exit+

smallTheftJobNoJail:
    jsr gameJailEvade

!exit: