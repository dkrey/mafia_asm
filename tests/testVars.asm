playerNames:
    .text "Anton"
    .fill 11, 0
    .text "Bertram"
    .fill 9, 0
    .text "Chris"
    .fill 11, 0
    .text "Detlef"
    .fill 10, 0
    .text "Erwin"
    .fill 11, 0
    .text "Friedhelm"
    .fill 7, 0
    .text "Gunther"
    .fill 9, 0
    .text "Hedwig"
    .fill 10, 0

// Anzahl der Mitspieler
playerCount:
    .byte 08

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


// Schulden in bit 7    1 Byte
currentPlayerDebtFlags:
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
    .dword $00000064
    .dword $00000064
    .dword $00000064
    .dword $00000064
    .dword $00000064
    .dword $00000064
    .dword $00000064
    .dword $00000064

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

// Besitz: 2 Byte pro Position, 14 Byte pro Spieler
playerSlotMachines:
    .word $0001
    .word $0001
    .word $0001
    .word $0001
    .word $0001
    .word $0001
    .word $0001
    .word $0001
playerProstitutes:
    .word $00fa
    .word $0001
    .word $0001
    .word $0001
    .word $0001
    .word $0001
    .word $0001
    .word $0001
playerBars:
    .word $0001
    .word $0001
    .word $0001
    .word $0001
    .word $0001
    .word $0001
    .word $0001
    .word $0001
playerGambling:
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
playerBetting:
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
playerBrothels:
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
playerHotels:
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000

// Personal: 10 Byte pro Spieler
playerGunfighters:
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000

playerBodyguards:
    .word $000f
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000

playerGuards:
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000

playerInformants:
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000

playerAttorneys:
    .word $0009
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000

//Bestechungen: 10 Byte pro Spieler
playerPolice:
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000

playerInspectors:
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000

playerJudges:
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000

playerStateAttorneys:
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000

playerMajors:
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000


// Gefängnisrunden      1 Byte
.pc = * "Player Jail"
playerJailTotal:
    .byte 06
    .byte 05
    .byte 04
    .byte 03
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
    .fill playerNameLength,0                                    // Name Geisel          16 Bytes
    .fill playerNameLength,0                                    // Name Geisel          16 Bytes
    .fill playerNameLength,0                                    // Name Geisel          16 Bytes
    .fill playerNameLength,0                                    // Name Geisel          16 Bytes
    .fill playerNameLength,0                                    // Name Geisel          16 Bytes
    .fill playerNameLength,0                                    // Name Geisel          16 Bytes
    .fill playerNameLength,0                                    // Name Geisel          16 Bytes
    .fill playerNameLength,0                                    // Name Geisel          16 Bytes