//===============================================================================
// Mafia ASM Project
//
/*
.disk [filename="mafiasm_b2.d64", name="MAFIA ASM" ] {
    [name="----------------", type="rel"],
    [name="MAFIA ASM       ", type="prg", segments="THEGAME" ],
    [name="----------------", type="rel"],
}

.segment THEGAME []
*/
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

#import "gameStringsDE.asm" // Language

#import "gameActionTheft.asm"
#import "gameJail.asm"
#import "gameFinances.asm"
#import "gameActionShop.asm"
#import "gameActionRecruiting.asm"
#import "gameActionBribery.asm"
#import "gameProperty.asm"
#import "gameActionTransfer.asm"
#import "gameOverview.asm"
#import "gameWinningConditions.asm"
#import "gameDebt.asm"
#import "gameMainMenu.asm"
#import "gameSetupPlayers.asm"
#import "gameJob.asm"
#import "gameDisaster.asm"
#import "gameActionGangwar.asm"
#import "gameInformants.asm"

//===============================================================================
// Spiel initialisieren
//===============================================================================

init:

    // Lower Case Char Mode
    //mov #$17: $D018

    // Disable C= + Shift
    mov #$80 : $0291

    jsr charsetAddUmlaut

//===============================================================================
// Titel anzeigen
//===============================================================================
showTitle:
    // clear the screen
    jsr CLEAR
    mov #RED:EXTCOL                 // Roter Overscan
    mov #YELLOW: BGCOL0             // Gelber Hintergrund

    mov16 #strVersion : TextPtr
    jsr Print_text

    ldx #06                         // Zeile setzen
    ldy #00                         // Spalte setzen

    mov16 #strTitleScreen : TextPtr    // Titelschirm ab Zeile 7 anzeigen
    jsr Print_text_xy                  // Text anzeigen
    jsr Wait_for_key                // auf Testendruck warten

    // Wie viele Spieler, welche Namen etc.
    jsr howManyPlayers

    ldx #00 // Spieler 0 beginnt
//===============================================================================
// Hauptschleife
//===============================================================================

// Durch die Spieler mit X zählen
mainNextPlayerLoop:
    stx currentPlayerNumber         // Aktuelle Spielernummer sichern

    jsr calcPlayerOffsets           // Offsets für den Speicher berechnen

    jsr gameDisasterCheck           // Schicksalschläge

    jsr gameJobCheck                // Parasit an Board?

    jsr gameFinancesOverview        // Eingaben und Ausgaben

    // Schulden prüfen
    jsr gameDept

    // Besitzverhältnisse ausrechnen und prüfen ob gewonnen
    jsr gameCheckWinningCondition

    // Spiel vorbei, wieder von vorn
    lda gameOver
    cmp #00
    beq !skip+
    jsr resetGame
    jmp showTitle
!skip:

mainTheftOrMenu:
    // Spieler im Gefängnis?
    ldx currentPlayerNumber         // Aktuelle Spielernummer wiederherstellen
    lda playerJailTotal, x
    cmp #0
    bne mainGotoJail

    jsr gameCheckInformantHint      // Vielleicht hat der Informant einen Tipp

    // Wenn Vermögen < 20.000 $ bzw 00004e20h dann nur kleine Diebstähle
    ldy currentPlayerOffset_4       // Offset für dword holen: 4 Byte

    compare32 playerMoney,y : minMoneyForMenu
    bcc mainNoMoney
    jmp mainMenu                    // Geld ist vorhanden, ab ins Hauptmenü
                                    // Bei Schulden ist das Hauptmenü auch erlaubt

mainGotoJail:
    jmp gameJailStay                // Knast

mainNoMoney:
    // Menü-Flag setzen, ohne Hauptmenü kann direkt eingekaft werden.
    lda #0
    sta playerCameFromMenu

    jsr smallTheft                  // Kein Geld, nur kleine Diebstähle
    jmp mainContinue

mainMenu:
    jsr gameMainMenu

mainContinue:
    ldx currentPlayerNumber         // Aktuelle Spielernummer wiederherstellen
    inx                             // nächster Spieler
    cpx playerCount                 // Solange x< Spieleranzahl weiter mit Schleife,
    bne !skip+                      // ansonsten ist
    ldx #00                         // Spieler 0 wieder dran
!skip:
    jmp mainNextPlayerLoop
