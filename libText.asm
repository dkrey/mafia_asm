#importonce

// PET Cursorbewegung
.const PET_HOME         = $13
.const PET_RIGHT        = $9d
.const PET_LEFT         = $9d
.const PET_UP           = $91
.const PET_DOWN         = $11

// PET Tasten
.const PET_CR           = $0d
.const PET_SPACE        = $20
.const PET_DELETE       = $14

// PET Extra
.const PET_CLEAR_SCREEN = $93
.const PET_LINE         = $b7

// PET Farben
.const PET_BLACK = $90
.const PET_WHITE = $05
.const PET_RED = $1c
.const PET_CYAN = $9f
.const PET_PURPLE = $9c
.const PET_GREEN = $1e
.const PET_BLUE = $1f
.const PET_YELLOW = $9e
.const PET_ORANGE = $81
.const PET_BROWN = $95
.const PET_PINK = $96
.const PET_DARK_GREY = $97
.const PET_GREY = $98
.const PET_LIGHT_GREEN = $99
.const PET_LIGHT_BLUE = $9a
.const PET_LIGHT_GREY = $9b


//===============================================================================
// Print_text_xy
//
// Gibt einen Null-terminierten Text an bestimmter Stelle aus
// ZP TextPtr: Textstelle
// X-Register: Zeile
// Y-Register: Spalte
//===============================================================================
Print_text_xy:
        clc
        jsr PLOT
        ldy #$00

!loop:
        lda (TextPtr), y
        beq !end+
        jsr BSOUT

!noreset:
        iny
        bne !loop-
!end:
        rts

//===============================================================================
// Print_text_
//
// Gibt einen Null-terminierten Text an bestimmter Stelle aus
// ZP TextPtr: Textstelle
//===============================================================================
Print_text:
        ldy #$00
!loop:
        lda (TextPtr), y
        beq !end+
        jsr BSOUT

!noreset:
        iny
        bne !loop-
!end:
        rts

//===============================================================================
// Print_text_offset
//
// Gibt einen Null-terminierten Text aus
// ZP TextPtr: Textstelle
// y = Offset im Speicher
//===============================================================================
Print_text_offset:

!loop:
        lda (TextPtr), y
        beq !end+
        jsr BSOUT

!noreset:
        iny
        bne !loop-
!end:
        rts

//===============================================================================
// Print_hex32_dec
//
// Gibt den Hex-Wert hex2dec_value
// als Dezimalzahl aus
// x und y Register werden überschrieben
//===============================================================================
Print_hex32_dec:
  jsr hex32dec
  ldx #09

!loop1:
    lda hex32dec_result,x
    bne !loop2+
    dex
    bne !loop1-

!loop2:
    lda hex32dec_result, x
    ora #$30
    jsr kernal_chrout
    dex
    bpl !loop2-
    rts

hex32dec:
    ldx #0

!loop3:
    jsr !div10+
    sta hex32dec_result,x
    inx
    cpx #10
    bne !loop3-
    rts

!div10:
    ldy #32
    lda #0
    clc
!loop4:
    rol
    cmp #10
    bcc !skip+
    sbc #10

!skip:
    rol hex32dec_value
    rol hex32dec_value + 1
    rol hex32dec_value + 2
    rol hex32dec_value + 3
    dey
    bpl !loop4-
    rts

hex32dec_value:
    .dword $ffffffff
hex32dec_result:
    .byte 0,0,0,0,0,0,0,0,0,0

//===============================================================================
// Print_hex16_dec
//
// Gibt den Hex-Wert hex16dec_value
// als Dezimalzahl aus
// x und y Register werden überschrieben
//===============================================================================
Print_hex16_dec:
  jsr hex16dec
  ldx #05

!loop1:
    lda hex16dec_result,x
    bne !loop2+
    dex
    bne !loop1-

!loop2:
    lda hex16dec_result, x
    ora #$30
    jsr kernal_chrout
    dex
    bpl !loop2-
    rts

hex16dec:
    ldx #0

!loop3:
    jsr !div10+
    sta hex16dec_result,x
    inx
    cpx #05
    bne !loop3-
    rts

!div10:
    ldy #16
    lda #0
    clc
!loop4:
    rol
    cmp #10
    bcc !skip+
    sbc #10

!skip:
    rol hex16dec_value
    rol hex16dec_value + 1
    dey
    bpl !loop4-
    rts

hex16dec_value:
    .word $ffff
hex16dec_result:
    .byte 0,0,0,0,0,0

//===============================================================================
// Print_hex8_dec
//
// Gibt den Hex-Wert hex16dec_value
// als Dezimalzahl aus
// x und y Register werden überschrieben
//===============================================================================
Print_hex8_dec:  //lda int8
  lda hex8dec_value
  ldx #0
!loop:
  jsr !div10+
  pha
  inx
  tya
  bne !loop-

!loop2:
  pla
  ora #$30
  jsr kernal_chrout
  dex
  bne !loop2-
  rts

!div10:
  sec
  ldy #$ff
!divlp:
  iny
  sbc #10
  bcs !divlp-
  adc #10
  rts

hex8dec_value:
    .byte $ff
