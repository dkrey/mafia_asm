#import "testHeader.asm"
#import "../gameOverview.asm"
#import "../gameDebt.asm"
#import "../gameInformants.asm"
#import "../gameActionTheft.asm"

main:

mainNextPlayerLoop:
    //jsr gameDept
    jsr gameOverviewMenu
    jsr smallTheft
    // Spieler 2 Bertram sein
    lda #01
    sta currentPlayerNumber
    jsr calcPlayerOffsets

    // Viele Informanten
    lda #$0f
    sta playerInformants,x

    // Informententest
    jsr gameCheckInformantHint
    // Schulden prüfen
    jsr gameDept


mainContinue:
    jsr main
