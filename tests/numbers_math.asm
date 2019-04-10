#import "testHeader.asm"

.label border = $d020
.label background = $d021
.label screen_memory = $0400

.const DELAY = 120


main:
  jsr CLEAR
  //getRandomRange16 #$00ff : #$03e8 // Werte zwischen 255 und 1000
  //print_int16 rnd16_result
/*
 0x2869F  165535
+0x086A1   34465
=0x30D40  200000
 */
  lda theftBaseBank +1
  sta rnd16_result +1
  lda #$A1
  sta rnd16_result
  print_int16 rnd16_result

  lda #PET_CR
  jsr BSOUT

  //print_int32 temp32

  print_int32 wallet
  lda #PET_CR
  jsr BSOUT

  add16To32 rnd16_result : wallet : result
  //add32 temp32 : wallet : result

  print_int32 result

  jsr Wait_for_key
  jmp main

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

temp32:
  .dword $000086a1

wallet:
  .dword $0002869f

result:
  .dword $00000000

.pseudocommand update_score score : value {
  :sub16 score : value : score
}

.pseudocommand print_score score {
  :int16_to_hex_str score : screen_memory + 40*12 + 17
}