#importonce

//===============================================================================
// titleScreen
//
// Der Startbildschirm
//===============================================================================
strTitleScreen:
    .byte PET_BLACK
    .fill 8, PET_SPACE
    .text "Mafia Assembler Edition"
    .byte PET_CR,PET_CR

    .fill 8, PET_SPACE
    .fill 23,PET_LINE
    .byte PET_CR,PET_CR,PET_CR
    .text " Nach einer Fabel von Sascha Laffrenzen"
    .byte PET_CR,PET_CR

    .fill 7, PET_SPACE
    .text "Freigegeben ab 80 Jahren"
    .fill 4,PET_CR



    .fill 5, PET_SPACE
    .text "(Weiter mit beliebiger Taste)"

    .byte PET_RED
    .fill 5, PET_CR
    .text "(c) 2019 Proktologisches Institut"
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
    .text "Ist das richtig (J/N)? "
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

strTotal:
    .text "Gesamt"
    .byte 0
strChoice:
    .text " Ihre Wahl ? "
    .byte 0

strSelectNothing:
    .byte PET_CR
    .text " 0. Nichts"
    .byte PET_CR,PET_CR,0

strLine40:
    .fill 40,PET_LINE
    .byte PET_CR,0

strLine14:
    .fill 14,PET_LINE
    .byte PET_CR,0

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
    .byte PET_CR, PET_CR,0

strTheftKerbSuccess2:
    .text " Die Prostituierte hat sich einen"
    .byte PET_CR
    .text " neuen Job gesucht."
    .byte PET_CR, PET_CR
    .text " Die Tageseinnahmen von "
    .byte 0

strTheftKerbSuccess3:
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

//===============================================================================
// Finanzen
//
//===============================================================================
strFinancesTitle:
    .fill 14, PET_SPACE
    .text "Finanzen"
    .byte PET_CR
    .fill 14, PET_SPACE
    .fill 8,PET_LINE
    .byte PET_CR, PET_CR, 0

strFinancesIncome:
    .text " Ihre Einnahmen sind:"
    .byte PET_CR, PET_CR, 0
strFinancesCosts:
    .text "Ihre Ausgaben:"
    .byte PET_CR, PET_CR, 0

strFinancesFinal:
    .byte PET_CR
    .text "Damit betr@gt ihr Verm&gen"
    .byte PET_CR, PET_CR, 0

// Einkommenspositionen
strFinancesSlotMachines:
    .text " Spielautomaten"
    .byte PET_CR, 0
strFinancesProstitutes:
    .text " Prostituierte"
    .byte PET_CR, 0
strFinancesBars:
    .text " Bars"
    .byte PET_CR, 0
strFinancesBetting:
    .text " Wettb*ros"
    .byte PET_CR, 0
strFinancesGambling:
    .text " Spielsalons"
    .byte PET_CR, 0
strFinancesBrothels:
    .text " Bordelle"
    .byte PET_CR, 0
strFinancesHotels:
    .text " Hotels"
    .byte PET_CR, 0

// Ausgaben
strFinancesGunfighters:
    .text " Revolverhelden"
    .byte PET_CR, 0
strFinancesBodyguards:
    .text " Leibw@chter"
    .byte PET_CR, 0
strFinancesGuards:
    .text " Nachtw@chter"
    .byte PET_CR, 0
strFinancesInformants:
    .text " Informanten"
    .byte PET_CR, 0
strFinancesAttorneys:
    .text " Anw@lte"
    .byte PET_CR, 0
strFinancesPolice:
    .text " Wachtmeister"
    .byte PET_CR, 0
strFinancesInspectors:
    .text " Kommissare"
    .byte PET_CR, 0
strFinancesJudges:
    .text " Richter"
    .byte PET_CR, 0
strFinancesStateAttorneys:
    .text " Staatsanw@lte"
    .byte PET_CR, 0
strFinancesMajors:
    .text " B*rgermeister"
    .byte PET_CR, 0

//===============================================================================
// shoppingMenu
//
// Gangsterbedarf
//===============================================================================

strShopTitle:
    .byte PET_CR, PET_CR
    .text " Die Anschaffungspreise sind: "
    .byte PET_CR
    .fill 40,PET_LINE
    .byte PET_CR,0
strShopSlotMachines:
    .text " 1. Spielautomaten (drei) ..... "
    .byte 0
strShopProstitutes:
    .text " 2. Prostituierte (eine) ...... "
    .byte 0
strShopBars:
    .text " 3. Bar ....................... "
    .byte 0
strShopBetting:
    .text " 4. Wettb*ro ................. "
    .byte 0
strShopGambling:
    .text " 5. Spielsalon ............... "
    .byte 0
strShopBrothels:
    .text " 6. Nobelbordell ............ "
    .byte 0
strShopHotels:
    .text " 7. Grandhotel ............. "
    .byte 0

//===============================================================================
// strPropertyOverview
//
// Sie beherrschen die Gegend
//===============================================================================
strPropertyOverview1:
    .text " Prozent gilt es zu beherrschen."
    .byte PET_CR, PET_CR, 0

strPropertyOverview2:
    .byte PET_CR
    .text " Sie beherrschen nun "
    .byte 0

strPropertyOverview3:
    .text " Prozent"
    .byte PET_CR
    .text " der ganzen Gegend."
    .byte PET_CR,0

strPropertyWin:
    .byte PET_CR
    .text " Damit haben sie gewonnen!!!"
    .byte PET_CR, PET_CR
    .byte 0

//===============================================================================
// strDept
//
// Sie beherrschen die Gegend
//===============================================================================
strDeptInfo1:
    .byte PET_CR, PET_CR
    .text " Sie haben Schulden!"
    .byte PET_CR, 0
strDeptInfo2:
    .byte PET_CR, PET_CR
    .text " Es bleiben Ihnen "
    .byte 0
strDeptInfo3:
    .text " Runden,"
    .byte PET_CR
    .text " diese auszugleichen."
    .byte PET_CR, PET_CR, PET_CR, 0

strDeptPawn1:
    .text "          Heute ist Stichtag!"
    .byte PET_CR
    .fill 10, PET_SPACE
    .fill 19,PET_LINE
    .byte PET_CR,PET_CR,0

strDeptFired:
    .byte PET_CR
    .text " Ihr Personal wurde entlassen,"
    .byte PET_CR
    .text " etwaige Restschulden werden erlassen."
    .byte PET_CR, PET_CR, 0

strDeptPawn2:
    .text " Folgende Positionen wurden"
    .byte PET_CR
    .text " gepf@ndet:"
    .byte PET_CR, PET_CR,0

