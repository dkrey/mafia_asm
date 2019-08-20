#importonce

disasterHeader:
    jsr CLEAR

    mov #YELLOW  : EXTCOL            // Schwarzer Overscan
    mov #YELLOW  : BGCOL0            // Gelber Hintergrund
    mov #BLACK : TEXTCOL             // schwarze Schrift

    set_cursor_position #8 : #2

    // Spielernamen anzeigen
    ldy currentPlayerOffset_16      // Offset für Spielernamen 16 Byte

    mov16 #playerNames : TextPtr
    jsr Print_text_offset           // Schreibe den Spielernamen

    lda #','
    jsr BSOUT
    lda #PET_CR                     // Zeilenumbruch
    jsr BSOUT
    jsr BSOUT
    rts

// Bei weniger als 50.000 $ Einkommen keine Disaster
gameDisasterCheck:
    ldx currentPlayerOffset_4

    compare32 playerIncome,x : #$0000c350

    bcs gameDisasterDefense
    rts

// Bestochene erhöhen die Chance, das Unheil abzuwehren
gameDisasterDefense:
    // 750 gilt es zu verringern
    mov16 #$02ee : disasterGroundvalue
    mov16 #$0000 : disasterTotalFactor

    // Faktoren für die Bestochenen ausrechnen
    ldx currentPlayerNumber
    mul8 playerPolice, x : #$0C
    mov16 mulResult : disasterPoliceFactor

    ldx currentPlayerNumber
    mul8 playerInspectors, x : #$0E
    mov16 mulResult : disasterInspectorFactor

    ldx currentPlayerNumber
    mul8 playerJudges, x : #$10
    mov16 mulResult : disasterJudgeFactor

    ldx currentPlayerNumber
    mul8 playerStateAttorneys, x : #$12
    mov16 mulResult : disasterStateAttorneyFactor

    ldx currentPlayerNumber
    mul8 playerMajors, x : #$14
    mov16 mulResult : disasterMajorFactor

    // Faktoren für Anwälte, Bordelle und Hotels
    ldx currentPlayerNumber
    mul8 playerAttorneys, x : #$0A
    mov16 mulResult : disasterAttorneyFactor

    ldx currentPlayerNumber
    mul8 playerBrothels, x : #$0A
    mov16 mulResult : disasterBrothelFactor

    ldx currentPlayerNumber
    mul8 playerHotels, x : #$46
    mov16 mulResult : disasterHotelFactor

    // Faktoren addieren
    add16 disasterPoliceFactor      : disasterTotalFactor : disasterTotalFactor
    add16 disasterInspectorFactor   : disasterTotalFactor : disasterTotalFactor
    add16 disasterJudgeFactor       : disasterTotalFactor : disasterTotalFactor
    add16 disasterStateAttorneyFactor : disasterTotalFactor : disasterTotalFactor
    add16 disasterMajorFactor       : disasterTotalFactor : disasterTotalFactor
    add16 disasterAttorneyFactor    : disasterTotalFactor : disasterTotalFactor
    add16 disasterBrothelFactor     : disasterTotalFactor : disasterTotalFactor
    add16 disasterHotelFactor       : disasterTotalFactor : disasterTotalFactor

    // ... und vom Grundwert abziehen
    sub32 disasterGroundvalue : disasterTotalFactor : disasterGroundvalue

    // wenn Grundwert > 750 ist Grundwert auf 100 zurücksetzen
    compare16  #$02ee : disasterGroundvalue
    bcs !skip+
    mov16 #$0064 : disasterGroundvalue
!skip:
    // Zufall von 0:1100
    getRandomRange16 #$0000 : #$044c

    // Wenn der Zufallswert unter dem Grundwert liegt, nimmt das Schicksal seinen lauf
    compare16 rnd16_result : disasterGroundvalue
    bcc gameDisasterContinue
    rts

