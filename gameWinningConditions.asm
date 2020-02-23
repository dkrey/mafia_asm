#importonce

gameCheckWinningCondition:
    lda gameMode
    cmp #0
    bne !skip+
    jmp gameCheckWinEstate
!skip:
    cmp #1
    bne !skip+
    jmp gameCheckWinFirstMillion
!skip:
    cmp #2
    bne !skip+
    jmp gameCheckWinLasVegas
!skip:
    jmp gameCheckWinEstate


// Spielmodus: Prozente der ganzen Gegend
gameCheckWinEstate:
    // Unter 20.000 Einkommen keine Berechnung
    compare32 currentTotalIncome : minMoneyForMenu
    bcs !skip+
    rts
!skip:

    // Ohne Personal auch keine Berechnung
    compare32 currentTotalCosts: #$00000000
    bne !skip+
    rts
!skip:

    // Besitzanteile ausrechnen
    jsr gamePropertyCalc

    // Ohne Prozente auch keine Anzeige
    ldx currentPlayerNumber
    lda playerEstates,x
    cmp #$00
    bne !skip+
    rts

    // Mit Schulden kann man nicht gewinnen
    ldx currentPlayerNumber
    lda playerDebtFlag,x
    cmp #$00
    beq !skip+
    rts
!skip:
    // mit neuen Schulden kann man auch nicht gewinnen
    ldx currentPlayerOffset_4
    lda playerMoney + 3, x
    and #$80
    bpl !skip+  // Keine Schulden
    rts

!skip:
    // Besitzverhältnisse anzeigen
    jsr CLEAR
    mov #BLACK : EXTCOL             // Schwarzer Overscan
    mov #BLACK : BGCOL0             // Schwarzer Hintergrund
    mov #YELLOW : TEXTCOL           // Gelbe Schrift

    // Spielziel anzeigen: so viel % müssen erobert werden
    ldx playerCount                 // Spieleranzahl -1
    dex
    Print_hex8_dec winFactorEstatePercentage, x
    lda #' '
    lda BSOUT

    mov16 #strPropertyOverview1 : TextPtr
    jsr Print_text

    mov16 #strPropertyOverview2 : TextPtr
    jsr Print_text

    Print_hex16_dec propsCurrentEstate

    mov16 #strPropertyOverview3 : TextPtr
    jsr Print_text

    // Gewonnen?
    // Gebietsanteile des Spielers laden
    ldy currentPlayerNumber
    lda playerEstates,y

    // Notwendige Gebietsanteile laden
    ldx playerCount
    dex
    cmp winFactorEstatePercentage, x    // und mit aktuellem Prozentsatz vergleichen
    bcc !end+                           // nicht gewonnen

    // Hat gewonnen
    mov #01 : gameOver
    mov16 #strPropertyWin : TextPtr
    jsr Print_text

!end:
    mov16 #strPressKey : TextPtr    // Text: Weiter
    jsr Print_text
    jsr Wait_for_key
    rts

gameCheckWinFirstMillion:
    ldy currentPlayerOffset_4       // Offset für dword holen: 4 Byte

    // Info ab 500.000$
    compare32 playerMoney,y :#$B71B0    // Unter 750.000 Vermögen keine Info
    bcs !skip+
    rts
!skip:
    jsr CLEAR
    mov #BLACK : EXTCOL             // Schwarzer Overscan
    mov #BLACK : BGCOL0             // Schwarzer Hintergrund
    mov #YELLOW : TEXTCOL           // Gelbe Schrift
    clear32 gameCheckWinFirstMillionDifference

    ldy currentPlayerOffset_4
    compare32 playerMoney,y : #$f4240   // Gewonnen
    bcc !skip+

    // Hat gewonnen
    mov16 #strGameModeMillionWin : TextPtr
    jsr Print_text
    mov #01 : gameOver
    mov16 #strPropertyWin : TextPtr
    jsr Print_text
    jmp !end-

!skip:
    ldy currentPlayerOffset_4
    sub32 #$f4240 : playerMoney,y : gameCheckWinFirstMillionDifference
    mov16 #strGameModeMillionAlmost : TextPtr
    jsr Print_text
    Print_hex32_dec gameCheckWinFirstMillionDifference
    lda #'$'
    jsr BSOUT
    lda #PET_CR
    jsr BSOUT
    jmp !end-

gameCheckWinLasVegas:
    ldy currentPlayerNumber

    // Info ab 500.000$
    lda playerHotels,y
    cmp #00
    bne !skip+
    rts
!skip:
    jsr CLEAR
    mov #BLACK : EXTCOL             // Schwarzer Overscan
    mov #BLACK : BGCOL0             // Schwarzer Hintergrund
    mov #YELLOW : TEXTCOL           // Gelbe Schrift
    lda #00
    sta gameCheckWinVegasDifference

    ldy currentPlayerNumber
    lda playerSlotMachines, y
    cmp #$64                     // 100 Automaten
    bcc !skip+
    // Gewonnen
    mov16 #strGameModeVegasWin : TextPtr
    jsr Print_text
    mov #01 : gameOver
    mov16 #strPropertyWin : TextPtr
    jsr Print_text
    jmp !end-

!skip:
    /// Automaten
    mov16 #strGameModeVegasAlmost : TextPtr
    jsr Print_text
    ldy currentPlayerNumber
    lda #$64
    sec
    sbc playerSlotMachines, y
    sta gameCheckWinVegasDifference
    Print_hex8_dec gameCheckWinVegasDifference
    mov16 #strFinancesSlotMachines : TextPtr
    jsr Print_text
    jmp !end-

gameCheckWinFirstMillionDifference:
    .dword $00000000

gameCheckWinVegasDifference:
    .byte $00
