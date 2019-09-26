NEW
  
AUTO 4,1
			.LIST OFF
            .OP	65C02
*--------------------------------------
			.INB /DEV/SPACE/SRC/DHGR.OFFSET.S
			.INB /DEV/SPACE/SRC/DHGR.TABLES.S
            .INB /DEV/SPACE/SRC/MEM.S
            .INB /DEV/SPACE/SRC/MLI.S
			.INB /DEV/SPACE/SRC/DHGR.INIT.S
			.INB /DEV/SPACE/SRC/DHGR.PLOT.S
			.INB /DEV/SPACE/SRC/DHGR.CLR.S
*            .INB /DEV/SPACE/SRC/DHGR.LINES.S
            .INB /DEV/SPACE/SRC/ENGINE.S
            .INB /DEV/SPACE/SRC/TOOLS.S
            .INB /DEV/SPACE/SRC/DATA.S
*--------------------------------------
*PLAYER_UP   .HS 38,5B           ; Pos X,Y
*            .DA #MAN_HI,/MAN_HI ; Addr SpriteSheet Lo/Hi
*            .HS 01,00           ; Orientation / Vitesse
*            .HS 64,5B           ; Destination X,Y
*            .HS 00,00           ; Ancienne position
*
*PLAYER_DWN  .HS 38,69           ; Pos X,Y
*            .DA #MAN_LO,/MAN_LO ; Addr SpriteSheet Lo/Hi
*            .HS 01,00           ; Orientation / Vitesse
*            .HS 64,69           ; Destination X,Y
*            .HS 00,00           ; Ancienne position
*--------------------------------------
GEST_X      .HS 10,00           ; Pos X,Orientation
GEST_Y      .HS 10,00           ; Pos Y,Orientation
*--------------------------------------
GEST2_X      .HS 60,FF           ; Pos X,Orientation
GEST2_Y      .HS 50,00           ; Pos Y,Orientation
*--------------------------------------
PAGE1       .EQ $2000
PAGE2       .EQ $4000
*--------------------------------------
            .MA COMPUTE_MOVE    ; 1 -> GEST buff address, 2 -> MaxVal
            LDA ]1+1
            BMI :1
            INC ]1              ; Orientation positive
            LDA ]1
            CMP ]2
            BNE :5
            LDA #$FF
            STA ]1+1
            JMP :5

:1          DEC ]1              ; Orientation negative
            BNE :5
            LDA #$00
            STA ]1+1

:5          ; return
            .EM
*--------------------------------------
LOAD_PAGE1
            JSR OPEN
            .HS 16
            .AS "/DEV/IMG/MONSTRE2.A2FC"
            >SET_RW_PARAMS PAGE1,#$00,#$20
            STA STORE80_ON
            STA PAGE2_ON
            JSR RD_TO_MAIN
            STA PAGE2_OFF
            STA STORE80_OFF
            JSR RD_TO_MAIN
            JSR CLOSE
            RTS

LOAD_PAGE2
            JSR OPEN
            .HS 16
            .AS "/DEV/IMG/MONSTRE1.A2FC"
            >SET_RW_PARAMS PAGE2,#$00,#$20
            JSR RD_TO_AUX2
            >SET_RW_PARAMS PAGE2,#$00,#$20
            JSR RD_TO_MAIN
            JSR CLOSE
            RTS

WAITVBL     BIT VBL
            BPL WAITVBL
.10         BIT VBL
            BMI .10
            RTS

SLEEP       LDA #$20
.11         JSR WAITVBL
            DEC
            BNE .11
            RTS

RUN
            >GODHGR

            JSR LOAD_PAGE1
            JSR LOAD_PAGE2

            STA STORE80_OFF
LOOP        STA PAGE2_ON ;Show PAGE 2
            JSR SLEEP
            STA PAGE2_OFF ;Show PAGE 1
            JSR SLEEP
            JMP LOOP
    
            LDA #$EE
            BRK
ENDCODE
*--------------------------------------
MAN
SAVE /DEV/SPACE/SRC/SPACE.S

ASM
