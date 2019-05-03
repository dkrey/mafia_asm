#importonce


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

/*

    // Auf Schulden prüfen
    ldx currentPlayerNumber
    lda playerDebtFlag, x
    cmp #00
    bne !skip+
    jmp !end+
    */
// Schulden
gameDeptSet:
    ldx currentPlayerNumber
    lda playerDebtFlag, x
    cmp #01 // Hatte schon vorherschulden + Schuldenrunden verringern
    beq gameDeptRounds
    // neue Schulden
    lda #01
    sta playerDebtFlag,x
    // 6 Runden Zeit, die Schulden abzubauen
    lda #06
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

    Print_hex8_dec playerDebtRounds, x // Runden

    mov16 #strDeptInfo3 : TextPtr   // Text: zu begleichen
    jsr Print_text

    mov16 #strPressKey : TextPtr    // Text: Weiter
    jsr Print_text
    jsr Wait_for_key

    jmp !end+

gameDeptPawn:
    // TODO Pfändung
    jmp !nodept-

!end:
    rts