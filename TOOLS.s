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
            .MA MYPLOT
            LDY ]3
            JSR SETDCOLOR
            LDX ]1
            LDY ]2
            JSR PLOT
            .EM
*--------------------------------------
            .MA TBLOC   ; 1 -> X, 2 -> Y
            ; Ligne haut
            LDY ]2
            LDX #$00
            JSR BLOC
            .DA #TRUC2,/TRUC2
            LDY ]2
            LDX #$0E
            JSR BLOC
            .DA #TRUC2,/TRUC2

            ; Ligne basse
            LDA ]2
            CLC
            ADC #$1D
            TAY
            LDX #$00
            JSR BLOC
            .DA #TRUC2,/TRUC2
            LDA ]2
            CLC
            ADC #$1D
            TAY
            LDX #$0E
            JSR BLOC
            .DA #TRUC2,/TRUC2

            ; Motif
            LDY ]2
            LDX ]1
            JSR BLOC
            .DA #TRUC2,/TRUC2
            LDY ]2
            LDX ]1
            JSR BLOC
            .DA #ITEM_1,/ITEM_1

            ; Copy Colle
            LDY ]2
            LDX ]1
            JSR COPY
            LDX ]1
            LDA ]2
            CLC
            ADC #$1D
            TAY
            JSR PASTE
            .EM
*--------------------------------------
MAN
SAVE /DEV/SPACE/SRC/TOOLS.S
LOAD /DEV/SPACE/SRC/SPACE.S

ASM
