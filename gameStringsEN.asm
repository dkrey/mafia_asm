#importonce

//===============================================================================
// InputYESNO
//
// Eingabe Ja / Nein bzw. yes no später
//===============================================================================
inputYes:
    .byte 'Y'
inputNo:
    .byte 'N'
//===============================================================================
// titleScreen
//
// Der Startbildschirm
//===============================================================================
strVersion:
    .text "Beta 1"
    .byte 0
strTitleScreen:
    .byte PET_BLACK
    .fill 8, PET_SPACE
    .text "Mafia Assembler Edition"
    .byte PET_CR,PET_CR

    .fill 8, PET_SPACE
    .fill 23,PET_LINE
    .byte PET_CR,PET_CR,PET_CR
    .text " After a fable of Sascha Laffrenzen"
    .byte PET_CR,PET_CR

    .fill 7, PET_SPACE
    .text "Content rated: elderly 80+ "
    .fill 4,PET_CR



    .fill 5, PET_SPACE
    .text "(Press any key)"

    .byte PET_RED
    .fill 5, PET_CR
    .text "(c)2019 Geriatric state combine for"
    .byte PET_CR
    .text "   dung and dataprocessing"
    .byte PET_BLACK, 0

//===============================================================================
// howManyScreen
//
// Wie viele Mitspieler
//===============================================================================
strHowManyScreen:
    .byte PET_CLEAR_SCREEN
    .byte PET_YELLOW
    .text "How many players (2-8) ? "
    .byte 0

strEnterName:
    .byte PET_CR
    .text "Your name, player "
    .byte 0

strCheckAllNames:
    .byte PET_CLEAR_SCREEN
    .byte PET_YELLOW
    .text "Todays players: "
    .byte PET_CR, PET_CR
    .byte 0
strIsThatCorrect:
    .text "Is that correct (Y/N)? "
    .byte 0
strGoodLuck:
    .byte PET_CR,PET_CR
    .text "Godspeed, suckers!"
    .byte PET_CR, PET_CR
    .text "(Press any key)"
    .byte 0

strWelcomePayment:
    .byte PET_CR
    .byte PET_CR
    .text " 60.000$ seed money? (Y/N) "
    .byte 0

//===============================================================================
// strGameModes
//
// Spielmodus
//===============================================================================
strGameModeChoice:
    .byte PET_CR, PET_CR
    .text " Please chose the game's goal!"
    .byte PET_CR, PET_CR
    .text " 1. The whole neighborhood"
    .byte PET_CR
    .text "    Own more than anyone else."
    .byte PET_CR,PET_CR
    .text " 2. My first million"
    .byte PET_CR
    .text "    Be the first to grub a million"
    .byte PET_CR,PET_CR
    .text " 3. Las Vegas:"
    .byte PET_CR
    .text "    One hotel and 100 slot machines."
    .byte PET_CR, PET_CR, 0
//===============================================================================
// General Purpose
//
// Wiederkehrende Texte
//===============================================================================
strYouHave:
    .text " You have"
    .byte 0
strHeHas:
    .text " has "
    .byte 0

strPerRound:
    .text " / round"
    .byte 0

strPressKey:
    .byte PET_CR
    .text "(Press any key)"
    .byte 0
strRound:
    .text " round"
    .byte 0
strRounds:
    .text " rounds"
    .byte 0

strTotal:
    .text "Total"
    .byte 0
strChoice:
    .text " Your choice ? "
    .byte 0
strBack:
    .byte PET_CR
    .text " 0. End round "
    .byte PET_CR,PET_CR,0

strSelectNothing:
    .byte PET_CR
    .text " 0. nothing "
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
    .text " You managed to escape!"
    .byte PET_CR, 0

strJailProstitute:
    .text " Your received the message that"
    .byte PET_CR
    .text " one of your prostitutes went"
    .byte PET_CR
    .text " to another pimp."
    .byte PET_CR, PET_CR, PET_CR, 0

strJailAttorney:
    .text " Your attorney bailed you out."
    .byte PET_CR, 0

strJailAlmostFree:
    .text " You will be released this year."
    .byte PET_CR, 0

strJailWait1:
    .text " You have to do time for "
    .byte PET_CR
    .byte 0

strJailWait2:
    .text " in jail."
    .byte PET_CR, 0

//===============================================================================
// smallTheftMenu
//
// Kleine Diebstähle
//===============================================================================

strSmallTheftMenu1:
    .byte PET_CR, PET_CR
    .text " You can do the following:"
    .byte PET_CR
    .fill 40,PET_LINE
    .byte PET_CR
    .text "   Rob a bank .................... 1"
    .byte PET_CR, PET_CR
    .text "   Bust a slotmachine ............ 2"
    .byte PET_CR, PET_CR
    .text "   Rob a bar  .................... 3"
    .byte PET_CR, PET_CR
    .text "   Scam a prostitute ............. 4"
    .byte PET_CR, PET_CR
    .byte 0
