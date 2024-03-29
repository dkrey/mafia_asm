#importonce

gameCheckInformantHint:
    // Informanten haben Tipps
    ldx currentPlayerNumber
    lda playerInformants,x
    cmp #0
    bne gameCheckInformantHint2   // Ohne Informanten, gleich raus
    rts
gameCheckInformantHint2:
    lda playerDebtFlag, x
    cmp #0
    beq gameCheckInformats  // Nur ohne Schulden zum Informanten
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
    //getRandomRange8 #0 : #3
    //cmp #0
    //beq gameInformantsProperty
    //später mal verschiedene Arten, erstmal dieser eine Tipp
    // denkbar später Entführungen und andere Verbrechen

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
    mov32 gameShopPriceBars : gameInformantsPrice
    mov #$00 : gameInformantsType
    jmp gameInformantsPropertyContinue

gameInformantsPropertyBetting:
    mov16 #strInformantBetting : TextPtr // Wettbüro
    jsr Print_text
    mov32 gameShopPriceBetting : gameInformantsPrice
    mov #$01 : gameInformantsType
    jmp gameInformantsPropertyContinue

gameInformantsPropertyGambling:
    mov16 #strInformantGambling : TextPtr // Spielsalon
    jsr Print_text
    mov32 gameShopPriceGambling : gameInformantsPrice
    mov #$02 : gameInformantsType
    jmp gameInformantsPropertyContinue

gameInformantsPropertyBrothels:
    mov16 #strInformantBrothel : TextPtr // Bordell
    jsr Print_text
    mov32 gameShopPriceBrothels : gameInformantsPrice
    mov #$03 : gameInformantsType
    jmp gameInformantsPropertyContinue

gameInformantsPropertyHotels:
    mov16 #strInformantHotel : TextPtr // Hotel
    jsr Print_text
    mov32 gameShopPriceHotels : gameInformantsPrice
    mov #$04: gameInformantsType
    jmp gameInformantsPropertyContinue

gameInformantsPropertyContinue:
    mov16 #strInformantForJust : TextPtr
    jsr Print_text
    mov #WHITE : TEXTCOL
    getRandomRange32 #$00000064 : gameInformantsPrice
    Print_hex32_dec rnd32_result

    lda #'$'
    jsr BSOUT
    mov #BLACK : TEXTCOL
    lda #PET_CR
    jsr BSOUT
    lda #PET_CR
    jsr BSOUT

    // Eigenes Vermögen anzeigen
    mov16 #strYouHave : TextPtr
    jsr Print_text
    ldy currentPlayerOffset_4
    mov32 playerMoney,y : hex32dec_value
    mov #WHITE : TEXTCOL
    jsr Print_hex32_dec_signed
    // mit Einheit $
    lda #'$'
    jsr BSOUT
    mov #BLACK : TEXTCOL
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
    jmp !finalend+

gameInformantsSetProperty:
    ldx currentPlayerNumber
    lda gameInformantsType
    cmp #0 // Bar
    bne !skip+
    inc playerBars, x
    jmp !selectedYesContinue+
!skip:
    cmp #1 // Wettbüro
    bne !skip+
    inc playerBetting, x
    jmp !selectedYesContinue+
!skip:
    cmp #2 // Spielsalon
    bne !skip+
    inc playerGambling, x
    jmp !selectedYesContinue+
!skip:
    cmp #3 // Bordell
    bne !skip+
    inc playerBrothels, x
    jmp !selectedYesContinue+
!skip:
    cmp #4 // Hotel
    bne !skip+
    inc playerHotels, x
    jmp !selectedYesContinue+
!skip:
    inc playerBars, x
!end:
    jmp !selectedYesContinue+

!selectedYes:
    jsr BSOUT
    jmp gameInformantsSetProperty
!selectedYesContinue:
    ldx currentPlayerOffset_4
    sub32 playerMoney,x :rnd32_result : playerMoney,x
    mov16 #strInformantYes : TextPtr
    jsr Print_text

    // Schulden erlaubt mit Hinweis
    ldx currentPlayerOffset_4
    lda playerMoney + 3, x
    and #$80
    bpl !finalend+  // Keine Schulden

    mov16 #strInformantDept : TextPtr
    jsr Print_text

    lda #PET_CR
    jsr BSOUT
    


!finalend:
    mov16 #strPressKey : TextPtr // Text: Weiter
    jsr Print_text
    jsr Wait_for_key
    rts

// Adress of the player variable Bar, Brothel etc
gameInformantsType:
    .byte $00

// Negotiated Price
gameInformantsPrice:
    .dword $00000000
