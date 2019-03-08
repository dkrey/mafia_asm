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

#import "helpers.asm"
#import "gameMemory.asm"
#import "libText.asm"
#import "libInput.asm"
#import "gameStringsDE.asm"

//===============================================================================
// Spiel initialisieren
//===============================================================================


init:

    .encoding "screencode_mixed"
    // Lower Case Char Mode
    mov #$17: $D018

    // Disable C= + Shift
    mov #$80 : $0291

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

    ldy #1                          // Anzahl Zeichen für die Input Routine: 1

    lda #>filter_num_players        // Filter setzen LSB: Zahlen 1-8
    ldx #<filter_num_players        // Filter setzen MSB: Zahlen 1-8

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
    stx ZeroPageTemp                // X-Wert sichern, weil Input ihn überschreibt
    txa
    clc                             // Dazu 0x31h addieren, wegen PetSCI und Ziffer
    adc #$31                        // und außerdem noch +1 weil von 0 gezählt
    jsr BSOUT
    lda #'?'                        // Fragezeichen am Satzende
    jsr BSOUT
    lda #' '                        // Leerzeichen hintendran
    jsr BSOUT

    ldy #32                         // 32 Zeichen darf der Name haben
    lda #>filter_alphanumeric       // Diese Zeichen sind erlaubt
    ldx #<filter_alphanumeric
    jsr Get_filtered_input

    //DEBUG
    mov16 #got_input : TextPtr
    jsr Print_text

    ldx ZeroPageTemp                // X-Wert aus Temp holen
    inx                             // Spielerzähler erhöhen
    cpx playerCount                 // Mit Anzahl vergleichen
    bne enterNames                  // weiter Spielername

//===============================================================================
// alles in Ordnung?
//===============================================================================
readyToBegin:

main:
    mov #GREEN : BGCOL0               // Debug
    nop
    jmp main

//===============================================================================

