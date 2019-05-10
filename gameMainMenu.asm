#importonce

gameMainMenu:
    // Anzeige der Pfändungsgüter
    jsr CLEAR
    mov #BLACK : EXTCOL             // Schwarzer Overscan
    mov #RED : BGCOL0               // Roter Hintergrund
    mov #BLACK : TEXTCOL            // Schwarze Schrift

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

    cmp #$02
    bne !skip+
    jsr gameShopMenu
    rts
!skip:

    rts