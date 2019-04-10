#importonce

// Resets everything
resetGame:
    // Spieleranzahl löschen
    lda #00
    sta playerCount
    sta currentPlayerNumber
    // Spielernamen löschen
    tax
!loop_x:
    sta playerNames,x
    inx
    cpx #(playerNames * playerNameLength)
    bne !loop_x-

    // Schuldenflag löschen
    tax
!loop_x:
    sta currentPlayerDebtFlags,x
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
    cpx #120
    bne !loop_x-
    rts

    // Personal, Bestechungen Knastrunden etc löschen
    tax
!loop_x:
    sta playerGunfighters,x
    inx
    cpx #160
    bne !loop_x-

    tax
!loop_x:
    sta playerGunfighters,x
    inx
    cpx #192
    bne !loop_x-

    // Geiselnamen löschen
    tax
!loop_x:
    sta playerHostageNames,x
    inx
    cpx #(playerNames * playerNameLength)
    bne !loop_x-

    rts
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
.pc = * "Player Money"
playerMoney:
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

// Besitz: 2 Byte pro Position, 14 Byte pro Spieler
playerSlotmachines:
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
playerWhores:
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
playerBars:
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
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
    .word $0000
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
    .word $0000
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
playerJailTotal:
    .byte 00
    .byte 00
    .byte 00
    .byte 00
    .byte 00
    .byte 00
    .byte 00
    .byte 00


// Abgesessene Runden   1 Byte
playerJailCurrent:
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

// Rahmenwerte für Diebstähle
theftBaseBank:
    .word $c350 // Min 50000

theftRndBank:
    .word $c350 // max 50000 oben drauf