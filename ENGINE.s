NEW
  
AUTO 4,1
			.LIST OFF
            .OP	65C02
*            .OR 6000
*--------------------------------------
UP          .EQ 01
DOWN        .EQ 00
*--------------------------------------
BLOCBUFF    .HS 00,00       ; Pos X,Y
            .HS 00,00       ; Orientation, Vitesse

TIME10      .HS 00,0A,14,1E,28,32,3C,46,50,5A
*--------------------------------------
            .MA GET_CANVAS
            PLA
            INC                 ; low byte of name address
            STA PTR
            PLA                 ; high byte of name address
            STA PTR+1

            LDA (PTR)
            TAX
            LDY #$01
            LDA (PTR),Y
            TAY

            LDA #$01
            CLC
            ADC PTR
            STA PTR
            BCC :1
            LDA #$00
            CLC
            ADC PTR+1
            STA PTR+1

:1          LDA PTR+1
            PHA
            LDA PTR
            PHA

            STX PTR
            STY PTR+1
            .EM
*--------------------------------------
BLOC        TXA
            CLC
            ADC #$0D
            STA BLOCBUFF

            TYA
            CLC
            ADC #$1B
            STA BLOCBUFF+1      ; Valeur de Y + 27 (derniere ligne du bloc)
            >GET_CANVAS

            LDA #$C4            ; Y va aller de $C4 -> $01 soit 196 octect
            STA CPTY            ; 1 octect représente 2 pixels -> 392 pixels au total

.3          LDY BLOCBUFF+1
            >FINDY
            LDA #$0D
            STA CPTX            ; CPTX de $0E -> $01

            LDX BLOCBUFF        ; CoordX

.8          LDY CPTY
            DEY
            LDA (PTR),Y
            STA COLOR           ; Couleur des 2 pixels

            AND #$0F            ; Couleur du pixel bas
            TAY                 ; Sauvegarde avant test
            EOR #$0E            ; Transparence ?
            BEQ .5
            JSR SETDCOLOR
            JSR PLOT_S

.5          DEX                 ; On passe au pixel haut (x-1)
            DEC CPTX

            LDA COLOR           ; Couleur des 2 pixel dans la pile
            LSR
            LSR
            LSR
            LSR                 ; Couleur du pixel bas
            TAY
            EOR #$0E            ; Transparence ?
            BEQ .6
            JSR SETDCOLOR
            JSR PLOT_S

.6          DEC CPTX
            BMI .1              ; On est arrivé en fin de ligne
            DEX
            DEC CPTY
            JMP .8              ; On continue sur la même ligne

.1          DEC CPTY
            BEQ .7              ; On est arrivé à la fin du bloc
            DEC BLOCBUFF+1      ; On attaque une nouvelle ligne
            JMP .3

.7          ; >RETURN
            RTS
*--------------------------------------
            .MA SETUP_BUFF ; Buff_Addr, Addr_Dest
            LDX #$01
            LDA #]1
            STA ]2
            LDA /]1
            STA ]2,X
            INX
            CLC
            LDA #]1
            ADC #$8C
            STA ]2,X
            INX
            LDA /]1
            ADC #$00
            STA ]2,X
            .EM
*--------------------------------------
COPY        
            PHY
            PHX

            STY BLOCBUFF+1

            LDA MBOFFSET,X
            BPL .1
            LDA ABOFFSET,X
.1          STA BLOCBUFF
            LDA #$00            ; Debut boucle generale de 140 ($8C) -> 0
            STA CPTY

.2          LDY BLOCBUFF+1
            >FINDY
            LDA #$05            ; Debut Boucle sur CoordX de 04 -> 1
            STA CPTX
            LDY BLOCBUFF

.3          
            STA PAGE2_ON
            LDA (SCRN_LO),Y

            PHY
            LDY CPTY
            STA (SAVE_AUX),Y
            PLY

            STA PAGE2_OFF
            LDA (SCRN_LO),Y
            
            PHY
            LDY CPTY
            STA (SAVE_MAIN),Y
            PLY

            INC CPTY
            LDA #$8C
            CMP CPTY
            BEQ .4              ; Fin de la zone à copier

            INY
            DEC CPTX
            BNE .3
            INC BLOCBUFF+1      ; On passe à la ligne du dessus
            JMP .2

.4          
            PLX
            PLY
            RTS
*--------------------------------------
PASTE       PHY
            PHX

            STY BLOCBUFF+1

            LDA MBOFFSET,X
            BPL .1
            LDA ABOFFSET,X

.1          STA BLOCBUFF
            LDA #$00            ; Debut boucle generale de 224 ($E0) -> 0
            STA CPTY

.2          LDY BLOCBUFF+1
            >FINDY
            LDA #$05            ; Debut Boucle sur CoordX de 04 -> 1
            STA CPTX
            LDY BLOCBUFF

.3
            STA PAGE2_ON
            PHY
            LDY CPTY
            LDA (SAVE_AUX),Y
            PLY
            STA (SCRN_LO),Y

            STA PAGE2_OFF
            PHY
            LDY CPTY
            LDA (SAVE_MAIN),Y
            PLY
            STA (SCRN_LO),Y

            INC CPTY
            LDA #$8C
            CMP CPTY
            BEQ .4              ; Fin de la zone à copier

            INY
            DEC CPTX
            BNE .3
            INC BLOCBUFF+1      ; On passe à la ligne du dessus
            JMP .2

.4          PLX
            PLY
            RTS
*--------------------------------------
MAN
SAVE /DEV/SPACE/SRC/ENGINE.S
LOAD /DEV/SPACE/SRC/SPACE.S

ASM
