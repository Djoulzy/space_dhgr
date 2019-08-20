NEW
  
AUTO 4,1
			.LIST OFF
            .OP	65C02
*--------------------------------------
			.INB /DEV/SPACE/SRC/DHGR.OFFSET.S
			.INB /DEV/SPACE/SRC/DHGR.TABLES.S
            .INB /DEV/SPACE/SRC/MEM.S
*            .INB /DEV/SPACE/SRC/MLI.S
			.INB /DEV/SPACE/SRC/DHGR.INIT.S
			.INB /DEV/SPACE/SRC/DHGR.PLOT.S
			.INB /DEV/SPACE/SRC/DHGR.CLR.S
            .INB /DEV/SPACE/SRC/DHGR.LINES.S
            .INB /DEV/SPACE/SRC/ENGINE.S
            .INB /DEV/SPACE/SRC/DATA.S
*--------------------------------------
REF         .HS 00              ; ProDOS reference number
OBJMEMLOC   .EQ $0800
DATAMEMLOC  .EQ $8000
*MLIPARAMS   .HS 00              ;number-of-parameters   0853
*            .HS 00,00           ;pointer to pathname
*            .HS C3              ;Normal file access permitted
*            .HS 04              ;Make it a text file
*            .HS 00,00           ;AUX_TYPE, not used
*            .HS 01              ;Standard file
*            .HS 00,00           ;Creation date (unused)
*            .HS 00,00           ;Creation time (unused)
*--------------------------------------
PLAYER_UP   .HS 38,5B           ; Pos X,Y
            .DA #MAN_HI,/MAN_HI ; Addr SpriteSheet Lo/Hi
            .HS 01,00           ; Orientation / Vitesse
            .HS 64,5B           ; Destination X,Y
            .HS 00,00           ; Ancienne position

PLAYER_DWN  .HS 38,69           ; Pos X,Y
            .DA #MAN_LO,/MAN_LO ; Addr SpriteSheet Lo/Hi
            .HS 01,00           ; Orientation / Vitesse
            .HS 64,69           ; Destination X,Y
            .HS 00,00           ; Ancienne position
*--------------------------------------
*           >GODHGR2
*           LDA #$00
*           JSR DHGR2_CLR
*
*           LDA #$01
*            STA DBL_DRAW
*
*           LDY #$02
*           JSR SETDCOLOR
*
*           LDX #$10
*           LDY #$10
*           JSR DPLOT
*            >SWITCH_PAGE
*           BRK
*LOAD_OBJ    JSR OPEN
*            .HS 1A
*            .AS "/DEV/SPACE/OBJ/DHGR.TABLES"
*            >SET_RW_PARAMS OBJMEMLOC,#$70,#$15
*            JSR READ_AUX
*            JSR CLOSE

*           JSR OPEN
*           .HS 17
*           .AS "/DEV/SPACE/OBJ/DATA.OBJ"
*           >SET_RW_PARAMS DATAMEMLOC,#$C4,#$07
*           JSR READ_AUX
*           JSR CLOSE



*            >DRAW_BLOC PLAYER_UP

*            RTS
*KEYB        LDA $C000
*            BPL KEYB
*            AND #$7F
*            STA STROBE
*--------------------------------------
RUN
            >GODHGR2
			LDA #$00
            JSR DHGR2_CLR
            STA STORE80_OFF
            STA PAGE2_OFF
            STA RAMRD_OFF
            STA RAMWRT_OFF

			LDA #$00			; Ecriture Page 1
            STA DBL_DRAW
			STA $E6

            STA STORE80_ON
            STA PAGE2_OFF
            STA RAMRD_OFF
            STA RAMWRT_OFF

            LDY #$02
            JSR SETDCOLOR
            LDX #$16
            LDY #$20
            JSR PLOT
    
TEST        LDX #$25
            LDY #$20
            JSR BLOC
            .DA #CHAIR,/CHAIR
            LDA #$EE
            BRK

*            >RELOC2AUX D2PLOT,D2PLOTEND
*            >RELOC2AUX BLOCDRAW,BLOCDRAWEND

*            >DRAW_SCENE ROOM_1_LO,BOARD_LO_X,BOARD_LO_Y
*            >DRAW_SCENE ROOM_1_HI,BOARD_HI_X,BOARD_HI_Y

*            >SET_POS PLAYER_DWN,#$04,#$05,DOWN
*            >DRAW_BLOC PLAYER_DWN
*            >SET_POS PLAYER_UP,#$04,#$05,UP
*            >DRAW_BLOC PLAYER_UP

GAMELOOP
*            >MOVE_SPRITE PLAYER_DWN
*            >MOVE_SPRITE PLAYER_UP
            >WAITVBL
            >SWITCH_PAGE

            JMP GAMELOOP
            BRK
*--------------------------------------
MAN
SAVE /DEV/SPACE/SRC/SPACE.S

ASM
