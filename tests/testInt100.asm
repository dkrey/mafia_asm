#import "testHeader.asm"



//Print_hex32_dec
main:
    Print_hex32_dec source

    jsr mul32by10

    lda #PET_CR
    jsr BSOUT


    lda #PET_CR
    jsr BSOUT
    Print_hex32_dec target

    lda #PET_CR
    jsr BSOUT

    mov16 #strPressKey : TextPtr // Text: Weiter
    jsr Print_text
    jsr Wait_for_key

mul32by10:
    // Source * 2
    lda source
    asl
    sta target
    lda source +1
    rol
    sta target +1
    lda source +2
    rol
    sta target +2
    lda source +3
    rol
    sta target +3
    // target * 2
    jsr mul2
    // + source
    clc
    lda target
    adc source
    sta target
    lda target +1
    adc source +1
    sta target +1
    lda target +2
    adc source +2
    sta target +2
    lda target +3
    adc source +3
    sta target +3
mul2:
    // target *2
    asl target
    rol target +1
    rol target +2
    rol target +3
    rts
/*
mul32by10:

    // Source * 2
    lda source
    asl
    sta target
    lda source +1
    rol
    sta target +1
    lda source +2
    rol
    sta target +2
    lda source +3
    rol
    sta target +3
    // target * 2
    lda target
    asl
    sta target
    lda target +1
    rol
    sta target +1
    lda target +2
    rol
    sta target +2
    lda target +3
    rol
    sta target +3

    // + target
    clc
    lda target
    adc source
    sta target
    lda target +1
    adc source +1
    sta target +1
    lda target +2
    adc source +2
    sta target +2
    lda target +3
    adc source +3
    sta target +3

    // target *2
    lda target
    asl
    sta target
    lda target +1
    rol
    sta target +1
    lda target +2
    rol
    sta target +2
    lda target +3
    rol
    sta target +3
    rts
*/
target:
    .dword $00000000

source:
    .dword $000000ff

mainNextPlayerLoop:
mainContinue:
