# Income and Costs
## Income
### Slot Machines
1.000 - 1.100

### Prostitutes
800 - 2.800

### Bars
10.000 - 20.000

### Betting
10.000 - 35.000

### Gambling
15.000 - 45.000

### Brothels
20.000 - 65.000

### Hotels
35.000 - 65.000

## Costs

### Gunfighters
6.000

### Bodyguards
4.000

### Guards
3.000

### Informants
2.000 - 10.000

### Attourney
8.000

### Police
3.000

### Policeinspector
12.000

### Judge
30.000

### Stateattourney
70.000

### Major
100.000


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
