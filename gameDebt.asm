#importonce

gameDeptPawnSlotMachines:
    .byte 00
gameDeptPawnProstitutes:
    .byte 00
gameDeptPawnBars:
    .byte 00
gameDeptPawnBetting:
    .byte 00
gameDeptPawnGambling:
    .byte 00
gameDeptPawnBrothels:
    .byte 00
gameDeptPawnHotels:
    .byte 00


gameDept:
    // Schulden prüfen und setzen
    ldx currentPlayerOffset_4
    lda playerMoney + 3, x
    and #$80
    bpl !nodept+  // Keine Schulden
    jmp gameDeptSet // Doch Schulden

    // keine Schulden
!nodept:
    lda #$00
    ldx currentPlayerNumber
    sta playerDebtFlag, x
    sta playerDebtRounds, x
    jmp !end+

// Schulden
gameDeptSet:
    ldx currentPlayerNumber
    lda playerDebtFlag, x
    cmp #0 // Hatte schon vorherschulden + Schuldenrunden verringern
    bne gameDeptRounds
    // neue Schulden
    lda #01
    sta playerDebtFlag,x
    // 6 Runden Zeit, die Schulden abzubauen
    lda #$06
    sta playerDebtRounds,x
    jmp gameDeptShow


gameDeptRounds:
    dec playerDebtRounds, x // Eine Runde abziehen

    lda playerDebtRounds, x
    cmp #00                 // Alle Runden abgelaufen, Pfändung
    bne gameDeptShow
    jmp gameDeptPawn

gameDeptShow:
    jsr CLEAR
    mov #RED : EXTCOL               // Roter Overscan
    mov #RED : BGCOL0               // Roter Hintergrund
    mov #BLACK : TEXTCOL            // Schwarze Schrift

    mov16 #strDeptInfo1 : TextPtr   // Text: Sie haben Schulden
    jsr Print_text

    mov16 #strDeptInfo2 : TextPtr   // Text: Sie haben Schulden
    jsr Print_text

    ldx currentPlayerNumber
    Print_hex8_dec playerDebtRounds, x // Runden

    mov16 #strDeptInfo3 : TextPtr   // Text: zu begleichen
    jsr Print_text

    mov16 #strPressKey : TextPtr    // Text: Weiter
    jsr Print_text
    jsr Wait_for_key

    jmp !end+

gameDeptPawn:
    // Entlassungen
    ldx currentPlayerNumber
    lda #00
    sta playerGunfighters,x
    sta playerBodyguards,x
    sta playerGuards,x
    sta playerInformants,x
    sta playerAttorneys,x
    sta playerPolice,x
    sta playerInspectors,x
    sta playerJudges,x
    sta playerStateAttorneys,x
    sta playerMajors,x

    // restliche Variablen leeren, sicher ist sicher
    sta gameDeptPawnSlotMachines
    sta gameDeptPawnProstitutes
    sta gameDeptPawnBars
    sta gameDeptPawnBetting
    sta gameDeptPawnGambling
    sta gameDeptPawnBrothels
    sta gameDeptPawnHotels


    // Pfändung Spielautomaten
    ldy playerSlotMachines,x
    cpy #0      // nicht vorhanden? Dann überspringen
    bne !loop+
    jmp !next+
!loop:
    //  Automatenanzahl verringern
    dey
    tya
    ldx currentPlayerNumber
    sta playerSlotMachines,x

    // 4000 $ wird pro Automat gutgeschrieben
    ldx currentPlayerOffset_4
    add16To32 #$0fa0 : playerMoney,x : playerMoney,x
    inc gameDeptPawnSlotMachines

    // noch Schulden?
    lda playerMoney + 3, x
    and #$80
    bmi !skip+
    jmp gameDeptPawnEnd
!skip:
    // Noch mehr Positionen, weiter in Schleife
    cpy #0
    bne !loop-

!next:
    // Pfändung Bars
    ldx currentPlayerNumber
    ldy playerBars,x
    cpy #0      // nicht vorhanden? Dann überspringen
    bne !loop+
    jmp !next+
!loop:
    //  Anzahl verringern
    dey
    tya
    ldx currentPlayerNumber
    sta playerBars,x

    // 40.000 $ werden gutgeschrieben
    ldx currentPlayerOffset_4
    add16To32 #$9c40 : playerMoney,x :  playerMoney,x
    inc gameDeptPawnBars

    // noch Schulden?
    lda playerMoney + 3, x
    and #$80
    bmi !skip+
    jmp gameDeptPawnEnd
!skip:
    // Noch mehr Positionen, weiter in Schleife
    cpy #0
    bne !loop-

!next:
    // Pfändung Wettbüro
    ldx currentPlayerNumber
    ldy playerBetting,x
    cpy #0      // nicht vorhanden? Dann überspringen
    bne !loop+
    jmp !next+
!loop:

    //  Anzahl verringern
    dey
    tya
    ldx currentPlayerNumber
    sta playerBetting,x

    // 80.000 $ werden gutgeschrieben
    ldx currentPlayerOffset_4
    add32 playerMoney,x : #$00013880 : playerMoney,x
    inc gameDeptPawnBetting

    // noch Schulden?
    lda playerMoney + 3, x
    and #$80
    bmi !skip+
    jmp gameDeptPawnEnd
!skip:
    // Noch mehr Positionen, weiter in Schleife
    cpy #0
    bne !loop-


!next:
    // Pfändung Spielsalon
    ldx currentPlayerNumber
    ldy playerGambling,x
    cpy #0      // nicht vorhanden? Dann überspringen
    bne !loop+
    jmp !next+
!loop:
    //  Anzahl verringern
    dey
    tya
    ldx currentPlayerNumber
    sta playerGambling,x

    // 150.000 $ werden gutgeschrieben
    ldx currentPlayerOffset_4
    add32 playerMoney,x : #$000249f0 : playerMoney,x
    inc gameDeptPawnGambling

    // noch Schulden?
    lda playerMoney + 3, x
    and #$80
    bmi !skip+
    jmp gameDeptPawnEnd
!skip:
    // Noch mehr Positionen, weiter in Schleife
    cpy #0
    bne !loop-


!next:
    // Pfändung Bordell
    ldx currentPlayerNumber
    ldy playerBrothels,x
    cpy #0      // nicht vorhanden? Dann überspringen
    bne !loop+
    jmp !next+
!loop:
    //  Anzahl verringern
    dey
    tya
    ldx currentPlayerNumber
    sta playerBrothels,x

    // 500.000 $ werden gutgeschrieben
    ldx currentPlayerOffset_4
    add32 playerMoney,x : #$0007a120 : playerMoney,x
    inc gameDeptPawnBrothels

    // noch Schulden?
    lda playerMoney + 3, x
    and #$80
    bmi !skip+
    jmp gameDeptPawnEnd
!skip:
    // Noch mehr Positionen, weiter in Schleife
    cpy #0
    bne !loop-

!next:
    // Pfändung Hotel
    ldx currentPlayerNumber
    ldy playerHotels,x
    cpy #0      // nicht vorhanden? Dann überspringen
    bne !loop+
    jmp gameDeptPawnEnd
!loop:
    //  Anzahl verringern
    dey
    tya
    ldx currentPlayerNumber
    sta playerHotels,x

    // 5.000.000 $ werden gutgeschrieben
    ldx currentPlayerOffset_4
    add32 playerMoney,x : #$004b4c40 : playerMoney,x
    inc gameDeptPawnHotels

    // noch Schulden?
    lda playerMoney + 3, x
    and #$80
    bmi !skip+
    jmp gameDeptPawnEnd
!skip:
    // Noch mehr Positionen, weiter in Schleife
    cpy #0
    bne !loop-


gameDeptPawnEnd:
    // Anzeige der Pfändungsgüter
    jsr CLEAR
    mov #RED : EXTCOL               // Roter Overscan
    mov #RED : BGCOL0               // Roter Hintergrund
    mov #BLACK : TEXTCOL            // Schwarze Schrift
    // Wurden Automaten gepfändet?
    mov16 #strDeptPawn1 : TextPtr // Text: "Stichtag"
    jsr Print_text

    mov16 #strDeptPawn2 : TextPtr // Text: "Folgendes wurde gepfändet"
    jsr Print_text

    lda gameDeptPawnSlotMachines
    cmp #0
    beq !skip+
    Print_hex8_dec gameDeptPawnSlotMachines
    plot_get
    ldy #4
    plot_set
    lda #'X'
    jsr BSOUT
    mov16 #strFinancesSlotMachines : TextPtr // Text: "Spielautomaten
    jsr Print_text
    lda #PET_CR
    jsr BSOUT
    lda #PET_CR
    jsr BSOUT
!skip:


    lda gameDeptPawnBars
    cmp #0
    beq !skip+
    Print_hex8_dec gameDeptPawnBars
    plot_get
    ldy #4
    plot_set
    lda #'X'
    jsr BSOUT
    mov16 #strFinancesBars : TextPtr // Text: "Bars
    jsr Print_text
    lda #PET_CR
    jsr BSOUT
    lda #PET_CR
    jsr BSOUT

!skip:
    lda gameDeptPawnBetting
    cmp #0
    beq !skip+
    Print_hex8_dec gameDeptPawnBetting
    plot_get
    ldy #4
    plot_set
    lda #'X'
    jsr BSOUT
    mov16 #strFinancesBetting : TextPtr // Text: "Wettbüro
    jsr Print_text
    lda #PET_CR
    jsr BSOUT
    lda #PET_CR
    jsr BSOUT

!skip:
    lda gameDeptPawnGambling
    cmp #0
    beq !skip+
    Print_hex8_dec gameDeptPawnGambling
    plot_get
    ldy #4
    plot_set
    lda #'X'
    jsr BSOUT
    mov16 #strFinancesGambling : TextPtr // Text: "Spielsalon
    jsr Print_text
    lda #PET_CR
    jsr BSOUT
    lda #PET_CR
    jsr BSOUT


!skip:
    lda gameDeptPawnBrothels
    cmp #0
    beq !skip+
    Print_hex8_dec gameDeptPawnBrothels
    plot_get
    ldy #4
    plot_set
    lda #'X'
    jsr BSOUT
    mov16 #strFinancesBrothels : TextPtr // Text: Bordell
    jsr Print_text
    lda #PET_CR
    jsr BSOUT
    lda #PET_CR
    jsr BSOUT

!skip:
    lda gameDeptPawnHotels
    cmp #0
    beq !skip+
    Print_hex8_dec gameDeptPawnHotels
    plot_get
    ldy #4
    plot_set
    lda #'X'
    jsr BSOUT
    mov16 #strFinancesHotels : TextPtr // Text: "Hotel
    jsr Print_text
    lda #PET_CR
    jsr BSOUT
    lda #PET_CR
    jsr BSOUT

!skip:
    mov16 #strDeptFired : TextPtr // Text: "Alle gefeuert"
    jsr Print_text
    mov16 #strPressKey : TextPtr // Text: Weiter
    jsr Print_text
    jsr Wait_for_key

    // Restschuldenerlass
    ldx currentPlayerOffset_4

    lda playerMoney + 3, x
    and #$80
    bpl !skip+
    clear32 playerMoney,x
!skip:
    jmp !nodept-    // Entferne Pfändungsflag

!end:
    rts
