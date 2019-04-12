#importonce

    mov #04 : jailRounds     // 1 Runde Gefängnis

    // Bildschirm leeren und Zeilenumbruch
    jsr CLEAR
    lda #PET_CR
    jsr BSOUT

    // Erfolg oder Misserfolg beim Ausrauben einer Bar
    getRandomRange8 #01 : #100
    cmp #60
    bcs smallTheftBarSuccess   // Wenn >= 60 Erfolg
    jmp smallTheftBarFail

// Bar wurde ausgeraubt:
// Inhalt auswürfeln und schauen, ob er einem Spieler gehört
smallTheftBarSuccess:
    lda playerCount
    asl
    asl
    sta randomFactor

    // Ausrechnen, ob es eine Bar eines Mitspielers betrifft
    // 300 / (Spieleranzahl * 4), entspricht der Originalformel, ausgenommen Anzahl der eigenen Bars
    divide16 #300 : randomFactor
    mov16 divResult : randomFactor

    getRandomRange8 #01 : #100

    lda rnd8_result
    cmp randomFactor                        // Ist es eine Bar eines Mitspielers?
    bcs smallTheftBarContinue

smallTheftBarOwner:
    getRandomRange8 #0 : playerCount
    cmp currentPlayerNumber                 // Spielernummer darf nicht gleich sein
    beq smallTheftBarOwner

    // Hat der Spieler überhaupt Automaten?
    asl                 // Offset für .word 16bit
    tax

    lda playerBars,x            // Automatenposition im Speicher
    cmp #01
    bcc smallTheftBarContinue           // hat keine Bar
    dec playerBars,x                    // Eine Bar abziehen
    mov16 #strTheftBarOwner : TextPtr   // Text: Die Bar gehört
    jsr Print_text

    mov16 #playerNames : TextPtr

    // noch 3 mal weiterschieben für 16 bit: Namensoffset
    txa
    asl
    asl
    asl
    tay

    jsr Print_text_offset   // Text:  <Spielername> CR CR
    lda #PET_CR
    jsr BSOUT
    jsr BSOUT


// Gewinn berechnen und anzeigen 4500+3000
smallTheftBarContinue:
    getRandomRange16 #$0bb8 : #$1d4c    // Beute 3000 - 7500
    mov16 rnd16_result :smallTheftJackpot

    mov16 #strTheftBarSuccess : TextPtr // Text: "Sie erbeuteten"
    jsr Print_text
    print_int32 smallTheftJackpot

    lda #'$'
    jsr BSOUT
    lda #PET_CR
    jsr BSOUT

    ldy currentPlayerOffset_4       // Offset für dword holen: 4 Byte

    // Gewinn zuweisen
    add32 playerMoney,y : smallTheftJackpot : playerMoney,y

    mov16 #strPressKey : TextPtr // Text: Weiter
    jsr Print_text
    jsr Wait_for_key
    jmp !exit+

smallTheftBarFail:
    jsr showMisfortune

    getRandomRange8 #0 : #100  // Zufall Entkommen

    cmp #60                    // 40 % Entkommenswahrscheinlichkeit
    bcs smallTheftBarNoJail

    jsr gameJailBusted
    jmp !exit+

smallTheftBarNoJail:
    mov16 #strTheftBarFail : TextPtr // Text: "Ohne Beute entkommen"
    jsr Print_text
    mov16 #strPressKey : TextPtr // Text: Weiter
    jsr Print_text
    jsr Wait_for_key

!exit: