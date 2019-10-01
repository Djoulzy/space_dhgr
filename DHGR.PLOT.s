NEW
  
AUTO 4,1
            .OP	65C02
            .LIST OFF
*--------------------------------------
DBL_DRAW	.HS 00          ; Si = 01, on dessine sur les deux pages
*--------------------------------------
* Color number (00 - 15) dans Y
SETDCOLOR
*			TAY
			LDA CLOM,Y 			;Lookup low byte of MAIN memory colour table
			STA ORMAIN+1		;Update the ORA instruction
			LDA CHIM,Y 			;Lookup high byte of MAIN memory colour table
			STA ORMAIN+2 		;Update the ORA instruction
			LDA CLOA,Y 			;Lookup low byte of AUX memory colour table
			STA ORAUX+1	 		;Update the ORA instruction
			LDA CHIA,Y 			;Lookup high byte of AUX memory colour table
			STA ORAUX+2 		;Update the ORA instruction
			RTS
*--------------------------------------
* Y in Y
			.MA FINDY
			LDA HTAB_LO,Y		;Find the low byte of the row address
			STA SCRN_LO 
			LDA HTAB_HI,Y		;Find the high byte of the row address
			STA SCRN_HI
			.EM
*--------------------------------------
* X in X / Y in Y
PLOT
			LDA HTAB_LO,Y		;Find the low byte of the row address
			STA SCRN_LO 
			LDA HTAB_HI,Y		;Find the high byte of the row address
			STA SCRN_HI
PLOT_S		LDY MBOFFSET,X		;Find what byte if any in MAIN we are working in
			BMI AUX				;If pixel has no bits in MAIN memory - go to aux routine

			PHX
			PHA
			LDA XMOD7,X
			TAX
			PLA

;			STA PAGE2_OFF		;Map $2000 to MAIN memory
			LDA (SCRN_LO),Y		;Load screen data
			AND MAINAND,X		;Erase pixel bits
ORMAIN		ORA MAINGR,X		;Draw coloured bits
			STA (SCRN_LO),Y		;Write back to screen

			PLX
AUX			LDY ABOFFSET,X 		;Find what byte if any in AUX we are working in
			BMI PLOTEND			;If no part of the pixel is in AUX - end the program

			PHX
			PHA
			LDA XMOD7,X
			TAX
			PLA

			STA RAMRD_ON		;Map $2000 to AUX memory
			LDA (SCRN_LO),Y		;Load screen data
			STA RAMRD_OFF
			AND AUXAND,X		;Erase pixel bits
ORAUX		ORA AUXGR,X			;Draw coloured bits
			STA RAMWRT_ON
			STA (SCRN_LO),Y		;Write back to screen
			STA RAMWRT_OFF
			PLX
PLOTEND		RTS 
*--------------------------------------
MAN
SAVE /DEV/SPACE/SRC/DHGR.PLOT.S
LOAD /DEV/SPACE/SRC/SPACE.S

ASM
