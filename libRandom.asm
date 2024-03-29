#importonce
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

.macro rndSidTimer() {
    lda #$80        //Frequenz
    sta $d40e       //Low-Byte  der Frequenz für Stimme 3
    sta $d40f       //High-Byte der Frequenz für Stimme 3
    sta $d412       //Rauschen für die 3. Stimme setzen
}

.macro rndCiaTimer() {
    lda $dc04  // Low-Byte  von Timer A aus dem CIA-1
    eor $dc05  // High-Byte von Timer A aus dem CIA-1
    eor $dd04  // Low-Byte  von Timer A aus dem CIA-2
    adc $dd05  // High-Byte von Timer A aus dem CIA-2
    eor $dd06  // Low-Byte  von Timer B aus dem CIA-2
    eor $dd07  // High-Byte von Timer B aus dem CIA-2
    eor $d41b   // eor mit SID
}

//===============================================================================
// getRandom8
//
// Berechnet einen 8 Bit Zufallswert in den Grenzen von rnd_low und rnd_high
// das Ergebnis steht dann im Akku
//===============================================================================
getRandom8:
    sec                     // Obergrenze berechnen
    lda rnd8_high
    cmp rnd8_low            // Wenn die Obergrenze = Untergrenze ist
    beq !end+
    sbc rnd8_low
    sta rnd8_diff
    rndSidTimer()
    rndCiaTimer()
    //jsr rndSid              // Seed aus dem SID holen
    cmp rnd8_diff
    bcs getRandom8           // Wenn der Wert darüber liegt, neu berechnen
    adc rnd8_low             // Untergrenze hinzufügen
!end:
    sta rnd8_result          // Ergebnis sichern
    rts

//===============================================================================
// getRandomBounds
//
// Berechnet einen 8 Bit Zufallswert in den Grenzen von rnd_low und rnd_high
// das Ergebnis steht dann im Akku
//===============================================================================
/*
getRandomBounds:
    //dec rnd8_high           // stupid fix
    lda rnd8_high           // Obergrenze berechnen
    sta rnd8_high
    cmp rnd8_low            // Wenn die Obergrenze = Untergrenze ist
    beq !end+
    sec
    sbc rnd8_low
    sta rnd8_diff
    rndSidTimer()
    rndCiaTimer()
    sta rnd8_result
    ldx #8
    lda #0
!goback:
    asl 
    rol rnd8_diff
    bcc !gofwd+
    clc 
    adc rnd8_result
    bcc !gofwd+
    inc rnd8_diff
!gofwd:
    dex
    bne !goback-
    clc
    adc rnd8_result
    lda rnd8_low
    adc rnd8_diff
!end:
    sta rnd8_result
    rts

*/
getRandomBounds:
    lda rnd8_high           // Obergrenze berechnen
    sta rnd8_high
    cmp rnd8_low            // Wenn die Obergrenze = Untergrenze ist
    bne !skip+
    jmp !end+
!skip:
    sec
    sbc rnd8_low
    sta rnd8_diff
    rndSidTimer()
    rndCiaTimer()
    sta rnd8_result
    lda #0

    asl 
    rol rnd8_diff
    bcc !gofwd+
    clc 
    adc rnd8_result
    bcc !gofwd+
    inc rnd8_diff

!gofwd:
    asl 
    rol rnd8_diff
    bcc !gofwd+
    clc 
    adc rnd8_result
    bcc !gofwd+
    inc rnd8_diff
!gofwd:
    asl 
    rol rnd8_diff
    bcc !gofwd+
    clc 
    adc rnd8_result
    bcc !gofwd+
    inc rnd8_diff
!gofwd:
    asl 
    rol rnd8_diff
    bcc !gofwd+
    clc 
    adc rnd8_result
    bcc !gofwd+
    inc rnd8_diff
!gofwd:
    asl 
    rol rnd8_diff
    bcc !gofwd+
    clc 
    adc rnd8_result
    bcc !gofwd+
    inc rnd8_diff
!gofwd:
    asl 
    rol rnd8_diff
    bcc !gofwd+
    clc 
    adc rnd8_result
    bcc !gofwd+
    inc rnd8_diff
!gofwd:
    asl 
    rol rnd8_diff
    bcc !gofwd+
    clc 
    adc rnd8_result
    bcc !gofwd+
    inc rnd8_diff
!gofwd:
    asl 
    rol rnd8_diff
    bcc !gofwd+
    clc 
    adc rnd8_result
    bcc !gofwd+
    inc rnd8_diff
!gofwd:
    clc
    adc rnd8_result
    lda rnd8_low
    adc rnd8_diff
!end:
    sta rnd8_result
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
  //jsr getRandom8
  jsr getRandomBounds
}


//===============================================================================
// getRandom16
//
// Berechnet einen 16 Bit Zufallswert in den Grenzen von rnd16_low und rnd16_high
//===============================================================================
getRandom16:
    sub16 rnd16_high : rnd16_low : rnd16_diff
    compare16 rnd16_diff : #$0000
    beq !end+
    //jsr rndSid              // Seed aus dem SID holen
    rndSidTimer()
    rndCiaTimer()
    lda rnd16_diff + 1      // Ist das Byte überhaupt gesetzt?
    cmp #00
    beq !skip+

!again:
    rndCiaTimer()
    //jsr rndTimer            // HighByte generieren
    sta rnd16_result +1
    cmp rnd16_diff + 1
    beq !end+
    bcs !again-             // Wenn der Wert darüber liegt, neu berechnen
!skip:

    rndCiaTimer()
    //jsr rndTimer            // lowbyte generieren
    sta rnd16_result
    cmp rnd16_diff
    beq !end+
    bcs !skip-              // Wenn zu hoch, dann nochmal
!end:
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
  clear16 rnd16_result
  clear16 rnd16_diff
  clear16 rnd16_low
  clear16 rnd16_high

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

//===============================================================================
// getRandom32
//
// Berechnet einen 32 Bit Zufallswert in den Grenzen von rnd32_low und rnd32_high
//===============================================================================
getRandom32:
    sub32 rnd32_high : rnd32_low : rnd32_diff
    compare32 rnd32_diff : #$00000000 // Obergrenze = Untergrenze
    bne !skip+
    jmp !end+
!skip:
    //jsr rndSid              // Seed aus dem SID holen
    rndSidTimer()
    rndCiaTimer()
    lda rnd32_diff + 3      // Ist das Byte überhaupt gesetzt?
    cmp #00
    beq !skip2+

!skip3:
    //jsr rndTimer            // Zufallswert setzen Byte3
    rndCiaTimer()
    sta rnd32_result +3
    cmp rnd32_diff + 3      // Ist der Wert zu groß?
    beq !skip2+
    bcs !skip3-

!skip2:
    lda rnd32_diff + 2
    cmp #00
    beq !skip1+

    //jsr rndTimer
    rndCiaTimer()
    sta rnd32_result +2
    cmp rnd32_diff + 2
    beq !skip1+
    bcs !skip2-

 !skip1:
    lda rnd32_diff + 1
    cmp #00
    beq !skip0+
    //jsr rndTimer
    rndCiaTimer()
    sta rnd32_result + 1
    cmp rnd32_diff + 1
    beq !skip0+
    bcs !skip1-
!skip0:
    //jsr rndTimer
    rndCiaTimer()
    sta rnd32_result
    cmp rnd32_diff
    beq !end+
    bcs !skip0-
!end:
    add32 rnd32_result : rnd32_low : rnd32_result // Untergrenze hinzuaddieren
    rts

rnd32_low:
    .dword 00000000
rnd32_high:
    .dword 00000000
rnd32_diff:
    .dword 00000000
rnd32_result:
    .dword 00000000

.pseudocommand getRandomRange32 low_val32 : high_val32 {
  clear32 rnd32_result
  clear32 rnd32_diff
  clear32 rnd32_low
  clear32 rnd32_high

  mov32 low_val32 : rnd32_low
  mov32 high_val32 : rnd32_high
  jsr getRandom32
}


//===============================================================================
// randomPerm8
//
// Bringt Zeichen in eine zufällige Reihenfolge
//===============================================================================
randomPerm8:
  // Ziffern-Sequenz aufbauen
  ldy #$00
!loop:
  tya
  sta rndPerm8_result, y
  iny
  cpy rndPerm8_limit
  bne !loop-
  dey
// Zahlen vertauschen
!loop:
  sty rndPerm8_limit                      // Y = Stelle in Ziffern-Sequenz

  getRandomRange8 #$00 : rndPerm8_limit   // Zufällige Stelle der Sequenz von 0 bis aktuelle Stelle
  tax                                     // Zufallsstelle in X
  // Zahlen vertauschen
  mov rndPerm8_result, x : ZeroPageTemp   // Zahl an der Stelle Zufallszahl temp. speichern
  mov rndPerm8_result, y : rndPerm8_result, x // Zahl an Stelle y nach y kopieren

  mov ZeroPageTemp : rndPerm8_result, y   // temp Wert (x) zurückholen und an y speichern

  dey
  bpl !loop-

  rts


.pseudocommand randomPerm8 limit {
  lda extract_byte_argument(limit, 0)
  sta rndPerm8_limit
  jsr randomPerm8
}

rndPerm8_limit:
  .byte $08

rndPerm8_result:
  .byte $00,$00,$00,$00,$00
  .byte $00,$00,$00,$00,$00
