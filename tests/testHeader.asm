#importonce

.encoding "petscii_mixed"
//===============================================================================
// Set the Basic Loader
BasicUpstart2(init)


#import "../libConstants.asm"
#import "testVars.asm"
#import "../libCharset.asm"
#import "../libMacros.asm"
#import "../libText.asm"
#import "../libInput.asm"
#import "../libRandom.asm"
#import "../libMath.asm"
#import "../gameStringsDE.asm"
#import "../gameJail.asm"


//===============================================================================
// Spiel initialisieren
//===============================================================================


init:
    jsr charsetAddUmlaut
jmp main