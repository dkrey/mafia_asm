#importonce

// PET Cursorbewegung
.const PET_HOME         = $13
.const PET_RIGHT        = $9d
.const PET_LEFT         = $9d
.const PET_UP           = $91
.const PET_DOWN         = $11

// PET Tasten
.const PET_CR           = $0d
.const PET_SPACE        = $20
.const PET_DELETE       = $14

// PET Extra
.const PET_CLEAR_SCREEN = $93
.const PET_LINE         = $b8

// PET Farben
.const PET_BLACK = $90
.const PET_WHITE = $05
.const PET_RED = $1c
.const PET_CYAN = $9f
.const PET_PURPLE = $9c
.const PET_GREEN = $1e
.const PET_BLUE = $1f
.const PET_YELLOW = $9e
.const PET_ORANGE = $81
.const PET_BROWN = $95
.const PET_PINK = $96
.const PET_DARK_GREY = $97
.const PET_GREY = $98
.const PET_LIGHT_GREEN = $99
.const PET_LIGHT_BLUE = $9a
.const PET_LIGHT_GREY = $9b


//===============================================================================
// Print_text_xy
//
// Gibt einen Null-terminierten Text an bestimmter Stelle aus
// ZP TextPtr: Textstelle
// X-Register: Zeile
// Y-Register: Spalte
//===============================================================================
Print_text_xy:
        clc
        jsr PLOT
        ldy #$00

!loop:
        lda (TextPtr), y
        beq !end+
        jsr BSOUT

!noreset:
        iny
        bne !loop-
!end:
        rts

//===============================================================================
// Print_text_
//
// Gibt einen Null-terminierten Text an bestimmter Stelle aus
// ZP TextPtr: Textstelle
//===============================================================================
Print_text:
        ldy #$00
!loop:
        lda (TextPtr), y
        beq !end+
        jsr BSOUT

!noreset:
        iny
        bne !loop-
!end:
        rts

//===============================================================================
// Print_text_offset
//
// Gibt einen Null-terminierten Text aus
// ZP TextPtr: Textstelle
// y = Offset im Speicher
//===============================================================================
Print_text_offset:

!loop:
        lda (TextPtr), y
        beq !end+
        jsr BSOUT

!noreset:
        iny
        bne !loop-
!end:
        rts


Print_hex32_dec:
