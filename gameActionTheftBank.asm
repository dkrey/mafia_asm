    mov #6 : jailRounds         // 6 Runden Gefängnis

    jsr CLEAR                   // Bildschirm leeren
    lda #PET_CR                 // Zeilenumbruch
    jsr BSOUT
    getRandomRange8 #0 : #100   // Zufall Bankquote
    //:print_int8 rnd8_result   // DEBUG Zufall anzeigen

    lda rnd8_result
    cmp #90
    bcs smallTheftBankSuccess   // Wenn >= 90, überspringe smallTheftBankSuccess
    jmp smallTheftBankFail

smallTheftBankSuccess:
    // Jackpot berechnen
    add16To32 #$c350 : smallTheftJackpot : smallTheftJackpot  // Grundwert 50.000
    getRandomRange16 #0 : #$c350                              // Plus Bonus 50.000
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

    jsr gameJailBusted          // doch nicht entkommen
    jmp !exit+

smallTheftBankNoJail:
    jsr gameJailEvade

!exit: