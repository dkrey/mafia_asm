#import "testHeader.asm"



//Print_hex32_dec
main:
    ldy #$0A                    // Anzahl Zeichen für die Input Routine: 10
    ldx #<filter_numeric        // Filter setzen LSB: Zahlen
    lda #>filter_numeric        // Filter setzen MSB: Zahlen

    jsr Get_filtered_input          // Input holen und speichern
    lda got_input                   // Ergebnis holen
    cmp #0                          // Prüfen, ob Spieleranzahl stimmt
    beq main          // Wenn einfach nur Enter gedrückt wurde,
                                    //  nochmal von vor
    //printhexfuckand50

    jsr strToHex32

    mov16 #strPressKey : TextPtr // Text: Weiter
    jsr Print_text
    jsr Wait_for_key


strToHex32:
    //Initialize multiplier, the running total, to zero
    ldx #0
    stx multiplier
    stx multiplier +1

!loop:
    lda got_input, x
    beq !done+      // Schluss bei 0
    inx
    pha
    // Multi32 Temp
    // petscii - $30 + temp


!done:
    rts

mul10:
    ldy #32
    ldx #0
    clc

!loop:
    lda result, x
    rol //n=n*2
    sta temp,x
    inx
    dey
    bne !loop-

    ldx #3 //hä?

    // n*8
!loop:
    asl result
    rol result +1
    rol result +2
    rol result +3
    dex
    bne !loop-

    // n*2 + n*8
    ldx #0
    ldy #4

!loop:
    lda result,x
    adc temp,x
    sta result,x
    inx
    dey
    bne !loop-



!skip:
// vars:
//
//
multiplier:
    .word $0000

result:
    .dword $00000000

temp:
    .dword $00000000

mainNextPlayerLoop:
mainContinue: