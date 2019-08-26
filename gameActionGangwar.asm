#importonce
/*
Bandenkrieg

Revolverhelden bzw. Wächter: max. 9 pro Seite
würfeln von 0-10

Abfrage von Disastern: Wenn genug Bestechungen: Würfeln für mehr Angreifer bzw. Wächter
dann max 3 Revolverhelden oder 3 Wächter extra, ebenfalls per Zufall

 */




//===============================================================================
// Gangwar - demolish buildings in the process
//
//==============================================================================
gameGangwarHeader:
    jsr CLEAR
    mov #BLACK : EXTCOL            //  Overscan
    mov #BROWN : BGCOL0              //  Hintergrund
    mov #BLACK : TEXTCOL           //  Schrift

    mov16 #strGangwarTitle1 : TextPtr // Text: "Überschrift:"
    jsr Print_text
    rts

gameGangwarMenu:
    jsr gameGangwarHeader

// Prüfe Revolverhelden
gameGangwarCheck:
    ldx currentPlayerNumber
    lda playerGunfighters, x
    sta gameGangwarAttackers    // schon mal Angreifer speichern
    bne !skip+
    mov16 #strGangwarMissing : TextPtr
    jsr Print_text
    lda #PET_CR
    jsr BSOUT
    mov16 #strPressKey : TextPtr // Text: Weiter
    jsr Print_text
    jsr Wait_for_key
    rts

// RH vorhanden
!skip:
    mov16 #strGangwarTitle2 : TextPtr // Text: "Überschrift2"
    jsr Print_text
// Spielernamen anzeigen
    ldx #00                         // Durch die Spielernamen mit X zählen
    mov16 #playerNames : TextPtr    // Beginn der Spielernamen

!loop:
// Spielernummer +1 anzeigen
    lda #' '
    jsr BSOUT
    txa                             // X nach A
    pha                             // A auf Stack sichern
    clc
    adc #$01                        // um 1 erhöhen, weil ab 0 gezählt wird
    sta hex8dec_value               // Wert anzeigen

    jsr Print_hex8_dec
    lda #'.'
    jsr BSOUT
    lda #' '

    jsr BSOUT

    pla                             // Alten X-Wert vom Stack holen
    tax                             // und nach X schieben
    .for (var i = 0; i < 4; i++) {  // *2^4 = *16
        asl
    }
    tay                             // Offset aus Akku nach Y
    jsr Print_text_offset           // Schreibe den Spielernamen
    lda #PET_CR                     // Zeilenumbruch
    jsr BSOUT
    inx
    cpx playerCount                 // Solange x< Spieleranzahl
    bne !loop-                      // weiter mit Schleife

    lda #PET_CR
    jsr BSOUT
    mov16 #strGangwarCancel : TextPtr
    jsr Print_text

    mov16 #strChoice : TextPtr
    jsr Print_text

//===============================================================================
// gameTransferChoice
//
// Wer bekommt das Geld
//===============================================================================
gameGangwarChoice:
    // Abfrage, welche Position
    // Auswahl holen
    jsr GETIN
    cmp #$30        // sichergehen, dass es eine gültige Ziffer ist <= 0
    bcc gameGangwarChoice
    cmp #$3a        // sichergehen, dass es eine gültige Ziffer ist >= #$3a
    bcs gameGangwarChoice

    cmp #0                          // 0 oder Enter, Abfrage erneut starten
    beq gameGangwarChoice

    sec                             // Konv PetSCII Zeichen zur Zahl
    sbc #$30

    // Auswahl nicht höher als erlaubt
    cmp #0              // Ziffer 0 = Exit
    bne !gameGangwarContinue+
    rts

!gameGangwarContinue:
    sec                            // Spielernummer - 1, so wie sie gespeichert sind
    sbc #$01

    cmp playerCount
    bcc !skip+          // Auswahl < ist okay

    jmp gameGangwarChoice

!skip:
    // Nicht an sich selbst überweisen
    cmp currentPlayerNumber
    bne !gameGangwarContinue+
    mov16 #strGangwarImpossible : TextPtr // Text: "Sie hauen sich eine rein"
    jsr Print_text
    lda #PET_CR
    jsr BSOUT
    mov16 #strPressKey : TextPtr // Text: Weiter
    jsr Print_text
    jsr Wait_for_key
    rts

!gameGangwarContinue:
    sta gameGangwarVictim
    pha
    jsr gameGangwarHeader
    mov16 #strGangwarSummary1 : TextPtr // Text: "Sie wollen bei"
    jsr Print_text
    mov16 #playerNames : TextPtr
    pla
    asl
    asl
    asl
    asl
    tay
    jsr Print_text_offset   // Text:  <Spielername> CR CR
    mov16 #strGangwarSummary2 : TextPtr // Text: "Aufräumen"
    jsr Print_text


// Der Angreifer hat
!gameGangwarAttackerSummary:
    mov16 #strYouHave : TextPtr
    jsr Print_text
    lda gameGangwarAttackers
    pha
    Print_hex8_dec gameGangwarAttackers
    lda #PET_CR
    jsr BSOUT
    mov16 #strFinancesGunfighters : TextPtr
    jsr Print_text

    pla
    cmp #$0A                    // max 9 Angreifer
    bcc !skip+                  // also bcc < 10
    lda #$09
    sta gameGangwarAttackers
    lda #PET_CR
    jsr BSOUT
    mov16 #strGangwarAttackersAmount : TextPtr
    jsr Print_text
!skip:
    // Angriffbonus durch Bestechungen
    mov16 #$0000 : disasterTotalFactor
    mov currentPlayerNumber : disasterPlayer
    jsr gameCalcTotalFactor
    lda #PET_CR
    jsr BSOUT

    // Angriffsbonusnachricht
    compare16 disasterTotalFactor : #$0032
    bcc !skip+
    mov16 #strGangwarAttackersBonus : TextPtr
    jsr Print_text
!skip:
    compare16 disasterTotalFactor : #$00C9   // über 200 Bestechungspunkte +3
    bcc !skip+
    clc
    lda gameGangwarAttackers
    adc #03
    sta gameGangwarAttackers
    jmp gameGangwarDefenderSummary
!skip:
    compare16 disasterTotalFactor : #$0064   // über 100 Bestechungspunkte +2
    bcc !skip+
    clc
    lda gameGangwarAttackers
    adc #02
    sta gameGangwarAttackers
    jmp gameGangwarDefenderSummary
!skip:
    compare16 disasterTotalFactor : #$0032  // über 50 Bestechungspunkte +1
    bcc gameGangwarDefenderSummary
    clc
    lda gameGangwarAttackers
    adc #01
    sta gameGangwarAttackers
    jmp gameGangwarDefenderSummary

gameGangwarDefenderSummary:
    lda #PET_CR
    jsr BSOUT
    jsr BSOUT

    // Anzeige: Gegner hat x Wächter
    mov16 #playerNames : TextPtr
    lda gameGangwarVictim
    asl
    asl
    asl
    asl
    tay
    jsr Print_text_offset

    mov16 #strHeHas : TextPtr
    jsr Print_text
    ldx gameGangwarVictim
    lda playerGuards, x
    sta gameGangwarDefenders
    pha
    Print_hex8_dec gameGangwarDefenders
    lda #' '
    jsr BSOUT
    mov16 #strFinancesGuards : TextPtr
    jsr Print_text

    pla
    cmp #$0A                    // max 9 Verteidiger
    bcc !skip+                  // also bcc < 10
    lda #$09
    sta gameGangwarDefenders
    lda #PET_CR
    jsr BSOUT
    mov16 #strGangwarDefendersAmount : TextPtr
    jsr Print_text
!skip:
    // Verteidigungsbonus durch Informanten
    ldx gameGangwarVictim
    // Angriffbonus durch Bestechungen
    mov16 #$0000 : disasterTotalFactor
    mov gameGangwarVictim : disasterPlayer
    jsr gameCalcTotalFactor
    lda #PET_CR
    jsr BSOUT

    // Verstärkunsnachricht
    compare16 disasterTotalFactor : #$0032
    bcc !skip+
    mov16 #strGangwarDefendersBonus : TextPtr
    jsr Print_text
!skip:
    compare16 disasterTotalFactor : #$00C9   // über 200 Bestechungspunkte +3
    bcc !skip+

    clc
    lda gameGangwarDefenders
    adc #03
    sta gameGangwarDefenders
    jmp gameGangwarStartFight
!skip:
    compare16 disasterTotalFactor : #$0064   // über 100 Bestechungspunkte +2
    bcc !skip+
    clc
    lda gameGangwarDefenders
    adc #02
    sta gameGangwarDefenders
    jmp gameGangwarStartFight
!skip:
    compare16 disasterTotalFactor : #$0032  // über 50 Bestechungspunkte +1
    bcc gameGangwarStartFight
    clc
    lda gameGangwarDefenders
    adc #01
    sta gameGangwarDefenders
    jmp gameGangwarStartFight


// Der eigentliche Bandenkrieg
gameGangwarStartFight:
    lda #00
    sta gameGangwarAttackersLoss
    sta gameGangwarDefendersLoss

    mov16 #strPressKey : TextPtr // Text: Weiter
    jsr Print_text
    jsr Wait_for_key

    // Wieder den Header anzeigen
    jsr CLEAR
    mov #BLACK : EXTCOL            //  Overscan
    mov #BLACK : BGCOL0              //  Hintergrund
    mov #RED : TEXTCOL           //  Schrift

    mov16 #strGangwarTitle3 : TextPtr // Text: "Der Kampf beginnt:"
    jsr Print_text

    // Name des Angreifers
    mov16 #playerNames : TextPtr
    ldy currentPlayerOffset_16
    jsr Print_text_offset

    // Name des Verteidigers
    plot_get
    ldy #$14
    plot_set

    lda gameGangwarVictim
    asl
    asl
    asl
    asl
    tay
    jsr Print_text_offset

    // unterstreichen
    lda #PET_CR
    jsr BSOUT
    mov16 #strLine18 : TextPtr
    jsr Print_text
    plot_get
    ldy #$14
    plot_set
    mov16 #strLine18 : TextPtr
    jsr Print_text
    lda #PET_CR
    jsr BSOUT
    jsr gameGangwarStats
    addDelay #$2e   // Kurze Pause

    // Keine Verteidiger
    lda gameGangwarDefenders
    cmp #0
    bne !skip+
    jmp gameGangwarFightOver
!skip:
    jmp gameGangwarFight
// Zeigt Anzahl der Revolverhelden und Wächter:
gameGangwarStats:

    ldx #$06
    ldy #$01
    plot_set
    Print_hex8_dec gameGangwarAttackers
    mov16 #strFinancesGunfighters : TextPtr
    jsr Print_text
    lda #' '
    jsr BSOUT
    jsr BSOUT
    plot_get
    ldy #$14
    plot_set
    Print_hex8_dec gameGangwarDefenders
    mov16 #strFinancesGuards : TextPtr
    jsr Print_text
    lda #' '
    jsr BSOUT
    jsr BSOUT
    rts

gameGangwarFight:
    // Der eigentliche Kampf:
    ldx gameGangwarAttackers
!attackloop:

    // Würfeln von 0 - 10
    getRandomRange8 #$00 : #$0A
    pha
    Print_hex8_dec rnd8_result
    pla
    cmp #05
    bcc !skip+
    // Treffer weil > 5
    dec gameGangwarDefenders
    inc gameGangwarDefendersLoss

!skip:
    lda gameGangwarDefenders
    cmp #00
    beq gameGangwarFightOver

    dec gameGangwarAttackers
    inc gameGangwarAttackersLoss
    addDelay #$1e
    jsr gameGangwarStats // Status anzeigen
    ldx gameGangwarAttackers
    cpx #00

    bne !attackloop-

    // Dramatische Pause und Ergebnis anzeigen
    addDelay #$2e
    jmp gameGangwarFightOver


gameGangwarFightOver:
    addDelay #$1e
    jsr gameGangwarStats // Status anzeigen
    lda #PET_CR
    jsr BSOUT

    // Verlusste anzeigen
    ldx #$08
    ldy #$00
    plot_set
    mov16 #strGangwarCasualties : TextPtr
    jsr Print_text
    lda #' '
    jsr BSOUT
    Print_hex8_dec gameGangwarAttackersLoss
    plot_get
    ldy #$14
    plot_set
    Print_hex8_dec gameGangwarDefendersLoss

    clear32 gameGangwarAttackersBurial
    clear32 gameGangwarDefendersBurial
    // Begräbniskosten Angreifer 25000$ pro Kopf
    ldx gameGangwarAttackersLoss
    cpx #0
    beq !skip+
!loop:
    add16To32 #$61a8 :gameGangwarAttackersBurial:gameGangwarAttackersBurial
    dex
    cpx #00
    bne !loop-
    // Begräbniskosten Verteidiger 15000$ pro Kopf
!skip:
    ldx gameGangwarDefendersLoss
    cpx #0
    beq !skip+
!loop:
    add16To32 #$3a98 :gameGangwarDefendersBurial:gameGangwarDefendersBurial
    dex
    cpx #00
    bne !loop-

!skip:
    ldx #$0A
    ldy #$00
    plot_set

    // Begräbniskosten anzeigen
    mov16 #strGangwarBurialCost : TextPtr
    jsr Print_text
    lda #' '
    jsr BSOUT
    Print_hex32_dec gameGangwarAttackersBurial
    lda #'$'
    jsr BSOUT
    plot_get
    ldy #$14
    plot_set
    Print_hex32_dec gameGangwarDefendersBurial
    lda #'$'
    jsr BSOUT

    // Begräbniskosten gleich abziehen
    ldx currentPlayerOffset_4
    sub32 playerMoney,x : gameGangwarAttackersBurial : playerMoney,x

    lda gameGangwarVictim
    asl
    asl
    tax
    sub32 playerMoney,x : gameGangwarDefendersBurial : playerMoney,x

    // Personal abziehen
    ldx currentPlayerNumber
    lda playerGunfighters, x
    sec
    sbc gameGangwarAttackersLoss
    bpl !skip+
    lda #00
!skip:
    sta playerGunfighters, x

    ldx gameGangwarVictim
    lda playerGuards, x
    sec
    sbc gameGangwarDefendersLoss
    bpl !skip+
    lda #00
!skip:
    sta playerGuards, x

    // Gewinnnachricht
    mov16 #strGangwarWinner1 : TextPtr      // Text: Die Familie von
    jsr Print_text

    lda gameGangwarDefenders
    cmp #00
    bne !skip+
    mov16 #playerNames : TextPtr
    ldy currentPlayerOffset_16
    jsr Print_text_offset
    jmp !skip2+
!skip:
    mov16 #playerNames : TextPtr
    lda gameGangwarVictim
    asl
    asl
    asl
    asl
    tay
    jsr Print_text_offset
!skip2:
    mov16 #strGangwarWinner2 : TextPtr      // Text: Hat die Schlacht gewonnen
    jsr Print_text

    lda gameGangwarDefenders
    cmp #00
    beq !skip+
    jmp gameGangwarFightExit
!skip:
    mov16 #strGangwarLoose : TextPtr
    jsr Print_text

    mov16 #playerNames : TextPtr
    lda gameGangwarVictim
    asl
    asl
    asl
    asl
    tay
    jsr Print_text_offset
    lda #':'
    jsr BSOUT
    lda #PET_CR
    jsr BSOUT
    jsr BSOUT

// Dinge, die dem Verlierer abgezogen werden, teuerste Immobilien zuerst
gameGangwarFightLoss:
    ldx gameGangwarVictim
// Hotel?
    lda playerHotels, x
    cmp #00
    beq !skip+
    getRandomRange8 #$01 : playerHotels, x
    sta ZeroPageTemp // Anzahl Hotels
    sec
    lda playerHotels, x
    sbc ZeroPageTemp
    sta playerHotels, x

    lda #' '
    jsr BSOUT
    Print_hex8_dec ZeroPageTemp
    lda #' '
    jsr BSOUT
    lda #'X'
    jsr BSOUT
    mov16 #strFinancesHotels : TextPtr
    jsr Print_text
    jmp gameGangwarFightExit
!skip:
// Bordell?
    lda playerBrothels, x
    cmp #00
    beq !skip+
    getRandomRange8 #$01 : playerBrothels, x
    sta ZeroPageTemp // Anzahl Brothels
    sec
    lda playerBrothels, x
    sbc ZeroPageTemp
    sta playerBrothels, x

    lda #' '
    jsr BSOUT
    Print_hex8_dec ZeroPageTemp
    lda #' '
    jsr BSOUT
    lda #'X'
    jsr BSOUT
    mov16 #strFinancesBrothels : TextPtr
    jsr Print_text
    jmp gameGangwarFightExit

!skip:
// Spielsalon?
    lda playerGambling, x
    cmp #00
    beq !skip+
    getRandomRange8 #$01 : playerGambling, x
    sta ZeroPageTemp // Anzahl Gambling
    sec
    lda playerGambling, x
    sbc ZeroPageTemp
    sta playerGambling, x

    lda #' '
    jsr BSOUT
    Print_hex8_dec ZeroPageTemp
    lda #' '
    jsr BSOUT
    lda #'X'
    jsr BSOUT
    mov16 #strFinancesGambling : TextPtr
    jsr Print_text
    jmp gameGangwarFightExit

!skip:
// Wettbüro?
    lda playerBetting, x
    cmp #00
    beq !skip+
    getRandomRange8 #$01 : playerBetting, x
    sta ZeroPageTemp // Anzahl Betting
    sec
    lda playerBetting, x
    sbc ZeroPageTemp
    sta playerBetting, x

    lda #' '
    jsr BSOUT
    Print_hex8_dec ZeroPageTemp
    lda #' '
    jsr BSOUT
    lda #'X'
    jsr BSOUT
    mov16 #strFinancesBetting : TextPtr
    jsr Print_text
    jmp gameGangwarFightExit

!skip:
// Bar?
    lda playerBars, x
    cmp #00
    beq !skip+
    getRandomRange8 #$01 : playerBars, x
    sta ZeroPageTemp // Anzahl Bars
    sec
    lda playerBars, x
    sbc ZeroPageTemp
    sta playerBars, x

    lda #' '
    jsr BSOUT
    Print_hex8_dec ZeroPageTemp
    lda #' '
    jsr BSOUT
    lda #'X'
    jsr BSOUT
    mov16 #strFinancesBars : TextPtr
    jsr Print_text
    jmp gameGangwarFightExit

!skip:
// Prost?
    lda playerProstitutes, x
    cmp #00
    beq !skip+
    getRandomRange8 #$01 : playerProstitutes, x
    sta ZeroPageTemp // Anzahl Prostitutes
    sec
    lda playerProstitutes, x
    sbc ZeroPageTemp
    sta playerProstitutes, x

    lda #' '
    jsr BSOUT
    Print_hex8_dec ZeroPageTemp
    lda #' '
    jsr BSOUT
    lda #'X'
    jsr BSOUT
    mov16 #strFinancesProstitutes : TextPtr
    jsr Print_text
    jmp gameGangwarFightExit

!skip:
// Automaten?
    lda playerSlotMachines, x
    cmp #00
    beq !skip+
    getRandomRange8 #$01 : playerSlotMachines, x
    sta ZeroPageTemp // Anzahl SlotMachines
    sec
    lda playerSlotMachines, x
    sbc ZeroPageTemp
    sta playerSlotMachines, x

    lda #' '
    jsr BSOUT
    Print_hex8_dec ZeroPageTemp
    lda #' '
    jsr BSOUT
    lda #'X'
    jsr BSOUT
    mov16 #strFinancesSlotMachines : TextPtr
    jsr Print_text
    jmp gameGangwarFightExit
!skip:
// Ende
gameGangwarFightExit:
    lda #PET_CR
    jsr BSOUT
    lda gameGangwarDefenders  // Die letzte Linie nicht anzeigen, wenn der Angreifer verloren hat
    cmp #00
    bne !skip+
    mov16 #strLine18 : TextPtr
    jsr Print_text
    lda #PET_CR
    jsr BSOUT
!skip:
    mov16 #strPressKey : TextPtr // Text: Weiter
    jsr Print_text
    jsr Wait_for_key

    rts

// Spielernummer des angegriffenen
gameGangwarVictim:
    .byte 0
// Anzahl Angreifer
gameGangwarAttackers:
    .byte 0
// Anzahl Verlusste Angreifer
gameGangwarAttackersLoss:
    .byte 0
// Begräbniskosten
gameGangwarAttackersBurial:
    .dword $00000000

// Anzahl Verteidiger
gameGangwarDefenders:
    .byte 0
// Anzahl Verlusste Verteidiger
gameGangwarDefendersLoss:
    .byte 0
// Begräbniskosten Verteidiger
gameGangwarDefendersBurial:
    .dword $00000000
