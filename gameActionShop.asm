#importonce

gameShopBuyingMask:
    .byte 00

gameShopPriceSlotMachines:
    .dword $00003a98
gameShopPriceProstitutes:
    .dword $00004e20
gameShopPriceBars:
    .dword $00013880
gameShopPriceBetting:
    .dword $00027100
gameShopPriceGambling:
    .dword $000493e0
gameShopPriceBrothels:
    .dword $000f4240
gameShopPriceHotels:
    .dword $00989680

gameShopCheckBudget:
    lda #0
    sta gameShopBuyingMask

    // Gehalt holen und vergleichen
    ldy currentPlayerOffset_4       // Offset für dword holen: 4 Byte

    // Spielautomatenbudget
    compare32 playerMoney,y : gameShopPriceSlotMachines

    bcs !skip+
    jmp !end+
!skip:
    inc gameShopBuyingMask

    // Prostituierte
    compare32 playerMoney,y : gameShopPriceProstitutes
    bcs !skip+
    jmp !end+
!skip:
    inc gameShopBuyingMask

    // Bar
    compare32 playerMoney,y : gameShopPriceBars
    bcs !skip+
    jmp !end+
!skip:
    inc gameShopBuyingMask

    // Wettbüro
    compare32 playerMoney,y : gameShopPriceBetting
    bcs !skip+
    jmp !end+
!skip:
    inc gameShopBuyingMask

    // Spielsalon
    compare32 playerMoney,y : gameShopPriceGambling
    bcs !skip+
    jmp !end+
!skip:
    inc gameShopBuyingMask

    // Bordell
    compare32 playerMoney,y : gameShopPriceBrothels
    bcs !skip+
    jmp !end+
!skip:
    inc gameShopBuyingMask

    // Hotel
    compare32 playerMoney,y : gameShopPriceHotels
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
    Print_hex32_dec gameShopPriceSlotMachines
    lda #' '
    jsr BSOUT
    lda #'$'
    jsr BSOUT
    lda #PET_CR
    jsr BSOUT

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

    // Anzeige Wettbüro
    lda gameShopBuyingMask
    cmp #04
    bcs !continue+
    jmp !end+
!continue:
    mov16 #strShopBetting : TextPtr
    jsr Print_text

    // Anzeige Spielsalon
    lda gameShopBuyingMask
    cmp #05
    bcs !continue+
    jmp !end+
!continue:
    mov16 #strShopGambling : TextPtr
    jsr Print_text

    // Anzeige Bordell
    lda gameShopBuyingMask
    cmp #06
    bcs !continue+
    jmp !end+
!continue:
    mov16 #strShopBrothels : TextPtr
    jsr Print_text

    // Anzeige Grandhotel
    lda gameShopBuyingMask
    cmp #07
    bcs !continue+
    jmp !end+
!continue:
    mov16 #strShopHotels : TextPtr
    jsr Print_text

!end:
    // Text: Nichts
    mov16 #strSelectNothing : TextPtr
    jsr Print_text
    mov16 #strChoice : TextPtr
    jsr Print_text

//===============================================================================
// gameShop
//
// Auswahl dim Shop
//===============================================================================
gameShopChoice:
    // Abfrage, welche Position
    ldy #1                          // Anzahl Zeichen für die Input Routine: 1

    ldx #<filter_numeric        // Filter setzen LSB: Zahlen 0-9
    lda #>filter_numeric        // Filter setzen MSB: Zahlen 0-9

    jsr Get_filtered_input          // Input holen und speichern
    lda got_input                   // Ergebnis holen
    cmp #0                          // 0 oder Enter, Abfrage erneut starten
    beq gameShopChoice

    sec                             // Konv PetSCII Zeichen zur Zahl
    sbc #$30

    // Auswahl nicht höher als erlaubt
    cmp gameShopBuyingMask
    beq !skip+          // Auswahl = höchste Auswahl ist okay
    bcc !skip+          // Auswahl < ist auch okay
    // hier ist's nicht okay, weil größer
    plot_get
    dey                 // Cursor zurücksetzen
    plot_set            // alte Auswahl überschreiben
    lda #' '
    jsr BSOUT
    plot_set            // Cursor zurücksetzen
    jmp gameShopChoice

!skip:
    cmp #0              // Ziffer 0 = Exit
    beq branchShopExit

    // Auswahl 1: Spielautomat
    cmp #1
    beq branchShopSlotMachines

    // Auswahl 2: Prostitution
    cmp #2
    beq branchShopProstitutes

    // Auswahl 3: Bar
    cmp #3
    beq branchShopBars

    // Auswahl 4: Wettbüro
    cmp #4
    beq branchShopBetting

    // Auswahl 5: Spielsalon
    cmp #5
    beq branchShopGambling

    // Auswahl 6: Bordell
    cmp #6
    beq branchShopBrothels

    // Auswahl 6: Hotel
    cmp #7
    beq branchShopHotels

branchShopExit:
    jmp !exit+
branchShopSlotMachines:
    jmp shopSlotMachines
branchShopProstitutes:
    Print_hex8_dec #$02
branchShopBars:
    Print_hex8_dec #$03
branchShopBetting:
    Print_hex8_dec #$04
branchShopGambling:
    Print_hex8_dec #$05
branchShopBrothels:
    Print_hex8_dec #$06
branchShopHotels:
    Print_hex8_dec #$07

// Automaten kaufen
shopSlotMachines:
    // 3 Automaten hinzufügen
    ldx currentPlayerNumber
    lda playerSlotMachines,x
    cmp #$ff // Überrollen verhindern
    bne !skip+
    jmp !exit+
!skip:
    inc playerSlotMachines,x
    inc playerSlotMachines,x
    inc playerSlotMachines,x

    // Geld abzeiehen
    ldy currentPlayerOffset_4

!exit:
    jsr Wait_for_key
    rts
