#importonce

gameMainMenu:
    // Anzeige der Pfändungsgüter
    jsr CLEAR
    mov #BLACK : EXTCOL             // Schwarzer Overscan
    mov #RED : BGCOL0               // Roter Hintergrund
    mov #BLACK : TEXTCOL            // Schwarze Schrift

   // Spielernamen anzeigen
    ldy currentPlayerOffset_16      // Offset für Spielernamen 16 Byte

    lda #PET_CR                     // Zeilenumbruch
    jsr BSOUT
    lda #' '
    jsr BSOUT
    mov16 #playerNames : TextPtr
    jsr Print_text_offset           // Schreibe den Spielernamen

    lda #','
    jsr BSOUT
    lda #PET_CR                     // Zeilenumbruch
    jsr BSOUT
    // Hauptmenü
    mov16 #strMainMenuTitle : TextPtr
    jsr Print_text

gameMainMenuChoice:
    // Auswahl holen
    jsr GETIN
    cmp #$30        // sichergehen, dass es eine gültige Ziffer ist <= 0
    bcc gameMainMenuChoice
    cmp #$3a        // sichergehen, dass es eine gültige Ziffer ist >= #$3a
    bcs gameMainMenuChoice
    sec             // PetSCII -> Dezimal also 47 abziehen
    sbc #$30

    cmp #$00
    beq gameMainMenuChoice // 0 oder Enter = Nochmal

    cmp #$01        // 1. kleine Diebstähle... dieses Wort...
    bne !skip+
    jmp smallTheft
!skip:

    cmp #$02        // 2. Shop
    bne !skip+
    jsr gameShopMenu
    rts
!skip:

    cmp #$03        // 3. Rekrutierung
    bne !skip+
    jsr gameRecruitingMenu
    rts
!skip:

    cmp #$04        // 4. Bestechung
    bne !skip+
    jsr gameBriberyMenu
    rts
!skip:
    cmp #$05        // 4. Bestechung
    bne !skip+
    jsr gameActionsMenu
    rts
!skip:

    cmp #$06        // 6. Geldtransfer
    bne !skip+
    jsr gameTransferMenu
    rts
!skip:

    cmp #$07        // 7. Besitz - beende die Runde nicht
    bne !skip+
    jsr gameOverviewMenu
    jmp gameMainMenu
!skip:
    rts
