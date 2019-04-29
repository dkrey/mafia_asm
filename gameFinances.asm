#importonce

gameFinancesCalcClearCurrent:
    clear32 currentTotalIncome
    clear32 currentTotalCosts
    clear32 currentSlotMachines
    clear32 currentProstitutes
    clear32 currentBars
    clear32 currentBetting
    clear32 currentGambling
    clear32 currentBrothels
    clear32 currentHotels
    clear32 currentGunfighters
    clear32 currentBodyguards
    clear32 currentGuards
    clear32 currentInformants
    clear32 currentAttorneys
    clear32 currentPolice
    clear32 currentInspectors
    clear32 currentJudges
    clear32 currentStateAttorneys
    clear32 currentMajors
    rts


#import "gameFinancesCosts.asm"
#import "gameFinancesIncome.asm"
#import "gameFinancesTotal.asm"




// Es wird geprüft, ob überhaupt was angezeigt werden muss
// Wenn kein Einkommen oder keine Ausgaben, dann weiter
gameFinancesOverview:
gameFinancesHasIncome:
    ldy currentPlayerNumber

    lda playerSlotMachines,y
    cmp #0
    beq !skip+
    jmp gameFinancesShow
!skip:
    lda playerProstitutes,y
    cmp #0
    beq !skip+
    jmp gameFinancesShow
!skip:
    lda playerBars,y
    cmp #0
    beq !skip+
    jmp gameFinancesShow
!skip:
    lda playerGambling,y
    cmp #0
    beq !skip+
    jmp gameFinancesShow
!skip:
    lda playerBetting,y
    cmp #0
    beq !skip+
    jmp gameFinancesShow
!skip:
    lda playerBrothels,y
    cmp #0
    beq !skip+
    jmp gameFinancesShow
!skip:
    lda playerHotels,y
    cmp #0
    beq !skip+
    jmp gameFinancesShow
!skip:

gameFinancesHasCosts:
!skip:
    lda playerGunfighters,y
    cmp #0
    beq !skip+
    jmp gameFinancesShow
!skip:
    lda playerBodyguards,y
    cmp #0
    beq !skip+
    jmp gameFinancesShow
!skip:
    lda playerGuards,y
    cmp #0
    beq !skip+
    jmp gameFinancesShow
!skip:
    lda playerInformants,y
    cmp #0
    beq !skip+
    jmp gameFinancesShow
!skip:
    lda playerAttorneys,y
    cmp #0
    beq !skip+
    jmp gameFinancesShow
!skip:
    lda playerPolice,y
    cmp #0
    beq !skip+
    jmp gameFinancesShow
!skip:
    lda playerInspectors,y
    cmp #0
    beq !skip+
    jmp gameFinancesShow
!skip:
    lda playerJudges,y
    cmp #0
    beq !skip+
    jmp gameFinancesShow
!skip:
    lda playerStateAttorneys,y
    cmp #0
    beq !skip+
    jmp gameFinancesShow
 !skip:
    lda playerMajors,y
    cmp #0
    beq !skip+
    jmp gameFinancesShow
!skip:
    rts

gameFinancesShow:
    jsr gameFinancesCalcClearCurrent
    jsr CLEAR
    mov #WHITE : EXTCOL             // Weißer Overscan
    mov #WHITE : BGCOL0             // Weißer Hintergrund
    mov #BLACK : TEXTCOL            // Schwarze Schrift

    jsr gameFinancesShowIncome      // Einkommen anzeigen
    mov16 #strPressKey : TextPtr    // Text: Weiter
    jsr Print_text
    jsr Wait_for_key

    jsr CLEAR

    jsr gameFinancesShowCosts       // Ausgaben anzeigen
    jsr gameFinancesShowTotal       // Gesamt

    // Schulden prüfen und setzen
    ldy currentPlayerOffset_4
    lda playerMoney + 3, y
    and #$80
    bpl !nodept+
    lda #$01
    ldy currentPlayerNumber
    sta playerDebtFlag,y

!nodept:
    lda #$00
    ldy currentPlayerNumber
    sta playerDebtFlag,y

    mov16 #strPressKey : TextPtr    // Text: Weiter
    jsr Print_text
    jsr Wait_for_key

    rts

currentTotalIncome:
    .dword $00000000
currentTotalCosts:
    .dword $00000000

// Income Temp Vars
currentSlotMachines:
    .dword $00000000
currentProstitutes:
    .dword $00000000
currentBars:
    .dword $00000000
currentBetting:
    .dword $00000000
currentGambling:
    .dword $00000000
currentBrothels:
    .dword $00000000
currentHotels:
    .dword $00000000


// Costs Temp Vars
currentGunfighters:
    .dword $00000000
currentBodyguards:
    .dword $00000000
currentGuards:
    .dword $00000000
currentInformants:
    .dword $00000000
currentAttorneys:
    .dword $00000000
currentPolice:
    .dword $00000000
currentInspectors:
    .dword $00000000
currentJudges:
    .dword $00000000
currentStateAttorneys:
    .dword $00000000
currentMajors:
    .dword $00000000

.pc = * "End?"