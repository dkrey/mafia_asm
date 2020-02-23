#import "testHeader.asm"
#import "../gameDebt.asm"
#import "../gameInformants.asm"
#import "../gameActionTheft.asm"

main:

mainNextPlayerLoop:
    jsr gameDept
    jsr smallTheft
    // Spieler 1 Bertram sein
    lda #01
    sta currentPlayerNumber
    jsr calcPlayerOffsets

    // Viele Informanten
    lda #$0f
    sta playerInformants,x

    // Informententest
    jsr gameCheckInformantHint


mainContinue:
    jsr main
