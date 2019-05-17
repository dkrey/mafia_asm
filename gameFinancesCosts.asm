#importonce

gameFinancesCalcTotalCosts:
    // Alles aufsummieren
    add32 currentGunfighters : currentTotalCosts : currentTotalCosts
    add32 currentBodyguards : currentTotalCosts : currentTotalCosts
    add32 currentGuards : currentTotalCosts : currentTotalCosts
    add32 currentInformants : currentTotalCosts : currentTotalCosts
    add32 currentAttorneys : currentTotalCosts : currentTotalCosts
    add32 currentPolice : currentTotalCosts : currentTotalCosts
    add32 currentInspectors : currentTotalCosts : currentTotalCosts
    add32 currentJudges : currentTotalCosts : currentTotalCosts
    add32 currentStateAttorneys : currentTotalCosts : currentTotalCosts
    add32 currentMajors : currentTotalCosts : currentTotalCosts
    rts

gameFinancesCalcGunfighters: // 6000 $
    ldx currentPlayerNumber
    lda playerGunfighters,x
    tax
!loop:
    add16To32 #$1770 : currentGunfighters : currentGunfighters
    dex
    bne !loop-
    rts

gameFinancesCalcBodyguards: // 4000 $
    ldx currentPlayerNumber
    lda playerBodyguards,x
    tax
!loop:
    add16To32 #$0fa0 : currentBodyguards : currentBodyguards
    dex
    bne !loop-
    rts

gameFinancesCalcGuards: // 3000 $
    ldx currentPlayerNumber
    lda playerGuards,x
    tax
!loop:
    add16To32 #$0bb8 : currentGuards : currentGuards
    dex
    bne !loop-
    rts

gameFinancesCalcInformants: // 2.000 - 10.000 $
    ldx currentPlayerNumber
    lda playerInformants,x
    tax
!loop:
    getRandomRange16 #$07d0 : #$2710
    add16To32 rnd16_result : currentInformants : currentInformants
    dex
    bne !loop-
    rts

gameFinancesCalcAttorneys: // 8000 $
    ldx currentPlayerNumber
    lda playerAttorneys,x
    tax
!loop:
    add16To32 #$1f40 : currentAttorneys : currentAttorneys
    dex
    bne !loop-
    rts

gameFinancesCalcPolice: // 3000 $
    ldx currentPlayerNumber
    lda playerPolice,x
    tax
!loop:
    add16To32 #$0bb8 : currentPolice : currentPolice
    dex
    bne !loop-
    rts

gameFinancesCalcInspectors: // 12000 $
    ldx currentPlayerNumber
    lda playerInspectors,x
    tax
!loop:
    add16To32 #$2ee0 : currentInspectors : currentInspectors
    dex
    bne !loop-
    rts

gameFinancesCalcJudges: // 30000 $
    ldx currentPlayerNumber
    lda playerJudges,x
    tax
!loop:
    add16To32 #$7530 : currentJudges : currentJudges
    dex
    bne !loop-
    rts

gameFinancesCalcStateAttorneys: // 70000 $
    ldx currentPlayerNumber
    lda playerStateAttorneys,x
    tax
!loop:
    add32 #$00011170 : currentStateAttorneys : currentStateAttorneys
    dex
    bne !loop-
    rts

gameFinancesCalcMajors: // 100000 $
    ldx currentPlayerNumber
    lda playerMajors,x
    tax
!loop:
    add32 #$000186a0 : currentMajors : currentMajors
    dex
    bne !loop-
    rts

//===============================================================================
// gameFinancesShowCosts
//
// Zeigt die Ausgaben
//===============================================================================
gameFinancesShowCosts:

    mov16 #strFinancesCosts : TextPtr // Text: "Ihre Ausgaben:"
    jsr Print_text

    // Revolverhelden:
    ldx currentPlayerNumber
    mov playerGunfighters, x : hex8dec_value
    cmp #0
    beq !skip+
    jsr Print_hex8_dec
    plot_get
    ldy #4
    plot_set
    lda #'X'
    jsr BSOUT
    mov16 #strFinancesGunfighters : TextPtr
    jsr Print_text
    plot_get
    ldy #25
    plot_set
    lda #'$'
    jsr BSOUT
    lda #' '
    jsr BSOUT

    jsr gameFinancesCalcGunfighters
    mov32 currentGunfighters : hex32dec_value
    jsr Print_hex32_dec
    lda #PET_CR
    jsr BSOUT

!skip:

    // Bodyguards:
    ldx currentPlayerNumber
    mov playerBodyguards, x : hex8dec_value
    cmp #0
    beq !skip+
    jsr Print_hex8_dec
    plot_get
    ldy #4
    plot_set
    lda #'X'
    jsr BSOUT
    mov16 #strFinancesBodyguards : TextPtr
    jsr Print_text
    plot_get
    ldy #25
    plot_set
    lda #'$'
    jsr BSOUT
    lda #' '
    jsr BSOUT


    jsr gameFinancesCalcBodyguards
    mov32 currentBodyguards : hex32dec_value
    jsr Print_hex32_dec
    lda #PET_CR
    jsr BSOUT

!skip:

    // Nachtwächter:
    ldx currentPlayerNumber
    mov playerGuards, x : hex8dec_value
    cmp #0
    beq !skip+
    jsr Print_hex8_dec
    plot_get
    ldy #4
    plot_set
    lda #'X'
    jsr BSOUT
    mov16 #strFinancesGuards : TextPtr
    jsr Print_text
    plot_get
    ldy #25
    plot_set
    lda #'$'
    jsr BSOUT
    lda #' '
    jsr BSOUT

    jsr gameFinancesCalcGuards
    mov32 currentGuards : hex32dec_value
    jsr Print_hex32_dec
    lda #PET_CR
    jsr BSOUT
!skip:

    // Informanten:
    ldx currentPlayerNumber
    mov playerInformants, x : hex8dec_value
    cmp #0
    beq !skip+
    jsr Print_hex8_dec
    plot_get
    ldy #4
    plot_set
    lda #'X'
    jsr BSOUT
    mov16 #strFinancesInformants : TextPtr
    jsr Print_text
    plot_get
    ldy #25
    plot_set
    lda #'$'
    jsr BSOUT
    lda #' '
    jsr BSOUT

    jsr gameFinancesCalcInformants
    mov32 currentInformants : hex32dec_value
    jsr Print_hex32_dec
    lda #PET_CR
    jsr BSOUT

!skip:

    // Anwälte:
    ldx currentPlayerNumber
    mov playerAttorneys, x : hex8dec_value
    cmp #0
    beq !skip+
    jsr Print_hex8_dec
    plot_get
    ldy #4
    plot_set
    lda #'X'
    jsr BSOUT
    mov16 #strFinancesAttorneys : TextPtr
    jsr Print_text
    plot_get
    ldy #25
    plot_set
    lda #'$'
    jsr BSOUT
    lda #' '
    jsr BSOUT

    jsr gameFinancesCalcAttorneys
    mov32 currentAttorneys : hex32dec_value
    jsr Print_hex32_dec
    lda #PET_CR
    jsr BSOUT


!skip:
    // Wachtmeister:
    ldx currentPlayerNumber
    mov playerPolice, x : hex8dec_value
    cmp #0
    beq !skip+
    jsr Print_hex8_dec
    plot_get
    ldy #4
    plot_set
    lda #'X'
    jsr BSOUT
    mov16 #strFinancesPolice : TextPtr
    jsr Print_text
    plot_get
    ldy #25
    plot_set
    lda #'$'
    jsr BSOUT
    lda #' '
    jsr BSOUT

    jsr gameFinancesCalcPolice
    mov32 currentPolice : hex32dec_value
    jsr Print_hex32_dec
    lda #PET_CR
    jsr BSOUT

!skip:
    // Kommissare:
    ldx currentPlayerNumber
    mov playerInspectors, x : hex8dec_value
    cmp #0
    beq !skip+
    jsr Print_hex8_dec
    plot_get
    ldy #4
    plot_set
    lda #'X'
    jsr BSOUT
    mov16 #strFinancesInspectors : TextPtr
    jsr Print_text
    plot_get
    ldy #25
    plot_set
    lda #'$'
    jsr BSOUT
    lda #' '
    jsr BSOUT

    jsr gameFinancesCalcInspectors
    mov32 currentInspectors : hex32dec_value
    jsr Print_hex32_dec
    lda #PET_CR
    jsr BSOUT

!skip:
    // Richter:
    ldx currentPlayerNumber
    mov playerJudges, x : hex8dec_value
    cmp #0
    beq !skip+
    jsr Print_hex8_dec
    plot_get
    ldy #4
    plot_set
    lda #'X'
    jsr BSOUT
    mov16 #strFinancesJudges : TextPtr
    jsr Print_text
    plot_get
    ldy #25
    plot_set
    lda #'$'
    jsr BSOUT
    lda #' '
    jsr BSOUT

    jsr gameFinancesCalcJudges
    mov32 currentJudges : hex32dec_value
    jsr Print_hex32_dec
    lda #PET_CR
    jsr BSOUT

!skip:
    // Staatsanwälte:
    ldx currentPlayerNumber
    mov playerStateAttorneys, x : hex8dec_value
    cmp #0
    beq !skip+
    jsr Print_hex8_dec
    plot_get
    ldy #4
    plot_set
    lda #'X'
    jsr BSOUT
    mov16 #strFinancesStateAttorneys : TextPtr
    jsr Print_text
    plot_get
    ldy #25
    plot_set
    lda #'$'
    jsr BSOUT
    lda #' '
    jsr BSOUT

    jsr gameFinancesCalcStateAttorneys
    mov32 currentStateAttorneys : hex32dec_value
    jsr Print_hex32_dec
    lda #PET_CR
    jsr BSOUT

!skip:
    // Bürgermeister:
    ldx currentPlayerNumber
    mov playerMajors, x : hex8dec_value
    cmp #0
    beq !skip+
    jsr Print_hex8_dec
    plot_get
    ldy #4
    plot_set
    lda #'X'
    jsr BSOUT
    mov16 #strFinancesMajors : TextPtr
    jsr Print_text
    plot_get
    ldy #25
    plot_set
    lda #'$'
    jsr BSOUT
    lda #' '
    jsr BSOUT
    jsr gameFinancesCalcMajors
    mov32 currentMajors : hex32dec_value
    jsr Print_hex32_dec
    lda #PET_CR
    jsr BSOUT

    // Gesamtauslistung
!skip:
    mov16 #strLine40 : TextPtr // Line
    jsr Print_text
    jsr gameFinancesCalcTotalCosts // Gesamteinkommen berechnen

    mov16 #strTotal : TextPtr // Text: Gesamt
    jsr Print_text
    plot_get
    ldy #25
    plot_set
    lda #'$'
    jsr BSOUT
    lda #' '
    jsr BSOUT
    mov32 currentTotalCosts : hex32dec_value
    jsr Print_hex32_dec
    lda #PET_CR
    jsr BSOUT

    rts