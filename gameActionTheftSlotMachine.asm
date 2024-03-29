#importonce

    mov #01 : jailRounds     // 1 Runde Gefängnis

    // Bildschirm leeren und Zeilenumbruch
    jsr CLEAR
    lda #PET_CR
    jsr BSOUT

    // Erfolg oder Misserfolg beim Automatenknacken
    getRandomRange8 #01 : #100
    cmp #10
    bcs smallTheftSlotMachineSuccess   // Wenn >= 10 Erfolg
    jmp smallTheftSlotMachineFail

// Automat wurde geknackt:
// Inhalt auswürfeln und schauen, ob er einem Spieler gehört
// Aktuell muss Zufall 0-80  kleiner als 160/Spieleranzahl sein, damit es einen Mitspieler trifft
smallTheftSlotMachineSuccess:
    lda playerCount
    // asl // erstmal doch nicht
    sta randomFactor

    // Ausrechnen, ob es einen Automaten eines Mitspielers betrifft
    // 160 / Spieleranzahl * 2, entspricht der Originalformel
    divide8 #160 : randomFactor

    mov divResult : randomFactor

    getRandomRange8 #01 : #80

    cmp randomFactor                        // Ist es ein Automat eines Mitspielers?

    bcs smallTheftSlotMachineContinue


smallTheftSlotMachineOwner:
    dec playerCount
    getRandomRange8 #0 : playerCount
    inc playerCount
    cmp currentPlayerNumber                 // Spielernummer darf nicht gleich sein
    beq smallTheftSlotMachineOwner

    // Hat der Spieler überhaupt Automaten?
    tax

    lda playerSlotMachines,x            // Automatenposition im Speicher
    cmp #01
    bcc smallTheftSlotMachineContinue   // hat keine Automaten
    dec playerSlotMachines,x            // Einen Automaten abziehen
    mov16 #strTheftSlotMachineOwner : TextPtr // Text: Der Automat gehört
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


// Gewinn berechnen und anzeigen
smallTheftSlotMachineContinue:
    getRandomRange16 #02 : #$02bc    // Gewinn berechnen 2- 700 $
    mov16 rnd16_result :smallTheftJackpot

    mov16 #strTheftSlotMachineSuccess : TextPtr // Text: "Sie erbeuteten"
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

smallTheftSlotMachineFail:
    jsr showMisfortune

    getRandomRange8 #0 : #100  // Zufall Entkommen

    cmp #10                    // 90 % Entkommenswahrscheinlichkeit
    bcs smallTheftSlotMachineNoJail

    jsr gameJailBusted
    jmp !exit+

smallTheftSlotMachineNoJail:
    jsr gameJailEvade

!exit: