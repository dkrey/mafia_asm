#importonce

// Zeichenlänge für Spielernamen
.const playerNameLength = 16

.pc = * "Player memory"
// Anzahl der Mitspieler
playerCount:
    .byte 0

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

curentPlayerMoney:
    .dword $0000,$0000                                          // Vermögen             4 Byte
curentPlayerDisplayMoney:
    .dword $0000,$0000,$0000,$0000,$0000                        // Vermögen in Dezimal  10 Byte
currentPlayerDebtFlag:
    .byte 00                                                    // Schulden in bit 7    1 Byte
currentPlayerEstate:                                            // Anteile der Gegend   1 Byte
    .byte 00
// Besitz               14 Byte
currentPlayerSlotmachine:
    .word $0000
currentPlayerWhore:
    .word $0000
currentPlayerBar:
    .word $0000
currentPlayerGambling:
    .word $0000
currentPlayerBetting:
    .word $0000
currentPlayerBrothel:
    .word $0000
currentPlayerHotel:
    .word $0000

// Personal             10 Byte
currentPlayerGunfighter:
    .word $0000
currentPlayerBodyguard:
    .word $0000
currentPlayerGuard:
    .word $0000
currentPlayerInformant:
    .word $0000
currentPlayerAttorney:
    .word $0000

//Bestechungen          10 Byte
currentPlayerPolice:
    .word $0000
currentPlayerInspector:
    .word $0000
currentPlayerJudge:
    .word $0000
currentPlayerStateAttorney:
    .word $0000
currentPlayerMajor:
    .word $0000
currentPlayerJailTotal:
    .byte 00                                                    // Gefängnisrunden      1 Byte
currentPlayerJailCurrent:
    .byte 00                                                    // Abgesessene Runden   1 Byte
currentPlayerDebtRounds:
    .byte 00                                                    // Schuldenrunden       1 Byte
currentPlayerHostageFlag:
    .byte 00                                                    // Flag Geisel          1 Byte
currentPlayerHostageName:
    .fill playerNameLength,0                                    // Name Geisel          16 Bytes

// Variablen für den Spieler
// 128 Bytes
player1:
    // Vermögen
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

    .dword $00000000                                            // Vermögen             4 Byte
    .byte 00                                                    // Schulden             1 Byte
    .byte 00                                                    // Anteile der Gegend   1 Byte
    .word $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000 // Besitz               14 Byte
    .word $0000, $0000, $0000, $0000, $0000                     // Personal             10 Byte
    .word $0000, $0000, $0000, $0000, $0000                     // Bestechungen         10 Byte
    .byte 00                                                    // Gefängnisrunden      1 Byte
    .byte 00                                                    // Abgesessene Runden   1 Byte
    .byte 00                                                    // Schuldenrunden       1 Byte
    .byte 00                                                    // Flag Geisel          1 Byte
    .fill 32,00                                                 // Name der Geisel      32 Byte

    .fill 52,00                                                 // Puffer für mehr      50 Byte
                                                                //                      =======
                                                                //                      128 Byte
player2:
    .fill 128,00
player3:
    .fill 128,00
player4:
    .fill 128,00
player5:
    .fill 128,00
player6:
    .fill 128,00
player7:
    .fill 128,00
player8:
    .fill 128,00

// Adressen der Spielerarrays zum Durchzählen in der Schleife
playerAddressTblHigh:
    .byte player1, player2, player3, player4, player5, player6, player7, player8
playerAddressTblLow:
    .byte player1 +1, player2 +1, player3 +1, player4 +1, player5 +1, player6 +1, player7 +1, player8 +1

// Attribut-Offsets der einzelnen Werte
playerAttrTbl:
    .byte 4,1,14,10,10,1,1,1,1,32

// Konstanten von hier an
//===============================================================================
// $00-$FF  PAGE ZERO (256 bytes)
// http://www.awsm.de/mem64/
                      // $00-$01   Reserved for IO
.const ZeroPageTemp    = $02
                      // $03-$8F   Reserved for BASIC

.const ZeroPageParam1  = $F7
.const ZeroPageParam2  = $F8
.const ZeroPageParam3  = $F9
.const ZeroPageParam4  = $FA
//.const ZeroPageParam5  = $77
//.const ZeroPageParam6  = $78
//.const ZeroPageParam7  = $79
//.const ZeroPageParam8  = $7A
//.const ZeroPageParam9  = $7B
                      // $90-$FA   Reserved for Kernal
.const ZeroPageLow     = $FB
.const ZeroPageHigh    = $FC
.const ZeroPageLow2    = $FD
.const ZeroPageHigh2   = $FE
                      // $FF       Reserved for Kernal
// additionally free if no RS323 and Tape in use
//$9E-$9F, $A5-$A7, $A9-$AB, $B0-$B6, $F7-$FA

// ZP Adresse für indirekte Texte
.const TextPtr          = ZeroPageLow


//===============================================================================
// $0100-$01FF  STACK (256 bytes)


//===============================================================================
// $0200-$9FFF  RAM (40K)
.const SCREEN          = $0400

//===============================================================================
// $A000-$BFFF  BASIC ROM (8K)


//===============================================================================
// $C000-$CFFF  RAM (4K)


//===============================================================================
// $D000-$DFFF  IO (4K)

// These are some of the C64 registers that are mapped into
// IO memory space
// Names taken from 'Mapping the Commodore 64' book

.const SP0X            = $D000
.const SP0Y            = $D001
.const MSIGX           = $D010
.const RASTER          = $D012
.const SPENA           = $D015
.const SCROLX          = $D016
.const VMCSB           = $D018
.const SPBGPR          = $D01B
.const SPMC            = $D01C
.const SPSPCL          = $D01E
.const EXTCOL          = $D020
.const BGCOL0          = $D021
.const BGCOL1          = $D022
.const BGCOL2          = $D023
.const BGCOL3          = $D024
.const SPMC0           = $D025
.const SPMC1           = $D026
.const SP0COL          = $D027
.const FRELO1          = $D400 //(54272)
.const FREHI1          = $D401 //(54273)
.const PWLO1           = $D402 //(54274)
.const PWHI1           = $D403 //(54275)
.const VCREG1          = $D404 //(54276)
.const ATDCY1          = $D405 //(54277)
.const SUREL1          = $D406 //(54278)
.const FRELO2          = $D407 //(54279)
.const FREHI2          = $D408 //(54280)
.const PWLO2           = $D409 //(54281)
.const PWHI2           = $D40A //(54282)
.const VCREG2          = $D40B //(54283)
.const ATDCY2          = $D40C //(54284)
.const SUREL2          = $D40D //(54285)
.const FRELO3          = $D40E //(54286)
.const FREHI3          = $D40F //(54287)
.const PWLO3           = $D410 //(54288)
.const PWHI3           = $D411 //(54289)
.const VCREG3          = $D412 //(54290)
.const ATDCY3          = $D413 //(54291)
.const SUREL3          = $D414 //(54292)
.const SIGVOL          = $D418 //(54296)
.const COLORRAM        = $D800
.const CIAPRA          = $DC00
.const CIAPRB          = $DC01

//===============================================================================
// $E000-$FFFF  KERNAL ROM (8K)

.const CLEAR            = $e544 // Clear screen
.const GETIN            = $FFE4 // Get single Character
.const CHRIN            = $FFCF // Get more chars including blinking Cursor
.const PLOT             = $FFF0 // Set Cursor
.const BSOUT            = $FFD2 // Print character

//===============================================================================

