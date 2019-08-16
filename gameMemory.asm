#importonce

// Spielziel
// 0 = Prozente der Gegend entsprechend winFactorEstatePercentage
gameMode:
    .byte 0

// Wenn 1, dann ist das Spiel vorbei
gameOver:
    .byte 0

// Anteil der ganzen Gegend, die erreicht werden muss
// abhängig von der Spieleranzahl
winFactorEstatePercentage:
    .byte $37   // 55 %
    .byte $32   // 50 %
    .byte $2d   // 45 %
    .byte $28   // 40 %
    .byte $23   // 35 %
    .byte $1e   // 30 %
    .byte $19   // 25 %
    .byte $14   // 20 %

// Anzahl der Mitspieler
playerCount:
    .byte 0

// Spieler, der an der Reihe ist 0-7(max)
currentPlayerNumber:
    .byte 0

// wird durch calcPlayerOffsets aus libMath berrechnet
currentPlayerOffset_2:
    .byte 0
currentPlayerOffset_4:
    .byte 0
currentPlayerOffset_8:
    .byte 0
currentPlayerOffset_16:
    .byte 0

// Mindestens 20.000 $ dez, um das Hauptmenu zu bekommen
minMoneyForMenu:
    .dword $00004e20

// Platzhalter für Zufälligkeit
.pc = * "Player Random"
randomFactor:
    .word 0000

// Spielervariablen
    // Name
    // Schulden j/n
    // Vermögen
    // Vermögen in Dez
    // Besitzanteile
    //
    // Besitz:
    // Anzahl Automaten
    // Anzahl Prostituierte
    // Anzahl Bars
    // Anzahl Spielsalons
    // Anzahl Wettbüros
    // Anzahl Puffs
    // Anzahl GrandHotels
    //
    // Personal:
    // Anzahl Revolverhelden (Angriff)
    // Anzahl Leibwächter (Verteidigung)
    // Wächter (Verteidigung)
    // Anzahl Informanten (verhindern Morde)
    // Anzahl Anwälte (helfen aus dem Knast)
    //
    // Bestechungen:
    // Anzahl Polizeiwachtmeister
    // Anzahl Kommissare
    // Anzahl Untersuchungsrichter
    // Anzahl Staatsanwalt
    // Anzahl Bürgermeister
    //
    // Knastrunden
    // Abgessesene Knastrunden
    // Schuldenrunden
    // Geisel j/n
    // Geiselname

// Namen der Mitspieler
playerNames:
    .fill playerNameLength,0
    .fill playerNameLength,0
    .fill playerNameLength,0
    .fill playerNameLength,0
    .fill playerNameLength,0
    .fill playerNameLength,0
    .fill playerNameLength,0
    .fill playerNameLength,0

// Schulden in bit 7    1 Byte
playerDebtFlag:
    .byte 00
    .byte 00
    .byte 00
    .byte 00
    .byte 00
    .byte 00
    .byte 00
    .byte 00

// Mitspieler als Mitarbeiter
playerEmployee:
    .byte 00
    .byte 00
    .byte 00
    .byte 00
    .byte 00
    .byte 00
    .byte 00
    .byte 00

// Vermögen: 4 Byte pro Spieler
playerMoney:
    .dword $00000000
    .dword $00000000
    .dword $00000000
    .dword $00000000
    .dword $00000000
    .dword $00000000
    .dword $00000000
    .dword $00000000

// Einkommen: 4 Byte pro Spieler
playerIncome:
    .dword $00000000
    .dword $00000000
    .dword $00000000
    .dword $00000000
    .dword $00000000
    .dword $00000000
    .dword $00000000
    .dword $00000000

