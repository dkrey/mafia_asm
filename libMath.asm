#importonce

//===============================================================================
// calcPlayerOffsets
//
// Berechnet die Player Offsets
//===============================================================================
calcPlayerOffsets:
    lda currentPlayerNumber
    asl
    sta currentPlayerOffset_2   // 2^1
    asl
    sta currentPlayerOffset_4   // 2^2
    asl
    sta currentPlayerOffset_8   // 2^3
    asl
    sta currentPlayerOffset_16   // 2^4
    rts

//===============================================================================
// divide16
// div16Dividend / div16Divisor = div16Result
// 16 Bit Division
//===============================================================================
//
.label div16Dividend    = $fb     //$fc used for hi-byte
.label div16Divisor     = $58     //$59 used for hi-byte
.label div16Remainder   = $fd     //$fe used for hi-byte
.label div16Res         = div16Dividend

divide16:
    lda #0                  // preset remainder to 0
    sta div16Remainder
    sta div16Remainder+1
    ldx #16                 // repeat for each bit: ...

!divloop:
    asl div16Dividend       // dividend lb & hb*2, msb -> Carry
    rol div16Dividend+1
    rol div16Remainder      // remainder lb & hb * 2 + msb from carry
    rol div16Remainder+1
    lda div16Remainder
    sec
    sbc div16Divisor        // substract divisor to see if it fits in
    tay                     // lb result -> Y, for we may need it later
    lda div16Remainder+1
    sbc div16Divisor+1
    bcc !skip+              // if carry=0 then divisor didn't fit in yet

    sta div16Remainder+1    // else save substraction result as new remainder,
    sty div16Remainder
    inc div16Res            // and INCrement result cause divisor fit in 1 times

!skip:
    dex
    bne !divloop-
    mov16 div16Res : divResult // Move it to another location, since ZP Adresses are used by printing
    rts

divResult:
    .word 0000

.pseudocommand divide16 dividend : divisor {
    clear16 divResult
    lda extract_byte_argument(dividend, 0)
    sta div16Dividend
    lda extract_byte_argument(dividend, 1)
    sta div16Dividend +1

    lda extract_byte_argument(divisor, 0)
    sta div16Divisor
    lda extract_byte_argument(divisor, 1)
    sta div16Divisor +1

    jsr divide16
}

.pseudocommand divide8 dividend : divisor {
    clear16 divResult
    lda extract_byte_argument(dividend, 0)
    sta div16Dividend

    lda extract_byte_argument(divisor, 0)
    sta div16Divisor

    lda #00
    sta div16Dividend +1
    sta div16Divisor +1

    jsr divide16
}


//===============================================================================
// mul8
// Fac1 * Fac2 = mul8Result
// 8 Bit multiplication, 16 Bit result
//===============================================================================
mul8:
.label mul8Fac1     = $58
.label mul8Fac2     = $59
        // A*256 + X = FAC1 * FAC2
        lda #$00
        ldx #$08
        clc
!m0:
        bcc !m1+
        clc
        adc mul8Fac2
!m1:
        ror
        ror mul8Fac1
        dex
        bpl !m0-
        ldx mul8Fac1
        sta mulResult +1
        stx mulResult
        rts

mulResult:
    .word 0000

.pseudocommand mul8 factor1 : factor2 {
    clear16 mulResult
    lda extract_byte_argument(factor1, 0)
    sta mul8Fac1

    lda extract_byte_argument(factor2, 0)
    sta mul8Fac2

    jsr mul8
}