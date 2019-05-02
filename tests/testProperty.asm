#import "testHeader.asm"
#import "../gameFinances.asm"
#import "../gameProperty.asm"

main:
mainNextPlayerLoop:
    // Spieler 1 Bertram sein
    lda #01
    sta currentPlayerNumber
    jsr calcPlayerOffsets

    // Einkommen berechnen und anzeigen
    jsr gameFinancesOverview

    // Besitzverhältnisse anzeigen
    jsr gamePropertyShow
    jsr Wait_for_key
mainContinue:
    jmp main