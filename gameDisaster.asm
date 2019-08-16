#importonce

gameDisasterCheck:
    ldx currentPlayerOffset_4

    compare32 playerIncome,x : #$0000c350 // Bei weniger als 50.000 $ Einkommen keine Disaster

    bcs gameDisasterDefense
    rts

gameDisasterDefense:
    // 750 gilt es zu verringern
    mov16 #$02ee : disasterGroundvalue

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

    // Zufall von 100:1100
    getRandomRange16 #$0064 : #$044c

    /*
    Print_hex16_dec rnd16_result

    lda #' '
    jsr BSOUT
    Print_hex16_dec disasterGroundvalue

    lda #PET_CR
    jsr BSOUT
    */

    // Wenn der Zufallswert unter dem Grundwert liegt, nimmt das Schicksal seinen lauf
    compare16 rnd16_result : disasterGroundvalue
    bcs gameDisasterContinue
    rts

// Unheil ließ sich nicht abwenden
gameDisasterContinue:
    // Speicher leeren
    lda #00
    sta disasterAmountSlotMachines
    sta disasterAmountProstitutes
    sta disasterAmountBars
    sta disasterAmountBetting
    sta disasterAmountGambling
    sta disasterAmountBrothels
    sta disasterAmountHotels

    getRandomRange8 #0 : #5
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

// Schwangere Prostituierte
disasterProstitutes:
    ldx currentPlayerNumber
    lda playerProstitutes, x
    cmp #$01
    bne !skip+
    jmp disasterSlotMachines // keine Prostituierten, vielleicht Automaten
!skip:
    getRandomRange8 #01 : playerProstitutes, x
    //rnd8_result

//geschlossene Bars
disasterBars:
// geschlossene Wettbüros
disasterBetting:
// geschlossene Spielsalons
disasterGambling:
// geschlossene Bordelle
disasterBrothels:
// geschlossene Hotels
disasterHotels:

// Anzeige der geschlossenen Immobilie
disasterEstate:


!end:
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