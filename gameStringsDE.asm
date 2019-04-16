#importonce

//===============================================================================
// titleScreen
//
// Der Startbildschirm
//===============================================================================
strTitleScreen:
    .byte PET_BLACK
    .fill 8, PET_SPACE
    .text "Mafia Assembler Editon"
    .byte PET_CR,PET_CR

    .fill 8, PET_SPACE
    .fill 22,PET_LINE
    .byte PET_CR,PET_CR
    .text " Nach einer Fabel von Sascha Laffrenzen"
    .byte PET_CR,PET_CR

    .fill 7, PET_SPACE
    .text "Freigegeben ab 80 Jahren"
    .fill 4,PET_CR



    .fill 5, PET_SPACE
    .text "(Weiter mit beliebiger Taste)"

    .byte PET_RED
    .fill 5, PET_CR
    .text "(c) 2019 Pathetisches Institut"
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
    .text "Wie viele Mitspieler (2-8) ? "
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
    .byte PET_CR, PET_CR
    .text "(Weiter mit beliebiger Taste)"
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
strRound:
    .text " Runde"
    .byte 0
strRounds:
    .text " Runden"
    .byte 0

//===============================================================================
// Jail
//
// Gefängnisdinge
//===============================================================================
strJailEscape:
    .text " Ihnen ist der Ausbruch gelungen!"
    .byte PET_CR, 0

strJailProstitute:
    .text " Sie erhielten die Nachricht, dass eine"
    .byte PET_CR
    .text " Ihrer Prostituierten sich einen"
    .byte PET_CR
    .text " anderen Zuh@lter gesucht hat."
    .byte PET_CR, PET_CR, PET_CR, 0

strJailAttorney:
    .text " Ihr Anwalt konnte Sie rausholen."
    .byte PET_CR, 0

strJailAlmostFree:
    .text " Sie kommen dieses Jahr frei."
    .byte PET_CR, 0

strJailWait1:
    .text " Sie sind im Gefaengnis und haben noch "
    .byte PET_CR
    .byte 0

strJailWait2:
    .text " abzusitzen."
    .byte PET_CR, 0

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
    .text "   Auf dem Strich missionieren ... 4"
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
    .text " hat sie"
    .byte PET_CR
    .text " verpfiffen. "
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
    .text " Gef@ngnis."
    .byte PET_CR
    .byte 0


//===============================================================================
// Kleine Diebstähle
//
//===============================================================================
// Bank
strTheftBankSuccess:
    .text " Ihr Bankraub war erfolgreich."
    .byte PET_CR
    .text " Sie erbeuteten "
    .byte 0

// Automaten
strTheftSlotMachineOwner:
    .text " Der Automat geh&rte "
    .byte 0

strTheftSlotMachineSuccess:
    .text " Der Automat enthielt "
    .byte 0

// Bar
strTheftBarOwner:
    .text " Die Bar geh&rte "
    .byte 0
strTheftBarSuccess:
    .text " Der Ueberfall brachte "
    .byte 0
strTheftBarFail:
    .text " Sie sind entwischt, mussten aber die"
    .byte PET_CR
    .text " Beute zur*cklassen. "
    .byte PET_CR, PET_CR , 0

// Strich
strTheftKerbOwner:
    .text " Die Prostituierte geh&rte zu "
    .byte 0
strTheftKerbSuccess1:
    .text " Sie waren sehr beeindruckend."
    .byte PET_CR, PET_CR
    .text " Die Prostituierte hat sich einen"
    .byte PET_CR
    .text " neuen Job gesucht."
    .byte PET_CR, PET_CR
    .text " Die Tageseinnahmen von "
    .byte 0
strTheftKerbSuccess2:
    .byte PET_CR
    .text " d*rfen sie behalten."
    .byte PET_CR
    .byte 0

strTheftKerbFail:
    .text " Aus Mitleid hat man Sie"
    .byte PET_CR
    .text " laufen gelassen."
    .byte PET_CR, PET_CR , 0

// Passant
strTheftPedestrianPlayer1:
    .text " Der Passant war "
    .byte 0
strTheftPedestrianPlayer2:
    .byte PET_CR
    .text " und hatte "
    .byte 0
strTheftPedestrianPlayer3:
    .text " bei sich."
    .byte PET_CR
    .byte 0

strTheftPedestrianSuccess1:
    .text " Der Passant hatte "
    .byte 0
strTheftPedestrianSuccess2:
    .text " bei sich."
    .byte PET_CR
    .byte 0
strTheftPedestrianBodyguard:
    .text " Ein Leibw@chter konnte den *berfall"
    .byte PET_CR
    .text " verhindern."
    .byte PET_CR
    .byte 0