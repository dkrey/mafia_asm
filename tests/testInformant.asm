#import "testHeader.asm"
#import "../gameInformants.asm"
#import "../gameActionTheft.asm"

main:
mainNextPlayerLoop:
    // Spieler 1 Bertram sein
    lda #01
    sta currentPlayerNumber
    jsr calcPlayerOffsets

    // Viele Informanten
    lda #$0f
    sta playerInformants,x

    // Informententest
    jsr gameCheckInformantHint
    jsr smallTheft

mainContinue:
    jsr main