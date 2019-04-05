#importonce

//===============================================================================
// calcPlayerOffsets
//
// Berechnet die Player Offsets
// aktueller Spieler muss ins X-Register
//===============================================================================
calcPlayerOffsets:
    txa
    asl
    sta currentPlayerOffset_2   // 2^1
    asl
    sta currentPlayerOffset_4   // 2^2
    asl
    sta currentPlayerOffset_8   // 2^3
    asl
    sta currentPlayerOffset_16   // 2^4
    rts