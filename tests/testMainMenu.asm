#import "testHeader.asm"
#import "../gameMainMenu.asm"
#import "../gameActionTheft.asm"
#import "../gameActionShop.asm"


main:
mainNextPlayerLoop:
    // Spieler 1 Bertram sein
    lda #01
    sta currentPlayerNumber
    jsr calcPlayerOffsets

    // Kleine Gaunerei testen
    jsr gameMainMenu

mainContinue:
    jsr main