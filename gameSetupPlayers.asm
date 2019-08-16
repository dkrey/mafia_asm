#importonce
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
    beq welcomePayment
    jsr resetGame
    jmp howManyPlayers      // Ansonsten von vorn

welcomePayment:
    mov16 #strWelcomePayment : TextPtr
    jsr Print_text
    ldx #<filter_yesno       // Diese Zeichen sind erlaubt
    lda #>filter_yesno
!getinput:
    jsr Get_filtered_input  // Ja oder nein
    lda got_input           // Antwort Char in den Akku
    cmp #0
    beq !getinput-          // aus versehen Enter gedrückt
    cmp #'J'
    bne readyToBegin

    // 60.000$ Startkapital
    ldx #00
!loop:
    txa
    asl
    asl
    tay
    add32 playerMoney, y : #$0000EA60 : playerMoney, y
    inx
    cpx playerCount                 // Solange x< Spieleranzahl
    bne !loop-                      // weiter mit Schleife

readyToBegin:
    mov16 #strGoodLuck: TextPtr     // Viel Glück anzeigen
    jsr Print_text
    jsr Wait_for_key                // auf Testendruck warten
    rts