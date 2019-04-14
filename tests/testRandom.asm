#import "testHeader.asm"

main:
    //getRandomRange16 #$0001 : #$0064
    //print_int16 rnd16_result

    //getRandomRange16 #$0000 : #$a000
    //print_hex16 rnd16_result

    getRandomRange32 #00000001 : #$00000064
    print_int32 rnd32_result


    lda #PET_CR
    jsr BSOUT
    jsr Wait_for_key
    jmp main
mainNextPlayerLoop:
mainContinue: