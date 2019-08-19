NEW
  
AUTO 4,1
            .OP	65C02
            .LIST OFF
*--------------------------------------
MAINAND		.DA #%01111111,#%01111110,#%01100001,#%00011111,#%01111111,#%01111000,#%00000111
MAINBL		.DA #%00000000,#%00000000,#%00000000,#%00000000,#%00000000,#%00000000,#%00000000
MAINMG		.DA #%00000000,#%00000001,#%00010000,#%00000000,#%00000000,#%00000100,#%01000000
MAINBR		.DA #%00000000,#%00000000,#%00001000,#%00000000,#%00000000,#%00000010,#%00100000
MAINOR		.DA #%00000000,#%00000001,#%00011000,#%00000000,#%00000000,#%00000110,#%01100000
MAINDG		.DA #%00000000,#%00000000,#%00000100,#%01000000,#%00000000,#%00000001,#%00010000
MAING1		.DA #%00000000,#%00000001,#%00010100,#%01000000,#%00000000,#%00000101,#%01010000
MAINGR		.DA #%00000000,#%00000000,#%00001100,#%01000000,#%00000000,#%00000011,#%00110000
MAINYE		.DA #%00000000,#%00000001,#%00011100,#%01000000,#%00000000,#%00000111,#%01110000
MAINDB		.DA #%00000000,#%00000000,#%00000010,#%00100000,#%00000000,#%00000000,#%00001000
MAINVI		.DA #%00000000,#%00000001,#%00010010,#%00100000,#%00000000,#%00000100,#%01001000
MAING2		.DA #%00000000,#%00000000,#%00001010,#%00100000,#%00000000,#%00000010,#%00101000
MAINPI		.DA #%00000000,#%00000001,#%00011010,#%00100000,#%00000000,#%00000110,#%01101000
MAINMB		.DA #%00000000,#%00000000,#%00000110,#%01100000,#%00000000,#%00000001,#%00011000
MAINLB		.DA #%00000000,#%00000001,#%00010110,#%01100000,#%00000000,#%00000101,#%01011000
MAINAQ		.DA #%00000000,#%00000000,#%00001110,#%01100000,#%00000000,#%00000011,#%00111000
MAINWI		.DA #%00000000,#%00000001,#%00011110,#%01100000,#%00000000,#%00000111,#%01111000

AUXAND		.DA #%01110000,#%00001111,#%01111111,#%01111100,#%01000011,#%00111111,#%01111111
AUXBL		.DA #%00000000,#%00000000,#%00000000,#%00000000,#%00000000,#%00000000,#%00000000
AUXMG		.DA #%00001000,#%00000000,#%00000000,#%00000010,#%00100000,#%00000000,#%00000000
AUXBR		.DA #%00000100,#%01000000,#%00000000,#%00000001,#%00010000,#%00000000,#%00000000
AUXOR		.DA #%00001100,#%01000000,#%00000000,#%00000011,#%00110000,#%00000000,#%00000000
AUXDG		.DA #%00000010,#%00100000,#%00000000,#%00000000,#%00001000,#%00000000,#%00000000
AUXG1		.DA #%00001010,#%00100000,#%00000000,#%00000010,#%00101000,#%00000000,#%00000000
AUXGR		.DA #%00000110,#%01100000,#%00000000,#%00000001,#%00011000,#%00000000,#%00000000
AUXYE		.DA #%00001110,#%01100000,#%00000000,#%00000011,#%00111000,#%00000000,#%00000000
AUXDB		.DA #%00000001,#%00010000,#%00000000,#%00000000,#%00000100,#%01000000,#%00000000
AUXVI		.DA #%00001001,#%00010000,#%00000000,#%00000010,#%00100100,#%01000000,#%00000000
AUXG2		.DA #%00000101,#%01010000,#%00000000,#%00000001,#%00010100,#%01000000,#%00000000
AUXPI		.DA #%00001101,#%01010000,#%00000000,#%00000011,#%00110100,#%01000000,#%00000000
AUXMB		.DA #%00000011,#%00110000,#%00000000,#%00000000,#%00001100,#%01000000,#%00000000
AUXLB		.DA #%00001011,#%00110000,#%00000000,#%00000010,#%00101100,#%01000000,#%00000000
AUXAQ		.DA #%00000111,#%01110000,#%00000000,#%00000001,#%00011100,#%01000000,#%00000000
AUXWI		.DA #%00001111,#%01110000,#%00000000,#%00000011,#%00111100,#%01000000,#%00000000

CLOM		.DA #MAINBL,#MAINMG,#MAINBR,#MAINOR,#MAINDG
			.DA #MAING1,#MAINGR,#MAINYE,#MAINDB,#MAINVI
			.DA #MAING2,#MAINPI,#MAINMB,#MAINLB,#MAINAQ,#MAINWI

CHIM		.DA /MAINBL,/MAINMG,/MAINBR,/MAINOR,/MAINDG,/MAING1
			.DA /MAINGR,/MAINYE,/MAINDB,/MAINVI,/MAING2,/MAINPI
			.DA /MAINMB,/MAINLB,/MAINAQ,/MAINWI

CLOA		.DA #AUXBL,#AUXMG,#AUXBR,#AUXOR,#AUXDG
			.DA #AUXG1,#AUXGR,#AUXYE,#AUXDB,#AUXVI
			.DA #AUXG2,#AUXPI,#AUXMB,#AUXLB,#AUXAQ,#AUXWI

CHIA		.DA /AUXBL,/AUXMG,/AUXBR,/AUXOR,/AUXDG,/AUXG1
			.DA /AUXGR,/AUXYE,/AUXDB,/AUXVI,/AUXG2,/AUXPI
			.DA /AUXMB,/AUXLB,/AUXAQ,/AUXWI
*--------------------------------------
MAN
SAVE /DEV/SPACE/SRC/DHGR.TABLES.S
LOAD /DEV/SPACE/SRC/SPACE.S

ASM
