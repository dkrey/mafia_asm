#importonce
//===============================================================================
// Wie viele spielen mit
//===============================================================================
howManyPlayers:
    // Farben setzen
    mov #BLACK : EXTCOL             // Schwarzer Overscan
    mov #BLUE : BGCOL0              // Blauer Hintergrund


    mov16 #strHowManyScreen : TextPtr  // Adresse vom Text setzen
    jsr Print_text                  // Text anzeigen

howManyPlayersInput:
    jsr GETIN
    cmp #$32        // sichergehen, dass es eine gültige Ziffer ist >= 2
    bcc howManyPlayersInput
    cmp #$39        // sichergehen, dass es eine gültige Ziffer ist <= 8
    bcs howManyPlayersInput

    cmp #0                          // 0 oder Enter, Abfrage erneut starten
    beq howManyPlayersInput

    sec                             // Konv PetSCII Zeichen zur Zahl
    sbc #$30
    sta playerCount                 // Abspeichern und Schluss
    Print_hex8_dec playerCount

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


!getinput:
    jsr GETIN
    cmp inputYes            // Spieler hat J gedrückt
    beq selectGameMode
    cmp inputNo            // Spieler hat N gedrückt
    beq !skip+
    jmp !getinput-          // nichts gedrückt
!skip:
    jsr resetGame
    jmp howManyPlayers      // Ansonsten von vorn


selectGameMode:
//===============================================================================
// Spielmodus
//===============================================================================
    // noch das Ja von vorhin anzeigen
    jsr BSOUT
    mov16 #strGameModeChoice: TextPtr // Spielmodi anzeigen
    jsr Print_text
    mov16 #strChoice : TextPtr
    jsr Print_text
!getinput:
    jsr GETIN
    cmp #$30        // sichergehen, dass es eine gültige Ziffer ist <= 0
    bcc !getinput-
    cmp #$3a        // sichergehen, dass es eine gültige Ziffer ist >= #$3a
    bcs !getinput-

    cmp #0                          // 0 oder Enter, Abfrage erneut starten
    beq !getinput-

    sec                             // Konv PetSCII Zeichen zur Zahl
    sbc #$30

    // Auswahl: Die ganze Gegend
    cmp #01
    bne !skip+
    lda #00
    sta gameMode
    lda #'1'
    jsr BSOUT
    jmp welcomePayment
!skip:
    cmp #02
    bne !skip+
    lda #01
    sta gameMode
    lda #'2'
    jsr BSOUT
    jmp welcomePayment
!skip:
    cmp #03
    bne !skip+
    lda #02
    sta gameMode
    lda #'3'
    jsr BSOUT
    jmp welcomePayment
!skip:
    jmp !getinput-

//===============================================================================
// Begrüßungsgeld
//===============================================================================
welcomePayment:
    mov16 #strWelcomePayment : TextPtr
    jsr Print_text

!getinput:
    jsr GETIN

    cmp inputYes
    beq !skip+
    cmp inputNo            // Spieler hat N gedrückt
    beq readyToBegin

    jmp !getinput-          // nichts gedrückt

!skip:
    jsr BSOUT
    // 60.000$ Startkapital
    ldx #00
!loop:
    txa
    asl
    asl
    tay
    add32 playerMoney, y : #$0010EA60 : playerMoney, y
    inx
    cpx playerCount                 // Solange x< Spieleranzahl
    bne !loop-                      // weiter mit Schleife
    jmp readyToBegin2

readyToBegin:
    jsr BSOUT                       // das N von Nein anzeigen
readyToBegin2:
    mov16 #strGoodLuck: TextPtr     // Viel Glück anzeigen
    jsr Print_text
    jsr Wait_for_key                // auf Testendruck warten
    rts
