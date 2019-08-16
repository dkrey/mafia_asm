#import "testHeader.asm"
#import "../gameActionTheft.asm"
#import "../gameOverview.asm"

main:
mainNextPlayerLoop:
    // Spieler 1 Bertram sein
    lda #01
    sta currentPlayerNumber
    jsr calcPlayerOffsets

    jsr gameDisasterCheck
    // Kleine Gaunerei testen
    jsr gameOverviewMenu

mainContinue:
    jsr main
