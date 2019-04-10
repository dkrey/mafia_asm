#importonce

.encoding "petscii_mixed"
//===============================================================================
// Set the Basic Loader
BasicUpstart2(init)


#import "../libConstants.asm"
#import "testVars.asm"
#import "../libCharset.asm"
#import "../helpers.asm"
#import "../libText.asm"
#import "../libInput.asm"
#import "../libMath.asm"
#import "../gameStringsDE.asm"


//===============================================================================
// Spiel initialisieren
//===============================================================================


init:
    jsr charsetAddUmlaut
jmp main