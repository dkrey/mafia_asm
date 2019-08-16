//===============================================================================
// shopping
//
//==============================================================================
gameOverviewMenu:
    jsr CLEAR
    mov #BLACK : EXTCOL            //  Overscan
    mov #RED : BGCOL0              //  Hintergrund
    mov #BLACK : TEXTCOL           //  Schrift

    mov16 #strOverviewTitle : TextPtr // Text: "Besitzverhältnisse:"
    jsr Print_text

    // Spielernamen anzeigen
    ldy currentPlayerOffset_16      // Offset für Spielernamen 16 Byte

    mov16 #playerNames : TextPtr
    jsr Print_text_offset           // Schreibe den Spielernamen

    lda #','
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
    lda #PET_CR
    jsr BSOUT
    lda #PET_CR
    jsr BSOUT

    // Anzeige Besitz
    // Spielautomaten:
    ldx currentPlayerNumber
    mov playerSlotMachines, x : hex8dec_value
    cmp #0
    beq !skip+

    mov16 #strFinancesSlotMachines : TextPtr
    jsr Print_text
    plot_get
    ldy #25
    plot_set
    jsr Print_hex8_dec

    lda #PET_CR
    jsr BSOUT
!skip:

    // Prostituierte:
    ldx currentPlayerNumber
    mov playerProstitutes, x : hex8dec_value
    cmp #0
    beq !skip+

    mov16 #strFinancesProstitutes : TextPtr
    jsr Print_text
    plot_get
    ldy #25
    plot_set
    jsr Print_hex8_dec

    lda #PET_CR
    jsr BSOUT
!skip:

    // Bars:
    ldx currentPlayerNumber
    mov playerBars, x : hex8dec_value
    cmp #0
    beq !skip+

    mov16 #strFinancesBars : TextPtr
    jsr Print_text
    plot_get
    ldy #25
    plot_set
    jsr Print_hex8_dec

    lda #PET_CR
    jsr BSOUT
!skip:

    // Wettbüro:
    ldx currentPlayerNumber
    mov playerBetting, x : hex8dec_value
    cmp #0
    beq !skip+

    mov16 #strFinancesBetting : TextPtr
    jsr Print_text
    plot_get
    ldy #25
    plot_set
    jsr Print_hex8_dec

    lda #PET_CR
    jsr BSOUT
!skip:

    // Spielsalon:
    ldx currentPlayerNumber
    mov playerGambling, x : hex8dec_value
    cmp #0
    beq !skip+

    mov16 #strFinancesGambling : TextPtr
    jsr Print_text
    plot_get
    ldy #25
    plot_set
    jsr Print_hex8_dec

    lda #PET_CR
    jsr BSOUT
!skip:

    // Bordell:
    ldx currentPlayerNumber
    mov playerBrothels, x : hex8dec_value
    cmp #0
    beq !skip+
    mov16 #strFinancesBrothels : TextPtr
    jsr Print_text
    plot_get
    ldy #25
    plot_set
    jsr Print_hex8_dec

    lda #PET_CR
    jsr BSOUT
!skip:

    // Hotels:
    ldx currentPlayerNumber
    mov playerHotels, x : hex8dec_value
    cmp #0
    beq !skip+
    mov16 #strFinancesHotels : TextPtr
    jsr Print_text
    plot_get
    ldy #25
    plot_set
    jsr Print_hex8_dec

    lda #PET_CR
    jsr BSOUT
!skip:
    // Anzeige Personal
    // Revolverhelden:
    ldx currentPlayerNumber
    mov playerGunfighters, x : hex8dec_value
    cmp #0
    beq !skip+

    mov16 #strFinancesGunfighters : TextPtr
    jsr Print_text
    plot_get
    ldy #25
    plot_set
    jsr Print_hex8_dec

    lda #PET_CR
    jsr BSOUT
!skip:

    // Leibwächter:
    ldx currentPlayerNumber
    mov playerBodyguards, x : hex8dec_value
    cmp #0
    beq !skip+

    mov16 #strFinancesBodyguards : TextPtr
    jsr Print_text
    plot_get
    ldy #25
    plot_set
    jsr Print_hex8_dec

    lda #PET_CR
    jsr BSOUT
!skip:

    // Wächter:
    ldx currentPlayerNumber
    mov playerGuards, x : hex8dec_value
    cmp #0
    beq !skip+

    mov16 #strFinancesGuards : TextPtr
    jsr Print_text
    plot_get
    ldy #25
    plot_set
    jsr Print_hex8_dec

    lda #PET_CR
    jsr BSOUT
!skip:

    // Informanten:
    ldx currentPlayerNumber
    mov playerInformants, x : hex8dec_value
    cmp #0
    beq !skip+

    mov16 #strFinancesInformants : TextPtr
    jsr Print_text
    plot_get
    ldy #25
    plot_set
    jsr Print_hex8_dec

    lda #PET_CR
    jsr BSOUT
!skip:

    // Anwälte:
    ldx currentPlayerNumber
    mov playerAttorneys, x : hex8dec_value
    cmp #0
    beq !skip+

    mov16 #strFinancesAttorneys : TextPtr
    jsr Print_text
    plot_get
    ldy #25
    plot_set
    jsr Print_hex8_dec

    lda #PET_CR
    jsr BSOUT
!skip:


    // Anzeige Bestechungen
    // Polizei:
    ldx currentPlayerNumber
    mov playerPolice, x : hex8dec_value
    cmp #0
    beq !skip+

    mov16 #strFinancesPolice : TextPtr
    jsr Print_text
    plot_get
    ldy #25
    plot_set
    jsr Print_hex8_dec

    lda #PET_CR
    jsr BSOUT
!skip:

    // Inspektoren:
    ldx currentPlayerNumber
    mov playerInspectors, x : hex8dec_value
    cmp #0
    beq !skip+

    mov16 #strFinancesInspectors : TextPtr
    jsr Print_text
    plot_get
    ldy #25
    plot_set
    jsr Print_hex8_dec

    lda #PET_CR
    jsr BSOUT
!skip:

    // Richter:
    ldx currentPlayerNumber
    mov playerJudges, x : hex8dec_value
    cmp #0
    beq !skip+

    mov16 #strFinancesJudges : TextPtr
    jsr Print_text
    plot_get
    ldy #25
    plot_set
    jsr Print_hex8_dec

    lda #PET_CR
    jsr BSOUT
!skip:

    // Staatsanwälte:
    ldx currentPlayerNumber
    mov playerStateAttorneys, x : hex8dec_value
    cmp #0
    beq !skip+

    mov16 #strFinancesStateAttorneys : TextPtr
    jsr Print_text
    plot_get
    ldy #25
    plot_set
    jsr Print_hex8_dec

    lda #PET_CR
    jsr BSOUT
!skip:

    // Bürgermeister:
    ldx currentPlayerNumber
    mov playerMajors, x : hex8dec_value
    cmp #0
    beq !skip+

    mov16 #strFinancesMajors : TextPtr
    jsr Print_text
    plot_get
    ldy #25
    plot_set
    jsr Print_hex8_dec

    lda #PET_CR
    jsr BSOUT
!skip:

    mov16 #strPressKey : TextPtr // Text: Weiter
    jsr Print_text
    jsr Wait_for_key

    rts