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
    // Schulden?
    ldx currentPlayerNumber
    lda playerDebtFlag, x
    cmp #00
    beq !skip+  // keine Schulden, also weiter
    jmp !end+   // doch Schulden, also Ende
!skip:
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
    mov #01 : gameShopPositionChoice
    mov16 #strShopSlotMachines : TextPtr
    mov32 gameShopPriceSlotMachines : gameShopPositionPrice
    jsr gameShopPrintOption

    // Anzeige Prostituierte
    mov #02 : gameShopPositionChoice
    mov16 #strShopProstitutes : TextPtr
    mov32 gameShopPriceProstitutes : gameShopPositionPrice
    jsr gameShopPrintOption

    // Anzeige Bars
    mov #03 : gameShopPositionChoice
    mov16 #strShopBars : TextPtr
    mov32 gameShopPriceBars : gameShopPositionPrice
    jsr gameShopPrintOption

    // Anzeige Wettbüro
    mov #04 : gameShopPositionChoice
    mov16 #strShopBetting : TextPtr
    mov32 gameShopPriceBetting : gameShopPositionPrice
    jsr gameShopPrintOption

    // Anzeige Spielsalon
    mov #05 : gameShopPositionChoice
    mov16 #strShopGambling : TextPtr
    mov32 gameShopPriceGambling : gameShopPositionPrice
    jsr gameShopPrintOption

    // Anzeige Bordell
    mov #06 : gameShopPositionChoice
    mov16 #strShopBrothels : TextPtr
    mov32 gameShopPriceBrothels : gameShopPositionPrice
    jsr gameShopPrintOption

    // Anzeige Bordell
    mov #07 : gameShopPositionChoice
    mov16 #strShopHotels : TextPtr
    mov32 gameShopPriceHotels : gameShopPositionPrice
    jsr gameShopPrintOption

!end:
    // Text: Nichts
    mov16 #strSelectNothing : TextPtr
    jsr Print_text
    mov16 #strChoice : TextPtr
    jsr Print_text

//===============================================================================
// gameShop
//
// Auswahl im Shop
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
    rts
branchShopSlotMachines:
    jmp shopBuySlotMachines
branchShopProstitutes:
    jmp shopBuyProstitutes
branchShopBars:
    jmp shopBuyBars
branchShopBetting:
    jmp shopBuyBetting
branchShopGambling:
    jmp shopBuyGambling
branchShopBrothels:
    jmp shopBuyBrothels
branchShopHotels:
    jmp shopBuyHotels

// Automaten kaufen
shopSlotMachines:
    // 3 Automaten hinzufügen
    ldx currentPlayerNumber
    lda playerSlotMachines,x
    cmp #$fd // Überrollen verhindern
    bne !skip+
    jmp !exit+
!skip:
    inc playerSlotMachines,x
    inc playerSlotMachines,x
    inc playerSlotMachines,x

    // Geld abzeiehen
    ldy currentPlayerOffset_4
    sub32 playerMoney,y : gameShopPriceSlotMachines : playerMoney,y
!exit:
    jmp gameShopMenu

// Automaten kaufen
shopBuySlotMachines:
    // 3 Automaten hinzufügen
    ldx currentPlayerNumber
    lda playerSlotMachines,x
    cmp #$fd // Überrollen verhindern
    bne !skip+
    jmp !exit+
!skip:
    inc playerSlotMachines,x
    inc playerSlotMachines,x
    inc playerSlotMachines,x

    // Geld abzeiehen
    ldy currentPlayerOffset_4
    sub32 playerMoney,y : gameShopPriceSlotMachines : playerMoney,y
!exit:
    jmp gameShopMenu

// Prostituierte anstellen
shopBuyProstitutes:
    ldx currentPlayerNumber
    lda playerProstitutes,x
    cmp #$ff // Überrollen verhindern
    bne !skip+
    jmp !exit+
!skip:
    inc playerProstitutes,x

    // Geld abzeiehen
    ldy currentPlayerOffset_4
    sub32 playerMoney,y : gameShopPriceProstitutes : playerMoney,y
!exit:
    jmp gameShopMenu

// Bars kaufen
shopBuyBars:
    ldx currentPlayerNumber
    lda playerBars,x
    cmp #$ff // Überrollen verhindern
    bne !skip+
    jmp !exit+
!skip:
    inc playerBars,x

    // Geld abzeiehen
    ldy currentPlayerOffset_4
    sub32 playerMoney,y : gameShopPriceBars : playerMoney,y
!exit:
    jmp gameShopMenu


// Wettbüros kaufen
shopBuyBetting:
    ldx currentPlayerNumber
    lda playerBetting,x
    cmp #$ff // Überrollen verhindern
    bne !skip+
    jmp !exit+
!skip:
    inc playerBetting,x

    // Geld abzeiehen
    ldy currentPlayerOffset_4
    sub32 playerMoney,y : gameShopPriceBetting : playerMoney,y
!exit:
    jmp gameShopMenu

// Spielsalon kaufen
shopBuyGambling:
    ldx currentPlayerNumber
    lda playerGambling,x
    cmp #$ff // Überrollen verhindern
    bne !skip+
    jmp !exit+
!skip:
    inc playerGambling,x

    // Geld abzeiehen
    ldy currentPlayerOffset_4
    sub32 playerMoney,y : gameShopPriceGambling : playerMoney,y
!exit:
    jmp gameShopMenu


// Bordell kaufen
shopBuyBrothels:
    ldx currentPlayerNumber
    lda playerBrothels,x
    cmp #$ff // Überrollen verhindern
    bne !skip+
    jmp !exit+
!skip:
    inc playerBrothels,x

    // Geld abzeiehen
    ldy currentPlayerOffset_4
    sub32 playerMoney,y : gameShopPriceBrothels : playerMoney,y
!exit:
    jmp gameShopMenu

// Hotel kaufen
shopBuyHotels:
    ldx currentPlayerNumber
    lda playerHotels,x
    cmp #$ff // Überrollen verhindern
    bne !skip+
    jmp !exit+
!skip:
    inc playerHotels,x

    // Geld abzeiehen
    ldy currentPlayerOffset_4
    sub32 playerMoney,y : gameShopPriceHotels : playerMoney,y
!exit:
    jmp gameShopMenu

// Anzeige Shop Position
gameShopPrintOption:
    lda gameShopBuyingMask
    cmp gameShopPositionChoice
    bcs !continue+
    jmp !end+
!continue:
    jsr Print_text
    Print_hex32_dec gameShopPositionPrice
    lda #' '
    jsr BSOUT
    lda #'$'
    jsr BSOUT
    lda #PET_CR
    jsr BSOUT
!end:
    rts

gameShopPositionChoice:
    .byte 00
gameShopPositionPrice:
    .dword $00000000
