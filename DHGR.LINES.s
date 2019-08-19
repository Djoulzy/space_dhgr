NEW
  
AUTO 4,1
			.LIST OFF
            .OP	65C02
*--------------------------------------
COLCNT      .EQ $09
*--------------------------------------
COLSWITCH   LDA COLCNT
            DEC
            BEQ .5
            JMP .6
.5          LDA #$0F
.6          STA COLCNT
            JSR SETDCOLOR
            RTS
*--------------------------------------
			.MA CORNER
			LDA ]3
			JSR SETDCOLOR

            LDX #$00
            LDY ]1
            JSR PLOT

            LDX #$8B
            LDY ]1
            JSR PLOT

            LDX #$00
            LDY ]2
            JSR PLOT

            LDX #$8B
            LDY ]2
            JSR PLOT
			.EM
*--------------------------------------
VLINE
            STX PTR
            LDA #$C0    ; 192 dans CPTY
            STA CPTY
.11         LDX PTR
            LDY CPTY
            DEY
            JSR PLOT
            DEC CPTY
            BNE .11
            RTS
*--------------------------------------
VERTLINE    LDA #$8C    ; 140 dans CPTX
            STA CPTX
            LDA #$0F
            STA COLCNT

.12         JSR COLSWITCH
            LDX CPTX
            DEX
            JSR VLINE
            DEC CPTX
            BNE .12
            RTS
*--------------------------------------
HLINE
            STY PTR
            LDA #$8C    ; 140 dans CPTX
            STA CPTX

.21         LDY PTR
            LDX CPTX
            DEX
            JSR PLOT
            DEC CPTX
            BNE .21
            RTS
*--------------------------------------
HORIZLINE   LDA #$C0    ; 192 dans CPTY
            STA CPTY
            LDA #$0F
            STA COLCNT

.22         JSR COLSWITCH
            LDY CPTY
            DEY
            JSR HLINE
            DEC CPTY
            BNE .22
            RTS
*--------------------------------------
MAN
SAVE /DEV/SPACE/SRC/DHGR.LINES.S

ASM
