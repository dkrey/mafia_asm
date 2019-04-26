#import "testHeader.asm"

main:

    compare32 #$00002a21 : #$00003a21
    //compare16  #$00ff : #$00fe
    //
    beq is_equal
    bcs is_bigger //or equal
    bcc is_smaller
is_smaller:
    print_hex8 #$01
    jsr Wait_for_key
    rts

is_bigger:
    print_hex8 #$02
    jsr Wait_for_key
    rts
is_equal:
    print_hex8 #$0f
    jsr Wait_for_key
    rts
mainNextPlayerLoop:
mainContinue: