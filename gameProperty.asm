#importonce

// Gesamtbesitz
propsTotalSlotMachines:
    .word $0001
propsTotalProstitutes:
    .word $0001
propsTotalBars:
    .word $0001
propsTotalBetting:
    .word $0001
propsTotalGambling:
    .word $0001
propsTotalBrothels:
    .word $0001
propsTotalHotels:
    .word $0001
propsTotalGunfighters:
    .word $0001
propsTotalBodyguards:
    .word $0001
propsTotalGuards:
    .word $0001
propsTotalInformants:
    .word $0001
propsTotalAttorneys:
    .word $0001
propsTotalPolice:
    .word $0001
propsTotalInspectors:
    .word $0001
propsTotalJudges:
    .word $0001
propsTotalStateAttorneys:
    .word $0001
propsTotalMajors:
    .word $0001

propsCurrentTotal:
    .word $0000
propsCurrentEstate:
    .word $0000

gamePropertySumPositions:
    // Grundwert setzen
    mov16 #$0000 : propsCurrentTotal
    mov16 #$0001 : propsTotalSlotMachines
    mov16 #$0001 : propsTotalProstitutes
    mov16 #$0001 : propsTotalBars
    mov16 #$0001 : propsTotalBetting
    mov16 #$0001 : propsTotalGambling
    mov16 #$0001 : propsTotalBrothels
    mov16 #$0001 : propsTotalHotels
    mov16 #$0001 : propsTotalGunfighters
    mov16 #$0001 : propsTotalBodyguards
    mov16 #$0001 : propsTotalGuards
    mov16 #$0001 : propsTotalInformants
    mov16 #$0001 : propsTotalAttorneys
    mov16 #$0001 : propsTotalPolice
    mov16 #$0001 : propsTotalInspectors
    mov16 #$0001 : propsTotalJudges
    mov16 #$0001 : propsTotalStateAttorneys
    mov16 #$0001 : propsTotalMajors
    clear16 propsCurrentTotal
    clear16 propsCurrentEstate
    ldx #0                          // Zählschleife 0 - Spieleranzahl
!loop:

    add8To16 playerSlotMachines,x : propsTotalSlotMachines : propsTotalSlotMachines
    add8To16 playerProstitutes,x : propsTotalProstitutes : propsTotalProstitutes
    add8To16 playerBars,x : propsTotalBars : propsTotalBars
    add8To16 playerBetting,x : propsTotalBetting : propsTotalBetting
    add8To16 playerGambling,x : propsTotalGambling : propsTotalGambling
    add8To16 playerBrothels,x : propsTotalBrothels : propsTotalBrothels
    add8To16 playerHotels,x : propsTotalHotels : propsTotalHotels
    add8To16 playerGunfighters,x : propsTotalGunfighters : propsTotalGunfighters
    add8To16 playerBodyguards,x : propsTotalBodyguards : propsTotalBodyguards
    add8To16 playerGuards,x : propsTotalGuards : propsTotalGuards
    add8To16 playerInformants,x : propsTotalInformants : propsTotalInformants
    add8To16 playerAttorneys,x : propsTotalAttorneys : propsTotalAttorneys
    add8To16 playerPolice,x : propsTotalPolice : propsTotalPolice
    add8To16 playerInspectors,x : propsTotalInspectors : propsTotalInspectors
    add8To16 playerJudges,x : propsTotalJudges : propsTotalJudges
    add8To16 playerStateAttorneys,x : propsTotalStateAttorneys : propsTotalStateAttorneys
    add8To16 playerMajors,x : propsTotalMajors : propsTotalMajors

    inx
    cpx playerCount                 // Solange x< Spieleranzahl
    beq !skip+
    jmp !loop-                      // weiter mit Schleife
    !skip:
    rts

// Besitzverhältnisse errechnen
gamePropertySumEstate:
    ldx currentPlayerNumber

    mul8 playerSlotMachines,x : #$64                // Anzahl Besitz * 100
    divide16 mulResult : propsTotalSlotMachines     // Ergebnis / Anzahl aller Pos. Besitz
    add16 divResult : propsCurrentTotal : propsCurrentTotal

    ldx currentPlayerNumber
    mul8 playerProstitutes,x : #$64                // Anzahl Besitz * 100
    divide16 mulResult : propsTotalProstitutes     // Ergebnis / Anzahl aller Pos. Besitz
    add16 divResult : propsCurrentTotal : propsCurrentTotal

    ldx currentPlayerNumber
    mul8 playerBars,x : #$64                // Anzahl Besitz * 100
    divide16 mulResult : propsTotalBars     // Ergebnis / Anzahl aller Pos. Besitz
    add16 divResult : propsCurrentTotal : propsCurrentTotal

    ldx currentPlayerNumber
    mul8 playerGambling,x : #$64                // Anzahl Besitz * 100
    divide16 mulResult : propsTotalGambling     // Ergebnis / Anzahl aller Pos. Besitz
    add16 divResult : propsCurrentTotal : propsCurrentTotal

    ldx currentPlayerNumber
    mul8 playerBetting,x : #$64                // Anzahl Besitz * 100
    divide16 mulResult : propsTotalBetting     // Ergebnis / Anzahl aller Pos. Besitz
    add16 divResult : propsCurrentTotal : propsCurrentTotal

    ldx currentPlayerNumber
    mul8 playerBrothels,x : #$64                // Anzahl Besitz * 100
    divide16 mulResult : propsTotalBrothels     // Ergebnis / Anzahl aller Pos. Besitz
    add16 divResult : propsCurrentTotal : propsCurrentTotal

    ldx currentPlayerNumber
    mul8 playerHotels,x : #$64                // Anzahl Besitz * 100
    divide16 mulResult : propsTotalHotels     // Ergebnis / Anzahl aller Pos. Besitz
    add16 divResult : propsCurrentTotal : propsCurrentTotal

    ldx currentPlayerNumber
    mul8 playerHotels,x : #$64                // Anzahl Besitz * 100
    divide16 mulResult : propsTotalHotels     // Ergebnis / Anzahl aller Pos. Besitz
    add16 divResult : propsCurrentTotal : propsCurrentTotal

    ldx currentPlayerNumber
    mul8 playerGunfighters,x : #$64                // Anzahl Besitz * 100
    divide16 mulResult : propsTotalGunfighters     // Ergebnis / Anzahl aller Pos. Besitz
    add16 divResult : propsCurrentTotal : propsCurrentTotal

    ldx currentPlayerNumber
    mul8 playerBodyguards,x : #$64                // Anzahl Besitz * 100
    divide16 mulResult : propsTotalBodyguards     // Ergebnis / Anzahl aller Pos. Besitz
    add16 divResult : propsCurrentTotal : propsCurrentTotal

    ldx currentPlayerNumber
    mul8 playerGuards,x : #$64                // Anzahl Besitz * 100
    divide16 mulResult : propsTotalGuards     // Ergebnis / Anzahl aller Pos. Besitz
    add16 divResult : propsCurrentTotal : propsCurrentTotal

    ldx currentPlayerNumber
    mul8 playerInformants,x : #$64                // Anzahl Besitz * 100
    divide16 mulResult : propsTotalInformants     // Ergebnis / Anzahl aller Pos. Besitz
    add16 divResult : propsCurrentTotal : propsCurrentTotal

    ldx currentPlayerNumber
    mul8 playerAttorneys,x : #$64                // Anzahl Besitz * 100
    divide16 mulResult : propsTotalAttorneys     // Ergebnis / Anzahl aller Pos. Besitz
    add16 divResult : propsCurrentTotal : propsCurrentTotal

    ldx currentPlayerNumber
    mul8 playerPolice,x : #$64                // Anzahl Besitz * 100
    divide16 mulResult : propsTotalPolice     // Ergebnis / Anzahl aller Pos. Besitz
    add16 divResult : propsCurrentTotal : propsCurrentTotal

    ldx currentPlayerNumber
    mul8 playerInspectors,x : #$64                // Anzahl Besitz * 100
    divide16 mulResult : propsTotalInspectors     // Ergebnis / Anzahl aller Pos. Besitz
    add16 divResult : propsCurrentTotal : propsCurrentTotal

    ldx currentPlayerNumber
    mul8 playerJudges,x : #$64                // Anzahl Besitz * 100
    divide16 mulResult : propsTotalJudges     // Ergebnis / Anzahl aller Pos. Besitz
    add16 divResult : propsCurrentTotal : propsCurrentTotal

    ldx currentPlayerNumber
    mul8 playerStateAttorneys,x : #$64                // Anzahl Besitz * 100
    divide16 mulResult : propsTotalStateAttorneys     // Ergebnis / Anzahl aller Pos. Besitz
    add16 divResult : propsCurrentTotal : propsCurrentTotal

    ldx currentPlayerNumber
    mul8 playerMajors,x : #$64                // Anzahl Besitz * 100
    divide16 mulResult : propsTotalMajors     // Ergebnis / Anzahl aller Pos. Besitz
    add16 divResult : propsCurrentTotal : propsCurrentTotal


    divide16 propsCurrentTotal : #$0011     // Gesamtergebnis / 17
    mov16 divResult : propsCurrentEstate
    rts


gamePropertyCalc:
    jsr gamePropertySumPositions
    jsr gamePropertySumEstate

    // Prozentsatz abspeichern
    ldx currentPlayerNumber
    lda propsCurrentEstate
    sta playerEstates,x

!end:
    rts