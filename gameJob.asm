#importonce

gameJobCheck:
    // Prüfen, ob sich ein Mitspieler eingeschlichen hat
    ldx currentPlayerNumber
    lda playerEmployee, x
    sta ZeroPageTemp

    cmp #0
    bne gameJobContinue
    rts

gameJobContinue:
    jsr CLEAR

    mov #BLACK  : EXTCOL            // Schwarzer Overscan
    mov #BLACK  : BGCOL0            // Schwarzer Hintergrund
    mov #GREEN : TEXTCOL            // Grüne Schrift

    dec ZeroPageTemp                // Das +1 wieder entfernen

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

    // Überschrift
    mov16 #strTheftJobIntro1 : TextPtr
    jsr Print_text

    // Gehalt anzeigen und gleich abziehen, mindestens 1000$
    ldx currentPlayerOffset_4
    getRandomRange32 #$000003e8 : playerIncome,x
    sub32 playerMoney, x : rnd32_result : playerMoney, x

    // Gehalt dem Mitarbeiter gutschreiben
    lda ZeroPageTemp
    asl
    asl
    tax
    add32 playerMoney, x : rnd32_result : playerMoney, x

    // Gehalt anzeigen
    mov32 rnd32_result : hex32dec_value
    jsr Print_hex32_dec

    // Arbeitnehmer anzeigen
    mov16 #strTheftJobIntro2 : TextPtr
    jsr Print_text
    lda #' '
    jsr BSOUT

    mov16 #playerNames : TextPtr
    lda ZeroPageTemp
    asl
    asl
    asl
    asl
    tay
    jsr Print_text_offset

    // Berufsüberschrift
    mov16 #strTheftJobIntro3 : TextPtr
    jsr Print_text

    // Beruf ausknobeln und anzeigen
    getRandomRange8 #0 : #7
    tax
    lda job_table_low, x
    sta TextPtr
    lda job_table_high, x
    sta TextPtr + 1
    jsr Print_text

    lda #'.'
    jsr BSOUT

    lda #PET_CR
    jsr BSOUT

    mov16 #strPressKey : TextPtr    // Text: Weiter
    jsr Print_text
    jsr Wait_for_key

    // Mitarbeiter löschen
    lda #0
    ldx currentPlayerNumber
    sta playerEmployee,x
    rts

job_table_low:
    .byte <strTheftJob1, <strTheftJob2, <strTheftJob3, <strTheftJob4
    .byte <strTheftJob5, <strTheftJob6, <strTheftJob7, <strTheftJob8

job_table_high:
    .byte >strTheftJob1, >strTheftJob2, >strTheftJob3, >strTheftJob4
    .byte >strTheftJob5, >strTheftJob6, >strTheftJob7, >strTheftJob8
