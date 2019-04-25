//===============================================================================
// Mafia ASM Project
//
.encoding "petscii_mixed"
//===============================================================================
// Set the Basic Loader
BasicUpstart2(init)

//===============================================================================
// import all game files
//

#import "libConstants.asm"
#import "libCharset.asm"
#import "libMacros.asm"
#import "gameMemory.asm"
#import "libText.asm"
#import "libInput.asm"
#import "libRandom.asm"
#import "libMath.asm"
#import "gameStringsDE.asm"
#import "gameActionTheft.asm"
#import "gameJail.asm"
#import "gameFinances.asm"

//===============================================================================
// Spiel initialisieren
//===============================================================================

init:

    // Lower Case Char Mode
    //mov #$17: $D018

    // Disable C= + Shift
    mov #$80 : $0291

    jsr charsetAddUmlaut
    // clear the screen
    jsr CLEAR

//===============================================================================
// Titel anzeigen
//===============================================================================
showTitle:
    mov #RED:EXTCOL                 // Roter Overscan
    mov #YELLOW: BGCOL0             // Gelber Hintergrund

    ldx #07                         // Zeile setzen
    ldy #00                         // Spalte setzen

    mov16 #strTitleScreen : TextPtr    // Titelschirm ab Zeile 7 anzeigen
    jsr Print_text_xy                  // Text anzeigen
    jsr Wait_for_key                // auf Testendruck warten

    // Wie viele Spiele, welche Namen etc.
    #import "gameSetupPlayers.asm"

//===============================================================================
// Hauptschleife
//===============================================================================
main:
    ldx #00                         // Durch die Spieler mit X zählen
                                    // Spieler 1 hat die 0
mainNextPlayerLoop:
    stx currentPlayerNumber         // Aktuelle Spielernummer sichern

    jsr calcPlayerOffsets           // Offsets für den Speicher berechnen

    jsr gameFinancesOverview        // Eingaben und Ausgaben

    // Spieler im Gefängnis?
    ldx currentPlayerNumber         // Aktuelle Spielernummer wiederherstellen
    lda playerJailTotal, x
    cmp #0
    bne mainGotoJail

    // Wenn Vermögen < 20.000 $ bzw 00004e20h dann nur kleine Diebstähle
    ldy currentPlayerOffset_4       // Offset für dword holen: 4 Byte

    compare32 playerMoney,y : minMoneyForMenu
    bcc mainNoMoney
    jmp mainMenu                    // Geld ist vorhanden, ab ins Hauptmenü

mainGotoJail:
    jmp gameJailStay                // Knast

mainNoMoney:
    jmp smallTheft                  // Kein Geld, nur kleine Diebstähle

mainMenu:
    mov #GREEN : BGCOL0               // Debug
    jsr Wait_for_key

mainContinue:
    ldx currentPlayerNumber         // Aktuelle Spielernummer wiederherstellen
    inx                             // nächster Spieler
    cpx playerCount                 // Solange x< Spieleranzahl
    bne mainNextPlayerLoop          // weiter mit Schleife, nächster Spieler
    jmp main                        // ansonsten ist Spieler 1 wieder dran


//===============================================================================

