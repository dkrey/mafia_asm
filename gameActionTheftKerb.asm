#importonce

    mov #03 : jailRounds     // 3 Runden Gefängnis

    // Bildschirm leeren und Zeilenumbruch
    jsr CLEAR
    lda #PET_CR
    jsr BSOUT

    // Erfolg oder Misserfolg beim Bekehren
    getRandomRange8 #01 : #100
    cmp #50
    bcs smallTheftKerbSuccess   // Wenn >= 50 Erfolg
    jmp smallTheftKerbFail

// Prostituierte wurde bekehrt:
// Inhalt auswürfeln und schauen, ob sie für einen Spieler arbeitet
smallTheftKerbSuccess:
    lda playerCount
    asl
    sta randomFactor

    // Ausrechnen, ob es eine Prostituierte eines Mitspielers betrifft
    // 255 / (Spieleranzahl * 2)
    divide16 #$00ff : randomFactor
    mov16 divResult : randomFactor

    getRandomRange8 #01 : #100

    lda rnd8_result
    cmp randomFactor                        // Ist es eine Prostituierte eines Mitspielers?
    bcs smallTheftKerbContinue

smallTheftKerbOwner:
    getRandomRange8 #0 : playerCount
    cmp currentPlayerNumber                 // Spielernummer darf nicht gleich sein
    beq smallTheftKerbOwner

    // Hat der Spieler überhaupt Prostituierte?
    tax
    lda playerProstitutes,x             // Pos im Speicher
    cmp #01
    bcc smallTheftKerbContinue           // hat keine Prostituierte

    dec playerProstitutes,x                    // Eine Prostituierte abziehen
    mov16 #strTheftKerbOwner : TextPtr   // Text: Die Prostituierte gehört zu
    jsr Print_text

    mov16 #playerNames : TextPtr

    // 4 mal weiterschieben für 16 bit: Namensoffset
    txa
    asl
    asl
    asl
    asl
    tay

    jsr Print_text_offset   // Text:  <Spielername> CR CR
    lda #PET_CR
    jsr BSOUT
    jsr BSOUT


// Gewinn berechnen und anzeigen 4500+3000
smallTheftKerbContinue:
    getRandomRange16 #$03e8 : #$0bb8    // Beute 1000 - 3000
    mov16 rnd16_result :smallTheftJackpot

    mov16 #strTheftKerbSuccess1 : TextPtr // Text: "Sie waren sehr beeindruckend"
    jsr Print_text
    jsr addDelay

    mov16 #strTheftKerbSuccess2 : TextPtr // Text: "Sie waren sehr beeindruckend"
    jsr Print_text

    print_int32 smallTheftJackpot
    lda #'$'
    jsr BSOUT

    mov16 #strTheftKerbSuccess3 : TextPtr // Text: "dürfen sie behalten"
    jsr Print_text

    ldy currentPlayerOffset_4       // Offset für dword holen: 4 Byte

    // Gewinn zuweisen
    add32 playerMoney,y : smallTheftJackpot : playerMoney,y

    mov16 #strPressKey : TextPtr // Text: Weiter
    jsr Print_text
    jsr Wait_for_key
    jmp !exit+

smallTheftKerbFail:
    jsr showMisfortune

    getRandomRange8 #0 : #100  // Zufall Entkommen

    cmp #50                    // 50 % Entkommenswahrscheinlichkeit
    bcs smallTheftKerbNoJail

    jsr gameJailBusted
    jmp !exit+

smallTheftKerbNoJail:
    mov16 #strTheftKerbFail : TextPtr // Text: "Ohne Beute entkommen"
    jsr Print_text
    mov16 #strPressKey : TextPtr // Text: Weiter
    jsr Print_text
    jsr Wait_for_key

!exit: