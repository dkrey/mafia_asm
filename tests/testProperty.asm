#import "testHeader.asm"
#import "../gameFinances.asm"
#import "../gameProperty.asm"
#import "../gameWinningConditions.asm"
#import "../gameDebt.asm"

main:
mainNextPlayerLoop:
    // Spieler 1 Bertram sein
    lda #01
    sta currentPlayerNumber
    jsr calcPlayerOffsets

    // Einkommen berechnen und anzeigen
    jsr gameFinancesOverview

    // Schulden prüfen
    jsr gameDept

    // Gewonnen?
    jsr gameCheckWinningCondition

    jsr Wait_for_key
mainContinue:
    jmp main