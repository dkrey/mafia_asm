#importonce
// Charset editieren nach Jörn:
// https://www.retro-programming.de/programming/nachschlagewerk/vic-ii/vic-ii-eigener-zeichensatz/

.const VICCHARSETADR           = $d000
.const CHARROMADR              = $d800


charsetAddUmlaut:
    lda #%00000011                     //Datenrichtung für Bit 0 & 1 des Port-A
    sta $dd02                          //zum Schreiben freigeben

    lda $dd00                          // Bank 3 aktivieren
    and #%11111100
    ora #%00000000
    sta $dd00

    // Bildschirm = c000
    lda $d018                          //VIC-II Register 24 in den Akku holen
    and #%00001111                     //Über Bits 7-4
    ora #%00000000                     //den Beginn des
    sta $d018                          //Bildschirmspeichers festlegen

    // Character = d000
    lda $d018                          //VIC-II Register 24 in den Akku holen
    and #%11110001                     //Über Bits 3-1
    ora #%00000100                     //den Beginn des
    sta $d018                          //Zeichensatzes festlegen
    sei                                //IRQs sperren

    // Char ROM kopieren
    lda $01                            //ROM-'Konfig' in den Akku
    pha                                //auf dem Stack merken
    and #%11111011                     //BIT-2 (E/A-Bereich) ausblenden
    sta $01                            //und zurückschreiben

    jsr copyCharROM                    //Zeichensatz kopieren
    mov32 a_umlaut : charToChange
    mov32 a_umlaut + 4 : charToChange + 4
    ldx #'@'                           // @ wird zu ä
    jsr replaceChar

    mov32 o_umlaut : charToChange
    mov32 o_umlaut + 4 : charToChange + 4
    ldx #'&'                           // & wird zu ö
    jsr replaceChar

    mov32 u_umlaut : charToChange
    mov32 u_umlaut + 4 : charToChange + 4
    ldx #'*'                           // * wird zu ü
    jsr replaceChar
    pla                                //ROM-Einstellung vom Stack holen
    sta $01                            //wiederherstellen

    cli                                //Interrupts freigeben

    lda #$c0                            // Den Kernalroutinen sagen
    sta $0288                           // dass der BS Speicher jetzt in C000 liegt
    rts


copyCharROM:
    lda #<CHARROMADR                   //Quelle (CharROM) auf die Zero-Page
    sta ZeroPageLow
    lda #>CHARROMADR
    sta ZeroPageHigh

    lda #<VICCHARSETADR                //Ziel (RAM-Adr. Zeichensatz) in die Zero-Page
    sta ZeroPageLow2
    lda #>VICCHARSETADR
    sta ZeroPageHigh2

    ldx #$08                           //wir wollen 8*256 = 2KB kopieren
loopPage:
    ldy #$00                           //Schleifenzähler für je 256 Bytes
loopChar:
    lda (ZeroPageLow),Y                //Zeichenzeile (Byte) aus dem CharROM holen
    sta (ZeroPageLow2),Y                //und in unseren gewählten Speicherbereich kopieren
    dey                                //Blockzähler (256 Bytes) verringern
    bne loopChar                       //solangen ungleich 0 nach loopChar springen
    inc ZeroPageHigh                 //Sonst das MSB der Adressen auf der Zeropage
    inc ZeroPageHigh2                  //um eine 'Seite' (256 Bytes) erhöhen
    dex                                //'Seiten'-Zähler (acht Seiten zu 256 Bytes) verringern
    bne loopPage                       //solange ungleich 0 nach loopPage springen

    rts                                //zurück zum Aufrufer

//*** ersetzt den Screencode im X-Register mit dem Zeichen von testchar
replaceChar:
 txa                            //Screencode * 8
 and #%00011111
 asl
 asl
 asl
 clc
 adc #<VICCHARSETADR            //LSB fürs Ziel (RAM-Adr. Zeichensatz) in die Zero-Page
 sta ZeroPageLow2

 txa                            //Screencode in den Akku
 lsr                            //die oberen drei BYTEs für die Ermittlung
 lsr                            //der Page verwenden
 lsr
 lsr
 lsr
 clc
 adc #>VICCHARSETADR            //einfach aufs MSB der Ziel-Adresse addieren
 sta ZeroPageHigh2

 ldy #$07
!loop:
 lda charToChange,Y
 sta (ZeroPageLow2),Y
 dey
 bpl !loop-

 rts                            //zurück zum Aufrufer

charToChange:
    .dword $00000000, $00000000

// @
a_umlaut:
    //.byte $c3,$18,$3c,$66,$7e,$66,$66,$00
    .byte $00,$42,$18,$3C,$66,$7E,$66,$00

// &
o_umlaut:
    //.byte $c3,$00,$3c,$66,$66,$66,$3c,$00
    .byte $00,$24,$00,$3C,$66,$66,$3C,$00

// *
u_umlaut:
    .byte $66,$00,$66,$66,$66,$66,$3C,$0
