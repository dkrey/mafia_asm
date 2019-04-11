#importonce

//===============================================================================
// smallTheft
//
// Kleine Diebstähle Auswahlmenü
//===============================================================================


smallTheft:
    clear32 smallTheftJackpot       // Jackpot reset
    jsr CLEAR
    mov #BLACK : EXTCOL             // Schwarzer Overscan
    mov #BLUE : BGCOL0              // Blauer Hintergrund
    mov #YELLOW : TEXTCOL           // Gelbe Schrift

    // Zeile 2, Spalte1
    ldx #02
    ldy #01
    clc
    jsr PLOT

    // Spielernamen anzeigen
    ldy currentPlayerOffset_16      // Offset für Spielernamen 16 Byte

    mov16 #playerNames : TextPtr
    jsr Print_text_offset           // Schreibe den Spielernamen

    lda #','
    jsr BSOUT
    lda #PET_CR                     // Zeilenumbruch
    jsr BSOUT

    mov16 #strYouHaveMoney : TextPtr // Text: "Sie haben"
    jsr Print_text

    ldy currentPlayerOffset_4       // Offset für dword holen: 4 Byte

    // Vermögen mit Offset in Dez anzeigen lassen
    mov32 playerMoney,y : hex2dec_value
    jsr Print_hex32_dec

    // mit Einheit $
    lda #' '
    jsr BSOUT
    lda #'$'
    jsr BSOUT

    // Auswahlmenü für kleine Diebstähle
    // Zweigeteilt, weil mehr als 256 Zeichen
    mov16 #strSmallTheftMenu1 : TextPtr
    jsr Print_text
    mov16 #strSmallTheftMenu2 : TextPtr
    jsr Print_text

//===============================================================================
// smallTheftChoice
//
// Auswahl der Gaunereien
//===============================================================================
smallTheftChoice:
    // Abfrage, welcher Diebstahl
    ldy #1                          // Anzahl Zeichen für die Input Routine: 1

    ldx #<filter_numeric        // Filter setzen LSB: Zahlen 0-9
    lda #>filter_numeric        // Filter setzen MSB: Zahlen 0-9

    jsr Get_filtered_input          // Input holen und speichern
    lda got_input                   // Ergebnis holen
    sec                             // Konv PetSCII Zeichen zur Zahl
    sbc #$30
    cmp #0                          // 0 oder Enter, Abfrage erneut starten
    beq smallTheftChoice

    // Auswahl 1: Bankraub
    cmp #1
    beq smallTheftBank
    // Auswahl 1: Spielautomaten knacken
    cmp #2
    beq smallTheftSlotMachine
    jmp continueMain

// Bankraub
smallTheftBank:
    //#import "gameActionTheftBank.asm"
    jmp continueMain


// Automaten knacken
smallTheftSlotMachine:
    #import "gameActionTheftSlotMachine.asm"
    jmp continueMain

//===============================================================================
// showMisfortune
//
// Unglück für alle
//===============================================================================
showMisfortune:
    getRandomRange8 #0 : #8
    //lda #07             // DEBUG Immer Mutter
    //sta rnd_result      // DEBUG Immer Mutter
    tax
    lda missfortune_table_low, x
    sta TextPtr
    lda missfortune_table_high, x
    sta TextPtr + 1
    jsr Print_text

    // Spezial Mutter Event
    lda rnd8_result
    cmp #07
    bne showMisfortuneReturn

    // Spielernamen auswürfeln und anzeigen
    mov16 #playerNames : TextPtr
showMisfortuneRndPlayer:
    getRandomRange8 #0 : playerCount
    cmp currentPlayerNumber                 // Spielernummer darf nicht gleich sein
    beq showMisfortuneRndPlayer

    .for (var i = 0; i < 4; i++) {  // *2^4 = *16
        asl
    }
    tay

    jsr Print_text_offset   // Die Mutter von Spieler X hat dich verpfiffen

    // Der Rest der Mutter
    lda #<strTheftMisfortune8_2
    sta TextPtr
    lda #>strTheftMisfortune8_2
    sta TextPtr +1
    jsr Print_text
showMisfortuneReturn:
    jsr addDelay
    rts


missfortune_table_low:
    .byte <strTheftMisfortune1, <strTheftMisfortune2, <strTheftMisfortune3, <strTheftMisfortune4
    .byte <strTheftMisfortune5, <strTheftMisfortune6, <strTheftMisfortune7, <strTheftMisfortune8_1

missfortune_table_high:
    .byte >strTheftMisfortune1, >strTheftMisfortune2, >strTheftMisfortune3, >strTheftMisfortune4
    .byte >strTheftMisfortune5, >strTheftMisfortune6, >strTheftMisfortune7, >strTheftMisfortune8_1


smallTheftJackpot:      // So viel Geld liegt in der Bank
    .dword $00000000

smallTheftRndFactor:   // Platzhalter für Zufälligkeit
    .byte 00


// Rahmenwerte für Diebstähle
theftBaseBank:
    .word $c350 // Min 50000

theftRndBank:
    .word $c350 // max 50000 oben drauf

theftBaseSlotMachine:
    .word $0002 // Mindestens 2 $

theftRndSlotMachine:
    .word $02bc // 700 $ drauf