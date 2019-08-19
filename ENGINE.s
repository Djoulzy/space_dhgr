NEW
  
AUTO 4,1
			.LIST OFF
            .OP	65C02
*--------------------------------------
UP          .EQ 01
DOWN        .EQ 00
*--------------------------------------
BLOC        .HS 00,00       ; Pos X,Y
            .HS 00,00       ; Addr SpriteSheet Lo/Hi
            .HS 00,00       ; Orientation, Vitesse

TIME10      .HS 00,0A,14,1E,28,32,3C,46,50,5A
*--------------------------------------
            .MA SAVE_STACK
            PHA
            PHX
            PHY
            .EM

            .MA RESTORE_STACK
            PLY
            PLX
            PLA
            .EM
*--------------------------------------
            .MA SET_POS             ; ObjectPtr,X,Y,(UP or DOWN)
            CLC
            LDY ]3
            LDA TIME10,Y
            ADC ]2
            TAY
            LDA ]4                  ; Si DOWN -> :1
            BEQ :1
            LDA BOARD_HI_X,Y        ; On ajoute les coord translatées
            STA ]1                  ; de la position du bloc
            LDA BOARD_HI_Y,Y
            STA ]1+1
            JMP :2
:1          LDA BOARD_LO_X,Y        ; On ajoute les coord translatées
            STA ]1                  ; de la position du bloc
            LDA BOARD_LO_Y,Y
            STA ]1+1
:2
*           LDX ]1
*           LDY ]1+1
*           BRK
            .EM
*--------------------------------------
            .MA PLOT
            LDA CLOM,Y 			; Lookup low byte of MAIN memory colour table
            STA ORMAIN+1        ; Update the ORA instruction
            LDA CHIM,Y 			; Lookup high byte of MAIN memory colour table
            STA ORMAIN+2 		; Update the ORA instruction
            LDA CLOA,Y 			; Lookup low byte of AUX memory colour table
            STA ORAUX+1	 		; Update the ORA instruction
            LDA CHIA,Y 			; Lookup high byte of AUX memory colour table
            STA ORAUX+2 		; Update the ORA instruction
            JSR D2PLOT          ; Affiche point Haut
            LDA DBL_DRAW        ; Si DBL_DRAW = 0 -> :1
            BEQ :1
            LDA SCRN_HI
            PHA
            CLC
            ADC #$20
            STA SCRN_HI
            JSR D2PLOT
            PLA
            STA SCRN_HI
:1
            .EM
*--------------------------------------
BLOCDRAW    LDY #$C3            ; Y va aller de $C3 -> $00
.3          >FINDY CPTY

            LDX #$0D
            STX CPTX            ; CPTX de $0D -> $00

.2          LDA XPOS
            CLC
            ADC CPTX
            TAX
            LDA (PTR),Y
            PHY                 ; Y dans la pile

            PHA
            AND #$0F            ; Couleur du pixel bas
            TAY
            EOR #$0E            ; Transparence ?
            BEQ .5
            >PLOT

.5          DEX
            DEC CPTX

            PLA
            AND #$F0
            LSR
            LSR
            LSR
            LSR
            TAY
            EOR #$0E            ; Transparence ?
            BEQ .6
            >PLOT

.6          PLY
            BEQ .7              
            DEY
            DEC CPTX

            BMI .1              ; peut etre BMI
            JMP .2
.1          DEC CPTY
            JMP .3

.7          ; >RETURN
BLOCDRAWEND RTS
*--------------------------------------
            .MA DRAW_BLOC
            LDA ]1
            STA XPOS
            LDA ]1+1
            STA CPTY
            LDA ]1+2
            STA PTR
            LDA ]1+3
            STA PTR+1
            JSR BLOCDRAW
            .EM
*--------------------------------------
            .MA COMPUTE_MOVE
            LDA ]2
            BEQ :3
            BMI :1
            ; Vitesse positive
            AND #$0F
            CLC
            ADC ]1
            CMP ]3          ; Comparaison avec le point d'arrive
            BCC :2          ; Pas encore arrivé
            LDX #$00
            STX ]2          ; vitesse à zero
            STX ]3          ; arrivée à zero
            JMP :2
            ; Vitesse négative
:1          LDA ]1          ; CoordX actuelle dans A
            TAX             ; CoordX actuelle dans X
            LDA ]2          ; Increment dans A
            AND #$0F        ; ABS(A)
            STA ]1          ; increment positif dans CoordX
            TXA             ; CoordX actuelle dans A
            SEC
            SBC ]1          ; CoordX actuelle - increment positif
            CMP ]3          ; Comparaison avec le point d'arrive
            BEQ :4          ; On est arrive
            BCS :2          ; pas encore arrivé
:4          LDX #$00
            STX ]2          ; vitesse à zero
            STX ]3          ; arrivée à zero
:2          STA ]1          ; Resultat de A vers CoordX actuelle
:3
            .EM
*--------------------------------------
            .MA MOVE_SPRITE

            LDA ]1          ; Test si ancienne position
            EOR ]1+8        ; egale position actuelle
            BNE :4          
            LDA ]1+1
            EOR ]1+9
            BEQ :3          ; si oui, on fait rien

:4          LDA ]1+2        ; SpriteSheet dans PTR
            STA PTR         ; ""
            LDA ]1+3        ; ""
            STA PTR+1       ; SpriteSheet dans PTR

            LDA ]1+8        ; Params pour ancienne position
            STA XPOS        ; ""
            LDA ]1+9        ; ""
            STA CPTY        ; Params pour ancienne position

*            JSR SPRITEDEL

            LDA ]1          ; CoordX
            STA ]1+8        ; dans Ancienne PosX
            LDA ]1+1        ; CoordY
            STA ]1+9        ; dans Ancienne PosY

            JMP :2
:3          JMP :1

:2          >COMPUTE_MOVE ]1,]1+4,]1+6
            >COMPUTE_MOVE ]1+1,]1+5,]1+7

            LDA #$00
            STA DBL_DRAW
            LDA ]1          ; Params pour nouvelle pos
            STA XPOS        ; ""
            LDA ]1+1        ; ""
            STA CPTY        ; Params pour nouvelle pos
            JSR BLOCDRAW
:1
            .EM
*--------------------------------------
            .MA DRAW_SCENE  ; ScenePtr, Board_X, Board_Y
            LDY #$00        ; Lecture de la scene de 0 -> 100
:1          LDA ]1,Y
            BEQ :2          ; Pas de bloc - on passe au suivant
            
            TAX             ; On charge la ref du picto
            LDA PICTO_LO,X  ; dans le buffer du bloc
            STA BLOC+2
            LDA PICTO_HI,X
            STA BLOC+3

            LDA ]2,Y        ; On ajoute les coord translatées
            STA BLOC        ; de la position du bloc
            LDA ]3,Y
            STA BLOC+1

            PHY
            LDY #$01
            STY DBL_DRAW
            >DRAW_BLOC BLOC
            PLY

:2          INY
            TYA
            CMP #$64
            BNE :1
            .EM
*--------------------------------------
MAN
SAVE /DEV/SPACE/SRC/ENGINE.S
LOAD /DEV/SPACE/SRC/SPACE.S

ASM
