#import "testHeader.asm"
#import "../gameActionTheft.asm"

main:
mainNextPlayerLoop:
    // Spieler 1 Bertram sein
    lda #01
    sta currentPlayerNumber
    jsr calcPlayerOffsets

    jsr gameJobCheck
    // Kleine Gaunerei testen
    jsr smallTheft

mainContinue:
    jsr main