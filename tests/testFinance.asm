#import "testHeader.asm"
#import "../gameFinances.asm"

main:
mainNextPlayerLoop:
    // Spieler 1 Bertram sein
    lda #01
    sta currentPlayerNumber
    jsr calcPlayerOffsets

    // Einkommen berechnen und anzeigen
    jsr gameFinancesShowIncome

mainContinue:
    jmp main