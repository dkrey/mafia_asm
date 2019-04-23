!--------------------------------------------------
!- Donnerstag, 14. Juni 2018 20:42:59
!- Import of : MAFIA.PRG
!- From Disk : c:\c64\tools\vice\disks\mafia_(sascha_laffrenzen).d64
!- Commodore 64
!--------------------------------------------------
!- Spielervariablen
!- $A = Anzahl der Mitspieler 1 - 8
!- $NA() = Namen der Mitspieler als Array
!- $MA() = Anteile der ganzen Gegend
!- $VM() = Vermögen
!- $SF() = Schuldenrunden 0-6
!- $GF() = Gefängnisrunden
!- $AZ() = Anzahl der verbrachten Gefängnisrunden
!-
!- CO = Aktueller Spieler in Schleife
!-
!- Entführungsaktion
!- $EG() = Anzahl der entführten Geiseln
!- $OP() = Name Entführungsopfer
!-
!-
!- Besitz
!- $AU() = Anzahl Automaten
!- $PR() = Anzahl Prostituierte
!- $BA() = Anzahl Bars
!- $SP() = Anzahl Spielsalons
!- $WE() = Anzahl Wettbüros
!- $PU() = Anzahl Puffs
!- $GH() = Anzahl GrandHotels
!-
!-
!- Personal
!- $RH() = Anzahl Revolverhelden (Angriff)
!- $LW() = Anzahl Leibwächter (Verteidigung)
!- $WA() = Wächter (Verteidigung)
!- $IN() = Anzahl Informanten (verhindern Morde)
!- $AN() = Anzahl Anwälte (helfen aus dem Knast)
!-
!-
!- Bestechungen
!- $PW() = Anzahl Polizeiwachtmeister
!- $KO() = Anzahl Kommissare
!- $UR() = Anzahl Untersuchungsrichter
!- $SA() = Anzahl Staatsanwahlt
!- $BM() = Anzahl Bürgermeister
!-
!-
!- Einnahmen
!- EA = Automaten
!- EN = Prostituierte
!- EB = Bars
!- EW = Wettbüro
!- ES = Spielsalon
!- EP = Bordell
!- EH = Hotel
!-
!- G1 = Gesamt Einnahmen
!- G2 = Gesamt Kosten
!- GS = Einnahmen + Kosten
!-
!-
!- Kosten
!- KA = Anwählte
!- KL = Leibwächter
!- KI = Informanten
!- KR = Revolverhelden
!- KW = Waechter
!- KP = Polizisten
!- KK = Kommisare
!- KU = U-Richter
!- KS = Staatsanwählte
!- KB = Buergermeister
!-
!- KZ = Kosten Zusammen

10 CLR:PRINTCHR$(14)
20 GOTO180
30 :
40 REM
50 DIMNA$(A):DIMVM(A):DIMGF(A)
60 DIMAZ(A):DIMPR(A):DIMBA(A):DIMWE(A):DIMSP(A):DIMPU(A)
70 DIMLW(A):DIMRH(A):DIMAN(A):DIMIN(A):DIMAU(A):DIMGH(A)
80 DIMWA(A):DIMMA(A):DIMM(18):DIMPW(A):DIMKO(A):DIMUR(A)
90 DIMSA(A):DIMBM(A):DIMSF(A):DIMOP$(A):DIMEG(A)
100 GOTO140

110 FOTI=1TOA
120 UM(I)=900000
130 NEXTI
140 IZ$=" In Zahlen bitte!"
150 WV$=" Wieviele Leute wollen Sie losschicken?"
160 SH$=" So viele haben Sie doch gar nicht!"
165 DR$=" (Druecken Sie bitte eine Taste!)"
170 RETURN
180 :

190 PRINT"{clear}{black}":POKE53280,2:POKE53281,7:
200 PRINT"{down*7}{right*3}{down*2}{right*11}M A F I A"
210 PRINT"{right*14}{cm u*9}"
215 PRINT"{down}{right*6}(freigegeben ab 18 Jahren)"
220 PRINT"{down}{right*2}Copyright 1986 by Sascha Laffrenzen"
230 FORI=1TO2500:NEXTI
231 :

260 PRINT"{clear}{yellow}":POKE53280,0:POKE53281,6
270 PRINT"{right}Wieviele Mitspieler ?"
280 GETA$
290 A=VAL(A$)
300 IF(A<1)+(A>9)THEN280
310 IFA$=""THEN280
320 PRINT
330 PRINT"{down}{right}Geben sie bitte Ihren Namen ein."
340 PRINT"{down}{right}{space*6}(nach jedem Namen bitte RETURN){down}"
350 GOSUB30
360 FORI=1TOA
370 PRINT"{right}Spieler";I;" "; :INPUTNA$(I)
380 PRINT
390 NEXTI
400 PRINT:PRINT" Moege der bessere gewinnen!"

410 FORI=1TO1500:NEXTI !- Pause
420 :

!- Hauptschleife.
430 FORCO=1TOA

440 GOSUB5440 !- Berechnung Einnahmen und Kosten
450 GOSUB5050 !- Berechnung Besitzverhältnisse
460 GOSUB550  !- Knastrunden

470 IF(G1<10000)*(G2=0)THEN500 !- Wenn zu wenig Einnahmen, dann direkt
                               !- kleine Diebstähle
475 GOSUB7550 !- Schicksalsschläge bei Einkommen > 50.000
480 GOSUB2690 !- Direkte Investitionen
490 GOTO520   !- nächster Spieler
500 GOSUB840  !- kleine Diebstähle
510 GOSUB2010 !- Investitionen

520 NEXTCO


530 GOTO420 !- Zurück in die Hauptschleife
540 :

!- Gefängnis
550 :
560 IFGF(CO)=0THENRETURN
570 IFAZ(CO)=GF(CO)+1THENGF(CO)=0:AZ(CO)=0:RETURN
580 POKE53280,0:POKE53281,0:PRINT"{clear}{yellow}{down}{right*8}"NA$(CO);",":PRINT
590 ZU=INT(RND(1)*100)
600 IFZU>10THEN640 !- Zufall Ausbruch

610 PRINT" Ihnen ist der Ausbruch gelungen!"
620 AZ(CO)=0:GF(CO)=0
630 GOTO820

!- Nuttenflucht
640 IFPR(CO)=0THEN680
650 ZU=INT(RND(1)*100)
660 IFZU>30+PR(CO)*4THEN680 !- Zufall Nuttenflucht
670 PRINT" Sie erhielten die Nachricht,dass eine"
672 PRINT"{right}Ihrer Prostituierten sich einen "
673 PRINT"{right}andreren Zuhaelter gesucht hat.":PR(CO)=PR(CO)-1:PRINT:PRINT

!- Anwahlt
680 IFAN(CO)=0THEN740
690 ZU=INT(RND(1)*100)
700 IFZU<100/(SQR(AN(CO)))THEN740 !- Zufall Anwalt Wurzel der Anzahl der Anwälte
710 PRINT" Ihr Anwalt konnte Sie rausholen!"
720 AZ(CO)=0:GF(CO)=0
730 GOTO820

740 D=GF(CO)-AZ(CO)
750 IFD=1THENJ$="Runde":GOTO790
760 IFD=0THENPRINT" Sie kommen dieses Jahr frei!":GOTO810
770 IFD=1THENJ$="Runde":GOTO790
780 J$="Runden"
790 PRINT" Sie sind im Gefaengnis und haben noch"
800 PRINTD;J$;" abzusitzen."
810 AZ(CO)=AZ(CO)+1
820 FORI=1TO2000:NEXTI
830 RETURN


!- Kleine Diebstähle
840 :
850 IFGF(CO)<>0THENRETURN
860 PRINT"{clear}{yellow}":POKE53280,0:POKE53281,6
870 PRINT:PRINTSPC(1);NA$(CO);","
880 IF(G1-Q)*(VM(CO)<20000)THENPRINT"{right}Sie stehen noch am Anfang der Kariere."
890 PRINT" Sie haben";VM(CO);"$."
900 PRINT
910 PRINT" Sie koennen Folgendes tun:"
920 PRINT"{cm y*40}"
930 PRINTTAB(3)"{up}Eine Bank ausrauben ........... 1 "
940 PRINTTAB(3)"{down}Einen Automaten knacken........ 2 "
950 PRINTTAB(3)"{down}Eine Bar ueberfallen........... 3 "
960 PRINTTAB(3)"{down}Ein Auto klauen und verkaufen.. 4 "
970 PRINTTAB(3)"{down}Einen Passanten ausnehmen...... 5"
980 PRINTTAB(3)"{down}Eine ehrliche Arbeit annehmen.. 6"
990 PRINTTAB(3)"{down}Keines davon................... 7"
1000 PRINT"{down}{space*2}Ihre Wahl ?"
1010 GETW$
1020 W=VAL(W$)
1030 IF(W<1)+(W>7)THEN1010

1040 ZU = INT(RND(1)*100)
1050 PRINT"{clear}"
1060 ON W GOTO 1070,1190,1340,1540,1660,1790,2000

!- Bankraub
1070 :
1080 IF ZU < 90 THEN 1130 !- Zufall Bankraub 10%
1090 PRINT:PRINT" Ihr Bankraub war erfolgreich."
1100 BE=INT(RND(1)*50000+50000)
1110 PRINT" Sie erbeuteten";BE;"$."
1120 GOTO1940
1130 GOSUB4940 !- Eskapaden des Misserfolgs
1140 PRINT:PRINTZ$
1150 Z=INT(RND(1)*100)
1160 IFZ>70THEN1840 !- Knast 30 %
1170 FORI=1TO800:NEXTI
1180 PRINT:PRINT" Sie konnten jedoch entkommen!":GOTO1940

!- Automaten knacken
1190 :
1200 IF ZU<160/(2*A)-AU(0) THEN 1270
1210 OW=INT(RND(1)*A+1) !- zufälliger Spieler
1220 IFOW=COTHEN1210
1230 IFAU(OW)=0THEN1270
1240 PRINT:PRINT" Der Automat gehoerte ";NA$(OW);"."
1250 AU(OW)=AU(OW)-1
1260 GOTO1310
1270 ZU=INT(RND(1)*100)
1280 IFZU<90THEN1310
1290 GOSUB4940
1300 PRINT:PRINTZ$:GOTO1840 !- Knast
1310 BE=INT(RND(1)*700+2)
1320 PRINT:PRINT" Der Automat enthielt";BE;"$."
1330 GOTO1940

!- Bar ausrauben
1340 :
1350 IFZU<300/(2*A)-BA(0)*2THEN1420
1360 OW=INT(RND(1)*A+1)
1370 IFOW=COTHEN1360
1380 IFBA(OW)=0THEN1420
1390 PRINT:PRINT" Die Bar gehoerte "NA$(OW);"."
1400 BA(OW)=BA(OW)-1
1410 GOTO1510
1420 ZU=INT(RND(1)*100)
1430 IFZU<60THEN1510
1440 GOSUB4940
1450 PRINT:PRINTZ$
1460 FORI=1TO800:NEXTI
1470 ZU=INT(RND(1)*100)
1480 IFZU<60THEN1840    !- Knast
1490 PRINT:PRINT" Sie sind entwischt,mussten aber die "
1491 PRINT"{down}{right}Beute zuruecklassen!"
1500 GOTO1940
1510 BE=INT(RND(1)*4500+3000)
1520 PRINT:PRINT" Der Ueberfall brachte";BE;"$."
1530 GOTO1940

!- Auto klauen
1540 :
1550 PRINT:PRINT" Sie konnten einen Wagen stehlen."
1560 FORI=1TO1000:NEXTI
1570 IFZU<50THEN1640
1580 GOSUB4940
1590 PRINTZ$:FORI=1TO1000:NEXTI
1600 ZU=INT(RND(1)*100)
1610 IFZU<50 THEN1840
1620 PRINT:PRINT" Nach einer langen Verfolgungsjagd "
1621 PRINT"{down}{right}konnten Sie entkommen."
1630 PRINT"{down}{right}Der Wagen ist allerdings im Arsch!":GOTO1940
1640 BE=INT(RND(1)*1000+2000)
1650 PRINT"{down} Der Verkauf brachte";BE;"$.":GOTO1940

!- Passant ausrauben
1660 :
1670 IFZU<10THENGOSUB4940:PRINTZ$:GOTO1840 !- Knast
1680 ZU=INT(RND(1)*100)
1690 IFZU<300/(2*A)THEN1760 !- Generischer Raub: 300 / 2* Anzahl Mitspieler

1700 OW=INT(RND(1)*A+1)
1710 IFOW=COTHEN1700 !- Mitspieler

1720 IF(VM(OW)<0)+(GF(OW)<>0)THEN1760 !- Skip Mitspieler hat kein Geld oder sitzt ein
1730 PRINT:PRINT" Der Passant war "NA$(OW)
1740 BE=INT(RND(1)*VM(OW)):VM(OW)=VM(OW)-BE !- Betrag vom Mitspieler
1750 PRINT" und hatte";BE;"$ bei sich.":GOTO1940
1760 BE=INT(RND(1)*800+120)
1770 PRINT:PRINT" Der Passant hatte";BE;"$ bei sich."
1780 GOTO1940

!- Ehrliche Arbeit
1790 :
1800 PRINT"{down*10}{right*4}Dann sind sie im falschen Spiel!"
1810 VM(CO)=0
1820 GOTO1990

!-
1830 :
1840 PRINT:PRINT" Sie wurden von der Polizei gefasst ":RU$="Runden"
1850 ONWGOSUB1870,1880,1890,1900,1910 !- Gefängnisrunden
1860 GOTO1920
1870 GF(CO)=6:RETURN
1880 GF(CO)=1:RU$="Runde":RETURN !- Selbst Automatenknacken bringt Knast
1890 GF(CO)=4:RETURN
1900 GF(CO)=3:RETURN
1910 GF(CO)=2:RETURN
1920 PRINT" und erhielten";GF(CO);RU$" Gefaengnis."
1930 GOTO1990

1940 VM(CO)=VM(CO)+BE
1950 FORI=1TO1000:NEXTI
1960 PRINT:PRINT" Ihr Vermoegen betraegt jetzt:"
1970 PRINT:PRINTTAB(12)VM(CO);"$."
1980 BE=0
1990 FORI=1TO3000:NEXTI:
2000 RETURN


!- Investitionen
2010 :
2020 IFGF(CO)<>0THENRETURN
2030 IFSF(CO)<>0THENPOKE53280,0:POKE53281,8:PRINT"{clear}{down}Womit wollen sie bezahlen?"
2040 IFSF(CO)<>0THENFORI=1TO3000:NEXTI:RETURN
2050 IFVM(CO)<20000THENRETURN
2060 PRINT"{clear}":POKE53280,0:POKE53281,4
2070 PRINT:PRINTSPC(1);NA$(CO);","
2080 PRINT" Sie haben"VM(CO)"$."
2090 PRINT:PRINT" Die Anschaffungspreise sind:"
2100 PRINT"{cm y*35}"
2110 PRINT" 1. Spielautomaten(drei)..... 15000 $":AU=1
2120 PRINT" 2. Prostituierte (eine)..... 20000 $":AU=2
2130 PRINT" 3. Bar...................... 80000 $":AU=3
2140 IFVM(CO)>80000THENPRINT" 4. Wettbuero................160000 $":AU=4
2150 IFVM(CO)>160000THENPRINT" 5. Spielsalon...............300000 $":AU=5
2160 IFVM(CO)>300000THENPRINT" 6. Nobelbordell............1000000 $":AU=6
2170 IFVM(CO)>1000000THENPRINT" 7. Grandhotel.............10000000 $":AU=7
2180 PRINT
2190 PRINT" Wenn Sie keins dieser Dinge haben"
2192 PRINT" wollen,geben sie bitte 'N' ein."
2200 GETW$
2210 IFW$=""THEN2200
2220 IFW$="n"THEN2680
2230 W=VAL(W$)
2240 IF(W<1)+(W>AU)THEN2200
2250 IFVM(CO)<15000THEN2620
2260 ONWGOTO2270,2320,2370,2420,2470,2520,2570
2270 :
2280 IF0>VM(CO)-15000THEN2620
2290 AU(CO)=AU(CO)+3
2300 VM(CO)=VM(CO)-15000
2310 GOTO2060
2320 :
2330 IF0>VM(CO)-20000THEN2620
2340 PR(CO)=PR(CO)+1
2350 VM(CO)=VM(CO)-20000
2360 GOTO2060
2370 :
2380 IF0>VM(CO)-80000THEN2620
2390 BA(CO)=BA(CO)+1
2400 VM(CO)=VM(CO)-80000
2410 GOTO2060
2420 :
2430 IF0>VM(CO)-160000THEN2620
2440 WE(CO)=WE(CO)+1
2450 VM(CO)=VM(CO)-160000
2460 GOTO2060
2470 :
2480 IF0>VM(CO)-300000THEN2620
2490 SP(CO)=SP(CO)+1
2500 VM(CO)=VM(CO)-300000
2510 GOTO2060
2520 :
2530 IF0>VM(CO)-1000000THEN2620
2540 PU(CO)=PU(CO)+1
2550 VM(CO)=VM(CO)-1000000
2560 GOTO2060
2570 :
2580 IF0>VM(CO)-10000000THEN2620
2590 GH(CO)=GH(CO)+1
2600 VM(CO)=VM(CO)-10000000
2610 GOTO2060
2620 POKE53280,0:POKE53281,0:PRINT"{clear}{yellow}"
2630 PRINT"{right*4}{down*10}{reverse on}In unserem Beruf macht man keine"
2640 PRINT"{right*4}{reverse on}Schulden,weil man nie weiss,ob{space*2}"
2650 PRINT"{right*4}{reverse on}man sie auch zurueckzahlen kann!"
2660 FORI=1TO400 :NEXTI
2670 GOTO2060
2680 RETURN

!- Investitionsmenü
2690 :
2700 IFGF(CO)<>0THENRETURN
2710 IFEG(CO)=1THEN7350
2720 PRINT"{clear}{black}":POKE53280,0:POKE53281,2
2730 PRINT:PRINT" Sie haben folgende Moeglichkeiten:{down}"
2740 PRINT"{cm y*40}"
2750 PRINT"{space*3}1. Kleine Diebstaehle"
2760 PRINT"{down}{space*3}2. Investitionen"
2770 PRINT"{down}{space*3}3. Rekrutierung"
2780 PRINT"{down}{space*3}4. Bestechung"
2790 PRINT"{down}{space*3}5. Aktionen"
2800 PRINT"{down}{space*3}6. Geldtransfer"
2810 PRINT"{down}{space*3}7. Besitzverhaeltnisse"
2820 PRINT"{down} Was waehlen Sie ?"
2830 GETW$
2840 IFW$="n"THENRETURN
2850 W=VAL(W$)
2860 IFW=7THEN4640
2870 IF(W<1)+(W>6)THEN2830
2880 IFW$=""THEN2830
2890 ONWGOSUB840,2010,2910,6700,3210,6410
2900 RETURN

!- Rekrutierung
2910 :
2920 PRINT"{clear}{white}":POKE53281,5:POKE53280,0
2930 PRINT
2940 IFVM(CO)>0THEN2980
2950 PRINT" Sie koennen sich keine Leute mehr{space*7}leisten!"
2960 FORI=1TO2500:NEXTI
2970 GOTO3190
2980 PRINT" Sie koennen folgende Leute einstellen:"
2990 PRINT"{cm y*40}{down}"
3000 PRINT"{space*4}1. Revolverheld{space*5}6000$/Monat"
3010 PRINT"{space*4}2. Leibwaechter{space*5}4000$/Monat"
3020 PRINT"{space*4}3. Anwalt{space*11}8000$/Monat"
3030 PRINT"{space*4}4. Informant{space*2}2000-10000$/Tip"
3040 PRINT"{space*4}5. Waechter{space*9}3000$/Monat"
3050 PRINT"{down}{right}Wenn Sie niemanden brauchen,geben Sie"
3055 PRINT"{right}bitte 'N' ein."
3060 GETW$
3070 W=VAL(W$)
3080 IFW$="n"THEN3190
3090 IF(W<1)+(W>5)THEN3060
3100 IFW$=""THEN3060
3110 REM
3120 INPUT"{down}{right}Wieviele ";AZ
3130 ONWGOTO3140,3150,3160,3170,3180
3140 RH(CO)=RH(CO)+AZ:GOTO2920
3150 LW(CO)=LW(CO)+AZ:GOTO2920
3160 AN(CO)=AN(CO)+AZ:GOTO2920
3170 IN(CO)=IN(CO)+AZ:GOTO2920
3180 WA(CO)=WA(CO)+AZ:GOTO2920
3190 RETURN
3200 PRINT:PRINTIZ$:GOTO3110

!- Aktionen
3210 :
3220 POKE53280,0:POKE53281,8:PRINT"{clear}{black}{down}"
3230 IFRH(CO)=0THENPRINT" Sie haben nicht die richtigen Leute ":GOTO3235
3231 GOTO3240
3235 PRINT" fuer eine Aktion.":FORI=1TO3000:NEXTI:GOTO4630
3240 PRINT"{space*2}Sie koennen diese Aktionen befehlen:"
3250 PRINT"{down}{space*11}1. Entfuehrung"
3260 PRINT"{space*11}2. Ermordung"
3270 PRINT"{space*11}3. Demolierung (Bars,etc.)"
3280 PRINT"{space*11}4. Keine"
3290 GETW$
3300 W=VAL(W$)
3310 IF(W<1)+(W>4)THEN3290
3320 ONWGOTO3330,3580,3920,4630

!- Entführung: egal wen
3330 :
3340 PRINT"{clear}":FL$="e":EG=0
3350 PRINT"{down}{right}Wen wollen Sie entfuehren lassen ?"
3360 PRINTSPC(1);:INPUTOP$(CO):EX=0
3370 IFOP$(CO)="Niemanden"THEN4630
3380 FORI=1TOA !- Mitspieler kann man nicht entführen
3390 IFNA$(I)=OP$(CO)THENPRINT"{down}{right}Das kann ich nicht zulassen!":GOTO3350
3400 NEXTI

3430 ZU=INT(RND(1)*100)
3440 REM
3450 PRINT"{down}"WV$:PRINTSPC(1);:INPUTSC
3460 IFSC=0THENRETURN
3470 IFSC>RH(CO)THENPRINTSH$:GOTO3440
3480 GOSUB4360:FORZ=1TO1000:NEXTZ
3490 IFMI=1THEN3540
3510 IFZU<60+SC/2+IN(CO)THEN3550 !- Zufall Entführung
3520 GOTO3540
3540 PRINT"{down}{right}Die Entfuehrung ist nicht geglueckt!":FORP7=1TO2000:NEXTP7:RETURN
3550 PRINT"{down}{right}Die Geisel befindet sich in Ihrer{space*7}Gewalt.":
3560 FORZ=1TO2000:NEXTZ:GOTO7360
3570 REM

!- Mord: Schergen eines Mitspielers
3580 :
3590 PRINT"{clear}{down}":EX=0
3600 PRINT"{right}Wen wollen Sie ermorden lassen ?{down}"
3610 PRINTSPC(1);:INPUTBS$
3620 IFBS$="Niemanden"THEN3890
!- Selbstmord und Mitspieler
3630 IFNA$(CO)=BS$THENPRINT"{down}{right}Das machen Sie lieber selber!":GOTO3690

3640 FORI=1TOA
3650 IFNA$(I)=BS$THEN3652
3651 GOTO3655
3652 PRINT"{down}{right}Du sollst Deinen Naechsten lieben wie"
3653 PRINT"{right}Dich selbst!!(SASCHA-Kapitel 16)"
3655 GOTO3690
3670 NEXTI

3672 PRINT"{down}{right}Wessen ";BS$;" ?{down}" !- Schergen des Mitspielers
3674 PRINTSPC(1);:INPUTAG$

3676 FORI=1TOA
3678 IFNA$(I)=AG$THEN3700
3680 NEXTI

3690 GOSUB3900:GOTO3590 !- Ungültige Eingabe: Wiederholung
3700 PRINT"{down}"WV$
3710 REM
3720 PRINTSPC(1);:INPUTSC !- Wie viele Revolverhelden schicken
3730 IFSC=0THENRETURN !- Keine RH geschickt
3740 IFSC>RH(CO)THENPRINT"{down}"SH$:GOSUB3900:GOTO3700 !- mehr RH als angeheuert
3750 GOSUB4360 !- Verlust ausrechnen
3760 ZU=INT(RND(1)*100)
3770 IFZU<50+SC/2+IN(CO)THEN3790 !- Informanten schützen vor Mord

3780 PRINT"{down}{right}Das Attentat ist schiefgegangen!!":GOTO3880
3790 PRINT"{down}{right}Das Attentat ist geglueckt!"
3800 IF(BS$="Polizist")*(PW(I)<>0)THENPW(I)=PW(I)-1
3810 IF(BS$="Kommissar")*(KO(I)<>0)THENKO(I)=KO(I)-1
3820 IF(BS$="Untersuchungsrichter")*(UR(I)<>0)THENUR(I)=UR(I)-1
3830 IF(BS$="Staatsanwalt")*(SA(I)<>0)THENSA(I)=SA(I)-1
3840 IF(BS$="Buergermeister")*(BM(I)<>0)THENBM(I)=BM(I)-1
3850 IF(BS$="Anwalt")*(AN(I)<>0)THENAN(I)=AN(I)-1
3860 IF(BS$="Informant")*(IN(I)<>0)THENIN(I)=IN(I)-1
3870 IFEX=1THENEG(I)=0
3880 FORZ=1TO3000:NEXTZ
3890 RETURN
3900 FORZ=1TO1500:NEXTZ:RETURN
3910 REM

!- Demolieren
3920 :
3930 PRINT"{clear}"
3940 PRINT"{down}{right}Was wollen Sie demolieren lassen ?"
3950 PRINTSPC(1);:INPUTDO$
3960 IF(DO$="Bar")+(DO$="Spielsalon")+(DO$="Bordell")+(DO$="Wettbuero")THEN3990
3965 IF(DO$="Hotel")THEN3990
3970 IFDO$="Nichts"THEN4340
3980 PRINT"{down}{right}Ist doch zum Ficken!!":GOTO3940
3990 PRINT"{down}{right}Wer ist der Besitzer ?"
4000 PRINTSPC(1);:INPUTBS$
4010 IFNA$(CO)=BS$THENPRINT"{down}{right}Biss bekackt,Alter?":GOTO3990
4020 FORI=1TOA
4030 IFNA$(I)=BS$THENEX=1:GOTO4050
4040 NEXTI
4050 IFEX=0THEN4120
4060 IFDO$="Bar"THENOB=BA(I)
4070 IFDO$="Wettbuero"THENOB=WE(I)
4080 IFDO$="Spielsalon"THENOB=SP(I)
4090 IFDO$="Bordell"THENOB=PU(I)
4100 IFDO$="Hotel"THENOB=GH(I)
4110 IFOB=0THENPRINT"{down}"SPC(1);BS$;"besitzt sowas nicht.":GOTO3940
4120 PRINT"{down}"WV$
4130 REM
4140 PRINTSPC(1);:INPUTSC
4150 IFSC=0THENRETURN
4160 IFSC>RH(CO)THENPRINTSH$:GOTO4120
4170 IFSC=0THEN4340
4180 FL$="D":GOSUB4360
4190 ZU=INT(RND(1)*100):FORZ=1TO1000:NEXTZ
4200 IFEX=0THEN4240
4210 IFZU>30+SC+IN(CO)-WA(I)THEN4310
4220 PRINT"{down}"SPC(1);NA$(I);"'s "DO$:PRINT"{right}wurde vollstaendig demoliert."
4230 GOTO4250
4240 PRINT" Ihre Leute haben gruendlich aufge-"
4245 PRINT" raeumt.":GOTO4330
4250 IFDO$="Bar"THENBA(I)=BA(I)-1
4260 IFDO$="Wettbuero"THENWE(I)=WE(I)-1
4270 IFDO$="Spielsalon"THENSP(I)=SP(I)-1
4280 IFDO$="Bordell"THENPU(I)=PU(I)-1
4290 IFDO$="Hotel"THENGH(I)=GH(I)-1
4300 GOTO4330
4310 PRINT"{down}{right}Sie wurden zurueckgeschlagen und "
4312 PRINT"{right}konnten keinen nennenswerten Schaden"
4315 PRINT"{right}anrichten."
4320 PRINT"{down}{right}Aber wir kommen wieder!!!!!!"
4330 FORI=1TO3000:NEXTI
4340 RETURN
4350 REM

!- Verlustrechnung der Aktion
4360 :
4370 FORZ=1TO2500:NEXTZ
4380 PRINTTAB(14)"{down}Verluste":PRINTTAB(14)"{cm y*8}"
4390 PRINT"{right}Auf Ihrer Seite:"
4400 TR=INT(RND(1)*(SC+1))
4410 RH(CO)=RH(CO)-TR
4420 IFTR=SCTHENMI=1
4430 IFSF(CO)=0THENVM(CO)=VM(CO)-TR*25000
4440 PRINTTAB(8)"Revolverhelden:";TAB(25)TR
4450 PRINTTAB(8)"Begraebniskosten:";
4460 IFSF<>0THENPRINTTAB(25)"Keine":GOTO4480
4470 PRINTTAB(25)TR*25000
4480 IFEX=0THEN4630
4490 PRINT" Auf der anderen Seite:":BK=0
4500 IFRH(I)=0THEN4530
4505 TR=INT(RND(1)*SC)*2
4510 IFTR>RH(I)THEN4505
4520 PRINTTAB(8)"Revolverhelden:";TAB(25)TR:BK=BK+TR*25000:RH(I)=RH(I)-TR
4530 IFWA(I)=0THEN4560
4535 TW=INT(RND(1)*SC)*2
4540 IFTW>WA(I)THEN4535
4550 IF(FL$="d")+(FL$="t")THENWA(I)=WA(I)-TW:BK=BK+TW*25000
4555 PRINTTAB(8)"Waechter:";TAB(25)TL
4560 IFLW(I)=0THEN4590
4565 TL=INT(RND(1)*SC)*2
4570 IFTL>LW(I)THEN4565
4580 IF(FL$="e")+(FL$="t")THENLW(I)=LW(I)-TL:BK=BK+TL*25000
4585 PRINTTAB(8)"Leibwaechter:";TAB(25)TL
4590 PRINTTAB(8)"Begraebniskosten:";
4600 IF(SF<>0)+(BK=0)THENPRINTTAB(25)"Keine":GOTO4630
4610 PRINTTAB(25)BK
4620 VM(I)=VM(I)-BK
4630 FL$="":RETURN
4640 :
4650 PRINT"{clear}{down}"

!- Besitzverhältnisse anzeigen
4660 :
4670 PRINTTAB(10)"Besitzverhaeltnisse"
4680 PRINTTAB(10)"{cm y*19}"
4690 PRINTSPC(1)NA$(CO);","
4700 PRINT" Sie besitzen:"
4710 PRINTTAB(4)"{down*2}Bargeld:"TAB(22)VM(CO);"$"
4720 IFAU(CO)<>0THENPRINTTAB(4)"Spielautomaten:";TAB(22)AU(CO)
4730 IFBA(CO)<>0THENPRINTTAB(4)"Bars:";TAB(22)BA(CO)
4740 IFWE(CO)<>0THENPRINTTAB(4)"Wettbueros:";TAB(22)WE(CO)
4750 IFSP(CO)<>0THENPRINTTAB(4)"Spielsalons:";TAB(22)SP(CO)
4760 IFPU(CO)<>0THENPRINTTAB(4)"Bordelle:";TAB(22)PU(CO)
4770 IFGH(CO)<>0THENPRINTTAB(4)"Grandhotels:";TAB(22)GH(CO)
4780 IFPR(CO)<>0THENPRINTTAB(4)"Prostituierte:";TAB(22)PR(CO)
4790 IFLW(CO)<>0THENPRINTTAB(4)"Leibwaechter:";TAB(22)LW(CO)
4800 IFRH(CO)<>0THENPRINTTAB(4)"Revolverhelden:";TAB(22)RH(CO)
4810 IFAN(CO)<>0THENPRINTTAB(4)"Anwaelte:";TAB(22)AN(CO)
4820 IFIN(CO)<>0THENPRINTTAB(4)"Informanten:";TAB(22)IN(CO)
4830 IFWA(CO)<>0THENPRINTTAB(4)"Waechter:";TAB(22)WA(CO)
4840 IF(PW(CO)<>0)+(KO(CO)<>0)+(UR(CO)<>0)+(SA(CO)<>0)+(BM(CO)<>0)THENPRINT" Best."
4850 IFPW(CO)<>0THENPRINTTAB(4)"Polizisten:"TAB(22)PW(CO)
4860 IFKO(CO)<>0THENPRINTTAB(4)"Kommissare:"TAB(22)KO(CO)
4870 IFUR(CO)<>0THENPRINTTAB(4)"Untersuchungsrichter:"TAB(22)UR(CO)
4880 IFSA(CO)<>0THENPRINTTAB(4)"Staatsanwaelte:"TAB(22)SA(CO)
4890 IFBM(CO)<>0THENPRINTTAB(4)"Buergermeister:"TAB(22)BM(CO)
4900 PRINT"{down}"DR$
4910 GETW$
4920 IFW$=""THEN4910
4930 GOTO2720

!- Misserfolge beim Diebstahl
4940 :
4950 PRINT
4960 X=INT(RND(1)*7+1)
4970 ONXGOTO4980,4990,5000,5010,5020,5030,5040
4980 Z$=" Pech!":RETURN
4990 Z$=" Ein Passant schlug Alarm.":RETURN
5000 Z$=" Die Polizei wurde auf Sie aufmerksam.":RETURN
5010 Z$=" Eine Streife ueberraschte Sie.":RETURN
5020 Z$=" Sie stellten sich ziemlich bloede an.":RETURN
5030 Z$=" Ihre Mutter hat Sie verpfiffen!":RETURN
5040 Z$=" Ihr Rheuma machte Ihnen wieder zu{space*7}schaffen.":RETURN


!- Berechnung der Besitzverhältnisse
5050 :
5060 IF(G1<20000)*(G2=0)THENRETURN
5070 POKE53280,0:POKE53281,0:PRINT"{clear}{yellow}"
5080 PRINT"Bitte warten...."
5090 PR(0)=1:AU(0)=1:BA(0)=1:WE(0)=1:SP(0)=1:PU(0)=1:GH(0)=1
5100 LW(0)=1:RH(0)=1:AN(0)=1:IN(0)=1:WA(0)=1
5110 PW(0)=1:KO(0)=1:UR(0)=1:SA(0)=1:BM(0)=1

