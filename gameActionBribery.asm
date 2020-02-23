#importonce

gameBribePricePolice:
    .dword $00000BB8
gameBribePriceInspectors:
    .dword $00002EE0
gameBribePriceJudges:
    .dword $00007530
gameBribePriceStateAttorneys:
    .dword $00011170
gameBribePriceMajors:
    .dword $000186A0


//===============================================================================
// Bribery
//
//==============================================================================
gameBriberyMenu:
    jsr CLEAR
    mov #RED : EXTCOL             //  Overscan
    mov #LIGHT_RED : BGCOL0             //  Hintergrund
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

    mov16 #strYouHave : TextPtr // Text: "Sie haben"
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
    mov16 #strBriberyTitle : TextPtr
    jsr Print_text

    // Anzeige Pozilei
    lda #PET_SPACE
    jsr BSOUT
    lda #'1'
    jsr BSOUT
    lda #'.'
    jsr BSOUT
    mov16 #strFinancesPolice : TextPtr
    jsr Print_text
    lda #PET_SPACE
    jsr BSOUT
    mov32 gameBribePricePolice : hex32dec_value
    jsr Print_hex32_dec_signed
    lda #'$'
    jsr BSOUT
    lda #' '
    jsr BSOUT
    jsr BSOUT
    mov16 #strPerRound : TextPtr // Text: "Pro Runde"
    jsr Print_text
    lda #':'
    jsr BSOUT

    lda #' '
    jsr BSOUT

    ldy currentPlayerNumber
    Print_hex8_dec playerPolice,y

    lda #PET_CR
    jsr BSOUT

    // Anzeige Inspektoren
    lda #PET_SPACE
    jsr BSOUT
    lda #'2'
    jsr BSOUT
    lda #'.'
    jsr BSOUT
    mov16 #strFinancesInspectors : TextPtr
    jsr Print_text
    lda #PET_SPACE
    jsr BSOUT
    mov32 gameBribePriceInspectors : hex32dec_value
    jsr Print_hex32_dec_signed
    lda #'$'
    jsr BSOUT

    lda #' '
    jsr BSOUT

    mov16 #strPerRound : TextPtr // Text: "Pro Runde"
    jsr Print_text
    lda #':'
    jsr BSOUT

    lda #' '
    jsr BSOUT

    ldy currentPlayerNumber
    Print_hex8_dec playerInspectors,y

    lda #PET_CR
    jsr BSOUT

  // Anzeige Richter
    lda #PET_SPACE
    jsr BSOUT
    lda #'3'
    jsr BSOUT
    lda #'.'
    jsr BSOUT
    mov16 #strFinancesJudges : TextPtr
    jsr Print_text
    lda #PET_SPACE
    jsr BSOUT
    mov32 gameBribePriceJudges : hex32dec_value
    jsr Print_hex32_dec_signed
    lda #'$'
    jsr BSOUT

    lda #' '
    jsr BSOUT
    mov16 #strPerRound : TextPtr // Text: "Pro Runde"
    jsr Print_text
    lda #':'
    jsr BSOUT

    lda #' '
    jsr BSOUT

    ldy currentPlayerNumber
    Print_hex8_dec playerJudges,y

    lda #PET_CR
    jsr BSOUT

  // Anzeige Staatsanwalt
    lda #PET_SPACE
    jsr BSOUT
    lda #'4'
    jsr BSOUT
    lda #'.'
    jsr BSOUT
    mov16 #strFinancesStateAttorneys : TextPtr
    jsr Print_text
    lda #PET_SPACE
    jsr BSOUT
    mov32 gameBribePriceStateAttorneys : hex32dec_value
    jsr Print_hex32_dec_signed
    lda #'$'
    jsr BSOUT

    lda #' '
    jsr BSOUT
    mov16 #strPerRound : TextPtr // Text: "Pro Runde"
    jsr Print_text
    lda #':'
    jsr BSOUT

    lda #' '
    jsr BSOUT

    ldy currentPlayerNumber
    Print_hex8_dec playerStateAttorneys,y

    lda #PET_CR
    jsr BSOUT

  // Anzeige Bürgermeister
    lda #PET_SPACE
    jsr BSOUT
    lda #'5'
    jsr BSOUT
    lda #'.'
    jsr BSOUT
    mov16 #strFinancesMajors : TextPtr
    jsr Print_text
    lda #PET_SPACE
    jsr BSOUT
    mov32 gameBribePriceMajors : hex32dec_value
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
    Print_hex8_dec playerMajors,y

    lda #PET_CR
    jsr BSOUT

  // Anzeige Computer

    lda #PET_SPACE
    jsr BSOUT
    lda #'6'
    jsr BSOUT
    lda #'.'
    jsr BSOUT
    mov16 #strBriberyComputer1 : TextPtr
    jsr Print_text

    lda #PET_CR
    jsr BSOUT

    lda #PET_CR
    jsr BSOUT

  // Anzeige Alle feuern
    lda #PET_CR
    jsr BSOUT
    lda #PET_SPACE
    jsr BSOUT
    lda #'7'
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
gameBribeChoice:
    // Abfrage, welche Position
    // Auswahl holen
    jsr GETIN
    cmp #$30        // sichergehen, dass es eine gültige Ziffer ist <= 0
    bcc gameBribeChoice
    cmp #$3a        // sichergehen, dass es eine gültige Ziffer ist >= #$3a
    bcs gameBribeChoice

    cmp #0                          // keine Eingabe und Enter, Abfrage erneut starten
    beq gameBribeChoice

    sec                             // Konv PetSCII Zeichen zur Zahl
    sbc #$30

    cmp #0              // Ziffer 0 = Exit
    beq branchBribeExit

    // Auswahl 1: Polizist
    cmp #1
    beq branchBribePolice

    // Auswahl 2: Inspektoren
    cmp #2
    beq branchBribeInspectors

    // Auswahl 3: Richter
    cmp #3
    beq branchBribeJudges

    // Auswahl 4: Staatsanwälte
    cmp #4
    beq branchBribeStateAttorneys

    // Auswahl 5: Bürgermeister
    cmp #5
    beq branchBribeMajors

    // Auswahl 7: Computer
    cmp #6
    beq branchBribeComputer

    // Auswahl 7: alle feuern
    cmp #7
    beq branchBribeFireAll

branchBribeExit:
    rts
branchBribePolice:
    jmp bribePolice
branchBribeInspectors:
    jmp bribeInspectors
branchBribeJudges:
    jmp bribeJudges
branchBribeStateAttorneys:
    jmp bribeStateAttorneys
branchBribeMajors:
    jmp bribeMajors
branchBribeComputer:
    jmp bribeComputer
branchBribeFireAll:
    jmp bribeFireAll

bribePolice:
    ldx currentPlayerNumber
    lda playerPolice,x
    cmp #$fe // Überrollen verhindern
    bne !skip+
    jmp !exit+
!skip:
    inc playerPolice,x
    jmp !exit+

bribeInspectors:
    ldx currentPlayerNumber
    lda playerInspectors,x
    cmp #$fe // Überrollen verhindern
    bne !skip+
    jmp !exit+
!skip:
    inc playerInspectors,x
    jmp !exit+

bribeJudges:
    ldx currentPlayerNumber
    lda playerJudges,x
    cmp #$fe // Überrollen verhindern
    bne !skip+
    jmp !exit+
!skip:
    inc playerJudges,x
    jmp !exit+

bribeStateAttorneys:
    ldx currentPlayerNumber
    lda playerStateAttorneys,x
    cmp #$fe // Überrollen verhindern
    bne !skip+
    jmp !exit+
!skip:
    inc playerStateAttorneys,x
    jmp !exit+

bribeMajors:
    ldx currentPlayerNumber
    lda playerMajors,x
    cmp #$fe // Überrollen verhindern
    bne !skip+
    jmp !exit+
!skip:
    inc playerMajors,x
    jmp !exit+

bribeComputer:
    lda #PET_CR
    jsr BSOUT
    mov16 #strBriberyComputer2 : TextPtr // Text: "Pro Runde"
    jsr Print_text
    jsr Wait_for_key
    lda #PET_CR
    jsr BSOUT

    jmp !exit+

bribeFireAll:
    // Alle Schergen feuern
    ldx currentPlayerNumber
    lda #0
    sta playerPolice,x
    sta playerInspectors,x
    sta playerJudges,x
    sta playerStateAttorneys,x
    sta playerMajors,x

!exit:
    jmp gameBriberyMenu

!end:
    rts
