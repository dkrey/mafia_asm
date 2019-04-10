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

    .byte PET_RED
    .byte PET_CR,PET_CR,PET_CR,PET_CR,PET_CR
    .text "(c) 2019 Kybernetisches Institut"
    .byte PET_CR
    .text "    f*r abgewandte Informatik"
    .byte PET_BLACK, 0

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

strCheckAllNames:
    .byte PET_CLEAR_SCREEN
    .byte PET_YELLOW
    .text "Es spielen mit: "
    .byte PET_CR, PET_CR
    .byte 0
strIsThatCorrect:
    .text "Ist das richtig (j/n)? "
    .byte 0
strGoodLuck:
    .byte PET_CR,PET_CR
    .text "M&ge der Bessere gewinnen!"
    .byte PET_CR
    .text "(Weiter mit beliebiger Taste)"
    .byte 0

//===============================================================================
// smallTheftMenu
//
// Kleine Diebstähle
//===============================================================================

strSmallTheftMenu1:
    .byte PET_CR, PET_CR
    .text " Sie k&nnen folgendes tun:"
    .byte PET_CR
    .fill 40,PET_LINE
    .byte PET_CR
    .text "   Eine Bank ausrauben ........... 1"
    .byte PET_CR, PET_CR
    .text "   Einen Automaten knacken ....... 2"
    .byte PET_CR, PET_CR
    .text "   Eine Bar *berfallen ........... 3"
    .byte PET_CR, PET_CR
    .text "   Ein Auto klauen und verkaufen . 4"
    .byte PET_CR, PET_CR
    .byte 0
strSmallTheftMenu2:
    .text "   Einen Passanten ausnehmen ..... 5"
    .byte PET_CR, PET_CR
    .text "   Eine ehrliche Arbeit annehmen . 6"
    .byte PET_CR, PET_CR
    .text "   Keines davon .................. 7"
    .byte PET_CR, PET_CR
    .text "  Ihre Wahl ? "
    .byte 0
//===============================================================================
// General Purpose
//
// Wiederkehrende Texte
//===============================================================================
strYouHaveMoney:
    .text " Sie haben "
    .byte 0

strPressKey:
    .byte PET_CR
    .text "(Weiter mit beliebiger Taste)"
    .byte 0

//===============================================================================
// TheftMisfortune
// Pech beim Diebstal
//===============================================================================

strTheftMisfortune1:
    .text " Pech"
    .byte PET_CR, PET_CR
    .byte 0
strTheftMisfortune2:
    .text " Ein Passant schlug Alarm."
    .byte PET_CR, PET_CR
    .byte 0
strTheftMisfortune3:
    .text " Die Polizei wurde auf Sie aufmerksam."
    .byte PET_CR, PET_CR
    .byte 0
strTheftMisfortune4:
    .text " Eine Streife ueberraschte Sie."
    .byte PET_CR, PET_CR
    .byte 0
strTheftMisfortune5:
    .text " Sie stellten sich ziemlich bl&de an."
    .byte PET_CR, PET_CR
    .byte 0
strTheftMisfortune6:
    .text " Ihre Mutter hat Sie verpfiffen!"
    .byte PET_CR, PET_CR
    .byte 0
strTheftMisfortune7:
    .text " Ihr Rheuma machte Ihnen wieder"
    .byte PET_CR
    .text " zu schaffen."
    .byte PET_CR, PET_CR
    .byte 0
strTheftMisfortune8_1:
    .text " Die Mutter von "
    .byte 0
strTheftMisfortune8_2:
    .byte PET_CR
    .text " hat sie verpfiffen. "
    .byte PET_CR, PET_CR
    .byte 0

strTheftEscape:
    .text " Sie konnten jedoch entkommen."
    .byte PET_CR
    .byte 0

strTheftJail1:
    .text " Sie wurden von der Polizei gefasst"
    .byte PET_CR
    .text " und erhielten "
    .byte 0
strTheftJail2:
    .text " Runden Gef@ngnis"
    .byte PET_CR
    .byte 0


//===============================================================================
// Kleine Diebstähle
//
//===============================================================================
strTheftBankSuccess:
    .text " Ihr Bankraub war erfolgreich."
    .byte PET_CR
    .text " Sie erbeuteten "
    .byte 0