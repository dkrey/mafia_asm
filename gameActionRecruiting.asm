#importonce

gameRecruitPriceGunfighters:
    .dword $00001770
gameRecruitPriceBodyguards:
    .dword $00000fa0
gameRecruitPriceInformants:
    .dword $000007d0
    .dword $00002710
gameRecruitPriceAttorneys:
    .dword $00001f40
gameRecruitPriceGuards:
    .dword $00000bb8




//===============================================================================
// shopping
//
//==============================================================================
gameRecruitingMenu:
    jsr CLEAR
    mov #BLACK : EXTCOL             //  Overscan
    mov #GREEN : BGCOL0             //  Hintergrund
    mov #WHITE : TEXTCOL            //  Schrift

    // Zeile 2, Spalte1
    ldx #02
    ldy #01
    clc
    jsr PLOT

    // Spielernamen anzeigen
    ldy currentPlayerOffset_16      // Offset für Spielernamen 16 Byte

    mov16 #playerNames : TextPtr
    jsr Print_text_offset           // Schreibe den Spielernamen

    lda #','
    jsr BSOUT
    lda #PET_CR                     // Zeilenumbruch
    jsr BSOUT

    mov16 #strYouHaveMoney : TextPtr // Text: "Sie haben"
    jsr Print_text

    ldy currentPlayerOffset_4       // Offset für dword holen: 4 Byte

    // Vermögen mit Offset in Dez anzeigen lassen
    mov32 currentTotalIncome : hex32dec_value
    jsr Print_hex32_dec_signed

    // mit Einheit $
    lda #' '
    jsr BSOUT
    lda #'$'
    jsr BSOUT

    mov16 #strPerRound : TextPtr // Text: "Pro Runde"
    jsr Print_text

    // Text: Überschrift
    mov16 #strRecruitingTitle : TextPtr
    jsr Print_text

    // Anzeige Revolverhelden
    mov16 #strRecruitingGunfighter : TextPtr
    jsr Print_text

    mov32 gameRecruitPriceGunfighters : hex32dec_value
    jsr Print_hex32_dec_signed
    lda PET_SPACE
    jsr BSOUT

    lda #'$'
    jsr BSOUT

    lda PET_SPACE
    jsr BSOUT

    mov16 #strPerRound : TextPtr // Text: "Pro Runde"
    jsr Print_text

    lda PET_CR
    jsr BSOUT



!end:
    // Text: Nichts
    mov16 #strSelectNothing : TextPtr
    jsr Print_text
    mov16 #strChoice : TextPtr
    jsr Print_text

//===============================================================================
// gameShop
//
// Auswahl im Shop
//===============================================================================
gameRecruitingChoice:
    // Abfrage, welche Position
    // Auswahl holen
    jsr GETIN
    cmp #$30        // sichergehen, dass es eine gültige Ziffer ist <= 0
    bcc gameRecruitingChoice
    cmp #$3a        // sichergehen, dass es eine gültige Ziffer ist >= #$3a
    bcs gameRecruitingChoice

    cmp #0                          // keine Eingabe und Enter, Abfrage erneut starten
    beq gameRecruitingChoice

    sec                             // Konv PetSCII Zeichen zur Zahl
    sbc #$30

    cmp #0              // Ziffer 0 = Exit
    beq branchRecruitingExit

    // Auswahl 1: Spielautomat
    cmp #1
    beq branchRecruitingGunfighters


branchRecruitingExit:
    rts
branchRecruitingGunfighters:
    jmp recruitGunfighters


recruitGunfighters:
    // einen Revolverhelden mumpiz
    ldx currentPlayerNumber
    lda playerGunfighters,x
    cmp #$fe // Überrollen verhindern
    bne !skip+
    jmp !exit+
!skip:
    inc playerGunfighters,x

!exit:
    jmp gameShopMenu

!end:
    rts