// Vermögen in Dezimal: 10 Byte pro Spieler + 6 Byte Luft für einfaches Multiplizieren
playerMoneyDec:
    .word $0000,$0000,$0000,$0000,$0000
    .fill 6, 0
    .word $0000,$0000,$0000,$0000,$0000
    .fill 6, 0
    .word $0000,$0000,$0000,$0000,$0000
    .fill 6, 0
    .word $0000,$0000,$0000,$0000,$0000
    .fill 6, 0
    .word $0000,$0000,$0000,$0000,$0000
    .fill 6, 0
    .word $0000,$0000,$0000,$0000,$0000
    .fill 6, 0
    .word $0000,$0000,$0000,$0000,$0000
    .fill 6, 0
    .word $0000,$0000,$0000,$0000,$0000
    .fill 6, 0

// Anteile der Gegend: 1 Byte pro Spieler
playerEstates:
    .byte 00
    .byte 00
    .byte 00
    .byte 00
    .byte 00
    .byte 00
    .byte 00
    .byte 00

// Besitz:
playerSlotMachines:
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
playerProstitutes:
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
playerBars:
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
playerBetting:
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
playerGambling:
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
playerBrothels:
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
playerHotels:
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00

// Personal: 10 Byte pro Spieler
playerGunfighters:
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00

playerBodyguards:
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00

playerGuards:
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00

playerInformants:
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00

playerAttorneys:
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00

//Bestechungen:
playerPolice:
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00

playerInspectors:
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00

playerJudges:
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00

playerStateAttorneys:
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00

playerMajors:
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00

// Gefängnisrunden      1 Byte
playerJailTotal:
    .byte 00
    .byte 00
    .byte 00
    .byte 00
    .byte 00
    .byte 00
    .byte 00
    .byte 00

// Schuldenrunden       1 Byte
playerDebtRounds:
    .byte 00
    .byte 00
    .byte 00
    .byte 00
    .byte 00
    .byte 00
    .byte 00
    .byte 00

// Flag Geisel          1 Byte, bit 7 für bpl
playerHostageFlags:
    .byte 00
    .byte 00
    .byte 00
    .byte 00
    .byte 00
    .byte 00
    .byte 00
    .byte 00

// Name Geisel          16 Bytes
playerHostageNames:
    .fill playerNameLength,0    // Name Geisel          16 Bytes
    .fill playerNameLength,0    // Name Geisel          16 Bytes
    .fill playerNameLength,0    // Name Geisel          16 Bytes
    .fill playerNameLength,0    // Name Geisel          16 Bytes
    .fill playerNameLength,0    // Name Geisel          16 Bytes
    .fill playerNameLength,0    // Name Geisel          16 Bytes
    .fill playerNameLength,0    // Name Geisel          16 Bytes
    .fill playerNameLength,0    // Name Geisel          16 Bytes


//===============================================================================
// Titel anzeigen
//===============================================================================
resetGame:
    // Spieleranzahl löschen
    lda #00
    sta playerCount
    sta currentPlayerNumber
    sta gameOver
    sta gameMode

    // Spielernamen löschen
    tax
!loop_x:
    sta playerNames,x
    inx
    cpx #(8 * playerNameLength)
    bne !loop_x-

    // Schuldenflag löschen
    tax
!loop_x:
    sta playerDebtFlag,x
    inx
    cpx #8
    bne !loop_x-

    // Mitarbeiter löschen
    tax
!loop_x:
    sta playerEmployee,x
    inx
    cpx #8
    bne !loop_x-

    // Geld löschen
    tax
!loop_x:
    sta playerMoney,x
    inx
    cpx #64
    bne !loop_x-
    // Einkommen löschen
!loop_x:
    sta playerIncome,x
    inx
    cpx #64
    bne !loop_x-
    // Geld in Dez löschen
    tax
!loop_x:
    sta playerMoneyDec,x
    inx
    cpx #128
    bne !loop_x-

    // Besitz löschen
    tax
!loop_x:
    sta playerEstates,x
    inx
    cpx #168
    bne !loop_x-
    rts

    // Geiselnamen löschen
    tax
!loop_x:
    sta playerHostageNames,x
    inx
    cpx #(playerNames * playerNameLength)
    bne !loop_x-

    rts