#importonce


//===============================================================================
// gameFinancesIncome
//
// Zeigt das Einkommen
//===============================================================================
gameFinancesIncome:
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
    ldx currentPlayerOffset_2
    mov16 playerSlotMachines, x : hex16dec_value
    jsr Print_hex16_dec
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

    mov16 #strPressKey : TextPtr // Text: Weiter
    jsr Print_text
    jsr Wait_for_key

// Income Temp Vars
currentSlotMachines:
    .dword $00000000
currentProstitutes:
    .dword $00000000
currentBars:
    .dword $00000000
currentGambling:
    .dword $00000000
currentBetting:
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