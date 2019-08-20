NEW
  
AUTO 4,1
			.LIST OFF
            .OP	65C02
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
BLOC        STX BLOCBUFF
            TYA
            CLC
            ADC #$1C
            STA BLOCBUFF+1
            >GET_CANVAS

            LDA #$C4            ; Y va aller de $C4 -> $01 soit 196 octect
            STA CPTY            ; 1 octect représente 2 pixels -> 392 pixels au total

.3          LDY BLOCBUFF+1
            >FINDY
            LDA #$0C
            STA CPTX            ; CPTX de $0D -> $00

.2          LDA BLOCBUFF        ; CoordX
            CLC
            ADC CPTX            ; CoordX + CptX
            TAX                 ; X contient CoordX

.8          LDY CPTY
            DEY
            LDA (PTR),Y
            STA COLOR           ; Couleur des 2 pixels

            AND #$0F            ; Couleur du pixel bas
            TAY                 ; Sauvegarde avant test
            EOR #$0E            ; Transparence ?
            BEQ .5
*            TYA                 ; Recuperation couleur pixel bas
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
*            TYA
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
MAN
SAVE /DEV/SPACE/SRC/ENGINE.S
LOAD /DEV/SPACE/SRC/SPACE.S

ASM
