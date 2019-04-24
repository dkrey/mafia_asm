#import "testHeader.asm"

main:
    ldx #04
    add32 money1,x : #$000000ff
    sub32 money1,x : #$0000ffff : hex32dec_value
    //mov32 #$0000ffff : hex32dec_value
    jsr Print_hex32_dec_signed

    jsr Wait_for_key
    rts

result32:
    .dword 00000000

money1:
    .dword $00000001
money2:
    .dword $00000005

mainNextPlayerLoop:
mainContinue: