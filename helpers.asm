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