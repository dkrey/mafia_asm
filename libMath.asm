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
// rndSid
//
// Bereitet den SID so vor, dass in d41b ein Zufallswert steht
//===============================================================================
rndSid:
    lda #$80        //Frequenz
    sta $d40e       //Low-Byte  der Frequenz für Stimme 3
    sta $d40f       //High-Byte der Frequenz für Stimme 3
    sta $d412       //Rauschen für die 3. Stimme setzen

//===============================================================================
// rndTimer
//
// Gibt einen Zufallswert im Akku zurück
//===============================================================================
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

//===============================================================================
// getRandom8
//
// Berechnet einen 8 Bit Zufallswert in den Grenzen von rnd_low und rnd_high
// das Ergebnis steht dann im Akku
//===============================================================================
getRandom8:
    sec                     // Obergrenze berechnen
    lda rnd8_high
    sbc rnd8_low
    sta rnd8_diff
    jsr rndSid              // Seed aus dem SID holen
    jsr rndTimer            // Zufallszahl aus dem CIA Timer generieren
    cmp rnd8_diff
    bcs getRandom8           // Wenn der Wert darüber liegt, neu berechnen
    adc rnd8_low             // Untergrenze hinzufügen
    sta rnd8_result          // Ergebnis sichern
    rts

rnd8_low:
    .byte 00
rnd8_high:
    .byte 00
rnd8_diff:
    .byte 00
rnd8_result:
    .byte 00

.pseudocommand getRandomRange8 low_val8 : high_val8 {
  lda extract_byte_argument(low_val8, 0)
  sta rnd8_low
  lda extract_byte_argument(high_val8, 0)
  sta rnd8_high
  jsr getRandom8
}


//===============================================================================
// getRandom16
//
// Berechnet einen 16 Bit Zufallswert in den Grenzen von rnd16_low und rnd16_high
//===============================================================================
getRandom16:
    sub16 rnd16_high : rnd16_low : rnd16_diff
    jsr rndSid              // Seed aus dem SID holen
    jsr rndTimer            // Zufallszahl aus dem CIA Timer generieren
    sta rnd16_result

    jsr rndTimer            // Zufallszahl aus dem CIA Timer generieren
    sta rnd16_result +1

    cmp rnd16_diff + 1
    bcs getRandom16         // Wenn der Wert darüber liegt, neu berechnen

    lda rnd16_result        // Wenn der Wert darüber liegt, neu berechnen, zweites Bit
    cmp rnd16_diff
    bcs getRandom16

    add16 rnd16_result : rnd16_low : rnd16_result // Untergrenze hinzuaddieren
    rts

rnd16_low:
    .word 0000
rnd16_high:
    .word 0000
rnd16_diff:
    .word 0000
rnd16_result:
    .word 0000

.pseudocommand getRandomRange16 low_val16 : high_val16 {
  lda extract_byte_argument(low_val16, 0)
  sta rnd16_low
  lda extract_byte_argument(low_val16, 1)
  sta rnd16_low +1

  lda extract_byte_argument(high_val16, 0)
  sta rnd16_high
  lda extract_byte_argument(high_val16, 1)
  sta rnd16_high + 1

  jsr getRandom16
}

/*
.pseudocommand conv16To32 int16 {
    // clear old result
    lda #00
    sta result16To32 + 3
    sta result16To32 + 2
    sta result16To32 + 1
    sta result16To32

    lda extract_byte_argument(int16, 0)
    sta result16To32
    lda extract_byte_argument(int16, 1)
    sta result16To32 + 1

}

result16To32:
    .dword 00000000

result8To32:
    .dword 00000000
*/