// Unheil ließ sich nicht abwenden
gameDisasterContinue:
    // Speicher leeren und Bildschirm vorbereiten

    lda #00
    sta disasterAmountSlotMachines
    sta disasterAmountProstitutes
    sta disasterAmountBars
    sta disasterAmountBetting
    sta disasterAmountGambling
    sta disasterAmountBrothels
    sta disasterAmountHotels
    sta disasterAmountGeneral

    clear32 disasterLoss

    // Schicksal auswürfeln
    lda #' '
    jsr BSOUT
    getRandomRange8 #$00 : #$05

    lda rnd8_result

    // Zufall bestimmt, was betroffen ist
    cmp #00
    beq branchDisasterProstitutes
    cmp #01
    beq branchDisasterBars
    cmp #02
    beq branchDisasterBetting
    cmp #03
    beq branchDisasterGambling
    cmp #04
    beq branchDisasterBrothels
    cmp #05
    beq branchDisasterHotels

branchDisasterProstitutes:
    jmp disasterProstitutes
branchDisasterBars:
    jmp disasterBars
branchDisasterBetting:
    jmp disasterBetting
branchDisasterGambling:
    jmp disasterGambling
branchDisasterBrothels:
    jmp disasterBrothels
branchDisasterHotels:
    jmp disasterHotels

// Veraltete Automaten
disasterSlotMachines:
    ldx currentPlayerNumber
    lda playerSlotMachines, x
    cmp #$01
    bne !skip+
    rts         // nur ein Automat, Glück gehabt
!skip:
    getRandomRange8 #01 : playerSlotMachines, x
    lda rnd8_result
    lsr                     // Ergebnis / 2
    cmp #0                  // wenn 0 dann Glück gehabt
    bne !skip+
    rts
!skip:

    sta disasterAmountSlotMachines
    jsr disasterHeader

    Print_hex8_dec disasterAmountSlotMachines
    mov16 #strDisasterSlotMachines : TextPtr // Text: "Automaten sind veraltet"
    jsr Print_text
    // Anzahl der Automaten abziehen
    ldx currentPlayerNumber
    sec
    lda playerSlotMachines, x
    sbc disasterAmountSlotMachines
    sta playerSlotMachines, x
    jmp !end+


// Schwangere Prostituierte
disasterProstitutes:
    ldx currentPlayerNumber
    lda playerProstitutes, x
    cmp #$01
    bne !skip+
    jmp disasterSlotMachines // keine Prostituierten, vielleicht Automaten
!skip:
    getRandomRange8 #01 : playerProstitutes, x
    lda rnd8_result
    lsr                     // Ergebnis / 2
    cmp #0                  // wenn 0 dann Glück gehabt
    bne !skip+
    rts
!skip:
    sta disasterAmountProstitutes
    jsr disasterHeader

    Print_hex8_dec disasterAmountProstitutes

    getRandomRange8 #00 : #01
    lda rnd8_result
    cmp #01
    bne !skip+
    mov16 #strDisasterProstitute1 : TextPtr // Text: "sind schwanger"
    jsr Print_text
    jmp !skip2+
!skip:
    mov16 #strDisasterProstitute2 : TextPtr // Text: "sind veraltet"
    jsr Print_text
!skip2:
    mov16 #strDisasterProstitute3 : TextPtr // Text :" Sie helfen finanziell "
    jsr Print_text

    // Kosten aufaddieren 10.000$ pro Person
    ldx #00
!loop:
    add16To32 #$2710 : disasterLoss : disasterLoss
    inx
    cpx disasterAmountProstitutes
    bne !loop-

    Print_hex32_dec disasterLoss

    lda #'$'
    jsr BSOUT

    // Geld abziehen
    ldx currentPlayerOffset_4
    sub32 playerMoney, x : disasterLoss : playerMoney, x

    // Anzahl der Prostituierten abziehen
    ldx currentPlayerNumber
    sec
    lda playerProstitutes, x
    sbc disasterAmountProstitutes
    sta playerProstitutes, x
    jmp !end+


//geschlossene Bars
disasterBars:
    ldx currentPlayerNumber
    lda playerBars, x
    cmp #$01
    bne !skip+
    jmp disasterSlotMachines // vielleicht Automaten
!skip:
    cmp #$02                // bei 2  wird nur noch eine Immo abgezogen
    bne !skip+
    lda #$01
    jmp !skip2+
!skip:
    getRandomRange8 #01 : playerBars, x
    lda rnd8_result
    lsr                     // Ergebnis / 2
    cmp #0                  // wenn 0 dann Glück gehabt
    bne !skip2+
    rts
!skip2:

    sta disasterAmountBars
    sta disasterAmountGeneral
    jsr disasterHeader

    jsr disasterShowReasons

    mov16 #strFinancesBars : TextPtr // Ihrer Bars
    jsr Print_text

    lda #PET_CR
    jsr BSOUT
    mov16 #strDisasterCloseDown : TextPtr // geschlossen werden
    jsr Print_text

    ldx currentPlayerNumber
    sec
    lda playerBars, x
    sbc disasterAmountGeneral
    sta playerBars, x
    jmp disasterJailCheck

// geschlossene Wettbüros
disasterBetting:
    ldx currentPlayerNumber
    lda playerBetting, x
    cmp #$01
    bne !skip+
    jmp disasterSlotMachines // vielleicht Automaten
!skip:
    cmp #$02                // bei 2  wird nur noch eine Immo abgezogen
    bne !skip+
    lda #$01
    jmp !skip2+
!skip:
    getRandomRange8 #01 : playerBetting, x
    lda rnd8_result
    lsr                     // Ergebnis / 2
    cmp #0                  // wenn 0 dann Glück gehabt
    bne !skip2+
    rts
!skip2:

    sta disasterAmountBetting
    sta disasterAmountGeneral
    jsr disasterHeader

    jsr disasterShowReasons

    mov16 #strFinancesBetting : TextPtr // Ihrer Immobilie
    jsr Print_text

    lda #PET_CR
    jsr BSOUT
    mov16 #strDisasterCloseDown : TextPtr // geschlossen werden
    jsr Print_text

    ldx currentPlayerNumber
    sec
    lda playerBetting, x
    sbc disasterAmountGeneral
    sta playerBetting, x
    jmp disasterJailCheck

// geschlossene Spielsalons
disasterGambling:
    ldx currentPlayerNumber
    lda playerGambling, x
    cmp #$01
    bne !skip+
    jmp disasterSlotMachines // vielleicht Automaten
!skip:
    cmp #$02                // bei 2  wird nur noch eine Immo abgezogen
    bne !skip+
    lda #$01
    jmp !skip2+
!skip:
    getRandomRange8 #01 : playerGambling, x
    lda rnd8_result
    lsr                     // Ergebnis / 2
    cmp #0                  // wenn 0 dann Glück gehabt
    bne !skip2+
    rts
!skip2:

    sta disasterAmountGambling
    sta disasterAmountGeneral
    jsr disasterHeader

    jsr disasterShowReasons

    mov16 #strFinancesGambling : TextPtr // Ihrer Immobilie
    jsr Print_text

    lda #PET_CR
    jsr BSOUT
    mov16 #strDisasterCloseDown : TextPtr // geschlossen werden
    jsr Print_text

    ldx currentPlayerNumber
    sec
    lda playerGambling, x
    sbc disasterAmountGeneral
    sta playerGambling, x
    jmp disasterJailCheck

// geschlossene Bordelle
disasterBrothels:
    ldx currentPlayerNumber
    lda playerBrothels, x
    cmp #$01
    bne !skip+
    jmp disasterSlotMachines // vielleicht Automaten
!skip:
    cmp #$02                // bei 2  wird nur noch eine Immo abgezogen
    bne !skip+
    lda #$01
    jmp !skip2+
!skip:
    getRandomRange8 #01 : playerBrothels, x
    lda rnd8_result
    lsr                     // Ergebnis / 2
    cmp #0                  // wenn 0 dann Glück gehabt
    bne !skip2+
    rts
!skip2:

    sta disasterAmountBrothels
    sta disasterAmountGeneral
    jsr disasterHeader

    jsr disasterShowReasons

    mov16 #strFinancesBrothels : TextPtr // Ihrer Immobilie
    jsr Print_text

    lda #PET_CR
    jsr BSOUT
    mov16 #strDisasterCloseDown : TextPtr // geschlossen werden
    jsr Print_text

    ldx currentPlayerNumber
    sec
    lda playerBrothels, x
    sbc disasterAmountGeneral
    sta playerBrothels, x
    jmp disasterJailCheck

// geschlossene Hotels
disasterHotels:
    ldx currentPlayerNumber
    lda playerHotels, x
    cmp #$01
    bne !skip+
    jmp disasterSlotMachines // vielleicht Automaten
!skip:
    cmp #$02                // bei 2  wird nur noch eine Immo abgezogen
    bne !skip+
    lda #$01
    jmp !skip2+
!skip:
    getRandomRange8 #01 : playerHotels, x
    lda rnd8_result
    lsr                     // Ergebnis / 2
    cmp #0                  // wenn 0 dann Glück gehabt
    bne !skip2+
    rts
!skip2:

    sta disasterAmountHotels
    sta disasterAmountGeneral
    jsr disasterHeader

    jsr disasterShowReasons

    mov16 #strFinancesHotels : TextPtr // Ihrer Immobilie
    jsr Print_text

    lda #PET_CR
    jsr BSOUT
    mov16 #strDisasterCloseDown : TextPtr // geschlossen werden
    jsr Print_text

    ldx currentPlayerNumber
    sec
    lda playerHotels, x
    sbc disasterAmountGeneral
    sta playerHotels, x
    jmp disasterJailCheck

disasterShowReasons:
    getRandomRange8 #0 : #4
    tax
    lda disaster_table_low, x
    sta TextPtr
    lda disaster_table_high, x
    sta TextPtr + 1
    jsr Print_text

    mov16 #strDisasterHadTo : TextPtr // Text: mussten
    jsr Print_text
    lda #PET_CR
    jsr BSOUT
    jsr BSOUT
    Print_hex8_dec disasterAmountGeneral // Anzahl der Dinge
    lda #' '
    mov16 #strDisasterYours : TextPtr // Text: Ihrer
    jsr Print_text

    rts

// GGf winken Gefängnisrunden
disasterJailCheck:
    // Sitzt der Spieler schon im Knast?
    ldx currentPlayerNumber
    lda playerJailTotal,x
    cmp #0
    beq !skip+
    jmp !end+
!skip:
    getRandomRange8 #$00 : #$09
    lda rnd8_result
    cmp #06
    bcs !skip+  // >= 6: Knast
    jmp !end+
!skip:
    getRandomRange8 #$02 : #$05
    lda rnd8_result
    ldx currentPlayerNumber
    sta playerJailTotal,x   // Knastrunden festlegen

    lda #PET_CR
    jsr BSOUT
    mov16 #strDisasterJail1 : TextPtr // Text: Sie haben Knast
    jsr Print_text

    Print_hex8_dec rnd8_result
    mov16 #strDisasterJail2 : TextPtr // Text: Sie haben Knast Teil 2
    jsr Print_text

// Taste für weiter und Ende
!end:
    lda #PET_CR
    jsr BSOUT
    mov16 #strPressKey : TextPtr    // Text: Weiter
    jsr Print_text
    jsr Wait_for_key
    rts


disasterGroundvalue:
    .word $0000
disasterPoliceFactor:
    .word $0000
disasterInspectorFactor:
    .word $0000
disasterJudgeFactor:
    .word $0000
disasterStateAttorneyFactor:
    .word $0000
disasterMajorFactor:
    .word $0000
disasterAttorneyFactor:
    .word $0000
disasterBrothelFactor:
    .word $0000
disasterHotelFactor:
    .word $0000
disasterTotalFactor:
    .word $0000

// Anzahl der geschlossenen Dinge
disasterAmountSlotMachines:
    .byte $00
disasterAmountProstitutes:
    .byte $00
disasterAmountBars:
    .byte $00
disasterAmountBetting:
    .byte $00
disasterAmountGambling:
    .byte $00
disasterAmountBrothels:
    .byte $00
disasterAmountHotels:
    .byte $00
//
disasterAmountGeneral:
    .byte $00

// Finanzielle Hilfe für Prostituierte
disasterLoss:
    .dword $0000

disaster_table_low:
    .byte <strDisasterReason1, <strDisasterReason2, <strDisasterReason3
    .byte <strDisasterReason4, >strDisasterReason5

disaster_table_high:
    .byte >strDisasterReason1, >strDisasterReason2, >strDisasterReason3
    .byte >strDisasterReason4, >strDisasterReason5
