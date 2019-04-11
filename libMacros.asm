#importonce

.label kernal_chrout = $ffd2


.pseudocommand clear_screen {
  jsr $e544
}

.pseudocommand set_cursor_position column : row {
  ldx row
  ldy column
  :plot_set
}

.pseudocommand plot_set {
  clc
  jsr $fff0
}
.pseudocommand plot_get {
  sec
  jsr $fff0
}

.pseudocommand clear32  destination {
  :_clear bits_to_bytes(32) : destination
}
.pseudocommand clear16  destination {
  :_clear bits_to_bytes(16) : destination
}
.pseudocommand clear destination {
  :_clear bits_to_bytes(8) : destination
}
.pseudocommand _clear bytes_count : destination {
  lda #00
  .for (var i = 0; i < bytes_count.getValue(); i++) {
    sta extract_byte_argument(destination, i)
  }
}

.pseudocommand mov32 source : destination {
  :_mov bits_to_bytes(32) : source : destination
}
.pseudocommand mov16 source : destination {
  :_mov bits_to_bytes(16) : source : destination
}
.pseudocommand mov source : destination {
  :_mov bits_to_bytes(8) : source : destination
}
.pseudocommand _mov bytes_count : source : destination {
  .for (var i = 0; i < bytes_count.getValue(); i++) {
    lda extract_byte_argument(source, i)
    sta extract_byte_argument(destination, i)
  }
}

.function extract_byte_argument(arg, byte_id) {
  .if (arg.getType()==AT_IMMEDIATE) {
    .return CmdArgument(arg.getType(), extract_byte(arg.getValue(), byte_id))
  } else {
    .return CmdArgument(arg.getType(), arg.getValue() + byte_id)
  }
}
.function extract_byte(value, byte_id) {
  .var bits = _bytes_to_bits(byte_id)
  .eval value = value >> bits
  .return value & $ff
}
.function _bytes_to_bits(bytes) {
  .return bytes * 8
}
.function bits_to_bytes(bits) {
  .return bits / 8
}

.macro nops(count) {
  .for (var i = 0; i < count; i++) {
    nop
  }
}

.macro cycles(count) {
  .if (count < 0) {
    .error "The cycle count cannot be less than 0 (" + count + " given)."
  }
  .if (count == 1) {
    .error "Can't wait only one cycle."
  }
  .if (mod(count, 2) != 0) {
    bit $ea
    .eval count -= 3
  }
  :nops(count/2)
}

.pseudocommand sub32 left : right : destination {
  :_sub bits_to_bytes(32) : left : right : destination
}

.pseudocommand sub16 left : right : destination {
  :_sub bits_to_bytes(16) : left : right : destination
}
.pseudocommand _sub bytes_count : left : right : result {
  sec
  .for (var i = 0; i < bytes_count.getValue(); i++) {
    lda extract_byte_argument(left, i)
    sbc extract_byte_argument(right, i)
    sta extract_byte_argument(result, i)
  }
}

.pseudocommand add32 left : right : destination {
  :_add bits_to_bytes(32) : left : right : destination
}

.pseudocommand add16 left : right : destination {
  :_add bits_to_bytes(16) : left : right : destination
}

.pseudocommand _add bytes_count : left : right : result {
  clc
  .for (var i = 0; i < bytes_count.getValue(); i++) {
    lda extract_byte_argument(left, i)
    adc extract_byte_argument(right, i)
    sta extract_byte_argument(result, i)
  }
}

.pseudocommand add8To32 val8 : val32 : result {
  clc
  lda extract_byte_argument(val32, 0)
  adc extract_byte_argument(val8, 0)
  sta extract_byte_argument(result, 0)

  lda extract_byte_argument(val32, 1)
  adc #00
  sta extract_byte_argument(result, 1)

  lda extract_byte_argument(val32, 2)
  adc #00
  sta extract_byte_argument(result, 2)

  lda extract_byte_argument(val32, 3)
  adc #00
  sta extract_byte_argument(result, 3)
}

.pseudocommand add16To32 val16 : val32 : result {
  clc
  lda extract_byte_argument(val32, 0)
  adc extract_byte_argument(val16, 0)
  sta extract_byte_argument(result, 0)

  lda extract_byte_argument(val32, 1)
  adc extract_byte_argument(val16, 1)
  sta extract_byte_argument(result, 1)

  lda extract_byte_argument(val32, 2)
  adc #00
  sta extract_byte_argument(result, 2)

  lda extract_byte_argument(val32, 3)
  adc #00
  sta extract_byte_argument(result, 3)
}

.label vic2_screen_control_register1 = $d011
.label vic2_screen_control_register2 = $d016
.label vic2_rasterline_register = $d012
.label vic2_interrupt_control_register = $d01a
.label vic2_interrupt_status_register = $d019

.macro stabilize_irq() {
  start:
    :mov16 #irq2 : $fffe
    inc vic2_rasterline_register
    asl vic2_interrupt_status_register
    tsx
    cli

    :cycles(18)

  irq2:
    txs
    :cycles(44)
  test:
    lda vic2_rasterline_register
    cmp vic2_rasterline_register
    beq next_instruction
  next_instruction:
}

