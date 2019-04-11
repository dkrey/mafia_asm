#import "testHeader.asm"

main:
    /*
    lda multi1
    sta mul8Fac1
    lda multi2
    sta mul8Fac2
    jsr mul8
*/
    sqrt16 #02
    print_hex8 sqrt8_result
    jsr Wait_for_key
    rts
mainNextPlayerLoop: