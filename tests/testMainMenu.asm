#import "testHeader.asm"
#import "../gameMainMenu.asm"
#import "../gameFinances.asm"
#import "../gameActionTheft.asm"
#import "../gameActionShop.asm"
#import "../gameActionRecruiting.asm"
#import "../gameActionBribery.asm"
#import "../gameOverview.asm"
#import "../gameActionTransfer.asm"
#import "../gameActionsMenu.asm"

main:
mainNextPlayerLoop:
    mov32 #$00001111 : currentTotalIncome
    // Spieler 1 Bertram sein
    lda #01
    sta currentPlayerNumber
    jsr calcPlayerOffsets

    jsr gameMainMenu

mainTheftOrMenu:
mainContinue:
    jsr main
