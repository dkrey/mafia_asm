# Random event formulas
## Small Theft


### Bank robbery
Success:
Rnd(0..100) > 90

Jail:
Rnd(0..100) < 70


### Slot Machines
Success:
Rnd(0..100) > 10

Jail:
Rnd(0..100) < 10

Co-Player Property:
Rnd(0..80) > 160 / Playercount


### Bar
Success:
Rnd(0..100) > 60

Jail:
Rnd(0..100) < 60

Co-Player Property:
Rnd(0..100) > 300 / (Playercount * 4)


### Kerb
Success:
Rnd(0..100) > 50

Jail:
Rnd(0..100) < 50

Co-Player Property:
Rnd(0..100) > 255 / (Playercount * 2)


### Pedestrian

Success:
Rnd(0..100) > 10

Co-Player:
Rnd(0..100) > 300 / (Playercount * 2)

Co-Player Bodyguard success
Rnd(0..100) > 90 / sqrt ( 1 + bodyguards )

Jail:
Rnd(0..100) < 20


## Jail

### Breakout
Rnd(0..100) > 90

### Attourney bailout
Rnd(0..100) > 90 / sqrt ( 1 + attourneys )

### Prostitutes leave
Rnd(0..110) > ( Prostitutes * 4 + 30)
