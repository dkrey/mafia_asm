#import "testHeader.asm"

main:
    /*
    lda multi1
    sta mul8Fac1
    lda multi2
    sta mul8Fac2
    jsr mul8
*/
    mul8 multi1 : multi2
    print_hex16 mulResult
    jsr Wait_for_key
    rts

multi1:
    .byte $ff
multi2:
    .byte 02