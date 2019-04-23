#importonce

gameFinancesCalcClearCurrent:
    clear32 currentSlotMachines
    clear32 currentProstitutes
    clear32 currentBars
    clear32 currentBetting
    clear32 currentGambling
    clear32 currentBrothels
    clear32 currentHotels
    rts

gameFinancesCalcTotalIncome:
    // Alles aufsummieren
    add32 currentSlotMachines : currentTotalIncome : currentTotalIncome
    add32 currentProstitutes : currentTotalIncome : currentTotalIncome
    add32 currentBars : currentTotalIncome : currentTotalIncome
    add32 currentBetting : currentTotalIncome : currentTotalIncome
    add32 currentGambling : currentTotalIncome : currentTotalIncome
    add32 currentBrothels : currentTotalIncome : currentTotalIncome
    add32 currentHotels : currentTotalIncome : currentTotalIncome
    rts

gameFinancesCalcSlotMachines:
    // Automaten
    ldx currentPlayerNumber         // Spielernummer
    lda playerSlotMachines,x       // Anzahl der Automaten
    tax
!loop:
    getRandomRange16 #$0064 : #$044c    // 100-1100$ Gewinn
    add16To32 rnd16_result : currentSlotMachines: currentSlotMachines   // für die Aufstellung sichern
    dex
    bne !loop-
    rts


gameFinancesCalcProstitutes:
    // Prostituierte
    ldx currentPlayerNumber         // Spielernummer
    lda playerProstitutes,x
    tax
!loop:
    getRandomRange16 #$0320 : #$0af0    // 800-2800$ Gewinn
    add16To32 rnd16_result : currentProstitutes: currentProstitutes   // für die Aufstellung sichern
    dex
    bne !loop-
    rts


gameFinancesCalcBars:
    // Bars
    ldx currentPlayerNumber         // Spielernummer
    lda playerBars,x
    tax
!loop:
    getRandomRange16 #$2710 : #$4e20    // 10.000-20.000$ Gewinn
    add16To32 rnd16_result : currentBars: currentBars   // für die Aufstellung sichern
    dex
    bne !loop-
    rts


gameFinancesCalcBetting:
    // Wettbüro
    ldx currentPlayerNumber         // Spielernummer
    lda playerBetting,x
    tax
!loop:
    getRandomRange16 #$2710 : #$88b8    // 10.000-35.000$ Gewinn
    add16To32 rnd16_result : currentBetting: currentBetting   // für die Aufstellung sichern
    dex
    bne !loop-
    rts

gameFinancesCalcGambling:
    // Spielsalon
    ldx currentPlayerNumber         // Spielernummer
    lda playerGambling,x
    tax
!loop:
    getRandomRange16 #$3a98 : #$afc8    // 15.000-45.000$ Gewinn
    add16To32 rnd16_result : currentGambling: currentGambling   // für die Aufstellung sichern
    dex
    bne !loop-
    rts


gameFinancesCalcBrothels:
    // Bordell
    ldx currentPlayerNumber         // Spielernummer
    lda playerBrothels,x
    tax
!loop:
    getRandomRange16 #$4e20 : #$fde8    // 20.000-65.000$ Gewinn
    add16To32 rnd16_result : currentBrothels: currentBrothels   // für die Aufstellung sichern
    dex
    bne !loop-
    rts

gameFinancesCalcHotels:
    // Hotels
    ldx currentPlayerNumber         // Spielernummer
    lda playerHotels,x
    tax
!loop:
    getRandomRange16 #$88b8 : #$fde8   // 35.000-65.000$ Gewinn
    add16To32 rnd16_result : currentHotels: currentHotels   // für die Aufstellung sichern
    dex
    bne !loop-
    rts

//===============================================================================
// gameFinancesShowIncome
//
// Zeigt das Einkommen
//===============================================================================
gameFinancesShowIncome:
    jsr gameFinancesCalcClearCurrent
    jsr CLEAR
    mov #WHITE : EXTCOL             // Schwarzer Overscan
    mov #WHITE : BGCOL0              // Blauer Hintergrund
    mov #BLACK : TEXTCOL           // Gelbe Schrift

    mov16 #strFinancesTitle : TextPtr // Text: "Finanzen:"
    jsr Print_text

    // Spielernamen anzeigen
    ldy currentPlayerOffset_16      // Offset für Spielernamen 16 Byte

    mov16 #playerNames : TextPtr
    jsr Print_text_offset           // Schreibe den Spielernamen

    lda #','
    jsr BSOUT
    lda #PET_CR                     // Zeilenumbruch
    jsr BSOUT

    mov16 #strFinancesIncome : TextPtr // Text: "Ihre Einnahmen sind:"
    jsr Print_text


    // Spielautomaten:
    ldx currentPlayerNumber
    mov playerSlotMachines, x : hex8dec_value
    cmp #0
    beq !skip+
    jsr Print_hex8_dec

    lda #' '
    jsr BSOUT
    lda #'X'
    jsr BSOUT
    mov16 #strFinancesSlotMachines : TextPtr
    jsr Print_text
    plot_get
    dex
    ldy #25
    plot_set
    lda #'$'
    jsr BSOUT

    jsr gameFinancesCalcSlotMachines
    mov32 currentSlotMachines : hex32dec_value
    jsr Print_hex32_dec
    lda #PET_CR
    jsr BSOUT

!skip:
    // Prostituierte
    ldx currentPlayerNumber
    mov playerProstitutes, x : hex8dec_value
    cmp #0
    beq !skip+
    jsr Print_hex8_dec

    lda #' '
    jsr BSOUT
    lda #'X'
    jsr BSOUT
    mov16 #strFinancesProstitutes : TextPtr
    jsr Print_text
    plot_get
    dex
    ldy #25
    plot_set
    lda #'$'
    jsr BSOUT
    jsr gameFinancesCalcProstitutes
    mov32 currentProstitutes : hex32dec_value
    jsr Print_hex32_dec
    lda #PET_CR
    jsr BSOUT

!skip:
    // Bars
    ldx currentPlayerNumber
    mov playerBars, x : hex8dec_value
    cmp #0
    beq !skip+
    jsr Print_hex8_dec

    lda #' '
    jsr BSOUT
    lda #'X'
    jsr BSOUT
    mov16 #strFinancesBars : TextPtr
    jsr Print_text
    plot_get
    dex
    ldy #25
    plot_set
    lda #'$'
    jsr BSOUT
    jsr gameFinancesCalcBars
    mov32 currentBars : hex32dec_value
    jsr Print_hex32_dec
    lda #PET_CR
    jsr BSOUT

!skip:
    // Wettbüro
    ldx currentPlayerNumber
    mov playerBetting, x : hex8dec_value
    cmp #0
    beq !skip+
    jsr Print_hex8_dec

    lda #' '
    jsr BSOUT
    lda #'X'
    jsr BSOUT
    mov16 #strFinancesBetting : TextPtr
    jsr Print_text
    plot_get
    dex
    ldy #25
    plot_set
    lda #'$'
    jsr BSOUT
    jsr gameFinancesCalcBetting
    mov32 currentBetting : hex32dec_value
    jsr Print_hex32_dec
    lda #PET_CR
    jsr BSOUT

!skip:
    // Spielsalon
    ldx currentPlayerNumber
    mov playerGambling, x : hex8dec_value
    cmp #0
    beq !skip+
    jsr Print_hex8_dec

    lda #' '
    jsr BSOUT
    lda #'X'
    jsr BSOUT
    mov16 #strFinancesGambling : TextPtr
    jsr Print_text
    plot_get
    dex
    ldy #25
    plot_set
    lda #'$'
    jsr BSOUT
    jsr gameFinancesCalcGambling
    mov32 currentGambling : hex32dec_value
    jsr Print_hex32_dec
    lda #PET_CR
    jsr BSOUT

!skip:
    // Bordell
    ldx currentPlayerNumber
    mov playerBrothels, x : hex8dec_value
    cmp #0
    beq !skip+
    jsr Print_hex8_dec

    lda #' '
    jsr BSOUT
    lda #'X'
    jsr BSOUT
    mov16 #strFinancesBrothels : TextPtr
    jsr Print_text
    plot_get
    dex
    ldy #25
    plot_set
    lda #'$'
    jsr BSOUT
    jsr gameFinancesCalcBrothels
    mov32 currentBrothels : hex32dec_value
    jsr Print_hex32_dec
    lda #PET_CR
    jsr BSOUT

!skip:
    // Hotel
    ldx currentPlayerNumber
    mov playerHotels, x : hex8dec_value
    cmp #0
    beq !skip+
    jsr Print_hex8_dec

    lda #' '
    jsr BSOUT
    lda #'X'
    jsr BSOUT
    mov16 #strFinancesHotels : TextPtr
    jsr Print_text
    plot_get
    dex
    ldy #25
    plot_set
    lda #'$'
    jsr BSOUT
    jsr gameFinancesCalcHotels
    mov32 currentHotels : hex32dec_value
    jsr Print_hex32_dec
    lda #PET_CR
    jsr BSOUT

!skip:
    mov16 #strLine40 : TextPtr // Line
    jsr Print_text

    jsr gameFinancesCalcTotalIncome // Gesamteinkommen berechnen

    mov16 #strTotal : TextPtr // Text: Gesamt
    jsr Print_text
    plot_get
    ldy #25
    plot_set
    lda #'$'
    jsr BSOUT
    mov32 currentTotalIncome : hex32dec_value
    jsr Print_hex32_dec
    lda #PET_CR
    jsr BSOUT

    mov16 #strPressKey : TextPtr // Text: Weiter
    jsr Print_text
    jsr Wait_for_key

    rts

currentTotalIncome:
    .dword $00000000
currentTotalCosts:
    .dword $00000000

// Income Temp Vars
currentSlotMachines:
    .dword $00000000
currentProstitutes:
    .dword $00000000
currentBars:
    .dword $00000000
currentBetting:
    .dword $00000000
currentGambling:
    .dword $00000000
currentBrothels:
    .dword $00000000
currentHotels:
    .dword $00000000


// Costs Temp Vars
currentGunfighters:
    .dword $00000000
currentBodyguards:
    .dword $00000000
currentGuards:
    .dword $00000000
currentInformants:
    .dword $00000000
currentAttorneys:
    .dword $00000000
currentPolice:
    .dword $00000000
currentInspectors:
    .dword $00000000
currentJudges:
    .dword $00000000
currentStateAttorneys:
    .dword $00000000
currentMajors:
    .dword $00000000
