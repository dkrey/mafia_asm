#importonce
    mov #01 : jailRounds     // 1 Runde Gefängnis

    // Bildschirm leeren und Zeilenumbruch
    jsr CLEAR
    lda #PET_CR
    jsr BSOUT

    // Prüfen, ob man nicht zu reich ist
    // 65integer € Einkommen
    ldx currentPlayerOffset_4

    compare32 playerIncome,x : #$0000ffff    // Obergrenze
    bcc smallTheftJobIsPoor

    // Zu wohlhabend
    mov16 #strTheftTooRich : TextPtr // Text: "Sie legen sich auf die Lauer"
    jsr Print_text

    lda #PET_CR
    jsr BSOUT
    jsr BSOUT
    mov16 #strPressKey : TextPtr // Text: Weiter
    jsr Print_text
    jsr Wait_for_key
    jmp !exit+

smallTheftJobIsPoor:
    // Erfolg oder Misserfolg beim Überfall
    getRandomRange8 #01 : #100
    cmp #20
    bcs smallTheftJobSuccess   // Wenn >= 20 Erfolg
    jmp smallTheftJobFail

smallTheftJobSuccess:
    // Liste aller Mitspieler in zufälliger Reihenfolge erstellen:
    randomPerm8 playerCount
    ldy #00
    // Nach dem Arbeitgeber wird entsprechend der Spieleranzahl gesucht
!loop:
    lda rndPerm8_result, y
    cmp currentPlayerNumber             // Spielernummer darf nicht gleich sein
    bne !skip+
    iny
    jmp !loop-
!skip:
    sta ZeroPageTemp                    // Spielernummer für den Fall der Fälle weglegen
    tax
    lda playerJailTotal,x               // kein Job bei Knast
    cmp #00
    beq !skip+
    iny
    cpy playerCount
    bcc !loop-
    jmp smallTheftJobNotFound

!skip:
    lda ZeroPageTemp
    // Einkommen unter 5000$ werden geschont
    asl
    asl
    tax

    compare32 playerIncome,x : #$00001388 // Bei weniger als 5000 $ Einkommen kein Job
    bcs smallTheftJob2

    iny
    cpy playerCount
    bcs smallTheftJobNotFound
    jmp !loop-

    // Die eigene Spielernummer als Mitarbeiter beim Mitspieler setzen
smallTheftJob2:
    ldx ZeroPageTemp
    lda currentPlayerNumber
    sta playerEmployee, x
    inc playerEmployee, x   // +1 damit auch Spieler 0 eine Chance hat

    mov16 #strTheftJobWait : TextPtr // Text: "Sie legen sich auf die Lauer"
    jsr Print_text

    lda #PET_CR
    jsr BSOUT
    jsr BSOUT
    mov16 #strPressKey : TextPtr // Text: Weiter
    jsr Print_text
    jsr Wait_for_key
    jmp !exit+

smallTheftJobNotFound:
    mov16 #strTheftNotFound : TextPtr // Text: "Niemand wollte sie einstellen"
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
