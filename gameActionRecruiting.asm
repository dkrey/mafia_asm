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
    lda #PET_SPACE
    jsr BSOUT
    lda #'1'
    jsr BSOUT
    lda #'.'
    jsr BSOUT
    mov16 #strFinancesGunfighters : TextPtr
    jsr Print_text
    lda #PET_SPACE
    jsr BSOUT
    mov32 gameRecruitPriceGunfighters : hex32dec_value
    jsr Print_hex32_dec_signed
    lda #'$'
    jsr BSOUT

    mov16 #strPerRound : TextPtr // Text: "Pro Runde"
    jsr Print_text
    lda #':'
    jsr BSOUT

    lda #' '
    jsr BSOUT

    ldy currentPlayerNumber
    Print_hex8_dec playerGunfighters,y

    lda #PET_CR
    jsr BSOUT

    // Anzeige Leibwächter
    lda #PET_SPACE
    jsr BSOUT
    lda #'2'
    jsr BSOUT
    lda #'.'
    jsr BSOUT
    mov16 #strFinancesBodyguards : TextPtr
    jsr Print_text
    lda #PET_SPACE
    jsr BSOUT
    mov32 gameRecruitPriceBodyguards : hex32dec_value
    jsr Print_hex32_dec_signed
    lda #'$'
    jsr BSOUT

    mov16 #strPerRound : TextPtr // Text: "Pro Runde"
    jsr Print_text
    lda #':'
    jsr BSOUT

    lda #' '
    jsr BSOUT

    ldy currentPlayerNumber
    Print_hex8_dec playerBodyguards,y

    lda #PET_CR
    jsr BSOUT

  // Anzeige Nachwächter
    lda #PET_SPACE
    jsr BSOUT
    lda #'3'
    jsr BSOUT
    lda #'.'
    jsr BSOUT
    mov16 #strFinancesGuards : TextPtr
    jsr Print_text
    lda #PET_SPACE
    jsr BSOUT
    mov32 gameRecruitPriceGuards : hex32dec_value
    jsr Print_hex32_dec_signed
    lda #'$'
    jsr BSOUT

    mov16 #strPerRound : TextPtr // Text: "Pro Runde"
    jsr Print_text
    lda #':'
    jsr BSOUT

    lda #' '
    jsr BSOUT

    ldy currentPlayerNumber
    Print_hex8_dec playerGuards,y

    lda #PET_CR
    jsr BSOUT

  // Anzeige Informant
    lda #PET_SPACE
    jsr BSOUT
    lda #'4'
    jsr BSOUT
    lda #'.'
    jsr BSOUT
    mov16 #strFinancesInformants : TextPtr
    jsr Print_text
    lda #PET_SPACE
    jsr BSOUT
    mov32 gameRecruitPriceInformants : hex32dec_value
    jsr Print_hex32_dec_signed
    lda #'$'
    jsr BSOUT

    mov16 #strPerRound : TextPtr // Text: "Pro Runde"
    jsr Print_text
    lda #':'
    jsr BSOUT

    lda #' '
    jsr BSOUT

    ldy currentPlayerNumber
    Print_hex8_dec playerInformants,y

    lda #PET_CR
    jsr BSOUT

  // Anzeige Anwälte
    lda #PET_SPACE
    jsr BSOUT
    lda #'5'
    jsr BSOUT
    lda #'.'
    jsr BSOUT
    mov16 #strFinancesAttorneys : TextPtr
    jsr Print_text
    lda #PET_SPACE
    jsr BSOUT
    mov32 gameRecruitPriceAttorneys : hex32dec_value
    jsr Print_hex32_dec_signed
    lda #'$'
    jsr BSOUT

    mov16 #strPerRound : TextPtr // Text: "Pro Runde"
    jsr Print_text
    lda #':'
    jsr BSOUT

    lda #' '
    jsr BSOUT

    ldy currentPlayerNumber
    Print_hex8_dec playerAttorneys,y

    lda #PET_CR
    jsr BSOUT

  // Anzeige Alle feuern
    lda #PET_CR
    jsr BSOUT
    lda #PET_SPACE
    jsr BSOUT
    lda #'6'
    jsr BSOUT
    lda #'.'
    jsr BSOUT
    mov16 #strRecruitingFireAll : TextPtr
    jsr Print_text

    lda #PET_CR
    jsr BSOUT

    lda #PET_CR
    jsr BSOUT

!end:
    // Text: Nichts
    mov16 #strBack : TextPtr
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

    // Auswahl 1: Revolverheld
    cmp #1
    beq branchRecruitingGunfighters

    // Auswahl 2: Leibwächter
    cmp #2
    beq branchRecruitingBodyguards

    // Auswahl 3: Nachtwächter
    cmp #3
    beq branchRecruitingGuards

    // Auswahl 4: Informanten
    cmp #4
    beq branchRecruitingInformants

    // Auswahl 5: Anwälte
    cmp #5
    beq branchRecruitingAttorneys

    // Auswahl 6: alle feuern
    cmp #6
    beq branchRecruitingFireAll

branchRecruitingExit:
    rts
branchRecruitingGunfighters:
    jmp recruitGunfighters
branchRecruitingBodyguards:
    jmp recruitBodyguards
branchRecruitingGuards:
    jmp recruitGuards
branchRecruitingInformants:
    jmp recruitInformants
branchRecruitingAttorneys:
    jmp recruitAttorneys
branchRecruitingFireAll:
    jmp recruitFireAll

recruitGunfighters:
    // einen Revolverhelden mumpiz
    ldx currentPlayerNumber
    lda playerGunfighters,x
    cmp #$fe // Überrollen verhindern
    bne !skip+
    jmp !exit+
!skip:
    inc playerGunfighters,x
    jmp !exit+

recruitBodyguards:
    // einen Revolverhelden mumpiz
    ldx currentPlayerNumber
    lda playerBodyguards,x
    cmp #$fe // Überrollen verhindern
    bne !skip+
    jmp !exit+
!skip:
    inc playerBodyguards,x
    jmp !exit+

recruitGuards:
    // einen Revolverhelden mumpiz
    ldx currentPlayerNumber
    lda playerGuards,x
    cmp #$fe // Überrollen verhindern
    bne !skip+
    jmp !exit+
!skip:
    inc playerGuards,x
    jmp !exit+

recruitInformants:
    // einen Revolverhelden mumpiz
    ldx currentPlayerNumber
    lda playerInformants,x
    cmp #$fe // Überrollen verhindern
    bne !skip+
    jmp !exit+
!skip:
    inc playerInformants,x
    jmp !exit+

recruitAttorneys:
    // einen Revolverhelden mumpiz
    ldx currentPlayerNumber
    lda playerAttorneys,x
    cmp #$fe // Überrollen verhindern
    bne !skip+
    jmp !exit+
!skip:
    inc playerAttorneys,x
    jmp !exit+

recruitFireAll:
    // Alle Schergen feuern
    ldx currentPlayerNumber
    lda #0
    sta playerAttorneys,x
    sta playerInformants,x
    sta playerGuards,x
    sta playerBodyguards,x
    sta playerGunfighters,x

!exit:
    jmp gameRecruitingMenu

!end:
    rts
