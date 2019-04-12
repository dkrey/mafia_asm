
#import "testHeader.asm"

main:

  sei
loop:

  jsr addDelay
  :update_score score : #1
  :print_score score

  jmp loop


score:
  .word 03

result:
  .word $0000

.pseudocommand update_score score : value {
  :add16 score : value : score
}

.pseudocommand print_score score {
  :int16_to_hex_str score : SCREEN + 40*12 + 17
}
mainNextPlayerLoop:
mainContinue: