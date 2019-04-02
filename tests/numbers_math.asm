//===============================================================================
// Tests
//
.encoding "petscii_mixed"
//===============================================================================
//
// Import helpers
#import "../helpers.asm"
#import "../gameMemory.asm"
#import "../libText.asm"
#import "../libInput.asm"

.label border = $d020
.label background = $d021
.label screen_memory = $0400

.const DELAY = 120
:BasicUpstart2(main)

main:

  :print_int32 #$989680
  jsr Wait_for_key
/*
  sei
loop:

  :raster_wait(60)

  dec delay
  bne loop
  lda #DELAY
  sta delay

  :update_score score : #1
  inc border
  :print_score score
  dec border

  jmp loop
*/
score:
  .word 3
delay:
  .byte DELAY

.pseudocommand update_score score : value {
  :sub16 score : value : score
}

.pseudocommand print_score score {
  :int16_to_hex_str score : screen_memory + 40*12 + 17
}