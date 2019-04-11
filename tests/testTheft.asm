#import "testHeader.asm"
#import "../gameActionTheft.asm"

main:
    // Spieler 1 Bertram sein
    lda #01
    sta currentPlayerNumber
    jsr calcPlayerOffsets

    // Kleine Gaunerei testen
    jsr smallTheft

continueMain:
    jsr main