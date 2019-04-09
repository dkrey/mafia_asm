//===============================================================================
// Tests
//
.encoding "petscii_mixed"
//===============================================================================
//
// Import helpers
#import "../helpers.asm"
#import "../gameMemory.asm"

#import "../libText.asm"
#import "../libInput.asm"
#import "../libMath.asm"
#import "../gameStringsDE.asm"

.label border = $d020
.label background = $d021
.label screen_memory = $0400


:BasicUpstart2(main)

main:
    .encoding "screencode_mixed"
    // Lower Case Char Mode
    mov #$17: $D018


loop:
    lda #00 // Random Untergrenze
    sta rnd_low
    lda #07
    sta rnd_high

    jsr getRandom
    sta rnd_result
    :print_int8 rnd_result
    lda rnd_result
    tax
    lda missfortune_tabl_low, x
    sta TextPtr
    lda missfortune_tabl_high, x
    sta TextPtr + 1
    jsr Print_text
return_loop:
    lda #PET_CR
    jsr BSOUT
    jsr Wait_for_key
    jmp loop




missfortune_tabl_low:
    .byte <strTheftMisfortune1, <strTheftMisfortune2, <strTheftMisfortune3, <strTheftMisfortune4, <strTheftMisfortune5, <strTheftMisfortune6, <strTheftMisfortune7

missfortune_tabl_high:
    .byte >strTheftMisfortune1, >strTheftMisfortune2, >strTheftMisfortune3, >strTheftMisfortune4, >strTheftMisfortune5, >strTheftMisfortune6, >strTheftMisfortune7
rnd_result:
    .byte 0