#importonce

gameCheckInformantHint:
    // Informanten haben Tipps
    ldx currentPlayerNumber
    lda playerInformants,x
    cmp #0
    bne gameCheckInformats   // Ohne Informanten, gleich raus
    rts

    // 90 / sqrt(1+Informanten)
    gameCheckInformats:
    adc #01 // Ein Extra-Informant als Basis
    sta randomFactor
    sqrt16 randomFactor
    sty randomFactor
    divide8 #90 : randomFactor

    lda divResult
    sta randomFactor
    getRandomRange8 #0 : #100   // neuer Zufall

    lda rnd8_result
    cmp randomFactor
    bcs !skip+
    rts

// Zeige den Tipp
!skip:
    jsr CLEAR
    mov #BLACK  : EXTCOL            // Schwarzer Overscan
    mov #GREEN  : BGCOL0            // Grüner Hintergrund
    mov #BLACK : TEXTCOL           // Schwarze Schrift
    mov16 #strInformantTitle : TextPtr
    jsr Print_text
    getRandomRange8 #0 : #3
    cmp #0
    beq gameInformantsProperty
    //später mal verschiedene Arten, erstmal dieser eine Tipp

gameInformantsProperty:
    mov16 #strInformantProperty : TextPtr // Text: Immobilie
    jsr Print_text

    getRandomRange8 #0 : #4

    cmp #0 // Bar
    bne !skip+
    jmp gameInformantsPropertyBars
!skip:
    cmp #1 // Wettbüro
    bne !skip+
    jmp gameInformantsPropertyBetting
!skip:
    cmp #2 // Spielsalon
    bne !skip+
    jmp gameInformantsPropertyGambling
!skip:
    cmp #3 // Bordell
    bne !skip+
    jmp gameInformantsPropertyBrothels
!skip:
    cmp #4 // Hotel
    bne !skip+
    jmp gameInformantsPropertyHotels
!skip:
    jmp gameInformantsPropertyBars

gameInformantsPropertyBars:
    mov16 #strInformantBar : TextPtr // Bar
    jsr Print_text
    mov16 #strInformantForJust : TextPtr
    jsr Print_text
    getRandomRange32 #$00000000 : gameShopPriceBars
    Print_hex32_dec rnd32_result
    lda #'$'
    jsr BSOUT
    lda PET_CR
    jsr BSOUT
    mov16 #strInformantDeal : TextPtr
    jsr Print_text

!getinput:
    jsr GETIN
    cmp inputYes            // Spieler hat J gedrückt
    beq !selectedYes+
    cmp inputNo            // Spieler hat N gedrückt
    beq !selectedNo+
    jmp !getinput-          // nichts gedrückt
!selectedNo:
    jsr BSOUT
    mov16 #strInformantNo : TextPtr
    jsr Print_text
    jmp !end+

!selectedYes:
    ldx currentPlayerNumber
    compare32 playerMoney,x : rnd32_result
    bcc !notEnoughMoney+

    ldx currentPlayerNumber
    inc playerBars, x
    sub32 playerMoney,x :rnd32_result : playerMoney,x
    mov16 #strInformantYes : TextPtr
    jsr Print_text
    jmp !end+

!notEnoughMoney:
    mov16 #strTransferNotEnough : TextPtr
    jsr BSOUT
    jmp !end+

gameInformantsPropertyBetting:
gameInformantsPropertyGambling:
gameInformantsPropertyBrothels:
gameInformantsPropertyHotels:

!end:
    mov16 #strPressKey : TextPtr // Text: Weiter
    jsr Print_text
    jsr Wait_for_key
    rts