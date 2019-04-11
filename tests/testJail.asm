#import "testHeader.asm"
#import "../gameActionTheft.asm"

main:
    ldx #00                         // Durch die Spieler mit X zählen
                                    // Spieler 1 hat die 0
mainNextPlayerLoop:
    stx currentPlayerNumber         // Aktuelle Spielernummer sichern

    jsr calcPlayerOffsets

    // Spieler im Gefängnis?
    lda playerJailTotal, x
    cmp #0
    bne mainGotoJail

    jsr smallTheft

mainGotoJail:
    jmp gameJailStay                // Knast

mainContinue:
    ldx currentPlayerNumber         // Aktuelle Spielernummer wiederherstellen
    inx                             // nächster Spieler
    cpx playerCount                 // Solange x< Spieleranzahl
    bne mainNextPlayerLoop          // weiter mit Schleife, nächster Spieler
    jmp main                        // ansonsten ist Spieler 1 wieder dran
