NEW
    
AUTO 4,1
            .OP	65C02
            .LIST OFF
*--------------------------------------	
STROBE		.EQ $C010
*--------------------------------------
            .MA GET_KEY
:1          LDA $C000
            BPL :1
            AND #$7F
            STA STROBE
            .EM
*--------------------------------------
MAN
SAVE /DEV/SPACE/SRC/TOOLS.S
LOAD /DEV/SPACE/SRC/SPACE.S

ASM
