#importonce
//===============================================================================
// Actions, Missions and such
//
//==============================================================================
gameActionsMenu:
    jsr CLEAR
    mov #BLACK : EXTCOL            //  Overscan
    mov #BROWN : BGCOL0              //  Hintergrund
    mov #BLACK : TEXTCOL           //  Schrift

    mov16 #strActionsMenu : TextPtr // Text: "Besitzverhältnisse:"
    jsr Print_text

    lda #PET_CR
    jsr BSOUT

    mov16 #strPressKey : TextPtr // Text: Weiter
    jsr Print_text
    jsr Wait_for_key
    rts

/*
Bandenkrieg

Revolverhelden bzw. Wächter: max. 9 pro Seite
würfeln von 1-10
Bei Informanten an der Untergrenze +1

Abfrage von Disastern: Wenn genug Bestechungen: Würfeln für mehr Angreifer bzw. Wächter
dann max 3 Revolverhelden oder 3 Wächter extra, ebenfalls per Zufall


 */