strSmallTheftMenu2:
    .text "   Rip off a pedestrian .......... 5"
    .byte PET_CR, PET_CR
    .text "   Find a honest job ............. 6"
    .byte PET_CR, PET_CR
    .text "   Nothing ....................... 7"
    .byte PET_CR, PET_CR
    .byte 0

//===============================================================================
// TheftMisfortune
// Pech beim Diebstal
//===============================================================================

strTheftMisfortune1:
    .text " Tough Luck"
    .byte PET_CR, PET_CR
    .byte 0
strTheftMisfortune2:
    .text " A pedestrian raised an alarm."
    .byte PET_CR, PET_CR
    .byte 0
strTheftMisfortune3:
    .text " The police became attentive."
    .byte PET_CR, PET_CR
    .byte 0
strTheftMisfortune4:
    .text " A police patrol cought you by surprise."
    .byte PET_CR, PET_CR
    .byte 0
strTheftMisfortune5:
    .text " You messed up badly."
    .byte PET_CR, PET_CR
    .byte 0
strTheftMisfortune6:
    .text " Your mother snitched on you!"
    .byte PET_CR, PET_CR
    .byte 0
strTheftMisfortune7:
    .text " Your rheumatism struck again."

    .byte PET_CR, PET_CR
    .byte 0
strTheftMisfortune8_1:
    .text " The mother of "
    .byte 0
strTheftMisfortune8_2:
    .text " snitched"
    .byte PET_CR
    .text " on you. "
    .byte PET_CR, PET_CR
    .byte 0

strTheftEscape:
    .text " You managed to escape though."
    .byte PET_CR
    .byte 0

strTheftJail1:
    .text " The police cought you."
    .byte PET_CR
    .text " You've been sentenced to "
    .byte 0
strTheftJail2:
    .text " of jail."
    .byte PET_CR
    .byte 0


//===============================================================================
// Kleine Diebstähle
//
//===============================================================================
// Bank
strTheftBankSuccess:
    .text " Your bank robbery was successful."
    .byte PET_CR
    .text " You looted "
    .byte 0

// Automaten
strTheftSlotMachineOwner:
    .text " The slotmachine's owner was "
    .byte 0

strTheftSlotMachineSuccess:
    .text " The slotmachine contained "
    .byte 0

// Bar
strTheftBarOwner:
    .text " The bar's owner was "
    .byte 0
strTheftBarSuccess:
    .text " The robbery brought you "
    .byte 0
strTheftBarFail:
    .text " You managed to get way, but"
    .byte PET_CR
    .text " without any loot. "
    .byte PET_CR, PET_CR , 0

// Strich
strTheftKerbOwner:
    .text " The prostitute's pimp was "
    .byte 0
strTheftKerbSuccess1:
    .text " Your performance was crummy "
    .byte PET_CR, PET_CR,0

strTheftKerbSuccess2:
    .text " The prostitute decided to look"
    .byte PET_CR
    .text " for a new job."
    .byte PET_CR, PET_CR
    .text " The day's takings of "
    .byte 0

strTheftKerbSuccess3:
    .byte PET_CR
    .text " are yours to keep."
    .byte PET_CR, 0

strTheftKerbFail:
    .text " Out of mercy "
    .byte PET_CR
    .text " they let you scram."
    .byte PET_CR, PET_CR , 0

// Passant
strTheftPedestrianPlayer1:
    .text " The pedestrian was "
    .byte 0
strTheftPedestrianPlayer2:
    .byte PET_CR
    .text " and had "
    .byte 0
strTheftPedestrianPlayer3:
    .text " in his purse."
    .byte PET_CR, 0

strTheftPedestrianSuccess1:
    .text " The pedestrian had "
    .byte 0
strTheftPedestrianSuccess2:
    .text " in his purse."
    .byte PET_CR, 0
strTheftPedestrianBodyguard:
    .text " A bodyguard was able to "
    .byte PET_CR
    .text " prevent the assault."
    .byte PET_CR, 0

// Ehrliche Arbeit
strTheftJobWait:
    .text " You are on the qui vive "
    .byte PET_CR
    .text " and hope for a potent employer"
    .byte PET_CR, 0

strTheftTooRich:
    .byte PET_CR
    .text " Oh please..."
    .byte PET_CR, PET_CR
    .text " With your income "
    .byte PET_CR
    .text " you won't dirty your hands."
    .byte PET_CR, 0