5120 FORI=1TOA
5130 PR(0)=PR(0)+PR(I): AU(0)=AU(0)+AU(I): BA(0)=BA(0)+BA(I)
5140 WE(0)=WE(0)+WE(I): SP(0)=SP(0)+SP(I): PU(0)=PU(0)+PU(I)
5150 GH(0)=GH(0)+GH(I): LW(0)=LW(0)+LW(I): RH(0)=RH(0)+RH(I)
5160 AN(0)=AN(0)+AN(I): IN(0)=IN(0)+IN(I): WA(0)=WA(0)+WA(I)
5170 PW(0)=PW(0)+PW(I): KO(0)=KO(0)+KO(I): UR(0)=UR(0)+UR(I)
5180 SA(0)=SA(0)+SA(I): BM(0)=BM(0)+BM(I)
5190 NEXTI

5200 M(1)=100*PR(CO)/PR(0): M(2)=100*AU(CO)/AU(0): M(3)=100*BA(CO)/BA(0)
5210 M(4)=100*WE(CO)/WE(0): M(5)=100*SP(CO)/SP(0): M(6)=100*PU(CO)/PU(0)
5220 M(7)=100*GH(CO)/GH(0): M(8)=100*LW(CO)/LW(0): M(9)=100*RH(CO)/RH(0)
5230 M(10)=100*AN(CO)/AN(0): M(11)=100*IN(CO)/IN(0): M(12)=100*WA(CO)/WA(0)
5240 M(13)=100*PW(CO)/PW(0): M(14)=100*KO(CO)/KO(0): M(15)=100*UR(CO)/UR(0)
5250 M(16)=100*SA(CO)/SA(0): M(17)=100*BM(CO)/BM(0)
5260 MA(CO)=0

5270 FORI=1TO17
5280 MA(CO)=MA(CO)+M(I)
5290 NEXTI

5300 MA(CO)=MA(CO)/17
5310 IFMA(CO)<100/A-5THEN5390
5320 POKE53280,0:POKE53280,0:PRINT"{clear}{yellow}"
5330 PRINTSPC(1)"{down}";:PRINT"{down*7}{right}"NA$(CO)","
5340 PRINT"{down}{right}Sie beherrschen nun"MA(CO)"Prozent der"
5350 PRINT"{right}ganzen Gegend und haben damit"
5360 PRINT"{down}{right}gewonnen!!!!":END
5370 :
5380 END
5390 PRINT"{clear}"
5400 PRINT:PRINTSPC(1);NA$(CO);","
5410 PRINT"{down}{right}Sie beherrschen jetzt"INT(MA(CO)):PRINT"{right}Prozent der ganzen Gegend"
5420 FORI=1TO2000:NEXTI
5430 RETURN

!- Berechnung des Einkommens
5440 :
5450 GS=0:EN=0:EB=0:EW=0:ES=0:EF=0:EA=0:KI=0:KA=0:KR=0:KL=0
5460 G1=0:G2=0:KP=0:KK=0:KU=0:KS=0:KB=0:EH=0
5470 :
5480 IFPR(CO)=0THEN5530 !- Prostituierte
5490 FORN=1TOPR(CO)
5500 Z=INT(RND(1)*2000)+800 !- EN wird um Zufallszahl erhöht
5510 EN=EN+Z
5520 NEXTN

5530 IFBA(CO)=0THEN5580 !- Bars
5540 FORN=1TOBA(CO)
5550 Z=INT(RND(1)*10000)+10000
5560 EB=EB+Z
5570 NEXTN

5580 IFWE(CO)=0THEN5630 !- Wettbüros
5590 FORN=1TOWE(CO)
5600 Z=INT(RND(1)*25000)+10000
5610 EW=EW+Z
5620 NEXTN

5630 IFGH(CO)=0THEN5680 !- Grandhotel
5640 FORN=1TOGH(CO)
5650 Z=INT(RND(1)*30000)+30000
5660 EH=EH+Z
5670 NEXTN

5680 IFSP(CO)=0THEN5730 !- Spielsalon
5690 FORN=1TOSP(CO)
5700 Z=INT(RND(1)*70000)+15000
5710 ES=ES+Z
5720 NEXTN

5730 IFPU(CO)=0THEN5780 !- Bordell
5740 FORN=1TOPU(CO)
5750 Z=INT(RND(1)*50000)+15000
5760 EP=EP+Z
5770 NEXTN

5780 IFAU(CO)=0THEN5830 !- Automaten
5790 FORN=1TOAU(CO)
5800 Z=INT(RND(1)*1000)+100
5810 EA=EA+Z
5820 NEXTN

5830 KA=8000*AN(CO)
5840 KL=4000*LW(CO)
5850 KR=6000*RH(CO)
5860 KW=3000*PW(CO)
5870 KP=3000*PW(CO)
5880 KK=12000*KO(CO)
5890 KU=30000*UR(CO)
5900 KS=70000*SA(CO)
5910 KB=100000*BM(CO)

5920 IFIN(CO)=0THEN5970 !- Kosten Informanten
5930 FORN=1TOIN(CO)
5940 Z=INT(RND(1)*8000)+2000
5950 KI=KI+Z
5960 NEXTN

5970 G1=EA+EN+EB+EW+ES+EP+EH
5980 G2=KA+KR+KI+KL+KW+KP+KK+KU+KS+KB
5990 GS=G1+G2
6000 IF(G1=0)*(G2=0)THENRETURN
6010 POKE53280,0:POKE53281,1:PRINT"{clear}{black}"
6020 PRINT"{down}"TAB(14)"Finanzen":PRINTTAB(13)" {cm y*8} ":PRINT
6030 PRINTSPC(1)NA$(CO);",":PRINT"{right}Ihre Einnahmen sind:{down}"
6040 IFEA<>0THENPRINT" Spielautomaten"TAB(25)"$"EA
6050 IFEN<>0THENPRINT" Prostituierte "TAB(25)"$"EN
6060 IFEB<>0THENPRINT" Bars{space*10}"TAB(25)"$"EB
6070 IFEW<>0THENPRINT" Wettbueros{space*4}"TAB(25)"$"EW
6080 IFES<>0THENPRINT" Spielsalons{space*3}"TAB(25)"$"ES
6090 IFEP<>0THENPRINT" Bordelle{space*6}"TAB(25)"$"EP
6100 IFEH<>0THENPRINT" Hotels{space*8}"TAB(25)"$"EH
6110 PRINT"{cm y*40}"
6120 PRINT"{up}{right}Gesamt:"TAB(25)"$"G1
6130 PRINT"{down}"DR$
6140 GETT$:IFT$=""THEN6140
6150 PRINT"{clear}":PRINT
6160 PRINT" Ihre Ausgaben:{down}"
6170 IFKA<>0THENPRINT" Anwaelte{space*6}";TAB(25)"$"KA
6180 IFKL<>0THENPRINT" Leibwaechter{space*2}";TAB(25)"$"KL
6190 IFKI<>0THENPRINT" Informanten{space*3}";TAB(25)"$"KI
6200 IFKR<>0THENPRINT" Revolverhelden";TAB(25)"$"KR
6210 IFKW<>0THENPRINT" Waechter{space*6}";TAB(25)"$"KW
6220 IFKP<>0THENPRINT" Polizisten{space*4}";TAB(25)"$"KP
6230 IFKK<>0THENPRINT" Kommissare{space*4}";TAB(25)"$"KK
6240 IFKU<>0THENPRINT" U-Richter{space*5}";TAB(25)"$"KU
6250 IFKS<>0THENPRINT" Staatsanwaelte";TAB(25)"$"KS
6260 IFKB<>0THENPRINT" Buergermeister";TAB(25)"$"KB
6270 KZ=KA+KL+KI+KR+KW+KP+KK+KU+KS+KB
6275 IFKZ=0THENPRINTTAB(25)"Keine!"
6280 PRINT"{cm y*40}"
6290 PRINT"Gesamt:"TAB(25)"$"G2
6300 PRINT"{down}{right}Damit betraegt Ihr Vermoegen{down}"
6310 PRINTTAB(25)" $"VM(CO)
6320 PRINTTAB(24)"+ $"G1:PRINTTAB(24)"- $";G2
6330 VM(CO)=VM(CO)+G1-G2
6340 PRINTTAB(23)"{cm y*14}":PRINTTAB(24)"= $"VM(CO)
6350 PRINT"{down}"DR$

