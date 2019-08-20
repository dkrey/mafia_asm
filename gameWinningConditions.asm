#importonce

gameCheckWinningCondition:
    lda gameMode
    cmp #0
    beq gameCheckWinEstate
    rts


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

    // Mit Schulden kann man nicht gewinnen
    lda playerDebtFlag,x
    cmp #$00
    beq !skip+
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