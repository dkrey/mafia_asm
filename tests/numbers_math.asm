//===============================================================================
// Tests
//
.encoding "petscii_mixed"
//===============================================================================
//
// Import helpers
#import "../helpers.asm"
#import "../gameMemory.asm"

.label border = $d020
.label background = $d021
.label screen_memory = $0400

.const DELAY = 30
:BasicUpstart2(main)
main:
  sei
loop:

  :raster_wait(60)

  dec delay
  bne loop
  lda #DELAY
  sta delay

  :update_score score : #50
  inc border
  :print_score score
  dec border

  jmp loop

score:
  .word 1000
delay:
  .byte DELAY

.pseudocommand update_score score : value {
  sed
  :sub16 score : value : score
  cld
}

.pseudocommand print_score score {
  :int16_to_bcd_str score : screen_memory + 40*12 + 17
}