#importonce

//===============================================================================
// calcPlayerOffsets
//
// Berechnet die Player Offsets
//===============================================================================
calcPlayerOffsets:
    lda currentPlayerNumber
    asl
    sta currentPlayerOffset_2   // 2^1
    asl
    sta currentPlayerOffset_4   // 2^2
    asl
    sta currentPlayerOffset_8   // 2^3
    asl
    sta currentPlayerOffset_16   // 2^4
    rts

//===============================================================================
// getRandom
//
// Berechnet einen 8 Bit Zufallswert in den Grenzen von rnd_low und rnd_high
// das Ergebnis steht dann im Akku
//===============================================================================
getRandom:
    sec                     // Obergrenze berechnen
    lda rnd_high
    sbc rnd_low
    sta rnd_diff
    jsr rndSid              // Seed aus dem SID holen
    jsr rndTimer            // Zufallszahl aus dem CIA Timer generieren
    cmp rnd_diff
    bcs getRandom           // Wenn der Wert darunter liegt, neu berechnen
    adc rnd_low             // Untergrenze hinzufügen
    rts

rndSid:
    lda #$80        //Frequenz
    sta $d40e       //Low-Byte  der Frequenz für Stimme 3
    sta $d40f       //High-Byte der Frequenz für Stimme 3
    sta $d412       //Rauschen für die 3. Stimme setzen

rndTimer:
    lda $dc04  // Low-Byte  von Timer A aus dem CIA-1
    eor $dc05  // High-Byte von Timer A aus dem CIA-1
    eor $dd04  // Low-Byte  von Timer A aus dem CIA-2
    adc $dd05  // High-Byte von Timer A aus dem CIA-2
    eor $dd06  // Low-Byte  von Timer B aus dem CIA-2
    eor $dd07  // High-Byte von Timer B aus dem CIA-2
    //eor $d012  // eor mit Rasterzeile
    eor $d41b   // eor mit SID
    rts

rnd_low:
    .byte 00
rnd_high:
    .byte 7
rnd_diff:
    .byte 00

.pseudocommand get_random_range low_val : high_val {
  lda extract_byte_argument(low_val, 0)
  sta rnd_low
  lda extract_byte_argument(high_val, 0)
  sta rnd_high
  jsr getRandom
}