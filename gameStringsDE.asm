#importonce

//===============================================================================
// titleScreen
//
// Der Startbildschirm
//===============================================================================
.pc = * "Title text"

strTitleScreen:
    .byte PET_BLACK
    .fill 8, PET_SPACE
    .text "Mafia Assembler Editon"
    .byte PET_CR,PET_CR

    .fill 8, PET_SPACE
    .fill 22,PET_LINE
    .byte PET_CR,PET_CR

    .fill 6, PET_SPACE
    .text "(Freigegeben ab 18 Jahren)"
    .byte PET_CR,PET_CR

    .fill 4, PET_SPACE
    .text "von und ohne Sascha Laffrenzen"
    .byte PET_CR,PET_CR,PET_CR,PET_CR

    .fill 5, PET_SPACE
    .text "(Weiter mit beliebiger Taste)"

    .byte PET_CR,PET_CR,PET_CR,PET_CR,PET_CR
    .text "(c) 2019 Kreybernetisches Institut"
    .byte PET_CR
    .text "         f. angewannte Informatik"
    .byte 0

//===============================================================================
// howManyScreen
//
// Wie viele Mitspieler
//===============================================================================
strHowManyScreen:
    .byte PET_CLEAR_SCREEN
    .byte PET_YELLOW
    .text "Wie viele Mitspieler? "
    .byte 0

strEnterName:
    .byte PET_CR
    .text "Ihr Name, Spieler "
    .byte 0
