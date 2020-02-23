#importonce

//===============================================================================
// InputYESNO
//
// Eingabe Ja / Nein bzw. yes no später
//===============================================================================
inputYes:
    .byte 'J'
inputNo:
    .byte 'N'
//===============================================================================
// titleScreen
//
// Der Startbildschirm
//===============================================================================
strVersion:
    .text "Beta 3"
    .byte 0
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
    .text "(c)2019 Geriatrisches Kombinat f*r"
    .byte PET_CR
    .text "   D*ngemittel und Datenverarbeitung"
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

strWelcomePayment:
    .byte PET_CR
    .byte PET_CR
    .text " Startkapital von 60.000$ (J/N) "
    .byte 0

//===============================================================================
// strGameModes
//
// Spielmodus
//===============================================================================
strGameModeChoice:
    .byte PET_CR, PET_CR
    .text " W@hlen Sie das Ziel des Spiels!"
    .byte PET_CR, PET_CR
    .text " 1. Die ganze Gegend:"
    .byte PET_CR
    .text "    Besitzen Sie mehr als alle anderen"
    .byte PET_CR,PET_CR
    .text " 2. Meine erste Million"
    .byte PET_CR
    .text "    H@ufen Sie eine Million Dollar an"
    .byte PET_CR,PET_CR
    .text " 3. Las Vegas:"
    .byte PET_CR
    .text "    Ein Hotel und 100 Automaten"
    .byte PET_CR, PET_CR, 0
//===============================================================================
// General Purpose
//
// Wiederkehrende Texte
//===============================================================================
strYouHave:
    .text " Sie haben "
    .byte 0
strHeHas:
    .text " hat "
    .byte 0

strPerRound:
    .text " / Runde"
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
strBack:
    .byte PET_CR
    .text " 0. Runde beenden "
    .byte PET_CR,PET_CR,0

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

strLine18:
    .fill 18,PET_LINE
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
    .text "   Prostituierte prellen ......... 4"
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
    .text " Ihre Begattungsversuche waren k*mmlich."
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
    .byte PET_CR, 0

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
    .byte PET_CR, 0

strTheftPedestrianSuccess1:
    .text " Der Passant hatte "
    .byte 0
strTheftPedestrianSuccess2:
    .text " bei sich."
    .byte PET_CR, 0
strTheftPedestrianBodyguard:
    .text " Ein Leibw@chter konnte den *berfall"
    .byte PET_CR
    .text " verhindern."
    .byte PET_CR, 0

// Ehrliche Arbeit
strTheftJobWait:
    .text " Sie legen sich auf die Lauer und "
    .byte PET_CR
    .text " hoffen auf einen potenten Arbeitgeber."
    .byte PET_CR, 0

strTheftTooRich:
    .byte PET_CR
    .text " Aber aber..."
    .byte PET_CR, PET_CR
    .text " Bei Ihren Einkommensverh@ltnissen "
    .byte PET_CR
    .text " werden Sie sich doch nicht selbst"
    .byte PET_CR
    .text " die H@nde schmutzig machen."
    .byte PET_CR, 0

strTheftNotFound:
    .byte PET_CR
    .text " Leider fand sich niemand,"
    .byte PET_CR
    .text " der Ihre F@higkeiten"
    .byte PET_CR
    .text " zu sch@tzen wusste."

    .byte PET_CR, 0

strTheftJobIntro1:
    .byte PET_CR
    .text " Freuen Sie sich!"
    .byte PET_CR, PET_CR
    .text " F*r nur schlappe "
    .byte 0
strTheftJobIntro2:
    .text "$ arbeitet "
    .byte PET_CR
    .byte 0
strTheftJobIntro3:
    .text " diese Runde f*r Sie als"
    .byte PET_CR
    .byte 0

strTheftJob1:
    .text " R*ckenkratzer"
    .byte 0
strTheftJob2:
    .text " Z@pfchen"
    .byte 0
strTheftJob3:
    .text " Sackhaar-Fris&r"
    .byte 0
strTheftJob4:
    .text " Luftpumpe"
    .byte 0
strTheftJob5:
    .text " Buchst*tze"
    .byte 0
strTheftJob6:
    .text " Arschgeweih"
    .byte 0
strTheftJob7:
    .text " Popeldreher"
    .byte 0
strTheftJob8:
    .text " T*rstopper"
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
    .byte 0
strFinancesProstitutes:
    .text " Prostituierte"
    .byte 0
strFinancesBars:
    .text " Bars"
    .byte 0
strFinancesBetting:
    .text " Wettb*ros"
    .byte 0
strFinancesGambling:
    .text " Spielsalons"
    .byte 0
strFinancesBrothels:
    .text " Bordelle"
    .byte 0
strFinancesHotels:
    .text " Hotels"
    .byte 0
// Ausgaben
strFinancesGunfighters:
    .text " Revolverhelden"
    .byte 0
strFinancesBodyguards:
    .text " Leibw@chter   "
    .byte 0
strFinancesGuards:
    .text " Nachtw@chter  "
    .byte 0
strFinancesInformants:
    .text " Informanten   "
    .byte 0
strFinancesAttorneys:
    .text " Anw@lte       "
    .byte 0
strFinancesPolice:
    .text " Wachtmeister  "
    .byte 0
strFinancesInspectors:
    .text " Kommissare    "
    .byte 0
strFinancesJudges:
    .text " Richter       "
    .byte 0
strFinancesStateAttorneys:
    .text " Staatsanw@lte "
    .byte 0
strFinancesMajors:
    .text " B*rgermeister "
    .byte 0

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

strGameModeMillionAlmost:
    .byte PET_CR
    .text " Sie besitzen bereits *ber 750.000 $"
    .byte PET_CR
    .text " Es fehlen nur noch "
    .byte 0

strGameModeMillionWin:
    .byte PET_CR
    .text " Sie haben die Million zuerst erreicht!"
    .byte PET_CR,0

strGameModeVegasAlmost:
    .byte PET_CR
    .text " Das Hotel steht bereits."
    .byte PET_CR
    .text " Es fehlen nur noch "
    .byte 0

strGameModeVegasWin:
    .byte PET_CR
    .text " Das Hotel und alle Automaten "
    .byte PET_CR
    .text " sind an Ort und Stelle."
    .byte PET_CR,0

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

//===============================================================================
// strMainMenu
//
// Hauptmenü
//===============================================================================

strMainMenuTitle:
    .byte PET_CR
    .text " Sie haben folgende M&glichkeiten: "
    .byte PET_CR,PET_CR
    .fill 40,PET_LINE
    .byte PET_CR
    .text "   1. Kleine Diebst@hle"
    .byte PET_CR, PET_CR
    .text "   2. Investitionen"
    .byte PET_CR, PET_CR
    .text "   3. Rekrutierung"
    .byte PET_CR, PET_CR
    .text "   4. Bestechung"
    .byte PET_CR, PET_CR
    .text "   5. Bandenkrieg"
    .byte PET_CR, PET_CR
    .text "   6. Geldtransfer"
    .byte PET_CR, PET_CR
    .text "   7. Besitzverh@ltnisse"
    .byte PET_CR, PET_CR,PET_CR
    .text " Was w@hlen Sie? "
    .byte PET_CR, PET_CR
    .byte 0

//===============================================================================
// strRecruiting
//
// Rekrutierungen
//===============================================================================
strRecruitingTitle:
    .byte PET_CR, PET_CR
    .text " Sie k&nnen folgende Leute einstellen: "
    .byte PET_CR
    .fill 40,PET_LINE
    .byte PET_CR,0
strRecruitingFireAll:
    .text " Alle entlassen"
    .byte 0

//===============================================================================
// strBribery
//
// Bestechungen
//===============================================================================
strBriberyTitle:
    .byte PET_CR, PET_CR
    .text " Wen wollen Sie bestechen? "
    .byte PET_CR
    .fill 40,PET_LINE
    .byte PET_CR,0

strBriberyComputer1:
    .text " Computer"
    .byte 0
strBriberyComputer2:
    .text " Wenn Sie nicht sofort Ihren L&tkolben"
    .byte PET_CR
    .text " da wegnehmen, rufe ich die Polizei!"
    .byte PET_CR, 0
//===============================================================================
// strOverviewTitle
//
// Besitzverhältnisse
//===============================================================================
strOverviewTitle:
    .byte PET_CR
    .text " Besitzverh@ltnisse"
    .byte PET_CR
    .fill 40,PET_LINE
    .byte PET_CR,0

//===============================================================================
// strTransferTitle
//
// Geld überweisen
//===============================================================================
strTransferTitle:
    .byte PET_CR
    .text " Geldtransfer"
    .byte PET_CR
    .fill 40,PET_LINE
    .byte PET_CR,0

strTransferWho:
    .text " An wen soll die *berweisung gehen? "
    .byte PET_CR
    .byte 0

strTransferAccountant:
    .text " Der Beg*nstigte ist "
    .byte 0

strTransferAmount:
    .text " Betrag $ "
    .byte 0

strTransferImpossible:
    .text " Sie machen wohl Witze?! "
    .byte PET_CR
    .byte 0

strTransferNotEnough:
    .text " So viel Geld haben Sie nicht. "
    .byte PET_CR
    .byte 0

strTransferDone:
    .text " Der Betrag wurde *berwiesen. "
    .byte PET_CR
    .byte 0

//===============================================================================
// strDisaster
//
// Schicksalschläge
//===============================================================================
strDisasterProstitute1:
    .text " Ihrer Prostituierten sind schwanger. "
    .byte PET_CR, 0
strDisasterProstitute2:
    .text " Ihrer Prostituierten sind veraltet. "
    .byte PET_CR, 0
strDisasterProstitute3:
    .text "Sie helfen finanziell mit "
    .byte 0
strDisasterSlotMachines:
    .text " Ihrer Automaten sind veraltet. "
    .byte 0
strDisasterHadTo:
    .text " musste(n) "
    .byte 0
strDisasterYours:
    .text " Ihrer"
    .byte 0
strDisasterCloseDown:
    .byte PET_CR
    .text " geschlossen werden."
    .byte PET_CR, 0
strDisasterReason1:
    .text " Aus hygenischen Gr*nden"
    .byte PET_CR,0
strDisasterReason2:
    .text " Wegen akuter Einsturzgefahr"
    .byte PET_CR,0
strDisasterReason3:
    .text " Wegen wiederholter Steuerhinterziehung"
    .byte PET_CR,0
strDisasterReason4:
    .text " Auf Dr@ngen einer B*rgerinitiative"
    .byte PET_CR,0
strDisasterReason5:
    .text " Aus Fairness gegen*ber Ihren Mitspielern"
    .byte PET_CR,0
strDisasterJail1:
    .byte PET_CR
    .text " Sie selbst erhielten "
    .byte 0
strDisasterJail2:
    .text " Runden Haft."
    .byte PET_CR,0

//===============================================================================
// strActions
//
// Aktionen Aufträge und so weiter
//===============================================================================

strGangwarTitle1:
    .byte PET_CR
    .text " Bandenkrieg"
    .byte PET_CR
    .fill 40,PET_LINE
    .byte 0
strGangwarTitle2:
    .byte PET_CR
    .text " Mit wem wollen Sie sich anlegen?"
    .byte PET_CR, PET_CR,0
strGangwarTitle3:
    .byte PET_CR
    .text " Der Kampf entbrennt"
    .byte PET_CR
    .fill 40,PET_LINE
    .byte PET_CR
    .byte 0
strGangwarCancel:
    .text " 0. den Schwanz einkneifen."
    .byte PET_CR,0
strGangwarImpossible:
    .byte PET_CR
    .text " Sie hauen Sich selbst eine rein"
    .byte PET_CR
    .text " und belassen es dabei."
    .byte PET_CR,0
strGangwarMissing:
    .byte PET_CR
    .text " Daf*r fehlen Ihnen"
    .byte PET_CR
    .text " die richtigen Leute."
    .byte PET_CR,0
strGangwarSummary1:
    .byte PET_CR
    .text " Sie wollen bei "
    .byte 0
strGangwarSummary2:
    .byte PET_CR
    .text " gr*ndlich aufr@umen."
    .byte 0

strGangwarAttackersAmount:
    .byte PET_CR
    .text " Davon passen 9 Schergen"
    .byte PET_CR
    .text " in Ihren Kleintransporter."
    .byte 0

strGangwarAttackersBonus:
    .byte PET_CR
    .text " Durch Ihre ausgezeichneten Kontakte"
    .byte PET_CR
    .text " bekommen Sie Verst@rkung."
    .byte 0

strGangwarDefendersAmount:
    .byte PET_CR
    .text " 9 Nachtw@chter schaffen es rechtzeitig"
    .byte PET_CR
    .text " zum vereinbarten Treffpunkt. "
    .byte 0

strGangwarDefendersBonus:
    .byte PET_CR
    .text " Ihr Gegner wurde vorgewarnt"
    .byte PET_CR
    .text " und bekommt Unterst*tzung."
    .byte 0
strGangwarCasualties:
    .text "Verluste:"
    .byte PET_CR,0
strGangwarBurialCost:
    .text "Begr@bniskosten:"
    .byte PET_CR,0

strGangwarWinner1:
    .byte PET_CR, PET_CR
    .text " Die Familie von "
    .byte 0
strGangwarWinner2:
    .byte PET_CR
    .text " hat den Kampf gewonnen."
    .byte 0

strGangwarLoose:
    .byte PET_CR, PET_CR
    .text " Verlusst f*r "
    .byte 0

strInformantTitle:
    .byte PET_CR, PET_CR
    .text " Ihr Informant hat einen Tipp f*r Sie"
    .byte PET_CR
    .fill 40,PET_LINE
    .byte PET_CR, PET_CR,0

strInformantProperty:
    .text " Chef, ich hab hier diese brandheisse"
    .byte PET_CR
    .text " Immobilie an der Hand: "
    .byte PET_CR, PET_CR, 0

strInformantBar:
    .text " Eine schmierige Bar"
    .byte 0
strInformantBetting:
    .text " Ein finsteres Wettb*ro"
    .byte 0
strInformantGambling:
    .text " Ein ranziger Spielsalon"
    .byte 0
strInformantBrothel:
    .text " Ein k@siges Bordell"
    .byte 0
strInformantHotel:
    .text " Ein bauf@lliges Grandhotel"
    .byte 0

strInformantForJust:
    .byte PET_CR,PET_CR,PET_CR
    .text " f*r nur schlappe "
    .byte 0

strInformantDeal:
    .byte PET_CR,PET_CR
    .text " Schlagen Sie ein? (J/N) "
    .byte 0

strInformantYes:
    .byte PET_CR, PET_CR
    .text " Mein Kontaktmann wird sich freuen."
    .byte PET_CR, PET_CR, 0

strInformantNo:
    .byte PET_CR, PET_CR
    .text " Dann verzieh dich, Meister."
    .byte PET_CR, PET_CR, 0

strInformantDept:
    .text " Ihr Bankkonto eher nicht."
    .byte PET_CR, PET_CR, 0