.macro set_raster(line_number) {
  lda #line_number
  sta vic2_rasterline_register

  lda vic2_screen_control_register1
  .if (line_number > 255) {
    ora #%10000000
  } else {
    and #%01111111
  }
  sta vic2_screen_control_register1
}

.macro raster_wait(line_number) {
!wait:
  lda #line_number
  cmp vic2_rasterline_register
  bne !wait-
  bit vic2_screen_control_register1
  .if (line_number <= 255) {
    bmi !wait-
  } else {
    bpl !wait-
  }
}

.pseudocommand print_hex32 int32 {
  :print_hex8 extract_byte_argument(int32, 3)
  :print_hex8 extract_byte_argument(int32, 2)
  :print_hex8 extract_byte_argument(int32, 1)
  :print_hex8 extract_byte_argument(int32, 0)
}

.pseudocommand print_hex16 int16 {
  :print_hex8 extract_byte_argument(int16, 1)
  :print_hex8 extract_byte_argument(int16, 0)
}
.pseudocommand print_hex8 int8 {
  lda int8
  pha
  lsr
  lsr
  lsr
  lsr
  :print_hex_digit()
  pla
  :print_hex_digit()
}


.macro print_hex_digit() {
  and #%00001111
  cmp #10
  bcs digit_letter
digit_number:
  clc
  adc #'0'
  jmp digit_end
digit_letter:
  clc
.encoding "petscii_upper"
  adc #'A' - 10
.encoding "screencode_mixed"
digit_end:
  jsr kernal_chrout
}

negative_int16:
  .word 0000

.pseudocommand int16_to_hex_str int16 : destination {
  // Auf Minus prüfen
  lda extract_byte_argument(int16, 1)
  and #$80
  bpl plus

  // Minus:
  lda #'-'                              // Minus mit Leerzeichen anzeigen
  sta destination
  lda #' '
  sta destination.getValue() + 1

  // Zweier Komplement +1
  lda extract_byte_argument(int16, 1)
  eor #$FF
  sta negative_int16 +1
  lda extract_byte_argument(int16, 0)
  eor #$FF
  sta negative_int16

  :add16 negative_int16 : #1 : negative_int16
  :int8_to_hex_str negative_int16 +1  : destination.getValue() + 2
  :int8_to_hex_str negative_int16 : destination.getValue() + 4
  jmp !end+
  plus:
  // Plus:
  :int8_to_hex_str extract_byte_argument(int16, 1) : destination
  :int8_to_hex_str extract_byte_argument(int16, 0) : destination.getValue() + 2
  !end:
}

.pseudocommand int8_to_hex_str int8 : destination {
  lda int8
  ldx #2
loopx:
  pha
  and #%00001111
  cmp #10
  bcs digit_letter
digit_number:
  clc
  adc #'0'
  jmp digit_end
digit_letter:
  clc
  adc #'a' - 10
digit_end:
  sta destination.getValue() - 1, X
  pla
  lsr
  lsr
  lsr
  lsr
  dex
  bne loopx
}

.pseudocommand int16_to_bcd_str int16 : destination {
  :int8_to_bcd_str extract_byte_argument(int16, 1) : destination
  :int8_to_bcd_str extract_byte_argument(int16, 0) : destination.getValue() + 2
}

.pseudocommand int8_to_bcd_str int8 : destination {
  lda int8
  ldx #2
loopx:
  pha
  and #%00001111
  clc
  adc #'0'
  sta destination.getValue() - 1, X
  pla
  lsr
  lsr
  lsr
  lsr
  dex
  bne loopx
}

.pseudocommand print_int8 int8
{
  //lda int8
  lda extract_byte_argument(int8, 0)
  ldx #0
loop:
  jsr div10
  pha
  inx
  tya
  bne loop

loop2:
  pla
  ora #$30
  jsr kernal_chrout
  dex
  bne loop2
  jmp end

div10:
  sec
  ldy #$ff
divlp:
  iny
  sbc #10
  bcs divlp
  adc #10
  rts
end:
}

.pseudocommand print_int16 int16 {
  :plot_get
  tya
  pha
  ldx extract_byte_argument(int16, 0)
  lda extract_byte_argument(int16, 1)
  jsr $bdcd
}

.pseudocommand print_int32 int32
{
  lda extract_byte_argument(int32, 0)
  sta int32_value
  lda extract_byte_argument(int32, 1)
  sta int32_value +1
  lda extract_byte_argument(int32, 2)
  sta int32_value +2
  lda extract_byte_argument(int32, 3)
  sta int32_value +3

  jsr hex2dec
  ldx #09

loop1:
    lda int32_result,x
    bne loop2
    dex
    bne loop1

loop2:
    lda int32_result, x
    ora #$30
    jsr kernal_chrout
    dex
    bpl loop2
    jmp end

hex2dec:
    ldx #0

loop3:
    jsr div10
    sta int32_result,x
    inx
    cpx #10
    bne loop3
    rts

div10:
    ldy #32
    lda #0
    clc
loop4:
    rol
    cmp #10
    bcc skip
    sbc #10

skip:
    rol int32_value
    rol int32_value + 1
    rol int32_value + 2
    rol int32_value + 3
    dey
    bpl loop4
    rts

int32_value:
  .byte $FF,$FF,$FF,$FF
int32_result:
    .byte 0,0,0,0,0,0,0,0,0,0
end:
}

