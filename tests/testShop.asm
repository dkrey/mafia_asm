#import "testHeader.asm"
#import "../gameActionShop.asm"

main:
mainNextPlayerLoop:
    // Spieler 1 Bertram sein
    lda #01
    sta currentPlayerNumber
    jsr calcPlayerOffsets

    // Shop testen
    jsr gameShopMenu

mainContinue:
    jsr main