6360 GETW$
6370 IFW$=""THEN6360 !- Warten auf Tastendruck
6380 IFVM(CO)<0THEN7060 !- Wenn Schulden
6390 SF(CO)=0
6400 RETURN

!- Geldtransfer
6410 :
6420 PRINT"{clear}":ER=0
6430 PRINTSPC(1)NA$(CO);","
6440 IFVM(CO)<0THENPRINT" Sie machen wohl Witze?":GOTO6650
6450 PRINT" Sie besitzen"VM(CO)"$."
6460 PRINT" Wem moechten Sie Geld geben ?"
6470 PRINT"{down}"SPC(1);:INPUTEM$
6480 IFEM$="Niemanden"THENRETURN
6490 FORI=1TOA
6500 IFEM$=NA$(I)THEN6530
6510 NEXTI
6520 ER=1
6530 PRINT"{down}{right}Wieviel wollen Sie "EM$
6540 PRINT"{right}geben?"
6550 :
6560 INPUT"{right}";TR
6570 GOTO6590
6580 :
6590 IFTR=0THENRETURN
6600 IF0>VM(CO)-TRTHENPRINT"{down}{right}Soviel besitzen Sie gar nicht!":GOTO6650
6610 VM(CO)=VM(CO)-TR
6620 IFER=1THENPRINT" Da ich die obrige Person nicht aus-":GOTO6624
6621 GOTO6630
6624 PRINT"{right}findig machen konnte,wurde der Betrag"
6626 PRINT"{right}an TKD HADEMARSCHEN ueberwiesen!!":GOTO6650
6630 VM(I)=VM(I)+TR
6640 PRINT"{down}{right}Damit besitzen Sie"VM(CO)"$."
6645 PRINT"{right}"NA$(I)" besitzt nun"VM(I)"$."
6650 PRINT"{down}{right}Noch was ?"
6660 GETW$
6670 IFW$<>"n"ANDW$<>"j"THEN6660
6680 IFW$="j"THEN6430
6690 RETURN

!- Bestechungen
6700 POKE53280,2:POKE53281,10:PRINT"{clear}{white}"
6710 PRINT"{down}{right}Wen wollen Sie bestechen ?":GOSUB6740
6730 GOTO6820
6740 PRINT"{down}{right}1. Polizeiwachtmeister"
6750 PRINT"{right}2. Kommissar"
6760 PRINT"{right}3. Untersuchungsrichter"
6770 PRINT"{right}4. Staatsanwalt"
6780 PRINT"{right}5. Buergermeister"
6790 PRINT"{right}6. Computer"
6800 PRINT"{down}{right}Keinen: 'N'"
6810 RETURN
6820 INPUTW$
6830 IFW$="n"THENRETURN
6840 W=VAL(W$)
6850 IFW<1ANDW>6THEN6820
6860 ONWGOTO6870,6880,6890,6900,6910,6920
6870 BG=3000:GOTO6930
6880 BG=12000:GOTO6930
6890 BG=30000:GOTO6930
6900 BG=70000:GOTO6930
6910 BG=100000:GOTO6930
6920 PRINT"{down}{right}Wenn Sie nicht sofort Ihren Loetkolben"
6925 PRINT"{right}da wegnehmen,rufe ich die Polizei.":GOTO7040
6930 PRINTSPC(1),"{down}"NA$(CO)","
6940 PRINT" Waeren Sie mit"BG"$/Monat":PRINT"{right}einverstanden?"
6950 GETQ$
6960 IFQ$<>"j"ANDQ$<>"n"THEN6950
6970 IFQ$="n"THENPRINT"{down}{right}Dann fick'dich selber,du Arsch!!":GOTO7040
6980 PRINT"{down}{right}Das freut mich(lechz)!!":ONWGOTO6990,7000,7010,7020,7030
6990 PW(CO)=PW(CO)+1:GOTO7040
7000 KO(CO)=KO(CO)+1:GOTO7040
7010 UR(CO)=UR(CO)+1:GOTO7040
7020 SA(CO)=SA(CO)+1:GOTO7040
7030 BM(CO)=BM(CO)+1:GOTO7040
7040 FORI=1TO3000:NEXTI
7050 RETURN
7060 :

!- Schulden
7070 POKE53280,0:POKE53281,1:PRINT"{clear}{red}"
7080 PRINT:PRINT"{right*6}{down*2}Sie haben Schulden!{down}"
7090 SF(CO)=SF(CO)+1
7100 IFSF(CO)=6THEN7150
7110 IF1=6-SF(CO)THENR$="Runde":GOTO7130
7120 R$="Runden"
7130 PRINT" Sie haben"6-SF(CO)R$" Zeit,um das Geld"
7135 PRINT"{right}an TKD HADEMARSCHEN zu ueberweisen!":PRINT
7140 GOTO7330

!-- Pfändung
7150 PRINT"{down}{right}Ich muss folgende Dinge pfaenden:"
7160 BA(0)=0:WE(0)=0:SP(0)=0:PU(0)=0:GH(0)=0:AU(0)=0:SF(0)=0

7170 IFVM(CO)>=0THEN7320 !- Wenn Vermögen >=0 dann Schluss mit Pfändung
                         !- Wird aber nur aufgerufen, wenn VM unter 0 ist

