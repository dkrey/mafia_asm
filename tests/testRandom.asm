#import "testHeader.asm"

main:
    //getRandomRange16 #$0001 : #$0064
    //print_int16 rnd16_result

    //getRandomRange16 #$0000 : #$a000
    //print_hex16 rnd16_result

    //getRandomRange32 #00000001 : #$00000064
    //print_int32 rnd32_result

    //randomPerm8 #$08



//Zahlenreihe Durcheinander:
randomPerm8 #$08
    ldx #00
!loop:
    txa
    pha
    Print_hex8_dec rndPerm8_result, x
    pla
    tax
    inx
    cpx #$08
    bne !loop-

    lda #'.'
    jsr BSOUT
    lda #PET_CR
    jsr BSOUT
    jsr Wait_for_key
    jmp main
mainNextPlayerLoop:
mainContinue: