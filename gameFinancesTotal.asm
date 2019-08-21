#importonce

gameFinancesCalcTotal:
    ldy currentPlayerOffset_4
    add32 currentTotalIncome : playerMoney,y : playerMoney,y
    sub32 playerMoney,y : currentTotalCosts : playerMoney,y
    // store current income
    mov32 currentTotalIncome : playerIncome,y
    rts

gameFinancesShowTotal:
    mov16 #strFinancesFinal : TextPtr // Text: Damit beträgt ihr Vermögen
    jsr Print_text
    plot_get
    ldy #25
    plot_set
    lda #'$'
    jsr BSOUT
    lda #' '
    jsr BSOUT

    ldy currentPlayerOffset_4       // Offset für dword holen: 4 Byte

    // Vermögen mit Offset in Dez anzeigen lassen
    mov32 playerMoney,y : hex32dec_value
    jsr Print_hex32_dec_signed
    lda #PET_CR
    jsr BSOUT

    // Einkommen +
    plot_get
    ldy #23
    plot_set
    lda #'+'
    jsr BSOUT
    lda #' '
    jsr BSOUT
    lda #'$'
    jsr BSOUT
    lda #' '
    jsr BSOUT

    mov32 currentTotalIncome : hex32dec_value
    jsr Print_hex32_dec
    lda #PET_CR
    jsr BSOUT

    // Ausgaben -
    plot_get
    ldy #23
    plot_set
    lda #'-'
    jsr BSOUT
    lda #' '
    jsr BSOUT
    lda #'$'
    jsr BSOUT
    lda #' '
    jsr BSOUT

    mov32 currentTotalCosts : hex32dec_value
    jsr Print_hex32_dec
    lda #PET_CR
    jsr BSOUT

    // Line
    plot_get
    ldy #23
    plot_set
    mov16 #strLine14: TextPtr
    jsr Print_text

    // Gesamt inkl. Rechnung
    plot_get
    ldy #23
    plot_set
    lda #'='
    jsr BSOUT
    lda #' '
    jsr BSOUT
    lda #'$'
    jsr BSOUT
    lda #' '
    jsr BSOUT

    jsr gameFinancesCalcTotal
    mov32 playerMoney,y : hex32dec_value
    jsr Print_hex32_dec_signed
    lda #PET_CR
    jsr BSOUT
    rts