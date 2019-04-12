#import "testHeader.asm"

main:
    getRandomRange32 #00000000 : #$a0000000
    print_hex32 rnd32_result

    //getRandomRange16 #$0000 : #$a000
    //print_hex16 rnd16_result
    jsr Wait_for_key

mainNextPlayerLoop:
mainContinue: