    mov #6 : smallTheftJail     // 6 Runden Gefängnis

    jsr CLEAR                   // Bildschirm leeren
    lda #PET_CR                 // Zeilenumbruch
    jsr BSOUT
    getRandomRange8 #0 : #100  // Zufall Bankquote
    //:print_int8 rnd8_result      // DEBUG Zufall anzeigen

    lda rnd8_result
    cmp #90
    bcs smallTheftBankSuccess   // Wenn >= 90, überspringe smallTheftBankSuccess
    jmp smallTheftBankFail
smallTheftBankSuccess:
    // Jackpot berechnen
    add16To32 theftBaseBank : smallTheftJackpot : smallTheftJackpot // Grundwert
    getRandomRange16 #0 : theftRndBank                              // Plus Bonus
    add16To32 rnd16_result : smallTheftJackpot : smallTheftJackpot

    mov16 #strTheftBankSuccess : TextPtr // Text: "Sie erbeuteten"
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

smallTheftBankFail:
    jsr showMisfortune
    getRandomRange8 #0 : #100  // Zufall Entkommen

    cmp #70                    // 30 % Entkommenswahrscheinlichkeit
    bcc smallTheftBankNoJail

    // Ab in den Knast
    mov16 #strTheftJail1 : TextPtr  // Text: Sie erhielten
    jsr Print_text

    print_int8 smallTheftJail   // Gefängnisrunden

    mov16 #strTheftJail2 : TextPtr  // Text : Runden Knast
    jsr Print_text

    // Gefängnisrunden setzen
    ldy currentPlayerNumber
    mov smallTheftJail : playerJailTotal,y
    mov16 #strPressKey : TextPtr // Text: Weiter
    jsr Print_text
    jsr Wait_for_key
    jmp !exit+

smallTheftBankNoJail:
    mov16 #strTheftEscape : TextPtr // Text: "Entkommen"
    jsr Print_text
    mov16 #strPressKey : TextPtr    // Text: Weiter
    jsr Print_text
    jsr Wait_for_key
!exit: