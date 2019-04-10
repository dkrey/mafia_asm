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
#import "helpers.asm"
#import "gameMemory.asm"
#import "libText.asm"
#import "libInput.asm"
#import "libMath.asm"
#import "gameStringsDE.asm"
#import "gameActionTheft.asm"

//===============================================================================
// Spiel initialisieren
//===============================================================================


init:

    .encoding "screencode_mixed"
    // Lower Case Char Mode
    //mov #$17: $D018

    // Disable C= + Shift
    mov #$80 : $0291

    jsr charsetAddUmlaut
    // clear the screen
    jsr CLEAR


//===============================================================================
// DEBUGDEBUGDEBUGDEBUGDEBUG
//===============================================================================
    //mov #08 : playerCount
    //jmp main // DEBUG

//===============================================================================
// DEBUGDEBUGDEBUGDEBUGDEBUG
//===============================================================================

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

//===============================================================================
// Wie viele spielen mit
//===============================================================================
howManyPlayers:
    // Farben setzen
    mov #BLACK : EXTCOL             // Schwarzer Overscan
    mov #BLUE : BGCOL0              // Blauer Hintergrund

    ldx #01                         // Zeile setzen
    ldy #01                         // Spalte setzen

    mov16 #strHowManyScreen : TextPtr  // Adresse vom Text setzen
    jsr Print_text_xy                  // Text anzeigen

    ldy #1
                      // Anzahl Zeichen für die Input Routine: 1
    ldx #<filter_num_players        // Filter setzen LSB: Zahlen 1-8
    lda #>filter_num_players        // Filter setzen MSB: Zahlen 1-8

    jsr Get_filtered_input          // Input holen und speichern
    lda got_input                   // Ergebnis holen
    cmp #0                          // Prüfen, ob Spieleranzahl stimmt
    beq howManyPlayers              // Wenn einfach nur Enter gedrückt wurde,
                                    //  nochmal von vorn

    sec                             // Konv PetSCII Zeichen zur Zahl
    sbc #$30
    sta playerCount                 // Abspeichern und Schluss

//===============================================================================
// Wer spielt mit
//===============================================================================
    ldx #00                         // X-Register mit Spieleranzahl beladen
enterNames:                         // Spielernamen eingeben
    mov16 #strEnterName : TextPtr   // "Namen eingeben" anzeigen
    jsr Print_text
    stx currentPlayerNumber         // X-Wert sichern, weil GetInput ihn überschreibt
    txa
    clc                             // Dazu 0x30h addieren, wegen PetSCI und Ziffer
    adc #$31                        // und außerdem noch +1 weil von 0 gezählt
    jsr BSOUT
    lda #'?'                        // Fragezeichen am Satzende
    jsr BSOUT
    lda #' '                        // Leerzeichen hintendran
    jsr BSOUT

    ldy #playerNameLength-1         // 16 Zeichen darf der Name haben aber Byte 0 am Ende, also 15

    ldx #<filter_alphanumeric       // Diese Zeichen sind erlaubt
    lda #>filter_alphanumeric

    jsr Get_filtered_input

    ldx currentPlayerNumber         // Aktuelle Spielerzahl für Offset-Schleife

    txa                             // X in den Akku und mit 16 multiplizieren
    .for (var i = 0; i < 4; i++) {  // *2^4 = *16
        asl
    }
    tay                             // Offset aus Akku nach Y

    mov16 #playerNames : TextPtr
    //lda #<playerNames              //  Zieladresse für den Spielernamen
    //sta TextPtr                    //           an TextPtr schreiben
    //lda #>playerNames
    //sta TextPtr+1

    jsr Move_input_to_TextPtr       // Namen an die neue Speicherstelle schreiben
    ldx currentPlayerNumber         // X-Wert aus Temp holen
    inx                             // Spielerzähler erhöhen
    cpx playerCount                 // Mit Anzahl vergleichen
    bne enterNames                  // weiter Spielername

//===============================================================================
// alles in Ordnung?
//===============================================================================
checkPlayerNames:
    mov16 #strCheckAllNames: TextPtr // Anzeige: Es spielen mit
    jsr Print_text

    ldx #00                         // Durch die Spielernamen mit X zählen
    mov16 #playerNames : TextPtr    // Beginn der Spielernamen

!loop:
    txa                             // X in den Akku und mit 16 multiplizieren
    .for (var i = 0; i < 4; i++) {  // *2^4 = *16
        asl
    }
    tay                             // Offset aus Akku nach Y
    jsr Print_text_offset           // Schreibe den Spielernamen
    lda #PET_CR                     // Zeilenumbruch
    jsr BSOUT
    inx
    cpx playerCount                 // Solange x< Spieleranzahl
    bne !loop-                      // weiter mit Schleife

    mov16 #strIsThatCorrect: TextPtr // Ist das richtig?
    jsr Print_text

    ldx #<filter_yesno       // Diese Zeichen sind erlaubt
    lda #>filter_yesno
!getinput:
    jsr Get_filtered_input  // Ja oder nein

    lda got_input           // Antwort Char in den Akku
    cmp #0
    beq checkPlayerNames          // aus versehen Enter gedrückt
    cmp #'J'
    beq readyToBegin
    jsr resetGame
    jmp howManyPlayers      // Ansonsten von vorn


readyToBegin:
    mov16 #strGoodLuck: TextPtr     // Viel Glück anzeigen
    jsr Print_text
    jsr Wait_for_key                // auf Testendruck warten


//===============================================================================
// Hauptschleife
//===============================================================================
main:
    ldx #00                         // Durch die Spieler mit X zählen
                                    // Spieler 1 hat die 0
nextPlayerLoop:
    stx currentPlayerNumber         // Aktuelle Spielernummer sichern
    // Wenn Vermögen < 20.000 $ bzw 00004e20h dann nur kleine Diebstähle
    jsr calcPlayerOffsets
    ldy currentPlayerOffset_4       // Offset für dword holen: 4 Byte

    lda playerMoney + 3, y          // Byte 0 vergleichen, weil little Endian
    cmp minMoneyForMenu + 3
    bcc noMoney

    lda playerMoney + 2, y          // Byte 1 vergleichen, weil little Endian
    cmp minMoneyForMenu + 2
    bcc noMoney

    lda playerMoney + 1, y          // Byte 2 vergleichen, weil little Endian
    cmp minMoneyForMenu + 1
    bcc noMoney

    lda playerMoney, y              // Byte 3 vergleichen, weil little Endian
    cmp minMoneyForMenu
    bcc noMoney

    jmp mainMenu                    // Geld ist vorhanden, ab ins Hauptmenü

noMoney:
    jmp smallTheft                  // Kein Geld, nur kleine Diebstähle

mainMenu:
    mov #GREEN : BGCOL0               // Debug
    jsr Wait_for_key

continueMain:
    ldx currentPlayerNumber         // Aktuelle Spielernummer wiederherstellen
    inx                             // nächster Spieler
    cpx playerCount                 // Solange x< Spieleranzahl
    bne nextPlayerLoop              // weiter mit Schleife, nächster Spieler
    jmp main                        // ansonsten ist Spieler 1 wieder dran


//===============================================================================

