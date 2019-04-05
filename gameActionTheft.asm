#importonce

//===============================================================================
// smallTheft
//
// Kleine Diebstähle Auswahlmenü
//===============================================================================
smallTheft:
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

    jsr Wait_for_key
    jmp continueMain