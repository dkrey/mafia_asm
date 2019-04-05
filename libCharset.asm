#importonce
// Charset editieren nach Jörn:
// https://www.retro-programming.de/programming/nachschlagewerk/vic-ii/vic-ii-eigener-zeichensatz/
//
//  VIC-II Speicher-Konstanten
.const VICBANKNO               = 0                             //Nr. (0 - 3) der 16KB Bank                              | Standard: 0
.const VICSCREENBLOCKNO        = 1                             //Nr. (0 -15) des 1KB-Blocks für den Textbildschirm      | Standard: 1
.const VICCHARSETBLOCKNO       = 7                             //Nr. (0 - 7) des 2KB-Blocks für den Zeichensatz         | Standard: 2
.const VICBITMAPBBLOCKNO       = 0                             //Nr. (0 - 1) des 8KB-Blocks für die BITMAP-Grafik       | Standard: 0
.const VICBASEADR              = VICBANKNO*16384               //Startadresse der gewählten VIC-Bank                    | Standard: $0000
.const VICCHARSETADR           = VICCHARSETBLOCKNO * 2048 + VICBASEADR //Adresse des Zeichensatzes                      | Standard: $1000 ($d000)

.const CHARROMADR              = $d800
.const ZP_HELPADR1             = $fb
.const ZP_HELPADR2             = $fd

//BasicUpstart2(main)
charsetAddUmlaut:
//*** Start des Zeichensatzes festlegen
    lda #VICSCREENBLOCKNO * 16 + VICCHARSETBLOCKNO * 2
    sta $d018                          //Adresse für Bildschirm und Zeichensatz festlegen
    sei                                //IRQs sperren

    lda $01                            //ROM-'Konfig' in den Akku
    pha                                //auf dem Stack merken
    and #%11111011                     //BIT-2 (E/A-Bereich) ausblenden
    sta $01                            //und zurückschreiben

    jsr copyCharROM                    //Zeichensatz kopieren

    pla                                //ROM-Einstellung vom Stack holen
    sta $01                            //wiederherstellen

    cli                                //Interrupts freigeben

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

    rts                                //zurück zum BASIC


copyCharROM:
    lda #<CHARROMADR                   //Quelle (CharROM) auf die Zero-Page
    sta ZP_HELPADR1
    lda #>CHARROMADR
    sta ZP_HELPADR1+1

    lda #<VICCHARSETADR                //Ziel (RAM-Adr. Zeichensatz) in die Zero-Page
    sta ZP_HELPADR2
    lda #>VICCHARSETADR
    sta ZP_HELPADR2+1

    ldx #$08                           //wir wollen 8*256 = 2KB kopieren
loopPage:
    ldy #$00                           //Schleifenzähler für je 256 Bytes
loopChar:
    lda (ZP_HELPADR1),Y                //Zeichenzeile (Byte) aus dem CharROM holen
    sta (ZP_HELPADR2),Y                //und in unseren gewählten Speicherbereich kopieren
    dey                                //Blockzähler (256 Bytes) verringern
    bne loopChar                       //solangen ungleich 0 nach loopChar springen
    inc ZP_HELPADR1+1                  //Sonst das MSB der Adressen auf der Zeropage
    inc ZP_HELPADR2+1                  //um eine 'Seite' (256 Bytes) erhöhen
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
 sta ZP_HELPADR2

 txa                            //Screencode in den Akku
 lsr                            //die oberen drei BYTEs für die Ermittlung
 lsr                            //der Page verwenden
 lsr
 lsr
 lsr
 clc
 adc #>VICCHARSETADR            //einfach aufs MSB der Ziel-Adresse addieren
 sta ZP_HELPADR2+1

 ldy #$07
!loop:
 lda charToChange,Y
 sta (ZP_HELPADR2),Y
 dey
 bpl !loop-

 rts                            //zurück zum Aufrufer

charToChange:
    .dword $00000000, $00000000

// @
a_umlaut:
    .byte $c3,$18,$3c,$66,$7e,$66,$66,$00

// &
o_umlaut:
    .byte $c3,$00,$3c,$66,$66,$66,$3c,$00

// /
u_umlaut:
    .byte $66,$00,$66,$66,$66,$66,$3C,$0