7180 FORI=1TO1000:NEXTI
7190 IFAU(CO)=0THEN7210
7200 AU(0)=AU(0)+1:PRINT"{right*8}{down*5}Automaten:"TAB(20)AU(0):AU(CO)=AU(CO)-1
7205 VM(CO)=VM(CO)+4000:GOTO7170
7210 IFBA(CO)=0THEN7230
7220 BA(0)=BA(0)+1:PRINT"{right*8}{down*6}Bars:"TAB(20)BA(0):BA(0)=BA(0)-1
7225 VM(CO)=VM(CO)+40000:GOTO7170
7230 IFWE(CO)=0THEN7250
7240 WE(0)=WE(0)+1:PRINT"{right*8}{down*7}Wettbueros:"TAB(20)WE(0):WE(0)=WE(0)-1
7245 VM(CO)=VM(CO)+80000:GOTO7170
7250 IFSP(0)=0THEN7270
7260 SP(0)=SP(0)+1:PRINT"{right*8}{down*8}Spielsalons:"TAB(20)SP(0):SP(0)=SP(0)-1
7265 VM(CO)=VM(CO)+150000:GOTO7170
7270 IFPU(CO)=0THEN7290
7280 PU(0)=PU(0)+1:PRINT"{right*7}{down*9}"'TABLISSEMENTS':"tab(20)pu(0)"
7285 PU(CO)=PU(CO)-1:VM(CO)=VM(CO)+500000:GOTO7170
7290 IFGH(CO)=0THEN7310
7300 GH(0)=GH(0)+1:PRINT"{right*8}{down*10}Hotels:"TAB(20)GH(0)
7305 GH(CO)=GH(CO)-1:VM(CO)=VM(CO)+5000000:GOTO7170
7310 PRINT"{down}{right}Der Rest wird ihnen erlassen!":VM(CO)=0

7320 PRINT"{down}{right}Es war mir ein Vergnuegen!"
7330 FORI=1TO2500:NEXTI
7340 RETURN

!- Entführung
7350 :
7360 PRINT"{black}":POKE53280,0:POKE53281,8
7370 PRINTSPC(1)"{down}"NA$(CO)","
7380 PRINT"{right}Wieviel Loesegeld verlangen Sie fuer"
7390 PRINTSPC(1);OP$(CO)"?"
7400 :
7410 PRINTSPC(1);:INPUTLG
7420 IFLG<20000THENPRINT"{down}{right}Nur nicht so zimperlich!":PRINT:GOTO7370
7440 ZU=INT(RND(1)*100):FORZ=1TO1000:NEXTZ
7450 IFZU>(LOG(LG)-3.5)*20^15THEN7470
7460 PRINT"{down}{right}Ihre Forderung wurde abgelehnt."
7465 PRINT"{right}Sie koennen die Geisel erschiessen.":GOTO7530
7470 PRINT"{down}{right}Das Geld wurde Ihnen ausgezahlt.":VM(CO)=VM(CO)+LG
7530 FORZ=1TO2000:NEXTZ:EG(CO)=0:RETURN
7540 :

!- Mögliche Unglücke bei Einkommen über 50000
7550 :
7555 N1=0:N2=0:N3=0:N4=0:N5=0:N6=0:N7=0
7560 IFG1<50000THENRETURN
7570 ZU=INT(RND(1)*100)
7580 X1=1.2:X2=1.6:Y=1.4:C=1.8
7581 X=75-PW(CO)*X1-UR(CO)*X2-KO(CO)*Y-AN(CO)-SA(CO)*C-BM(CO)*2-PU(CO)-GH(CO)*7
7582 IFZU>XTHENRETURN
7583 ZU=INT(RND(1)*5+1)
7585 ONZUGOTO7590,7620,7650,7680,7700
7590 IFBA(CO)=0THEN7730
7600 N1=INT(RND(1)*BA(CO)/2)
7610 IFN1>1THENBA(CO)=BA(CO)-N1:GOTO7900
7620 IFWE(CO)=0THEN7730
7630 N2=INT(RND(1)*WE(CO)/2)
7640 IFN2>1THENWE(CO)=WE(CO)-N2:GOTO7900
7650 IFPU(CO)=0THEN7730
7660 N4=INT(RND(1)*PU(CO)/2)
7670 IFN4>1THENPU(CO)=PU(CO)-N4:GOTO7900
7680 IFGH(CO)=0THEN7730
7685 N5=INT(RND(1)*GH(CO)/2)
7690 IFN5>1THENGH(CO)=GH(CO)-N5:GOTO7900
7700 IFSP(CO)=0THEN7730
7710 N3=INT(RND(1)*SP(CO)/2)
7720 IFN3>1THENSP(CO)=SP(CO)-N3:GOTO7900
7730 IFAU(CO)=0THEN7300
7740 N6=INT(RND(1)*AU(CO)/2)
7750 IFN6<2THENN6=0:GOTO7780
7760 AU(CO)=AU(CO)-N6:GOTO7900
7780 IFPR(CO)=0THEN8000
7790 N7=INT(RND(1)*PR(CO)/2)
7800 IFN7<2THEN7890
7810 PR(CO)=PR(CO)-N7:GOTO7900
7890 RETURN
7900 POKE53280,0:POKE53281,7:PRINT"{black}"
7910 PRINTSPC(1)"{down}"NA$(CO)","
7915 IF(N6<>0)+(N7<>0)THEN7973
7920 GOSUB8010
7930 PRINT" mussten{down}"
7938 IFN1>1THENPRINTTAB(5)N1;"Ihrer Bars"
7939 IFN2>1THENPRINTTAB(5)N2;"Ihrer Wettbueros"
7940 IFN3>1THENPRINTTAB(5)N3;"Ihrer Spielsalons"
7941 IFN4>1THENPRINTTAB(5)N4;"Ihrer Bordelle"
7942 IFN5>1THENPRINTTAB(5)N5;"Ihrer Hotels"
7950 PRINT"{down}{right}geschlossen werden."
7955 IFGF(CO)<>0THEN7980
7960 ZU=INT(RND(1)*10)
7970 IFZU<=4THENGF(CO)=INT(RND(1)*5+2)
7971 PRINT"{down}{right}Sie selbst erhielten"GF(CO)"Runden Haft.":GOTO7980
7972 GOTO7980
7973 IFN6<>0THENPRINTSPC(1)N6"Ihrer Automaten sind veraltert.":GOTO7980
7975 ZU=INT(RND(1)*4+1)
7976 IFZU>3THENVM(CO)=VM(CO)-N7*50000:PRINTSPC(1)N7"Ihrer Prostituierten sind"
7977 PRINT"{right}schwanger,und sie helfen finanziell.":GOTO7980
7978 PRINTSPC(1)N7"Ihrer Prostituierten sind veraltet."
7980 FORZ=1TO2500: NEXTZ
8000 RETURN
8010 I=INT(RND(1)*5+1)
8020 ONIGOTO8030,8040,8050,8060,8070
8030 PRINT"{right}Aus hygienischen Gruenden":RETURN
8040 PRINT"{right}Wegen akuter Einsturzgefahr":RETURN
8050 PRINT"{right}Wegen wiederholter Steuerhinterziehung":RETURN
8060 PRINT"{right}Auf Draengen einer Buergerinitiative":RETURN
8070 PRINT"{right}Aus Fairness gegenueber dem Mitspieler":RETURN
