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
    //jsr strToHex32
    jsr Move_input_to_Hex32

    lda #PET_CR
    jsr BSOUT
    Print_hex32_dec strToHex32_result

    mov16 #strPressKey : TextPtr // Text: Weiter
    jsr Print_text
    jsr Wait_for_key

/*
strToHex32:
    ldx #0

!loop:
    lda got_input, x
    beq !done+      // Schluss bei 0
    pha             // String erstmal weglegen
    jsr mul32by10   // zwischenergebnis * 10
    pla             // String wiederholen
    sec             // um PETSCII bereinigen
    sbc #$30
    sta ZeroPageTemp
    clc
    // Hinzuaddieren
    add8To32 ZeroPageTemp : target : target
    mov32 target : source
    inx
    cpx #$0B    // 10 Stellen max.
    bne !loop-

!done:
    rts

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


target:
    .dword $00000000

source:
    .dword $00000000

*/
mainNextPlayerLoop:
mainContinue:
