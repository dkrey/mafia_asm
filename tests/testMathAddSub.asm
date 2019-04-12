#import "testHeader.asm"

main:
    ldx #04
    add32 money1,x : #$00000001 : result32
    print_int32 result32
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