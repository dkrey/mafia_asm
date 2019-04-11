#import "testHeader.asm"

main:
/*
    lda dividend
    sta div16Dividend
    lda dividend +1
    sta div16Dividend +1

    lda divisor
    sta div16Divisor
    lda divisor +1
    sta div16Divisor +1

    jsr divide16
*/
    divide16 dividend : divisor
    //divide16 #$000c : #$0002

    print_int16 divResult
    jsr Wait_for_key
    rts

dividend:
    .word $00a0
divisor:
    .word $0004