strTheftNotFound:
    .byte PET_CR
    .text " Unfortunately there was "
    .byte PET_CR
    .text " nobody to be found who cared "
    .byte PET_CR
    .text " to employ you."

    .byte PET_CR, 0

strTheftJobIntro1:
    .byte PET_CR
    .text " Joy and Happiness!"
    .byte PET_CR, PET_CR
    .text " For just "
    .byte 0
strTheftJobIntro2:
    .text "$ "
    .byte PET_CR
    .byte 0
strTheftJobIntro3:
    .text " is working for you as "
    .byte PET_CR
    .byte 0

strTheftJob1:
    .text " backscratcher"
    .byte 0
strTheftJob2:
    .text " suppository"
    .byte 0
strTheftJob3:
    .text " pubic hair stylist"
    .byte 0
strTheftJob4:
    .text " air pump"
    .byte 0
strTheftJob5:
    .text " bookend"
    .byte 0
strTheftJob6:
    .text " tramp stamp"
    .byte 0
strTheftJob7:
    .text " chest hair toupet"
    .byte 0
strTheftJob8:
    .text " doorstopper"
    .byte 0

//===============================================================================
// Finanzen
//
//===============================================================================
strFinancesTitle:
    .fill 14, PET_SPACE
    .text "Finances"
    .byte PET_CR
    .fill 14, PET_SPACE
    .fill 8,PET_LINE
    .byte PET_CR, PET_CR, 0

strFinancesIncome:
    .text " Your income:"
    .byte PET_CR, PET_CR, 0
strFinancesCosts:
    .text " Your outcome:"
    .byte PET_CR, PET_CR, 0

strFinancesFinal:
    .byte PET_CR
    .text "Your new total:"
    .byte PET_CR, PET_CR, 0

// Einkommenspositionen
strFinancesSlotMachines:
    .text " Slotmachines"
    .byte 0
strFinancesProstitutes:
    .text " Prostitutes"
    .byte 0
strFinancesBars:
    .text " Bars"
    .byte 0
strFinancesBetting:
    .text " Betting offices"
    .byte 0
strFinancesGambling:
    .text " Arcades"
    .byte 0
strFinancesBrothels:
    .text " Brothels"
    .byte 0
strFinancesHotels:
    .text " Hotels"
    .byte 0
// Ausgaben
strFinancesGunfighters:
    .text " Gunfighters   "
    .byte 0
strFinancesBodyguards:
    .text " Bodyguards    "
    .byte 0
strFinancesGuards:
    .text " Nightwatchman "
    .byte 0
strFinancesInformants:
    .text " Informants    "
    .byte 0
strFinancesAttorneys:
    .text " Attorneys     "
    .byte 0
strFinancesPolice:
    .text " Policemen     "
    .byte 0
strFinancesInspectors:
    .text " Inspectors    "
    .byte 0
strFinancesJudges:
    .text " Judges        "
    .byte 0
strFinancesStateAttorneys:
    .text " StateAttorneys"
    .byte 0
strFinancesMajors:
    .text " Majors        "
    .byte 0

//===============================================================================
// shoppingMenu
//
// Gangsterbedarf
//===============================================================================

strShopTitle:
    .byte PET_CR, PET_CR
    .text " The purchase prices are: "
    .byte PET_CR
    .fill 40,PET_LINE
    .byte PET_CR,0
strShopSlotMachines:
    .text " 1. Slotmachines (three) ...... "
    .byte 0
strShopProstitutes:
    .text " 2. Prostitute (one) .......... "
    .byte 0
strShopBars:
    .text " 3. Bar ....................... "
    .byte 0
strShopBetting:
    .text " 4. Gambling office ........... "
    .byte 0
strShopGambling:
    .text " 5. Arcade .................... "
    .byte 0
strShopBrothels:
    .text " 6. Brothel ................... "
    .byte 0
strShopHotels:
    .text " 7. Grandhotel ................ "
    .byte 0

//===============================================================================
// strPropertyOverview
//
// Sie beherrschen die Gegend
//===============================================================================
strPropertyOverview1:
    .text " percent are to be owned."
    .byte PET_CR, PET_CR, 0

strPropertyOverview2:
    .byte PET_CR
    .text " You now own "
    .byte 0

strPropertyOverview3:
    .text " percent"
    .byte PET_CR
    .text " of the neighborhood."
    .byte PET_CR,0

strPropertyWin:
    .byte PET_CR
    .text " Therefore you win !!!"
    .byte PET_CR, PET_CR
    .byte 0

strGameModeMillionAlmost:
    .byte PET_CR
    .text " You already have over 750.000 $"
    .byte PET_CR
    .text " Only this amount is left: "
    .byte 0

strGameModeMillionWin:
    .byte PET_CR
    .text " You made a million first!"
    .byte PET_CR,0

strGameModeVegasAlmost:
    .byte PET_CR
    .text " One hotel is already yours."
    .byte PET_CR
    .text " There are only missing "
    .byte 0

strGameModeVegasWin:
    .byte PET_CR
    .text " The hotel and all slotmachines "
    .byte PET_CR
    .text " are all on the spot."
    .byte PET_CR,0

//===============================================================================
// strDept
//
// Sie beherrschen die Gegend
//===============================================================================
strDeptInfo1:
    .byte PET_CR, PET_CR
    .text " You are in debt!"
    .byte PET_CR, 0
strDeptInfo2:
    .byte PET_CR, PET_CR
    .text " You have"
    .byte 0
strDeptInfo3:
    .text " rounds left,"
    .byte PET_CR
    .text " to settle all debts."
    .byte PET_CR, PET_CR, PET_CR, 0

strDeptPawn1:
    .text "          Today is due date!"
    .byte PET_CR
    .fill 10, PET_SPACE
    .fill 19,PET_LINE
    .byte PET_CR,PET_CR,0

strDeptFired:
    .byte PET_CR
    .text " Your personnel has been sacked,"
    .byte PET_CR
    .text " outstanding debts have been cancelled."
    .byte PET_CR, PET_CR, 0

strDeptPawn2:
    .text " Following positions have been"
    .byte PET_CR
    .text " pawned:"
    .byte PET_CR, PET_CR,0

//===============================================================================
// strMainMenu
//
// Hauptmenü
//===============================================================================

strMainMenuTitle:
    .byte PET_CR
    .text " These are your choices: "
    .byte PET_CR,PET_CR
    .fill 40,PET_LINE
    .byte PET_CR
    .text "   1. Small thievery"
    .byte PET_CR, PET_CR
    .text "   2. Investments"
    .byte PET_CR, PET_CR
    .text "   3. Recruting"
    .byte PET_CR, PET_CR
    .text "   4. Bribery"
    .byte PET_CR, PET_CR
    .text "   5. Gang war"
    .byte PET_CR, PET_CR
    .text "   6. Money transfer"
    .byte PET_CR, PET_CR
    .text "   7. Possessions"
    .byte PET_CR, PET_CR,PET_CR
    .text " Your choice? "
    .byte PET_CR, PET_CR
    .byte 0

//===============================================================================
// strRecruiting
//
// Rekrutierungen
//===============================================================================
strRecruitingTitle:
    .byte PET_CR, PET_CR
    .text " You can hire these guys: "
    .byte PET_CR
    .fill 40,PET_LINE
    .byte PET_CR,0
strRecruitingFireAll:
    .text " Fire everyone"
    .byte 0

//===============================================================================
// strBribery
//
// Bestechungen
//===============================================================================
strBriberyTitle:
    .byte PET_CR, PET_CR
    .text " Who do you want to bribe? "
    .byte PET_CR
    .fill 40,PET_LINE
    .byte PET_CR,0

strBriberyComputer1:
    .text " Computer"
    .byte 0
strBriberyComputer2:
    .text " If you don't put your soldering iron"
    .byte PET_CR
    .text " away, I'm calling the cops!"
    .byte PET_CR, 0
//===============================================================================
// strOverviewTitle
//
// Besitzverhältnisse
//===============================================================================
strOverviewTitle:
    .byte PET_CR
    .text " Posessions"
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
    .text " Money transfer"
    .byte PET_CR
    .fill 40,PET_LINE
    .byte PET_CR,0

strTransferWho:
    .text " Who will be the recipient? "
    .byte PET_CR
    .byte 0

strTransferAccountant:
    .text " The recipient is "
    .byte 0

strTransferAmount:
    .text " Amount $ "
    .byte 0

strTransferImpossible:
    .text " Are you joking?! "
    .byte PET_CR
    .byte 0

strTransferNotEnough:
    .text " You don't have enough money. "
    .byte PET_CR
    .byte 0

strTransferDone:
    .text " The money has been transferred. "
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
    .text " 0. een Schwanz einkneifen."
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
    .text " und bekommt Unterst&tzung."
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
    .text " Ey Meister, hab hier diese brandheisse"
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
    .text " f*r nur lumpige "
    .byte 0

strInformantDeal:
    .byte PET_CR,PET_CR
    .text " Schlagen Sie ein? (J/N) "
    .byte 0

strInformantYes:
    .byte PET_CR, PET_CR
    .text " Das erfreut das Informantenherz."
    .byte PET_CR, PET_CR, 0

strInformantNo:
    .byte PET_CR, PET_CR
    .text " Dann kopuliere er selber mit sich, "
    .byte PET_CR
    .text " elender B*rzel! "
    .byte PET_CR, PET_CR, 0