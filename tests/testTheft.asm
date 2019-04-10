#import "testHeader.asm"
#import "../gameActionTheft.asm"

main:
    // Spieler 1 Bertram sein
    lda #01
    sta currentPlayerNumber
    jsr calcPlayerOffsets

    // Raub Testen
    jsr smallTheft

continueMain:
    jsr main