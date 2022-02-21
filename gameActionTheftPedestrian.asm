#importonce
    mov #02 : jailRounds     // 2 Runden Gefängnis

    // Bildschirm leeren und Zeilenumbruch
    jsr CLEAR
    lda #PET_CR
    jsr BSOUT

    // Erfolg oder Misserfolg beim Überfall
    getRandomRange8 #01 : #100
    cmp #$0a
    bcs smallTheftPedestrianSuccess   // Wenn >= 10 Erfolg
    jmp smallTheftPedestrianFail

// Überfall gelingt
smallTheftPedestrianSuccess:
    lda playerCount
    asl
    sta randomFactor

    // Ausrechnen, ob es einen Mitspieler betrifft
    // 300 / (Spieleranzahl * 2)
    divide16 #$012c : randomFactor
    mov16 divResult : randomFactor

    getRandomRange8 #01 : #100

    lda rnd8_result
    cmp randomFactor                        // Trifft es einen Mitspieler

    bcs smallTheftPedestrianPlayer
    jmp smallTheftPedestrianContinue

smallTheftPedestrianPlayer:
    dec playerCount
    getRandomRange8 #0 : playerCount
    inc playerCount
    cmp currentPlayerNumber                 // Spielernummer darf nicht gleich sein
    beq smallTheftPedestrianPlayer

    // Check
    tax                     // Akku nach X
    sta ZeroPageTemp        // noch mal temp sichern

    // Sitzt der Spieler im Knast?
    lda playerJailTotal, x
    cmp #0
    beq !skip+
    jmp smallTheftPedestrianContinue // Spieler im Knast, doch normaler Passant
!skip:

    // Hat der Spieler Leibwächter?
    lda playerBodyguards,x
    cmp #0
    bne smallTheftPedestrianBodyguard  // Sind Leibwächter beschäftigt?
    jmp smallTheftPedestrianNoBodyguard

smallTheftPedestrianBodyguard:
    adc #01 // Ein Extra-Leibwächter als Basis
    sta randomFactor
    sqrt16 randomFactor
    sty randomFactor
    divide8 #90 : randomFactor
    lda divResult
    sta randomFactor
    getRandomRange8 #0 : #100   // neuer Zufall

    lda rnd8_result
    cmp randomFactor
    bcc smallTheftPedestrianNoBodyguard // Bodyguard hat nichts genützt

smallTheftPedestrianBodyguardSuccess:
    mov16 #strTheftPedestrianPlayer1 : TextPtr   // Text: Der Passant war
    jsr Print_text
    mov16 #playerNames : TextPtr
    // Spielernummer von temp und 4 mal weiterschieben für 16 bit: Namensoffset
    lda ZeroPageTemp
    asl
    asl
    asl
    asl
    tay
    jsr Print_text_offset   // Text:  <Spielername> CR CR
    lda #'.'
    jsr BSOUT
    lda #PET_CR
    jsr BSOUT

    mov16 #strTheftPedestrianBodyguard : TextPtr
    jsr Print_text
    lda #PET_CR
    jsr BSOUT
    mov16 #strPressKey : TextPtr // Text: Weiter
    jsr Print_text
    jsr Wait_for_key
    jmp !exit+

smallTheftPedestrianNoBodyguard:
    lda ZeroPageTemp    // Spielernummer wieder von temp holen
    // Hat der Spieler überhaupt Geld?
    asl
    asl                 // weiterer Shift auf .dword 32bit
    tax

    lda playerMoney + 3, x
    and #$80
    bpl !nodept+  // Keine Schulden
    jmp smallTheftPedestrianContinue  // doch nix

    !nodept:
    lda playerMoney,x                   // Pos im Speicher
    // Erst auf Schulden prüfen

    compare32 playerMoney,x : #$00000064 // Bei weniger als 100 $ kein Diebstahl

    bcs smallTheftPedestrianPlayer2
    jmp smallTheftPedestrianContinue    // hat kein Geld

smallTheftPedestrianPlayer2:
    // Betrag zum Abzug festellen:
    getRandomRange32 #$00000001 : playerMoney,x

    mov32 rnd32_result :smallTheftJackpot

    // Betrag vom Opfer abziehen
    sub32 playerMoney, x : smallTheftJackpot : playerMoney, x

    mov16 #strTheftPedestrianPlayer1 : TextPtr   // Text: Der Passant war
    jsr Print_text
    mov16 #playerNames : TextPtr
    // noch 2 mal weiterschieben für 16 bit: Namensoffset
    txa
    asl
    asl
    tay
    jsr Print_text_offset   // Text:  <Spielername> CR CR

    mov16 #strTheftPedestrianPlayer2 : TextPtr   // Text: und hatte
    jsr Print_text

    print_int32 smallTheftJackpot               // Text : Geld
    lda #'$'
    jsr BSOUT

    mov16 #strTheftPedestrianPlayer3 : TextPtr   // Text: bei sich
    jsr Print_text

    // Gewinn zuweisen
    ldy currentPlayerOffset_4
    add32 playerMoney,y : smallTheftJackpot : playerMoney,y

    lda #PET_CR
    jsr BSOUT
    mov16 #strPressKey : TextPtr // Text: Weiter
    jsr Print_text
    jsr Wait_for_key
    jmp !exit+

// Normaler Passant: Gewinn berechnen und anzeigen
smallTheftPedestrianContinue:
    getRandomRange16 #$0078 : #$0398    // Beute 120 - 920
    mov16 rnd16_result :smallTheftJackpot

    mov16 #strTheftPedestrianSuccess1 : TextPtr // Text: "Der Passaant hatte"
    jsr Print_text

    print_int32 smallTheftJackpot               // Text : Geld
    lda #'$'
    jsr BSOUT

    mov16 #strTheftPedestrianSuccess2 : TextPtr // Text: "bei sich"
    jsr Print_text

    ldy currentPlayerOffset_4       // Offset für dword holen: 4 Byte

    // Gewinn zuweisen
    add32 playerMoney,y : smallTheftJackpot : playerMoney,y

    lda #PET_CR
    jsr BSOUT
    jsr BSOUT
    mov16 #strPressKey : TextPtr // Text: Weiter
    jsr Print_text
    jsr Wait_for_key
    jmp !exit+

smallTheftPedestrianFail:
    jsr showMisfortune

    getRandomRange8 #0 : #100  // Zufall Entkommen

    cmp #80                    // 20 % Entkommenswahrscheinlichkeit
    bcs smallTheftPedestrianNoJail

    jsr gameJailBusted
    jmp !exit+

smallTheftPedestrianNoJail:
    jsr gameJailEvade

!exit:
