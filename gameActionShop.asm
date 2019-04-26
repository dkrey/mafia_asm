#importonce

gameShopBuyingMask:
    .byte 00

gameShopCheckBudget:
    lda #0
    sta gameShopBuyingMask

    // Gehalt holen und vergleichen
    ldy currentPlayerOffset_4       // Offset für dword holen: 4 Byte

    // Spielautomatenbudget
    compare32 playerMoney,y : #$00003a99

    bcs !skip+
    jmp !end+
!skip:
    inc gameShopBuyingMask

    // Prostituierte
    compare32 playerMoney,y : #$00004e20
    bcs !skip+
    jmp !end+
!skip:
    inc gameShopBuyingMask

    // Bar
    compare32 playerMoney,y : #$00013880
    bcs !skip+
    jmp !end+
!skip:
    inc gameShopBuyingMask

    // Wettbüro
    compare32 playerMoney,y : #$00027100
    bcs !skip+
    jmp !end+
!skip:
    inc gameShopBuyingMask

    // Spielsalon
    compare32 playerMoney,y : #$000493e0
    bcs !skip+
    jmp !end+
!skip:
    inc gameShopBuyingMask

    // Bordell
    compare32 playerMoney,y : #$000f4240
    bcs !skip+
    jmp !end+
!skip:
    inc gameShopBuyingMask

    // Hotel
    compare32 playerMoney,y : #$00989680
    bcs !skip+
    jmp !end+
!skip:
    inc gameShopBuyingMask
!end:
    rts


//===============================================================================
// shopping
//
//==============================================================================
gameShopMenu:
    jsr CLEAR
    mov #BLACK : EXTCOL             // Schwarzer Overscan
    mov #PURPLE : BGCOL0              // Blauer Hintergrund
    mov #BLACK : TEXTCOL           // Gelbe Schrift

    jsr gameShopCheckBudget        // Budget prüfen

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
    mov32 playerMoney,y : hex32dec_value
    jsr Print_hex32_dec_signed

    // mit Einheit $
    lda #' '
    jsr BSOUT
    lda #'$'
    jsr BSOUT

    // Text: Die Preise sind:
    mov16 #strShopTitle : TextPtr
    jsr Print_text

    // Anzeige Automaten
    lda gameShopBuyingMask
    cmp #01
    bcs !continue+
    jmp !end+
!continue:
    mov16 #strShopSlotMachines : TextPtr
    jsr Print_text

    // Anzeige Prostituierte
    lda gameShopBuyingMask
    cmp #02
    bcs !continue+
    jmp !end+
!continue:
    mov16 #strShopProstitutes : TextPtr
    jsr Print_text

    // Anzeige Bars
    lda gameShopBuyingMask
    cmp #03
    bcs !continue+
    jmp !end+
!continue:
    mov16 #strShopBars : TextPtr
    jsr Print_text
!end:
    // Text: Nichts
    mov16 #strShopExit : TextPtr
    jsr Print_text
    mov16 #strChoice : TextPtr
    jsr Print_text

    print_int8 gameShopBuyingMask
    jsr Wait_for_key
    rts