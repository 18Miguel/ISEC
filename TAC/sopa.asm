.8086
.model small
.stack 2048
dseg    segment para public 'data'
	Erro_Open			db		'Erro ao tentar abrir o ficheiro$'
	Erro_Ler_Msg		db		'Erro ao tentar ler do ficheiro$'
	Erro_Close			db		'Erro ao tentar fechar o ficheiro$'
	Fich1				db		'LLow.TXT',0
	Fich2				db		'LNormal.TXT',0
	Fich3				db   	'LHigh.TXT',0
	HandleFich			dw		0
	car_fich			db		?

	Car					db		32	; Guarda um caracter do Ecran 
	Cor					db		7	; Guarda os atributos de cor do caracter
	POSy				db		8	; Linha do AVATAR
	POSx				db		38	; Coluna do AVATAR
	BackgroundColor		db		09h ; Cor de fundo ; [ ((0-1) / (0-7)) || (0-F) ] HEX

	LVL					db		0	; Nível de jogo [1,2,3]
	Encontradas			db		0	; Palavras encontrdas
	Tentativas			dw		0	; Numero de tentativas

	CurrentSeconds		db		0	; Vai guardar os segundos actuais
	PreviousSeconds		db		0	; Guarda os últimos segundos que foram lidos  
	Timeout				db		151	; Tempo maximo para jogar e ganhar o jogo
	SwitchTimeONOFF		db		0	;Liga e desliga timer 0-OFF  1-ON

	NameTitle			db		" ___                      _       _        _%",
								"/ __| ___ _ __  __ _   __| |___  | |   ___| |_ _ _ __ _ ___%",
								"\__ \/ _ \ '_ \/ _` | / _` / -_) | |__/ -_)  _| '_/ _` (_-<%",
								"|___/\___/ .__/\__,_| \__,_\___| |____\___|\__|_| \__,_/__/%",
								"         |_|$"
	MainMenu			db		'MainMenu.txt',0
	LevelMenu			db		'LVLMenu.txt',0
	KeysMenu			db    	'KeysMenu.txt',0
	TopMenu				db    	'TopMenu.txt',0
	AboutMenu			db    	'AbtMenu.txt',0
	WordsMenu			db    	'WordMenu.txt',0
	NewWord				db    	'NewWord.txt',0
	IndexMenu			db		1
	IndexMenuLimit		db		?

	; String para onde irão ser copiadas as palavras a encontrar consoante o LVL do jogo
	Words				db		150 dup(?)			; 'ABC%ABC%$'
	; Ficheiros das palavras
	WordsLow			db		'WLow.txt',0
	WordsNormal			db    	'WNormal.txt',0
	WordsHigh			db    	'WHigh.txt',0
	
	wordPlaceholder		db		15
	wordFoundIndex		db		12 dup(0)	; Índice da palavra encontrada		;EX: 'ABC%ABC%$' 1, 2
	PosWordsX			db		?
	PosWordsY			db		?

	; TOP 10
	Top10File			db		'Top10.TXT',0
	Top10				db		130 dup(?),"$"
	IndexTop10			db		0
	LINE_FEED			db 		10
	CARDINAL			db 		35
	GetNameTop10		db 		'InTop10.txt',0
    PlayerName      	db 		12 dup(?)
    PlayerScore			sbyte	0	; Score do jogador
    PlayerScoreCHAR 	db 		3 dup(?)

	; Vectores para guardar posições dos caracteres selecionados
	VectorPosX			db		30 dup(?)
	VectorPosY			db		30 dup(?)
	; String com os carateres da palavra selecionados pelo jogador
	PlayerWord			db		30 dup(?)
	PlayerWordSize		db		0
	CheckWordsFlag		db		0	; Varia entre 0 e 1
	; Indices para as seleções das palavras ;VERSÃO EXTRA
	FirstPosX			db		0
	FirstPosY			db		0
	LastPosX			db		0
	LastPosY			db		0


	letra			db 		'ABCDEFGHIJKLMNOPQRSTUVWXYZ',0
	tabelanormal	db		450 dup(1),0
	ultimo_num_aleat dw		0
	str_num 		db 		5 dup(?),'$'
	
	;Diraçao e coordenadas aleatorias 
	POSyPalavra		db		3	
	POSxPalavra		db		3
	palavrapos		db		'palavraaposicionar$'
	direcao			db		0
	palavra_size	db		0h
	POSxinicial		db   	28
	POSyfinal		db   	14
	;Adicionar e Remover Palavras -Extra
	NewLine			db		13,10
	CountWords  	db		0 
dseg    ends


cseg    segment para public 'code'
	assume  cs:cseg, ds:dseg

;########################################################################
GOTO_XY	MACRO	POSx, POSy
	MOV		ah, 02h
	MOV		bh, 0		; numero da página
	MOV		dl, POSx
	MOV		dh, POSy
	INT		10h
ENDM

;########################################################################
;ROTINA PARA APAGAR ECRAN
APAGA_ECRAN	proc
		xor		bx, bx
		mov		cx, 25*80
		
APAGA:	
	mov		byte ptr es:[bx],' '
	mov		byte ptr es:[bx+1],7
	inc		bx
	inc 	bx
	loop	APAGA
	ret
APAGA_ECRAN	endp
;########################################################################

;########################################################################
; LE UMA TECLA
LE_TECLA	PROC
	CMP		LVL, 0
	JNE		LE_TECLA_JOGO
	MOV		AH, 0Bh
	INT 	21h
	CMP 	AL, 0
	JE		LE_TECLA
	JMP		VERIFICA_TECLA
LE_TECLA_JOGO:
	CMP		PlayerScore, 0
	JNE		SAI_TECLA
	CMP		SwitchTimeONOFF, 0
	JE		LE_TECLA_JOGO_S_TIMER
	CALL	TIMER
	MOV		AH, 0Bh
	INT 	21h
	CMP 	AL, 0
	JE		LE_TECLA_JOGO
	JMP		VERIFICA_TECLA
LE_TECLA_JOGO_S_TIMER:
	MOV		AH, 0Bh
	INT 	21h
	CMP 	AL, 0
	JE		LE_TECLA_JOGO
	JMP		VERIFICA_TECLA
VERIFICA_TECLA:
	mov		ah,08h
	int		21h
	mov		ah,0
	cmp		al,0
	jne		SAI_TECLA
	mov		ah, 08h
	int		21h
	mov		ah,1
SAI_TECLA:	RET
LE_TECLA	endp
;########################################################################

;######################################################################## ;MIGUEL
; Lê menus em ficheiros txt e imprimi-os no ecra
; Paramentros [File] - Mover para DX o endereço -> LEA     DX, FILE
READ_PRINT_FILE_MENU PROC
	PUSH	DX
	;MOV		POSx, 14
	;MOV		POSy, 8
	GOTO_XY POSx, POSy
	POP		DX
	;LEA     DX, FILE
	JMP     OPEN_FILE
OPEN_FILE:
	MOV     AH, 3Dh
	MOV     AL, 0
	INT     21h
	JC      OPEN_ERROR
	MOV     HandleFich, AX
	JMP     READ_PRINT_CHAR
OPEN_ERROR:
	MOV     AH, 09h
	LEA     DX, Erro_Open
	INT     21h
	JMP     READ_PRINT_FILE_MENU_EXIT
READ_PRINT_CHAR:
	MOV     AH, 3Fh
	MOV     BX, HandleFich
	MOV     CX, 1
	LEA     DX, car_fich
	INT     21h
	JC	ERRO_LER
	CMP	AX, 0		;EOF?
	JE	CLOSE_FILE
	MOV	DL, car_fich
	
	CMP     DL, 10
	JE      JMP_LINE
	CMP     DL, 13
	JE      READ_PRINT_CHAR
	MOV     AH, 02h
	INT     21h
	JMP	READ_PRINT_CHAR
JMP_LINE:
	INC     POSy
	GOTO_XY POSx, POSy
	JMP     READ_PRINT_CHAR
ERRO_LER:
	MOV     AH, 09h
	LEA     DX, Erro_Ler_Msg
	INT     21h
CLOSE_FILE:
	MOV     AH, 3Eh
	MOV     BX, HandleFich
	INT     21h
	JNC     READ_PRINT_FILE_MENU_EXIT
	MOV     AH, 09h
	LEA     DX, Erro_Close
	INT     21h
	RET
READ_PRINT_FILE_MENU_EXIT:
	MOV	POSx, 3
	MOV	POSy, 3
	RET
READ_PRINT_FILE_MENU endp
;########################################################################

;######################################################################## ;MIGUEL
DISPLAY_MENU PROC
	MOV		BL, 1
	GOTO_XY	10, BL
	XOR		SI, SI
	JMP		PRINT_TITLE
JMP_LINE_TITLE:
	INC		BL
	GOTO_XY 10, BL
	INC		SI
	JMP		PRINT_TITLE
PRINT_TITLE:
	MOV		DL, NameTitle[SI]
	MOV 	AH, 02h
	INT		21h
	INC		SI
	CMP		NameTitle[SI], '%'
	JE		JMP_LINE_TITLE
	CMP		NameTitle[SI], '$'
	JNE		PRINT_TITLE
	LEA		DX, MainMenu
	MOV		POSx, 14
	MOV		POSy, 8
	CALL	READ_PRINT_FILE_MENU
	CALL	MAIN_MENU_NAVIGATION
	RET
DISPLAY_MENU endp
;########################################################################

;######################################################################## ;MIGUEL
; Navegação do menu principal
MAIN_MENU_NAVIGATION PROC
	MOV		IndexMenu, 1
	MOV		IndexMenuLimit, 5
	MOV		POSx, 17
	MOV		POSy, 11
	MOV		Cor, 30h
	CALL	PAINT_CURRENT_SELECTION
	JMP		READ_ARROW

READ_ARROW:
	CALL 	LE_TECLA
	CMP		AH, 1
	JE		ARROWS
	CMP		AL, 13 		; ENTER
	JE		OPTION_SELECTED
	JMP		READ_ARROW

ARROWS:
	CALL	ARROW_NAV
	JMP		READ_ARROW

OPTION_SELECTED:
	CMP		IndexMenu, 1	; JOGAR
	JE		OPEN_LEVEL_MENU
	CMP		IndexMenu, 2	; TECLAS
	JE		OPEN_KEYS_MENU
	CMP		IndexMenu, 3	; TOP 10
	JE		OPEN_TOP10
	CMP		IndexMenu, 4	; SOBRE
	JE		OPEN_ABOUT_MENU
	CMP		IndexMenu, 5	; Sair
	JE		END_PROGRAM
OPEN_LEVEL_MENU:
	MOV		SwitchTimeONOFF, 0
	LEA		DX, LevelMenu
	MOV		POSx, 14
	MOV		POSy, 8
	CALL	READ_PRINT_FILE_MENU
	CALL	LEVEL_MENU_NAVIGATION
	
	MOV		DL, BackgroundColor
	MOV		Cor, DL
	XOR		DX, DX
	CALL	PAINT_CURRENT_SELECTION
	CMP		LVL, 0
	JNE		WORDS_MENU
	LEA		DX, MainMenu
	MOV		POSx, 14
	MOV		POSy, 8
	CALL	READ_PRINT_FILE_MENU
	JMP		MAIN_MENU_NAVIGATION

WORDS_MENU:	
	XOR		DX,DX
	LEA		DX, WordsMenu
	MOV		POSx, 14
	MOV		POSy, 8
	CALL	READ_PRINT_FILE_MENU
	CAll 	IMPRIME_PALAVRAS_ALT
	CALL	ALT_PALAVRAS_MENU_NAVIGATION

	CMP		IndexMenu,3		;verifica se é para 'continuar'
	JB		WORDS_MENU

	;CALL 	APAGA_ECRAN
	;CALL	PAINT_SCREEN
	MOV		DL, BackgroundColor
	MOV		Cor, DL
	XOR		DX, DX
	CALL	PAINT_CURRENT_SELECTION
	CMP		LVL, 0
	JNE		MAIN_MENU_NAVIGATION_EXIT

	LEA		DX, MainMenu
	MOV		POSx, 14
	MOV		POSy, 8
	CALL	READ_PRINT_FILE_MENU
	JMP		MAIN_MENU_NAVIGATION

OPEN_KEYS_MENU:
	MOV		DL, BackgroundColor
	MOV		Cor, DL
	XOR		DX, DX
	CALL	PAINT_CURRENT_SELECTION
	LEA		DX, KeysMenu
	MOV		POSx, 14
	MOV		POSy, 8
	CALL	READ_PRINT_FILE_MENU
	CALL	KEYS_AND_ABOUT_MENU_NAVIGATION

	LEA		DX, MainMenu
	MOV		POSx, 14
	MOV		POSy, 8
	CALL	READ_PRINT_FILE_MENU
	JMP		MAIN_MENU_NAVIGATION

OPEN_TOP10:
	MOV		DL, BackgroundColor
	MOV		Cor, DL
	XOR		DX, DX
	CALL	PAINT_CURRENT_SELECTION
	CALL	APAGA_ECRAN
	CALL	PAINT_SCREEN
	LEA		DX, TopMenu
	MOV		POSx, 21
	MOV		POSy, 8
	CALL	READ_PRINT_FILE_MENU
	CALL	TOP_MENU_NAVIGATION

	LEA		DX, MainMenu
	MOV		POSx, 14
	MOV		POSy, 8
	CALL	READ_PRINT_FILE_MENU
	JMP		MAIN_MENU_NAVIGATION

OPEN_ABOUT_MENU:
	MOV		DL, BackgroundColor
	MOV		Cor, DL
	XOR		DX, DX
	CALL	PAINT_CURRENT_SELECTION
	LEA		DX, AboutMenu
	MOV		POSx, 14
	MOV		POSy, 8
	CALL	READ_PRINT_FILE_MENU
	CALL	KEYS_AND_ABOUT_MENU_NAVIGATION

	LEA		DX, MainMenu
	MOV		POSx, 14
	MOV		POSy, 8
	CALL	READ_PRINT_FILE_MENU
	JMP		MAIN_MENU_NAVIGATION

MAIN_MENU_NAVIGATION_EXIT:
	CALL 	APAGA_ECRAN
	CALL	PAINT_SCREEN
	MOV		POSx, 38
	MOV		POSy, 7
	MOV		SwitchTimeONOFF, 1
	RET
END_PROGRAM:
	GOTO_XY 0, 22
	MOV     AH, 4Ch
	INT     21h
MAIN_MENU_NAVIGATION endp
;########################################################################

;######################################################################## ;MIGUEL
; Navegação das setas cima e baixo nos menus
; Paramentros [IndexMenuLimit] - Defenir limite maximo do IndexMenu
ARROW_NAV PROC
	CMP 	AL, 48h
	JNE		DOWN

	MOV		DL, BackgroundColor
	MOV		Cor, DL
	XOR		DX, DX
	CALL	PAINT_CURRENT_SELECTION	; Repinta seleção com cor original
	DEC		POSy		; Cima
	DEC		IndexMenu
	CMP		IndexMenu, 1
	JB		UNDO_UP
	MOV		Cor, 30h
	CALL	PAINT_CURRENT_SELECTION
	JMP		ARROW_NAV_EXIT
UNDO_UP:
	INC		POSy		; Baixo
	INC		IndexMenu
	MOV		Cor, 30h
	CALL	PAINT_CURRENT_SELECTION
	JMP		ARROW_NAV_EXIT

DOWN:
	CMP		AL, 50h
	JNE		ARROW_NAV_EXIT

	MOV		DL, BackgroundColor
	MOV		Cor, DL
	XOR		DX, DX
	CALL	PAINT_CURRENT_SELECTION	; Repinta seleção com cor original
	INC 	POSy		; Baixo
	INC		IndexMenu
	MOV		AL, IndexMenuLimit
	CMP		IndexMenu, AL
	JA		UNDO_DOWN
	MOV		Cor, 30h
	CALL	PAINT_CURRENT_SELECTION
	JMP		ARROW_NAV_EXIT
UNDO_DOWN:
	DEC		POSy		; Cima
	DEC		IndexMenu
	MOV		Cor, 30h
	CALL	PAINT_CURRENT_SELECTION
	JMP		ARROW_NAV_EXIT

ARROW_NAV_EXIT: RET
ARROW_NAV endp
;########################################################################

;######################################################################## ;MIGUEL
; Navegação do menu de dificuldade/nível do jogo
LEVEL_MENU_NAVIGATION PROC
	MOV		IndexMenu, 1
	MOV		IndexMenuLimit, 4
	MOV		POSx, 17
	MOV		POSy, 11
	MOV		Cor, 30h
	CALL	PAINT_CURRENT_SELECTION
	JMP		LER_SETA
LER_SETA:
	CALL 	LE_TECLA
	CMP		AH, 1
	JE		ARROWS
	
	CMP		AL, 13 		; ENTER
	JE		OPTION_SELECTED
	
	JMP		LER_SETA

ARROWS:
	CALL	ARROW_NAV
	JMP		LER_SETA

OPTION_SELECTED:
	CMP		IndexMenu, 1	; LVL Básico
	JE		LVL_BASICO
	CMP		IndexMenu, 2	; LVL Intermédio
	JE		LVL_INTERMEDIO
	CMP		IndexMenu, 3	; LVL Avançado
	JE		LVL_AVANCADO
	CMP		IndexMenu, 4	; Voltar
	JE		BACK_TO_MAIN_MENU

LVL_BASICO:
	MOV		LVL, 1
	JMP		LEVEL_MENU_NAVIGATION_EXIT
LVL_INTERMEDIO:
	MOV		LVL, 2
	JMP		LEVEL_MENU_NAVIGATION_EXIT
LVL_AVANCADO:
	MOV		LVL, 3
	JMP		LEVEL_MENU_NAVIGATION_EXIT
LEVEL_MENU_NAVIGATION_EXIT:
	RET

BACK_TO_MAIN_MENU:
	MOV		DL, BackgroundColor
	MOV		Cor, DL
	XOR		DX, DX
	CALL	PAINT_CURRENT_SELECTION
	RET

LEVEL_MENU_NAVIGATION endp
;########################################################################

;######################################################################## ;MIGUEL
; Navegação do menu de TECLAS & SOBRE do jogo
KEYS_AND_ABOUT_MENU_NAVIGATION PROC
	MOV		POSx, 17
	MOV		POSy, 19
	MOV		Cor, 30h
	CALL	PAINT_CURRENT_SELECTION
READ_KEY:
	CALL 	LE_TECLA	
	CMP		AL, 13 		; ENTER
	JE		KEYS_AND_ABOUT_MENU_NAVIGATION_EXIT
	JMP		READ_KEY
KEYS_AND_ABOUT_MENU_NAVIGATION_EXIT:
	MOV		DL, BackgroundColor
	MOV		Cor, DL
	XOR		DX, DX
	CALL	PAINT_CURRENT_SELECTION
	RET
KEYS_AND_ABOUT_MENU_NAVIGATION endp
;########################################################################

;######################################################################## ;MIGUEL
; Navegação do menu Top 10
TOP_MENU_NAVIGATION PROC
	CALL	PRINT_TOP10_PLAYERS
	MOV		POSx, 24
	MOV		POSy, 22
	MOV		Cor, 30h
	MOV		wordPlaceholder, 32
	JMP		SET_LINE_TITLE
CURRENT_SELECTION:
	GOTO_XY	POSx, POSy	; Vai para nova posição
	MOV 	AH, 08h
	MOV		BH, 0		; Numero da página
	INT		10h			; [AL] Guarda o Caracter que está na posição do Cursor; [AH] Guarda a cor que está na posição do Cursor
	INC		POSx
	DEC		wordPlaceholder
	XOR		BX, BX
	MOV     AH, 09h
	MOV     BL, Cor		; Black Text, Cyan Background
	MOV     CX, 1		; Print one char
	INT     10h
	CMP		wordPlaceholder, 0
	JA		CURRENT_SELECTION
	JMP		READ_KEY
READ_KEY:
	CALL 	LE_TECLA	
	CMP		AL, 13 		; ENTER
	JE		TOP_MENU_NAVIGATION_EXIT
	JMP		READ_KEY

TOP_MENU_NAVIGATION_EXIT:
	CALL	APAGA_ECRAN
	CALL	PAINT_SCREEN
	JMP		SET_LINE_TITLE
SET_LINE_TITLE:
	MOV		BL, 1
	GOTO_XY	10, BL
	XOR		SI, SI
	JMP		PRINT_TITLE
JMP_LINE_TITLE:
	INC		BL
	GOTO_XY 10, BL
	INC		SI
	JMP		PRINT_TITLE
PRINT_TITLE:
	MOV		DL, NameTitle[SI]
	MOV 	AH, 02h
	INT		21h
	INC		SI
	CMP		NameTitle[SI], '%'
	JE		JMP_LINE_TITLE
	CMP		NameTitle[SI], '$'
	JNE		PRINT_TITLE
	CMP		POSx, 24
	JE		CURRENT_SELECTION
	MOV		POSx, 24
	RET
TOP_MENU_NAVIGATION ENDP
;########################################################################

;######################################################################## ;MIGUEL
PRINT_TOP10_PLAYERS PROC
	CALL	READ_FILE_TOP10
	XOR		SI, SI
	XOR		AX, AX
	XOR		BX, BX
	XOR		CX, CX
	XOR		DX, DX
	MOV		POSx, 47
	MOV		POSy, 12
	JMP		PRINT_POINTS
PRINT_POINTS:
	INC		SI
	CMP		Top10[SI], '$'
	JE		PRINT_TOP10_PLAYERS_EXIT
	CMP		Top10[SI], '#'
	JE		PRINT_POINTS
	GOTO_XY POSx, POSy
	MOV		DL, Top10[SI]
	MOV		AH, 02h
	INT		21h
	INC		POSx
	CMP		Top10[SI], 10
	JNE		PRINT_POINTS
	MOV		POSx, 31
	JMP		PRINT_NICKNAME

PRINT_NICKNAME:
	INC		SI
	CMP		Top10[SI], '$'
	JE		PRINT_TOP10_PLAYERS_EXIT
	CMP		Top10[SI], 10
	JE		JUMP_LINE
	GOTO_XY POSx, POSy
	MOV		DL, Top10[SI]
	MOV		AH, 02h
	INT		21h
	INC		POSx
	JMP		PRINT_NICKNAME
JUMP_LINE:
	MOV		POSx, 47
	INC		POSy
	JMP		PRINT_POINTS
PRINT_TOP10_PLAYERS_EXIT: RET
PRINT_TOP10_PLAYERS ENDP
;########################################################################

;######################################################################## ;MIGUEL
; Paramentros [Cor] - Mover os atributos para a variavel Cor 
PAINT_CURRENT_SELECTION PROC
	MOV		wordPlaceholder, 46
	JMP		CURRENT_SELECTION
CURRENT_SELECTION:
	GOTO_XY	POSx, POSy	; Vai para nova posição
	MOV 	AH, 08h
	MOV		BH, 0		; Numero da página
	INT		10h			; [AL] Guarda o Caracter que está na posição do Cursor; [AH] Guarda a cor que está na posição do Cursor
	INC		POSx
	DEC		wordPlaceholder
	XOR		BX, BX
	MOV     AH, 09h
	MOV     BL, Cor		; Black Text, Cyan Background
	MOV     CX, 1		; Print one char
	INT     10h
	CMP		wordPlaceholder, 0
	JA		CURRENT_SELECTION
	MOV		POSx, 17
	GOTO_XY	POSx, POSy
	RET
PAINT_CURRENT_SELECTION ENDP
;########################################################################

;######################################################################## ;MIGUEL
; LÊ NOVAMENTE O CARACTER NA POSICAO DO CURSOR
; Parametros [Px, Py] Px - Coluna & Py - Linha do caratere a ler 
LE_CAR MACRO Px, Py
	GOTO_XY	Px, Py	; Vai para nova posição
	MOV 	AH, 08h
	MOV		BH, 0		; numero da página
	INT		10h		
	MOV		Car, AL		; Guarda o Caracter que está na posição do Cursor
	MOV		Cor, AH		; Guarda a cor que está na posição do Cursor
ENDM
;########################################################################

;######################################################################## ;MIGUEL
; Verifica se a palavra selocionada pelo jogador correspode a uma palavra do array words
CHECK_WORDS PROC
	XOR		SI, SI
	XOR		DI, DI
	XOR		AX, AX
	XOR		BX, BX
	XOR		BP, BP
	CMP		PlayerWord[SI], '$'
	JE		EXIT_PLAYER_WORD_EMPTY
	MOV		CheckWordsFlag, 0
	MOV		AH, 02h
	JMP		CHECK_WORD

EXIT_PLAYER_WORD_EMPTY:
	RET

CHECK_WORD:
	MOV		BL, PlayerWord[SI]
	MOV		BH, Words[DI]
	CMP		BH, BL
	JNE		CHAR_NOT_EQUAL
	JMP		INC_SI_DI

INC_SI_DI:
	INC		SI
	INC		DI
	CMP		PlayerWord[SI], 24h	 ; $ 24h
	JE		LAST_WORD_CHAR
	JMP		CHECK_WORD

CHAR_NOT_EQUAL:
	XOR		SI, SI
	JMP		INC_DI_NEXT_WORD

WORDS_ENDS:
	CMP		Words[DI], 24h		; $ 24h
	JE		CHECK_WORDS_EXIT
	JMP		CHECK_WORD

LAST_WORD_CHAR:
	CMP		Words[DI], 25h		; % 25h
	JE		IF_WORD_WAS_ALREADY_FOUND
	JMP		CHAR_NOT_EQUAL

IF_WORD_WAS_ALREADY_FOUND:
	CMP		wordFoundIndex[BP], 1
	JNE		WORD_FOUND
	MOV		PlayerWord[0], '$'
	JMP		CHECK_WORDS_EXIT
WORD_FOUND:
	MOV		wordFoundIndex[BP], 1 ; If word 'OLA' found, then [Words = 'ABC%OLA%CBA%$'] ==> [wordFoundIndex = '0,1,0']
	CALL	PAINT_WORD
	JMP		PAINT_WORD_FOUND
PAINT_WORD_FOUND:
	GOTO_XY VectorPosX[SI], VectorPosY[SI]
	MOV 	AH, 08h	; Lê caracter
	MOV		BH, 0
	INT		10h		
	; Guarda o Caracter que está na posição do Cursor em AL
	MOV     AH, 09h
	XOR		BX, BX
	MOV     BL, 30h ; Black text, Cyan background
	MOV     CX, 1	; Print one char
	INT     10h
	INC		SI
	CMP		PlayerWordSize, 0
	DEC		PlayerWordSize
	JA		PAINT_WORD_FOUND
	MOV		PlayerWord[0], '$'
	CALL	CLEAR_PLAYERWORD_DISPLAY
	RET

INC_DI_NEXT_WORD:
	CMP		Words[DI], 25h		; % 25h
	JNE		INC_DI
	INC		DI					; Salta '%'
	INC		BP					; wordFoundIndex[BP]
	JMP		WORDS_ENDS

INC_DI:
	INC		DI
	JMP		INC_DI_NEXT_WORD

CHECK_WORDS_EXIT:
	MOV		CheckWordsFlag, 1	; Inverter PlayerWord e voltar a verificar
	RET
CHECK_WORDS ENDP
;########################################################################

;######################################################################## ;MIGUEL
READ_FILE_TOP10 PROC
  	MOV   Top10[0], '!'
	XOR   SI, SI
	LEA   DX, Top10File
;OPEN_FILE:
	MOV   AH, 3Dh
	MOV   AL, 0
	INT   21h
	JC    OPEN_ERROR
	MOV   HandleFich, AX
	JMP   READ_CHAR
OPEN_ERROR:
	MOV   AH, 09h
	LEA   DX, Erro_Open
	INT   21h
	JMP   READ_FILE_TOP10_EXIT
READ_CHAR:
	MOV   AH, 3Fh
	MOV   BX, HandleFich
	MOV   CX, 1
	LEA   DX, car_fich
	INT   21h
	JC    ERRO_LER
	CMP		AX, 0				;EOF?
	JE		CLOSE_STRING
	MOV		DL, car_fich
	CMP   DL, 10
	JE    NEXT_PLAYER
	CMP   DL, 13
	JE    READ_CHAR
	MOV   Top10[SI], DL
	INC   SI
	JMP		READ_CHAR
NEXT_PLAYER:
	MOV   Top10[SI], 10
	INC   SI
	JMP   READ_CHAR
CLOSE_STRING:
	;MOV   Top10[SI], '%'
	;INC   SI
	MOV   Top10[SI], '$'
	JMP   CLOSE_FILE
ERRO_LER:
	MOV   AH, 09h
	LEA   DX, Erro_Ler_Msg
	INT   21h
CLOSE_FILE:
	MOV   AH, 3Eh
	MOV   BX, HandleFich
	INT   21h
	JNC   READ_FILE_TOP10_EXIT
	MOV   AH, 09h
	LEA   DX, Erro_Close
	INT   21h
	RET
READ_FILE_TOP10_EXIT: RET
READ_FILE_TOP10 ENDP
;########################################################################

;######################################################################## ;MIGUEL
; Apenas chamar quando PlayerScore é positivo
; Verifica se [PlayerScore] entra no Top 10 e escreve os restantes scores
WRITE_TOP10_TO_FILE PROC
	XOR  AX, AX
    XOR  BX, BX
    XOR  CX, CX
    XOR  DX, DX
;OPEN_FILE:
    MOV  AH, 3Dh
    MOV  AL, 1 ; 0 Read, 1 Write, 2 Read & Write
    LEA  DX, Top10File
    INT  21h
    MOV  HandleFich, AX

    MOV  CheckWordsFlag, 0          ; Flag, para verificar se a nova pontuação foi adicionada ou não
    
;WRITE_STRING:
    CMP  Top10[0], '!'
    JE   CARDINAL_REPLACE_PLAYERSCORE    ; Jump if Top10 is empty
    XOR  SI, SI
    JMP  WRITE_STRING_LOOP
WRITE_STRING_LOOP:
	CMP  Top10[SI], '!'
    JE   CARDINAL_REPLACE_PLAYERSCORE
    CMP  IndexTop10, 10
    JAE  CLOSE_FILE
    CMP  Top10[SI], '#'
    JE   READ_NUMBER
    CMP  Top10[SI], 10
    JE   JUMP_LINE
    CMP  Top10[SI], '$'
    JE   CHECK_FLAG_AND_CLOSE_FILE
    MOV  BX, HandleFich
    MOV  CX, 1      ; STRING LENGTH
    LEA  DX, Top10[SI]
    MOV  AH, 40h
    INT  21h
    INC  SI
    JMP  WRITE_STRING_LOOP
JUMP_LINE:
    MOV  BX, HandleFich
    MOV  CX, 1
    LEA  DX, LINE_FEED
    MOV  AH, 40h
    INT  21h
    INC  SI
    JMP  WRITE_STRING_LOOP
READ_NUMBER:	
	XOR  AX, AX
    XOR  DX, DX
    XOR  BX, BX
	MOV  BX, HandleFich
	MOV  CX, 1          ; STRING LENGTH
    LEA  DX, CARDINAL
    MOV  AH, 40h
    INT  21h

    INC  SI                     ; Jump '#'
    INC  IndexTop10
    XOR  AX, AX
    XOR  DX, DX
    MOV  DL, CheckWordsFlag
    CMP  DL, 1
    JE   WRITE_STRING_LOOP
; 1st Number (hundreds)
    MOV  AL, Top10[SI]
    SUB  AL, 48
    MOV  DL, 100
    MUL  DL             ; X1*100
; 2nd Number (dozens)
    MOV  DH, AL
    MOV  AL, Top10[SI+1]
    SUB  AL, 48
    MOV  DL, 10
    MUL  DL             ; X2*10
    ADD  AL, DH         ; X2*10 + X1*100
; 3rd Number (units)
    ADD  AL, Top10[SI+2]
    SUB  AL, 48         ; X1*100 + X2*10 + X3
; Compare BoardScore with PlayerScore
    CMP  PlayerScore, AL
    JA   REPLACE_PLAYERSCORE ; Jump if PlayerScore >
    XOR  AX, AX
    JMP  WRITE_STRING_LOOP

CARDINAL_REPLACE_PLAYERSCORE:
	XOR  AX, AX
    XOR  BX, BX
    XOR  DX, DX
	MOV  BX, HandleFich
	MOV  CX, 1          ; STRING LENGTH
    LEA  DX, CARDINAL
    MOV  AH, 40h
    INT  21h
	XOR  AX, AX
    XOR  BX, BX
    XOR  DX, DX
	JMP	 REPLACE_PLAYERSCORE
REPLACE_PLAYERSCORE:
	CALL	APAGA_ECRAN
	CALL	PAINT_SCREEN
	MOV		POSx, 14
	MOV		POSy, 8
	LEA		DX, GetNameTop10
	MOV		AX, HandleFich
	PUSH	AX
	CALL	READ_PRINT_FILE_MENU
	POP		AX
	MOV		HandleFich, AX
	MOV		POSx, 24
	MOV		POSy, 15
	GOTO_XY	POSx, POSy
	XOR		DX, DX
    XOR  	DI, DI
    JMP  	GET_PLAYER_NAME

GET_PLAYER_NAME:
	XOR	 AX, AX
    MOV  AH, 01h
    INT  21h
    CMP  AL, 8
	JE	 DELETE_CHAR
    CMP  AL, 13
    JE   WRITE_SCORE_AND_PLAYER_NAME
	CMP	 AL, 65				; A
	JB	 GET_PLAYER_NAME 	; <
	CMP	 AL, 122			; z
	JA	 GET_PLAYER_NAME	; >
    MOV  PlayerName[DI], AL
	INC	 POSx
    INC  DI
    CMP  DI, 10
    JB   GET_PLAYER_NAME
    JMP  WRITE_SCORE_AND_PLAYER_NAME
DELETE_CHAR:
	MOV  	AH, 02h
	MOV  	DX, ' '
    INT  	21h
	GOTO_XY POSx, POSy
	CMP		DI, 0
	JBE		GET_PLAYER_NAME
	DEC 	DI
	DEC		POSx
	GOTO_XY POSx, POSy
	XOR		DX, DX
	JMP	 	GET_PLAYER_NAME

WRITE_SCORE_AND_PLAYER_NAME:
    MOV  CheckWordsFlag, 1            ; Flag, para verificar se a nova pontuação foi adicionada ou não

    CALL CONVERT_SCORE_TO_CHAR

    XOR  AX, AX
    XOR  BX, BX
    XOR  CX, CX
    XOR  DX, DX
    MOV  BX, HandleFich

    MOV  CX, 3          ; STRING LENGTH
    LEA  DX, PlayerScoreCHAR
    MOV  AH, 40h
    INT  21h

    LEA  DX, LINE_FEED
    MOV  CX, 1
    MOV  AH, 40h
    INT  21h

    MOV  CX, DI         ; STRING LENGTH
    LEA  DX, PlayerName
    MOV  AH, 40h
    INT  21h

    LEA  DX, LINE_FEED
    MOV  CX, 1
    MOV  AH, 40h
    INT  21h
    
    CMP  IndexTop10, 10
    JAE  CLOSE_FILE

	MOV  CX, 1          ; STRING LENGTH
    LEA  DX, CARDINAL
    MOV  AH, 40h
    INT  21h

    JMP  WRITE_STRING_LOOP

CHECK_FLAG_AND_CLOSE_FILE:
    CMP  CheckWordsFlag, 0
    JE   REPLACE_PLAYERSCORE
	MOV  Top10[SI+1], '$'
    JMP  CLOSE_FILE

CLOSE_FILE:
    MOV  AH, 3Eh
    MOV  BX, HandleFich
    INT  21h
    RET
WRITE_TOP10_TO_FILE ENDP
;########################################################################

;######################################################################## ;MIGUEL
CONVERT_SCORE_TO_CHAR PROC
	XOR		AX, AX
	XOR		BX, BX
	XOR		CX, CX
	XOR 	DX, DX
    XOR     BP, BP
    MOV     AL, PlayerScore
	JMP		DIVISION_BY_TEN
DIVISION_BY_TEN:	; Enquanto AX != 0 Faz DX = AX%BX && AX = AX/BX
	CMP		AX, 0
	JE		WRITE_ZEROS
	MOV 	BX, 10					; 10, para as divisoes sucessiva por 10
	DIV 	BX          			; Divide AX/BX e mete o resto em DX
	PUSH 	DX						; PUSH -> Pilha do resto da divisão
	INC 	CX						; CX++
	XOR 	DX, DX
	JMP 	DIVISION_BY_TEN
WRITE_ZEROS:
    CMP     CX, 2
    JA      WRITE_NUM
    MOV     PlayerScoreCHAR[BP], '0'
    INC     BP
    CMP     CX, 1
    JA      WRITE_NUM
    MOV     PlayerScoreCHAR[BP], '0'
    INC     BP
	CMP     CX, 0
    JA      WRITE_NUM
    MOV     PlayerScoreCHAR[BP], '0'
    RET
WRITE_NUM:
	CMP 	CX, 0
	JE 		CONVERT_SCORE_TO_CHAR_EXIT	; Termina função
	POP 	DX						; POP <- Pilha do resto da divisão
	ADD 	DX, 48					; Numeros de 0 a 9 de acordo com ASCCI Table
	MOV     PlayerScoreCHAR[BP], DL
    INC     BP
	DEC 	CX						; CX--
	JMP 	WRITE_NUM
CONVERT_SCORE_TO_CHAR_EXIT:	RET
CONVERT_SCORE_TO_CHAR ENDP
;########################################################################

;######################################################################## ;MIGUEL
; Adiciona carater na string player
CHECK_NON_INVERTED_AND_INVERTED_WORD PROC
	CALL	CHECK_WORDS
	CMP		CheckWordsFlag, 0
	JE		CHECK_NON_INVERTED_AND_INVERTED_WORD_EXIT

	XOR		AX, AX
	XOR		SI, SI
	XOR		DI, DI
	MOV		AL, PlayerWordSize
	MOV		DI, AX
	DEC		DI
	JMP		INVERTED_WORD

INVERTED_WORD:
	MOV		AL, PlayerWord[SI]
	MOV		Car, AL

	MOV		AL, PlayerWord[DI]
	MOV		PlayerWord[SI], AL

	MOV		AL, Car
	MOV		PlayerWord[DI], AL

	INC		SI
	DEC		DI
	CMP		SI, DI
	JBE		INVERTED_WORD

	CALL	CHECK_WORDS
	CMP		CheckWordsFlag, 0
	JE		CHECK_NON_INVERTED_AND_INVERTED_WORD_EXIT

	MOV		PlayerWord[0], '$'
	CALL	N_TENTATIVAS
	CALL	UNMARK_SELECTED_CHAR	
	RET	
CHECK_NON_INVERTED_AND_INVERTED_WORD_EXIT: RET
CHECK_NON_INVERTED_AND_INVERTED_WORD ENDP
;########################################################################

;######################################################################## ;MIGUEL
; Pinta palavra encontrada fora do tabuleiro
PAINT_WORD PROC
	MOV		wordPlaceholder, 14
	CMP		LVL, 3
	JE		PAINT_WORD_HIGH

	MOV		PosWordsX, 57
	MOV		PosWordsY, 3
	MOV		DX, BP
	ADD		PosWordsY, DL
	GOTO_XY	PosWordsX, PosWordsY
	XOR		DX, DX
	MOV		wordPlaceholder, 12
	JMP		PAINT_WORD_LOOP
PAINT_WORD_LOOP:
	MOV 	AH, 08h	; Lê caracter
	MOV		BH, 0
	INT		10h		
	; Guarda o Caracter que está na posição do Cursor em AL
	MOV     AH, 09h
	XOR		BX, BX
	MOV     BL, 30h ; Black text, Cyan background
	MOV     CX, 1	; Print one char
	INT     10h
	DEC		wordPlaceholder
	INC		PosWordsX
	GOTO_XY	PosWordsX, PosWordsY
	CMP		wordPlaceholder, 0
	JA		PAINT_WORD_LOOP
	CALL	P_ENCONTRADAS
	XOR		SI, SI
	RET

PAINT_WORD_HIGH:
	MOV		PosWordsX, 10
	MOV		PosWordsY, 19
	MOV		DX, BP
	XOR		BX, BX
	CMP		DL, 1
	JAE		PAINT_WORD_LOOP_POS
	GOTO_XY	PosWordsX, PosWordsY
	JMP		PAINT_WORD_LOOP

PAINT_WORD_LOOP_POS:
	CMP		DL, 0
	JBE		PAINT_WORD_LVL_HIGH	; Condição de saida
	ADD		PosWordsX, 15
	DEC		DL
	INC		BH
	CMP		BH, 4
	JAE		PAINT_WORD_POS_REST ; JBE(<=) // JAE(>=)
	JMP 	PAINT_WORD_LOOP_POS

PAINT_WORD_POS_REST:
	MOV		PosWordsX, 10
	INC		PosWordsY
	XOR		BX, BX
	JMP 	PAINT_WORD_LOOP_POS	

PAINT_WORD_LVL_HIGH:
	GOTO_XY	PosWordsX, PosWordsY
	XOR		DX, DX
	JMP		PAINT_WORD_LOOP
PAINT_WORD endp
;########################################################################

;######################################################################## ;MIGUEL
; Incrementa o número de palavras encontradas e imprime no ecrã
P_ENCONTRADAS PROC
	GOTO_XY	34, 1
	INC		Encontradas
	XOR		AX,AX
	MOV 	AL, Encontradas
	CALL	CONVERT_AND_PRINT
	RET
P_ENCONTRADAS endp
;########################################################################

;######################################################################## ;MIGUEL
; Incrementa o número de tentativas e imprime no ecrã
N_TENTATIVAS PROC
	GOTO_XY	49, 1
	INC		Tentativas
	MOV 	AX, Tentativas
	CALL	CONVERT_AND_PRINT
	RET
N_TENTATIVAS endp
;########################################################################

;######################################################################## ;MIGUEL
; Converte um número em char e imprime no ecrã
; [PARAMETROS] Mover para [AX] o número a converter
CONVERT_AND_PRINT PROC
	XOR		CX, CX
	XOR 	DX, DX
	JMP		DIVISION_BY_TEN
DIVISION_BY_TEN:	; Enquanto AX != 0 Faz DX = AX%BX && AX = AX/BX
	CMP		AX, 0
	JE		PRINT_NUM
	MOV 	BX, 10					; 10, para as divisoes sucessiva por 10
	DIV 	BX          			; Divide AX/BX e mete o resto em DX
	PUSH 	DX						; PUSH -> Pilha do resto da divisão
	INC 	CX						; CX++
	XOR 	DX, DX
	JMP 	DIVISION_BY_TEN
PRINT_NUM:
	CMP 	CX, 0
	JE 		CONVERT_AND_PRINT_EXIT	; Termina função
	POP 	DX						; POP <- Pilha do resto da divisão
	ADD 	DX, 48					; Numeros de 0 a 9 de acordo com ASCCI Table
	MOV 	ah, 02h
	INT 	21h
	DEC 	CX						; CX--
	JMP 	PRINT_NUM
CONVERT_AND_PRINT_EXIT:	RET
CONVERT_AND_PRINT ENDP
;########################################################################

;######################################################################## ;MIGUEL
; Valida posição do caractere selecionado
CHECK_CHAR_POSITION PROC
	CMP	PlayerWordSize, 1
	JBE	CHECK_CHAR_POSITION_EXIT		; Jump if(PlayerWordSize <= 1)
	
	XOR	SI, SI
	XOR	CX, CX
	XOR	AX, AX

	MOV	AL, VectorPosX[SI]
	MOV	AH, VectorPosY[SI]
	INC	SI
	INC	CL
	
	ADD	AL, 2
	CMP	AL, VectorPosX[SI]
	JE		RIGHT							; DIAGONAL_TOP_RIGHT, LINE_RIGHT, DIAGONAL_LOWER_RIGHT
	
	SUB	AL, 4
	CMP	AL, VectorPosX[SI]
	JE		LEFT							; DIAGONAL_TOP_LEFT, LINE_LEFT, DIAGONAL_LOWER_LEFT

	ADD	AH, 1
	CMP	AH, VectorPosY[SI]
	JE		COLUMN_LOWER

	SUB	AH, 2
	CMP	AH, VectorPosY[SI]
	JE		COLUMN_TOP

	JMP	CLEAR_ALL

RIGHT:
; DIAGONAL_TOP_RIGHT, LINE_RIGHT, DIAGONAL_LOWER_RIGHT
	CMP	AH, VectorPosY[SI]
	JE		LINE_RIGHT

	ADD	AH, 1
	CMP	AH, VectorPosY[SI]
	JE		DIAGONAL_LOWER_RIGHT

	SUB	AH, 2
	CMP	AH, VectorPosY[SI]
	JE		DIAGONAL_TOP_RIGHT

	JMP	CLEAR_ALL

LEFT:
; DIAGONAL_TOP_LEFT, LINE_LEFT, DIAGONAL_LOWER_LEFT
	CMP		AH, VectorPosY[SI]
	JE		LINE_LEFT

	ADD		AH, 1
	CMP		AH, VectorPosY[SI]
	JE		DIAGONAL_LOWER_LEFT

	SUB		AH, 2
	CMP		AH, VectorPosY[SI]
	JE		DIAGONAL_TOP_LEFT

	JMP		CLEAR_ALL

DIAGONAL_LOWER_RIGHT:
;Vx[0] = 2 & Vy[0] = 3 --[NEXT]--> Vx[1] = 2+2 & Vy[1] = 3+1
	XOR		AX, AX
	MOV		AL, VectorPosX[SI]
	ADD		AL, 2
	MOV		AH, VectorPosY[SI]
	ADD		AH, 1
	
	INC		SI
	INC		CL
	CMP		CL, PlayerWordSize
	JE		CHECK_CHAR_POSITION_EXIT

	CMP		VectorPosX[SI], AL
	JNE		CLEAR_ALL
	CMP		VectorPosY[SI], AH
	JNE		CLEAR_ALL
	
	JMP		DIAGONAL_LOWER_RIGHT

DIAGONAL_LOWER_LEFT:
;Vx[0] = 2 & Vy[0] = 3 --[NEXT]--> Vx[1] = 2-2 & Vy[1] = 3+1
	XOR		AX, AX
	MOV		AL, VectorPosX[SI]
	SUB		AL, 2
	MOV		AH, VectorPosY[SI]
	ADD		AH, 1
	
	INC		SI
	INC		CL
	CMP		CL, PlayerWordSize
	JE		CHECK_CHAR_POSITION_EXIT

	CMP		VectorPosX[SI], AL
	JNE		CLEAR_ALL
	CMP		VectorPosY[SI], AH
	JNE		CLEAR_ALL
	
	JMP		DIAGONAL_LOWER_LEFT

DIAGONAL_TOP_LEFT:
;Vx[0] = 2 & Vy[0] = 3 --[NEXT]--> Vx[1] = 2-2 & Vy[1] = 3-1
	XOR		AX, AX
	MOV		AL, VectorPosX[SI]
	SUB		AL, 2
	MOV		AH, VectorPosY[SI]
	SUB		AH, 1
	
	INC		SI
	INC		CL
	CMP		CL, PlayerWordSize
	JE		CHECK_CHAR_POSITION_EXIT
	
	CMP		VectorPosX[SI], AL
	JNE		CLEAR_ALL
	CMP		VectorPosY[SI], AH
	JNE		CLEAR_ALL
	
	JMP		DIAGONAL_TOP_LEFT

DIAGONAL_TOP_RIGHT:
;Vx[0] = 2 & Vy[0] = 3 --[NEXT]--> Vx[1] = 2+2 & Vy[1] = 3-1
	XOR		AX, AX
	MOV		AL, VectorPosX[SI]
	ADD		AL, 2
	MOV		AH, VectorPosY[SI]
	SUB		AH, 1
	
	INC		SI
	INC		CL
	CMP		CL, PlayerWordSize
	JE		CHECK_CHAR_POSITION_EXIT

	CMP		VectorPosX[SI], AL
	JNE		CLEAR_ALL
	CMP		VectorPosY[SI], AH
	JNE		CLEAR_ALL
	
	JMP		DIAGONAL_TOP_RIGHT

LINE_LEFT:
;Vx[0] = 2 & Vy[0] = 3 --[NEXT]--> Vx[1] = 2-2 & Vy[1] = 3
	XOR		AX, AX
	MOV		AL, VectorPosX[SI]
	SUB		AL, 2
	MOV		AH, VectorPosY[SI]
	
	INC		SI
	INC		CL
	CMP		CL, PlayerWordSize
	JE		CHECK_CHAR_POSITION_EXIT

	CMP		VectorPosX[SI], AL
	JNE		CLEAR_ALL
	CMP		VectorPosY[SI], AH
	JNE		CLEAR_ALL
	
	JMP		LINE_LEFT

LINE_RIGHT:
;Vx[0] = 2 & Vy[0] = 3 --[NEXT]--> Vx[1] = 2+2 & Vy[1] = 3
	XOR	AX, AX
	MOV	AL, VectorPosX[SI]
	ADD	AL, 2
	MOV	AH, VectorPosY[SI]
	
	INC	SI
	INC	CL
	CMP	CL, PlayerWordSize
	JE		CHECK_CHAR_POSITION_EXIT

	CMP	VectorPosX[SI], AL
	JNE	CLEAR_ALL
	CMP	VectorPosY[SI], AH
	JNE	CLEAR_ALL
	
	JMP	LINE_RIGHT

COLUMN_TOP:
;Vx[0] = 2 & Vy[0] = 3 --[NEXT]--> Vx[1] = 2 & Vy[1] = 3-1
	XOR		AX, AX
	MOV		AL, VectorPosX[SI]
	MOV		AH, VectorPosY[SI]
	SUB		AH, 1
	
	INC		SI
	INC		CL
	CMP		CL, PlayerWordSize
	JE		CHECK_CHAR_POSITION_EXIT

	CMP		VectorPosX[SI], AL
	JNE		CLEAR_ALL
	CMP		VectorPosY[SI], AH
	JNE		CLEAR_ALL
	
	JMP		COLUMN_TOP

COLUMN_LOWER:
;Vx[0] = 2 & Vy[0] = 3 --[NEXT]--> Vx[1] = 2 & Vy[1] = 3+1
	XOR	AX, AX
	MOV	AL, VectorPosX[SI]
	MOV	AH, VectorPosY[SI]
	ADD	AH, 1

	INC	SI
	INC	CL
	CMP	CL, PlayerWordSize
	JE	CHECK_CHAR_POSITION_EXIT
	
	CMP	VectorPosX[SI], AL
	JNE	CLEAR_ALL
	CMP	VectorPosY[SI], AH
	JNE	CLEAR_ALL
	
	JMP	COLUMN_LOWER

CLEAR_ALL:
	CALL	N_TENTATIVAS
	CALL	UNMARK_SELECTED_CHAR
	XOR		SI, SI
	MOV		PlayerWord[SI], '$'
	MOV		PlayerWordSize, 0
	RET

CHECK_CHAR_POSITION_EXIT: RET
CHECK_CHAR_POSITION ENDP
;########################################################################

;######################################################################## ;MIGUEL
; Desmarca carateres seleionados pelo o jogador
UNMARK_SELECTED_CHAR PROC
	XOR		SI, SI
	XOR		CX, CX
	MOV		CL, PlayerWordSize
	CMP		PlayerWordSize, 0
	JA		UNMARK_LOOP
	RET
	
UNMARK_LOOP:
	GOTO_XY	VectorPosX[SI], VectorPosY[SI]
	; Lê o caracter [AL] e a cor [AH] na posição do cursor
	XOR		AX, AX
	MOV 	AH, 08h
	MOV		BH, 0
	INT		10h
	XOR		BX, BX
	; Imprime caracter [AL] e a cor [AH] na posição do cursor
	;MOV		AL, PlayerWord[SI]
	NOT		AH			; Inverte cor
	MOV		BL, AH
	MOV 	AH, 09h
	MOV		BH, 0
	MOV		CX, 1
	INT		10h
	MOV		CL, PlayerWordSize
	DEC		PlayerWordSize
	INC		SI
	LOOP	UNMARK_LOOP
	CALL	CLEAR_PLAYERWORD_DISPLAY
	RET
UNMARK_SELECTED_CHAR endp
;########################################################################

;######################################################################## ;MIGUEL
; Limpa mostrador da palavra composta pelos caracteres selecionados pelo jogador
CLEAR_PLAYERWORD_DISPLAY PROC
	GOTO_XY	55, 1
	MOV		CX, 15
	MOV		AH, 02h
	MOV		DX, ' '
	JMP		CLEAR_PLAYERWORD_AND_EXIT
CLEAR_PLAYERWORD_AND_EXIT:
	INT		21h
	LOOP 	CLEAR_PLAYERWORD_AND_EXIT
	RET
CLEAR_PLAYERWORD_DISPLAY endp
;########################################################################

;######################################################################## ;MIGUEL & ALEX
; Lê ficheiro com palavras consoante o LVL
READ_FILE_WORDS PROC
	XOR     SI, SI

	CMP     LVL, 1
	JNE     CHECK_NORMAL_LVL
	LEA     DX, WordsLow		;Mov File
	JMP     OPEN_FILE
CHECK_NORMAL_LVL:
	CMP     LVL, 2
	JNE     CHECK_HIGH_LVL
	LEA     DX, WordsNormal		;Mov File
	JMP     OPEN_FILE
CHECK_HIGH_LVL:
	LEA     DX, WordsHigh		;Mov File
	JMP     OPEN_FILE
	
OPEN_FILE:
	MOV     AH, 3Dh
	MOV     AL, 0
	INT     21h
	JC      OPEN_ERROR
	MOV     HandleFich, AX
	JMP     READ_CHAR
OPEN_ERROR:
	MOV     AH, 09h
	LEA     DX, Erro_Open
	INT     21h
	JMP     READ_FILE_WORDS_EXIT
READ_CHAR:
	MOV     AH, 3Fh
	MOV     BX, HandleFich
	MOV     CX, 1
	LEA     DX, car_fich
	INT     21h
	JC		ERRO_LER
	CMP		AX, 0				;EOF?
	JE		CLOSE_STRING
	MOV		DL, car_fich
	CMP     DL, 10
	JE      NEXT_WORD
	CMP     DL, 13
	JE      READ_CHAR
	MOV     Words[SI], DL
	INC     SI
	JMP		READ_CHAR
NEXT_WORD:
	MOV     Words[SI], '%'
	INC     SI
	JMP     READ_CHAR
CLOSE_STRING:
	MOV     Words[SI], '%'
	INC     SI
	MOV     Words[SI], '$'
	;LEA     DX, Words							; DEBUG
	;MOV     AH, 09h							; DEBUG
	;INT     21h								; DEBUG
	JMP     CLOSE_FILE
ERRO_LER:
	MOV     AH, 09h
	LEA     DX, Erro_Ler_Msg
	INT     21h
CLOSE_FILE:
	MOV     AH, 3Eh
	MOV     BX, HandleFich
	INT     21h
	JNC     READ_FILE_WORDS_EXIT
	MOV     AH, 09h
	LEA     DX, Erro_Close
	INT     21h
	RET
READ_FILE_WORDS_EXIT: RET
READ_FILE_WORDS ENDP
;########################################################################

;######################################################################## ;MIGUEL
; Adiciona carater na string player
ADD_PLAYERWORD PROC
	XOR		SI, SI
	XOR		CX, CX
	MOV		CL, PlayerWordSize
	JMP		LOOP_SI
LOOP_SI:
	INC		SI
	LOOP	LOOP_SI

	XOR		AX, AX
	MOV		AH, POSx
	MOV		VectorPosX[SI], AH
	MOV		AH, POSy
	MOV		VectorPosY[SI], AH

	MOV		AL, Car
	MOV		PlayerWord[SI], AL
	INC 	PlayerWordSize
	INC		SI
	MOV		PlayerWord[SI], '$'

	XOR		AX, AX
	GOTO_XY	55, 1
	LEA		DX, PlayerWord
	MOV		AH, 09h
	INT		21h
	RET
ADD_PLAYERWORD endp
;########################################################################

;######################################################################## ;MIGUEL
; Seleciona palavras apenas com a primeria e ultima posição ; VERSÃO EXTRA
SELECT_WORDS_VE PROC
	XOR		AX, AX
	CMP		FirstPosY, 0
	JNE		GET_LAST_POS
	MOV		AL, POSx
	MOV		FirstPosX, AL
	MOV		AL, POSy
	MOV		FirstPosY, AL
	RET
GET_LAST_POS:
	MOV		AL, POSx
	MOV		LastPosX, AL
	MOV		AL, POSy
	MOV		LastPosY, AL
	; Guarda POSx & POSy atuais
	XOR		DX, DX
	MOV		DH, POSx
	MOV		DL, POSy
	PUSH	DX
	; LINHA
	MOV		AL, FirstPosY
	MOV		POSy, AL
	CMP		AL, LastPosY
	JE		LINE
	; COLUNA
	MOV		AL, FirstPosX
	MOV		POSx, AL
	CMP		AL, LastPosX
	JE		COLUMN
	; DIAGONAL
	MOV		AL, FirstPosY
	;MOV		POSx, AL
	CMP		AL, LastPosY
	JB		DIAGONAL
	; DIAGONAL INVERTIDA
	JA		INVERTED_DIAGONAL

LINE:
	MOV		AL, FirstPosX
	CMP		AL, LastPosX
	JB		NON_INVERTED_LINE
	JMP		INVERTED_LINE
NON_INVERTED_LINE:
	MOV		AL, FirstPosX
	MOV		POSx, AL
	CALL	SELECT_CHAR_AND_ADD_PLAYERWORD_VE
	ADD		FirstPosX, 2
	MOV		AH, LastPosX
	CMP		FirstPosX, AH		; AH <==> LastPosX
	JBE		NON_INVERTED_LINE	; JB <
	JMP		SELECT_WORDS_VE_EXIT
INVERTED_LINE:
	MOV		AL, LastPosX
	MOV		POSx, AL
	CALL	SELECT_CHAR_AND_ADD_PLAYERWORD_VE
	ADD		LastPosX, 2
	MOV		AH, FirstPosX
	CMP		LastPosX, AH		; AH <==> FirstPosX
	JBE		INVERTED_LINE		; JB <
	JMP		SELECT_WORDS_VE_EXIT

COLUMN:
	MOV		AL, FirstPosY
	CMP		AL, LastPosY
	JB		NON_INVERTED_COLUMN
	JMP		INVERTED_COLUMN
NON_INVERTED_COLUMN:
	MOV		AL, FirstPosY
	MOV		POSy, AL
	CALL	SELECT_CHAR_AND_ADD_PLAYERWORD_VE
	INC		FirstPosY
	MOV		AH, LastPosY
	CMP		FirstPosY, AH		; AH <==> LastPosY
	JBE		NON_INVERTED_COLUMN	; JB <
	JMP		SELECT_WORDS_VE_EXIT
INVERTED_COLUMN:
	MOV		AL, LastPosY
	MOV		POSy, AL
	CALL	SELECT_CHAR_AND_ADD_PLAYERWORD_VE
	INC		LastPosY
	MOV		AH, FirstPosY
	CMP		LastPosY, AH		; AH <==> FirstPosY
	JBE		INVERTED_COLUMN		; JB <
	JMP		SELECT_WORDS_VE_EXIT

DIAGONAL:
	MOV		AL, FirstPosX
	CMP		AL, LastPosX
	JB		DIAGONAL_RIGHT
	JMP		DIAGONAL_LEFT
DIAGONAL_RIGHT:
	MOV		AL, FirstPosX
	MOV		POSx, AL
	MOV		AL, FirstPosY
	MOV		POSy, AL
	CALL	SELECT_CHAR_AND_ADD_PLAYERWORD_VE
	ADD		FirstPosX, 2
	INC		FirstPosY
	MOV		AH, LastPosY
	CMP		FirstPosY, AH		; AH <==> LastPosY
	JBE		DIAGONAL_RIGHT		; JB <
	JMP		SELECT_WORDS_VE_EXIT
DIAGONAL_LEFT:
	MOV		AL, FirstPosX
	MOV		POSx, AL
	MOV		AL, FirstPosY
	MOV		POSy, AL
	CALL	SELECT_CHAR_AND_ADD_PLAYERWORD_VE
	SUB		FirstPosX, 2
	INC		FirstPosY
	MOV		AH, LastPosY
	CMP		FirstPosY, AH		; AH <==> LastPosY
	JBE		DIAGONAL_LEFT		; JB <
	JMP		SELECT_WORDS_VE_EXIT

INVERTED_DIAGONAL:
	MOV		AL, FirstPosX
	CMP		AL, LastPosX
	JA		INVERTED_DIAGONAL_RIGHT
	JMP		INVERTED_DIAGONAL_LEFT
INVERTED_DIAGONAL_RIGHT:
	MOV		AL, LastPosX
	MOV		POSx, AL
	MOV		AL, LastPosY
	MOV		POSy, AL
	CALL	SELECT_CHAR_AND_ADD_PLAYERWORD_VE
	ADD		LastPosX, 2
	INC		LastPosY
	MOV		AH, FirstPosY
	CMP		LastPosY, AH				; AH <==> FirstPosY
	JBE		INVERTED_DIAGONAL_RIGHT		; JB <
	JMP		SELECT_WORDS_VE_EXIT
INVERTED_DIAGONAL_LEFT:
	MOV		AL, LastPosX
	MOV		POSx, AL
	MOV		AL, LastPosY
	MOV		POSy, AL
	CALL	SELECT_CHAR_AND_ADD_PLAYERWORD_VE
	SUB		LastPosX, 2
	INC		LastPosY
	MOV		AH, FirstPosY
	CMP		LastPosY, AH				; AH <==> FirstPosY
	JBE		INVERTED_DIAGONAL_LEFT		; JB <
	JMP		SELECT_WORDS_VE_EXIT

SELECT_WORDS_VE_EXIT:
	CALL	CHECK_CHAR_POSITION
	CALL	CHECK_NON_INVERTED_AND_INVERTED_WORD
	MOV		FirstPosX, 0
	MOV		FirstPosY, 0
	MOV		LastPosX, 0
	MOV		LastPosY, 0
	POP		DX
	MOV		POSx, DH
	MOV		POSy, DL
	RET
SELECT_WORDS_VE ENDP
;########################################################################

;######################################################################## ;MIGUEL
; Lê, seleciona e addiciona caracter ao array PlayerWord
SELECT_CHAR_AND_ADD_PLAYERWORD_VE PROC
	LE_CAR	POSx, POSy
	MOV		BL, BackgroundColor
	NOT		BL
	MOV 	AH, 09h
	MOV		AL, Car
	MOV		BH, 0
	MOV		CX, 1
	INT		10h
	CALL	ADD_PLAYERWORD
	RET
SELECT_CHAR_AND_ADD_PLAYERWORD_VE ENDP
;########################################################################

;######################################################################## ;MIGUEL
; Verifica fim se Timeout == 0 ou Encontradas == NumeroPalavras
CHECK_END PROC
	CMP		Timeout, 0
	JE		CALCULATE_SCORE ;CHECK_END_EXIT DEBUG
	JMP		LVL_LOW
LVL_LOW:
	CMP		LVL, 1
	JNE		LVL_NORMAL
	CMP		Encontradas, 8
	JE		CALCULATE_SCORE
	JMP		CHECK_END_EXIT
LVL_NORMAL:
	CMP		LVL, 2
	JNE		LVL_HIGH
	CMP		Encontradas, 10
	JE		CALCULATE_SCORE
	JMP		CHECK_END_EXIT
LVL_HIGH:
	CMP		LVL, 3
	JNE		CHECK_END_EXIT
	CMP		Encontradas, 12
	JE		CALCULATE_SCORE
	JMP		CHECK_END_EXIT

CALCULATE_SCORE:
	; SCORE = Time + E - T
	XOR		AX, AX
	MOV		AL, Timeout
	ADD		AL, Encontradas
	SUB		AX, Tentativas 
	MOV		PlayerScore, AL
	CMP		AX, 0
	JLE		CLOSE_PROGRAM
	GOTO_XY 0, 18
	XOR		AX, AX
	XOR		BX, BX
	XOR		CX, CX
	XOR		DX, DX
	CALL 	READ_FILE_TOP10
	XOR		DX, DX
	XOR		CX, CX
	XOR		BX, BX
	XOR		AX, AX
	CALL	WRITE_TOP10_TO_FILE
	RET

CLOSE_PROGRAM:
	MOV     AH, 4Ch
	INT     21h

CHECK_END_EXIT:	RET
CHECK_END ENDP
;########################################################################

;######################################################################## ;MIGUEL
; Get system time
GET_TIME PROC
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSHF
	MOV		AH, 2CH             ; Get System Time
	INT		21H                 
	MOV		CurrentSeconds, DH  ;MOV CurrentMinutes, CL;MOV CurrentHours, CH
	POPF
	POP		DX
	POP		CX
	POP		BX
	POP		AX
	RET 
GET_TIME ENDP
;########################################################################

;######################################################################## ;ALEX & MIGUEL
; Atualiza o tempo do jogo
TIMER PROC
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSHF

	CMP		Timeout, 0
	JE		ZERO
	CALL	CHECK_END
	CALL	GET_TIME
	MOV		AL, CurrentSeconds
	CMP		PreviousSeconds, AL	; Verifica se os segundos mudaram desde a ultima leitura
	JE		TIMER_EXIT			; Se os segundos atuais forem iguais aos segundos anteriores sai do PROC
	MOV		PreviousSeconds, AL	; Atualiza para os segundos atuais

	DEC		Timeout
	GOTO_XY	17, 1
	CMP		Timeout, 0
	JE		ZERO
	XOR		AX, AX
	MOV		AL, Timeout
	CALL  	CONVERT_AND_PRINT
	CMP   	Timeout, 99
	JE    	CLEAR_ZERO
	CMP   	Timeout, 9
	JE    	CLEAR_ZERO
	JMP   	TIMER_EXIT
CLEAR_ZERO:
	MOV		AH, 0Ah
	MOV   	AL, ' '
	MOV   	CX, 2
	INT		10h
	JMP   	TIMER_EXIT
ZERO:
	MOV   	DL, 48
	MOV   	AH, 02h
	INT   	21H
	CALL	CHECK_END
	JMP   	TIMER_EXIT

TIMER_EXIT:
	GOTO_XY	POSx, POSy			; Volta a colocar o cursor onde estava antes de atualizar o timeout
	POPF
	POP		DX
	POP		CX
	POP		BX
	POP		AX
	RET
TIMER ENDP
;########################################################################

;######################################################################## ;Alex	& MIGUEL
;Imprimir palavras do ficheiro fora do tabuleiro
PRINT_RIGHT_WORDS PROC
	PUSH	AX
	PUSH 	BX
	PUSH 	CX
	PUSH 	DX
	PUSHF
	
	XOR 	SI, SI
	XOR		CX, CX
	CMP		LVL, 3
	JE		WORDS_LVL_HIGH

	MOV		CL, 3
	GOTO_XY 57, CL
	JMP		WORDS_LOOP
WORDS_LOOP:
	MOV 	ah, 02h
	MOV 	dl, Words[SI]
	INT 	21h
	INC		SI
	CMP		Words[SI], '%'	;% == 25h		; verificar se muda de palavra
	JE		NEW_WORD
	CMP		Words[SI], '$'	;% == 25h		; verifica se termina string
	JE		PRINT_RIGHT_WORDS_EXIT
	JMP		WORDS_LOOP
NEW_WORD:
	INC 	SI
	CMP		Words[SI], '$'	;%$== 24h
	JE		PRINT_RIGHT_WORDS_EXIT
	INC		CL
	GOTO_XY 57, CL
	JMP		WORDS_LOOP

WORDS_LVL_HIGH:
	XOR		BX, BX
	MOV		CH, 10
	MOV		CL, 19
	GOTO_XY CH, CL
	JMP		WORDS_LOOP_LVL_HIGH
WORDS_LOOP_LVL_HIGH:
	MOV 	AH, 02h
	MOV 	DL, Words[SI]
	INT 	21h
	INC		SI
	INC		BL
	CMP		Words[SI], '%'	;% == 25h
	JE		NEXT_WORD_HIGH
	CMP		Words[SI], '$'	;$ == 24h
	JE		PRINT_RIGHT_WORDS_EXIT
	JMP		WORDS_LOOP_LVL_HIGH
NEXT_WORD_HIGH:
	MOV 	DL, ' '
	INT 	21h
	INC		BL
	CMP		BL, 14
	JBE		NEXT_WORD_HIGH
	INC		SI
	CMP		Words[SI], '$'
	JE		PRINT_RIGHT_WORDS_EXIT
	INC		BH
	CMP		BH, 4
	JAE		NEXT_LINE_HIGH
	XOR		BL, BL
	JMP		WORDS_LOOP_LVL_HIGH
NEXT_LINE_HIGH:
	INC		CL
	XOR		BL, BL
	GOTO_XY CH, CL
	JMP		WORDS_LOOP_LVL_HIGH

PRINT_RIGHT_WORDS_EXIT:
	POPF
	POP DX		
	POP CX
	POP BX
	POP AX
	GOTO_XY POSx, POSy
	RET
PRINT_RIGHT_WORDS endp
;########################################################################

;######################################################################## ;MIGUEL
; Pinta ecrã
PAINT_SCREEN PROC
	MOV		AH, 06h    ; Scroll up function
	XOR		AL, AL     ; Clear entire screen
	XOR		CX, CX     ; Upper left corner CH = row, CL = column
	MOV		DX, 184FH  ; lower right corner DH = row, DL = column 
	MOV		BH, BackgroundColor
	INT		10H
	RET
PAINT_SCREEN endp
;########################################################################

;######################################################################## ;ALEX
;Calcular numero aleatorio
CalcAleat proc near

  sub	sp,2
  push	bp
  mov	bp,sp
  push	ax
  push	cx
  push	dx	
  mov	ax,[bp+4]
  mov	[bp+2],ax

  mov	ah,00h
  int	1ah

  add	dx,ultimo_num_aleat
  add	cx,dx	
  mov	ax,65521
  push	dx
  mul	cx
  pop	dx
  xchg	dl,dh
  add	dx,32749
  add	dx,ax

  mov	ultimo_num_aleat,dx

  mov	[BP+4],dx
  mov ax, dx

  pop	dx
  pop	cx
  pop	ax
  pop	bp
  ret
CalcAleat endp
;########################################################################

;######################################################################## ;ALEX
; Colocar letra aleatoria
LETRA_ALEATORIA proc
  xor si,si
  xor bx,bx
CICLO_ALEATORIA:
  call 	CalcAleat
  pop		ax
  and 	al, 00011111b			 
  ;MOV 	numaleat[1],AH	
  CMP		al, 19h
  JA		CICLO_ALEATORIA
  mov 	BL,AL
  mov		ah,letra[BX]
  mov		tabelanormal[si],ah
  inc		si
  CMP		tabelanormal[si], 0
  JE		LETRA_ALET_EXIT
  JMP		CICLO_ALEATORIA
LETRA_ALET_EXIT: 
  RET
LETRA_ALEATORIA endp
;########################################################################

;######################################################################## ;ALEX
ESCREVE_STRING PROC
		xor 	si,si
		CALL	LETRA_ALEATORIA
		xor 	ax,ax
		xor 	bx,bx
		xor 	si,si
String_level:
		CMP 	LVL, 1
		JE		string_low
		CMP		LVL, 2
		JE		string_normal
		CMP		LVL, 3
		JE		string_high
string_low:
		mov		POSx,30
		mov		POSy,3
		JMP		Imprime_letra_LOW
string_normal:
		mov		POSx,28
		mov		POSy,3
		jmp 	Imprime_letra_normal
string_high:
		mov		POSx,10
		mov		POSy,3
		jmp		Imprime_letra_high
Imprime_letra_LOW:
		GOTO_XY POSx,POSy		
		mov		dl, tabelanormal[si]		; IMPRIME caracter 
		mov		ah, 02h
		int		21H	
		add		POSx,2						;nova posiçao
		inc 	si							;nova letra	
		CMP 	tabelanormal[si],0			; verifica se terminou a strig
		JE		ESCREVE_STRING_EXT			;Se ainda nao terminou continua
		LE_CAR 	POSx, POSy						;le o caractere	no ecra
		CMP		Car, 177					;Se for parede, vai para 'parede'
		JE		PAREDE_LOW
		JMP		Imprime_letra_LOW				;Senao imprime a nova letra
PAREDE_LOW:
		mov 	POSx,30					;volta para o inicio da linha (supostamente seria numero 3)
		inc 	POSy					
		CMP 	POSy, 13				;verifica ja acabaram as linhas
		JE		ESCREVE_STRING_EXT
		jmp		Imprime_letra_LOW			;imprime a letra
Imprime_letra_normal:
		GOTO_XY POSx,POSy		
		mov		dl, tabelanormal[si]		; IMPRIME caracter 
		mov		ah, 02h
		int		21H	
		add		POSx,2						;nova posiçao
		inc 	si							;nova letra	
		CMP 	tabelanormal[si],0			; verifica se terminou a strig
		JE		ESCREVE_STRING_EXT			;Se ainda nao terminou continua
		LE_CAR 	POSx, POSy					;le o caractere	no ecra
		CMP		Car, 177					;Se for parede, vai para 'parede'
		JE		PAREDE_NORMAL
		JMP		Imprime_letra_normal				;Senao imprime a nova letra
PAREDE_NORMAL:
		mov 	POSx,28					;volta para o inicio da linha (supostamente seria numero 3)
		inc 	POSy					
		CMP 	POSy, 15				;verifica ja acabaram as linhas
		JE		ESCREVE_STRING_EXT
		jmp		Imprime_letra_normal			;imprime a letra
Imprime_letra_high:
		GOTO_XY POSx,POSy		
		mov		dl, tabelanormal[si]		; IMPRIME caracter 
		mov		ah, 02h
		int		21H	
		add		POSx,2						;nova posiçao
		inc 	si							;nova letra	
		CMP 	tabelanormal[si],0			; verifica se terminou a strig
		JE		ESCREVE_STRING_EXT			;Se ainda nao terminou continua
		LE_CAR 	POSx, POSy						;le o caractere	no ecra
		CMP		Car, 177					;Se for parede, vai para 'parede'
		JE		PAREDE_HIGH
		JMP		Imprime_letra_high				;Senao imprime a nova letra
PAREDE_HIGH:
		mov 	POSx,10				;volta para o inicio da linha (supostamente seria numero 3)
		inc 	POSy					
		CMP 	POSy, 18				;verifica ja acabaram as linhas
		JE		ESCREVE_STRING_EXT
		jmp		Imprime_letra_high			;imprime a letr
ESCREVE_STRING_EXT:
			GOTO_XY 3,3
			RET
ESCREVE_STRING endp
;########################################################################

;######################################################################## ;ALEX
;posicionar palavras na tabela											
words_position proc
		PUSHF
		PUSH AX
		PUSH BX
		PUSH CX
		PUSH DX	
		xor si,si
		xor ax,ax
		xor dx,dx
		xor di,di
read_word:
	MOV		AL, Words[DI]
	MOV		palavrapos[SI], AL
	INC		SI
	INC		DI
	CMP		Words[DI], '%'
	JNE		read_word
	JMP		final_read_word
final_read_word:
	MOV		palavrapos[SI], '%'
level:
	CMP 	LVL, 1
	JE		calcular_dir_low
	CMP		LVL, 2
	JE		calcular_dir_normal
	CMP		LVL, 3
	JE		calcular_dir_high
calcular_dir_low:
		xor		ax,ax
		;direcao aleatoria
		call 	CalcAleat				; direçao da palavra
		pop 	ax
		and		al,00000111b  			;0 a 7 (8 direçoes)
		mov		direcao,al
		;coordenadas aleatorias
		xor		ax,ax
		call 	CalcAleat				;coordenadas da palavra
		pop 	ax
		;POSx:
		and		ah,00111111b			;numeros recebidos ficam entre 0 e 31
		CMP		ah,28					;28 e 48
		JB		calcular_dir_low
		CMP		ah,48
		JA		calcular_dir_low
		test	ah,1b					;verificar se é par
		JPO 	calcular_dir_low
		mov		POSx,ah
		mov		POSxPalavra,ah
		;POSy:
		and 	al,00001111b			;numeros recebidos ficam entre 0 e 15
		CMP		al,3
		JB		calcular_dir_low
		CMP		al,12
		JA		calcular_dir_low
		mov		POSy,al
		mov		POSyPalavra,al
		JMP 	direcao_palavra
calcular_dir_normal: 
		xor		ax,ax
		;direcao aleatoria
		call 	CalcAleat				; direçao da palavra
		pop 	ax
		and		al,00000111b  			;0 a 7 (8 direçoes)
		mov		direcao,al
		;coordenadas aleatorias
		xor		ax,ax
		call 	CalcAleat				;coordenadas da palavra
		pop 	ax
		;POSx:
		and		ah,00111111b			;numeros recebidos ficam entre 0 e 31
		CMP		ah,28					;28 a 50 (3 e 25 antigo)
		JB		calcular_dir_normal
		CMP		ah,50
		JA		calcular_dir_normal
		test	ah,1b					;verificar se é par
		JPO 	calcular_dir_normal
		mov		POSx,ah
		mov		POSxPalavra,ah
		;POSy:
		and 	al,00001111b			;numeros recebidos ficam entre 0 e 15
		CMP		al,3					;3 a 14 as linhas novas
		JB		calcular_dir_normal
		CMP		al,14
		JA		calcular_dir_normal
		mov		POSy,al
		mov		POSyPalavra,al
		;debug
		;MOSTRA	palavrapos
		JMP 	direcao_palavra
calcular_dir_high:
		xor		ax,ax
		;direcao aleatoria
		call 	CalcAleat				; direçao da palavra
		pop 	ax
		and		al,00000111b  			;0 a 7 (8 direçoes)
		mov		direcao,al

		;coordenadas aleatorias
		xor		ax,ax
		call 	CalcAleat				;coordenadas da palavra
		pop 	ax
		;POSx:
		and		ah,0111111b			;numeros recebidos ficam entre 0 e 31
		CMP		ah,10
		JB		calcular_dir_high
		CMP		ah,68
		JA		calcular_dir_high
		test	ah,1b					;verificar se é par
		JPO 	calcular_dir_high
		mov		POSx,ah
		mov		POSxPalavra,ah
		;POSy:
		and 	al,00001111b			;numeros recebidos ficam entre 0 e 15
		CMP		al,3
		JB		calcular_dir_high
		CMP		al,17
		JA		calcular_dir_high
		mov		POSy,al
		mov		POSyPalavra,al
		JMP 	direcao_palavra
direcao_palavra:
		xor		si,si
		CMP		direcao, 0
		JE		check_diag_top_direita
		CMP		direcao, 1 
		JE		check_linha_direita
		CMP		direcao, 2
		JE		check_diag_lower_direita
		CMP		direcao, 3
		JE		check_linha_baixo
		CMP		direcao, 4
		JE		check_diag_lower_esquerda
		CMP		direcao, 5
		JE		check_linha_esquerda
		CMP		direcao, 6
		JE		check_diag_top_esquerda
		CMP		direcao, 7
		JE		check_linha_cima
		JMP		calcular_dir_normal
		
check_diag_top_direita:			; direcao = 0
		GOTO_XY POSx,POSy
		CMP		palavrapos[si], '%'					; verificar se a palavra terminou
		JE		escrever_palavra
		LE_CAR 	POSx, POSy
		cmp		Car,177					;verificar se é parede
		JE		level
		CMP 	Cor, 30h
		JE 		corAzul_DTD
		inc		si
		add		POSx,2
		dec		POSy
		JMP		check_diag_top_direita
corAzul_DTD: 
		mov 	dl,Car 
		cmp 	palavrapos[si],dl
		JNE 	level
		inc		si
		add		POSx,2
		dec		POSy
		JMP		check_diag_top_direita

check_linha_direita:			; direcao = 1
		GOTO_XY POSx,POSy 
		CMP		palavrapos[si], '%'					; verificar se a palavra terminou
		JE		escrever_palavra
		LE_CAR 	POSx, POSy
		cmp		Car,177					;verificar se é parede
		JE		level
		CMP 	Cor, 30h
		JE 		corAzul_LD
		inc		si
		add		POSx,2
		JMP		check_linha_direita	
corAzul_LD: 
		mov 	dl,Car 
		cmp 	palavrapos[si],dl
		JNE 	level
		inc		si
		add		POSx,2
		JMP		check_linha_direita

check_diag_lower_direita:		; direcao = 2
		GOTO_XY POSx,POSy
		CMP		palavrapos[si], '%'					
		JE		escrever_palavra
		LE_CAR 	POSx, POSy
		cmp		Car,177					
		JE		level
		CMP 	Cor, 30h
		JE 		corAzul_DLD
		inc		si
		add		POSx,2
		inc		POSy
		JMP		check_diag_lower_direita
corAzul_DLD: 
		mov 	dl,Car 
		cmp 	palavrapos[si],dl
		JNE 	level
		inc		si
		add		POSx,2
		inc		POSy
		JMP		check_diag_lower_direita


check_linha_baixo:				; direcao = 3
		GOTO_XY POSx,POSy
		CMP		palavrapos[si], '%' 		
		JE		escrever_palavra
		LE_CAR 	POSx, POSy
		CMP		Car, 177					
		JE		level
		CMP 	Cor, 30h
		JE 		corAzul_LB
		inc		si
		inc		POSy
		JMP		check_linha_baixo
corAzul_LB: 
		mov 	dl,Car 
		cmp 	palavrapos[si],dl
		JNE 	level
		inc		si
		inc		POSy
		JMP		check_linha_baixo

check_diag_lower_esquerda:				; direcao = 4
		GOTO_XY POSx,POSy
		CMP		palavrapos[si], '%'					
		JE		escrever_palavra
		LE_CAR 	POSx, POSy
		CMP		Car, 177					
		JE		level
		CMP 	Cor, 30h
		JE 		corAzul_DLE
		inc		si
		sub		POSx,2
		inc		POSy
		JMP		check_diag_lower_esquerda
corAzul_DLE: 
		mov 	dl,Car 
		cmp 	palavrapos[si],dl
		JNE 	level
		inc		si
		sub		POSx,2
		inc		POSy
		JMP		check_diag_lower_esquerda

check_linha_esquerda:				; direcao = 5
		GOTO_XY POSx,POSy
		CMP		palavrapos[si], '%'					
		JE		escrever_palavra
		LE_CAR 	POSx, POSy
		CMP		Car, 177					
		JE		level
		CMP 	Cor, 30h
		JE 		corAzul_LE
		inc		si
		sub		POSx,2
		JMP		check_linha_esquerda
corAzul_LE: 
		mov 	dl,Car 
		cmp 	palavrapos[si],dl
		JNE 	level
		inc		si
		sub		POSx,2
		JMP		check_linha_esquerda

check_diag_top_esquerda:				; direcao = 6
		GOTO_XY POSx,POSy
		CMP		palavrapos[si], '%'					
		JE		escrever_palavra
		LE_CAR 	POSx, POSy
		cmp		Car,177					
		JE		level
		CMP 	Cor, 30h
		JE 		corAzul_DTE
		inc		si
		sub		POSx,2
		dec		POSy
		JMP		check_diag_top_esquerda
corAzul_DTE: 
		mov 	dl,Car 
		cmp 	palavrapos[si],dl
		JNE 	level
		inc		si
		sub		POSx,2
		dec		POSy
		JMP		check_diag_top_esquerda

check_linha_cima:						; direcao = 7
		GOTO_XY POSx,POSy
		CMP		palavrapos[si], '%'					
		JE		escrever_palavra
		LE_CAR 	POSx, POSy
		CMP		Car,177					
		JE		level
		CMP 	Cor, 30h
		JE 		corAzul_LC
		inc		si
		dec		POSy
		JMP		check_linha_cima
corAzul_LC: 
		mov 	dl,Car 
		cmp 	palavrapos[si],dl
		JNE 	level
		inc		si
		dec		POSy
		JMP		check_linha_cima
;palavra pode ser escrita no devido espaço
escrever_palavra:
		xor		SI,SI
		xor		bx,bx
		xor 	ax,ax
		mov		ah,POSxPalavra
		mov		al,POSyPalavra
		mov		POSx,ah
		mov		POSy,al

		CMP		direcao, 0
		JE		diagonal_top_direita
		CMP		direcao, 1
		JE		linha_direita
		CMP		direcao, 2
		JE		diagonal_lower_direita
		CMP		direcao, 3
		JE		linha_baixo
		CMP		direcao, 4
		JE		diagonal_lower_esquerda
		CMP		direcao, 5
		JE		linha_esquerda
		CMP		direcao, 6
		JE		diagonal_top_esquerda
		CMP		direcao, 7
		JE		linha_cima
;escrever na direcao obtida:
diagonal_top_direita:
		GOTO_XY POSx,POSy
		MOV     AH, 09h
		MOV     AL, palavrapos[si]
		MOV     BL, 30h ; Black text, Cyan background
		MOV     CX, 1    ; Print one char
		INT     10h
		add		POSx,2				;subir um na diagonal direita
		dec		posy				;subir um na diagonal direita
		inc 	si
		CMP		palavrapos[si], '%'
		JE		outra_palavra
		JMP		diagonal_top_direita
linha_direita:
		GOTO_XY POSx,POSy
		MOV     AH, 09h
		MOV     AL, palavrapos[si]
		MOV     BL, 30h ; Black text, Cyan background
		MOV     CX, 1    ; Print one char
		INT     10h
		add		POSx,2				
		inc 	si
		CMP		palavrapos[si], '%'
		JE		outra_palavra
		JMP		linha_direita
diagonal_lower_direita:
		GOTO_XY POSx,POSy
		MOV     AH, 09h
		MOV     AL, palavrapos[si]
		MOV     BL, 30h ; Black text, Cyan background
		MOV     CX, 1    ; Print one char
		INT     10h
		add		POSx,2				
		inc		POSy				
		inc 	si
		CMP		palavrapos[si], '%'
		JE		outra_palavra
		JMP		diagonal_lower_direita
linha_baixo:
		GOTO_XY POSx,POSy
		MOV     AH, 09h
		MOV     AL, palavrapos[si]
		MOV     BL, 30h ; Black text, Cyan background
		MOV     CX, 1    ; Print one char
		INT     10h
		inc		POSy				
		inc 	si
		CMP		palavrapos[si], '%'
		JE		outra_palavra
		JMP		linha_baixo
diagonal_lower_esquerda:
		GOTO_XY POSx,POSy
		MOV     AH, 09h
		MOV     AL, palavrapos[si]
		MOV     BL, 30h ; Black text, Cyan background
		MOV     CX, 1    ; Print one char
		INT     10h
		sub		POSx,2				
		inc		POSy				
		inc 	si
		CMP		palavrapos[si], '%'
		JE		outra_palavra
		JMP		diagonal_lower_esquerda
linha_esquerda:
		GOTO_XY POSx,POSy
		MOV     AH, 09h
		MOV     AL, palavrapos[si]
		MOV     BL, 30h ; Black text, Cyan background
		MOV     CX, 1    ; Print one char
		INT     10h
		sub		POSx,2				
		inc 	si
		CMP		palavrapos[si], '%'
		JE		outra_palavra
		JMP		linha_esquerda
diagonal_top_esquerda:
		GOTO_XY POSx,POSy
		MOV     AH, 09h
		MOV     AL, palavrapos[si]
		MOV     BL, 30h ; Black text, Cyan background
		MOV     CX, 1    ; Print one char
		INT     10h
		sub		POSx,2
		dec		POSy				
		inc 	si
		CMP		palavrapos[si], '%'
		JE		outra_palavra
		JMP		diagonal_top_esquerda
linha_cima:
		GOTO_XY POSx,POSy
		MOV     AH, 09h
		MOV     AL, palavrapos[si]
		MOV     BL, 30h ; Black text, Cyan background
		MOV     CX, 1    ; Print one char
		INT     10h
		dec		POSy				
		inc 	si
		CMP		palavrapos[si], '%'
		JE		outra_palavra
		JMP		linha_cima
outra_palavra:
		inc 	DI
		xor		SI,SI
		CMP		Words[DI], '$'
		JE		black_background
		JMP		read_word
black_background:
		CALL	FUNDO_TECLAS_PRETO
words_position_exit:
		MOV POSx, 38	; Coluna do AVATAR
		MOV POSy, 8		; Linha do AVATAR
		POPF
		POP DX		
		POP CX
		POP BX
		POP AX
		RET
words_position endp
;########################################################################

;######################################################################## ;ALEX
;Trocar a cor do background das palavras posicionadas
FUNDO_TECLAS_PRETO PROC
		CMP 	LVL, 1
		JE		b_bkground_low
		CMP		LVL, 2
		JE		b_bkground_normal
		CMP		LVL, 3
		JE		b_bkground_high
b_bkground_low:
		MOV		POSx, 30
		MOV		POSy, 3
		MOV		POSxinicial, 30
		MOV		POSyfinal, 13
		JMP		letras_loop		
b_bkground_normal:
		MOV		POSx, 28
		MOV		POSy, 3	
		mov		POSxinicial, 28
		MOV		POSyfinal, 15
		JMP		letras_loop
b_bkground_high:
		MOV		POSx, 10
		MOV		POSy, 3
		mov		POSxinicial, 10
		MOV		POSyfinal, 18
		JMP		letras_loop
letras_loop:
		GOTO_XY POSx,POSy
		LE_CAR 	POSx, POSy
		MOV     AH, 09h
		MOV     AL, Car
		MOV     BL, 09h ; Black text, Cyan background
		MOV     CX, 1    ; Print one char
		INT     10h
		add		POSx,2
		LE_CAR 	POSx, POSy
		CMP		Car, 177
		JE		fim_linha
		JMP 	letras_loop
fim_linha:
		mov		dl, POSxinicial	
		mov		POSx, dl
		inc		POSy
		;GOTO_XY	POSx,POSy
		;LE_CAR 	POSx, POSy
		;CMP		Car, 177
		mov		dl, POSyfinal
		CMP 	POSy,dl
		JE		FUNDO_TECLAS_PRETO_EXT
		JMP		letras_loop


FUNDO_TECLAS_PRETO_EXT:
		RET
FUNDO_TECLAS_PRETO ENDP
;########################################################################
;######################################################################## ALEX
;Imprime as palavras do respetivo nivel no menu "Alterar Palavras"
IMPRIME_PALAVRAS_ALT proc		
		xor		bx,bx
		xor		ax,ax
		xor		dx,dx
		CALL	READ_FILE_WORDS
		XOR		SI, SI
		MOV		CL, 10
		MOV		POSx,22				;começa linha 11
		GOTO_XY POSx, CL
		MOV 	ah, 02h
		MOV 	dl, '['
		INT 	21h
		JMP		WORDS_LOOP
LEFT_WORD:
		MOV		POSx,22
		INC		CL
		GOTO_XY POSx, CL
		MOV 	ah, 02h
		MOV 	dl, '['
		INT 	21h
WORDS_LOOP:
		MOV 	ah, 02h
		MOV 	dl, Words[SI]
		INT 	21h
		INC		SI
		CMP		Words[SI], '%'	;% == 25h		; verificar se muda de palavra
		JE		NEW_WORD
		CMP		Words[SI], '$'	;% == 25h		; verifica se termina string
		JE		IMPRIME_PALAVRAS_ALT_EXIT
		JMP		WORDS_LOOP
NEW_WORD:
		MOV 	ah, 02h
		MOV 	dl, ']'
		INT 	21h
		INC 	SI
		CMP		Words[SI], '$'	;%$== 24h
		JE		IMPRIME_PALAVRAS_ALT_EXIT
		CMP		POSx, 46
		JE		LEFT_WORD
		MOV		POSx,46
		GOTO_XY POSx, CL
		MOV 	ah, 02h
		MOV 	dl, '['
		INT 	21h
		JMP		WORDS_LOOP
IMPRIME_PALAVRAS_ALT_EXIT:RET
IMPRIME_PALAVRAS_ALT endp
;########################################################################	ALEX
;Escrever palavra nova no ecra dentro dos [] e ler teclas
NEW_WORD_ALT PROC
		XOR		DX,DX
		LEA		DX, NewWord
		MOV		POSx, 14
		MOV		POSy, 8
		CALL	READ_PRINT_FILE_MENU
		xor		bx,bx
		xor		ax,ax
		xor		dx,dx
		XOR		SI, SI
		MOV		POSx,33
		MOV		POSy,13

CICLO:	
		
		goto_xy	POSx,POSy
		call 	LE_TECLA
		cmp		ah,1
		je		ESTEND
		CMP 	AL,27		; ESCAPE
		JE		BACK_TO_MAIN_MENU
		CMP 	AL,8			; Teste BACK SPACE <- (apagar digito)
		JE		BACKSPACE
		CMP		AL, 13 		; ENTER
		JE		ENTER_KEY
		CMP		POSx,45
		JA		CICLO
		mov		dl, al		; imprime caracter no ecran 
        mov     ah,02h
		int		21h
		inc		POSx
		jmp		CICLO
ENTER_KEY:
		MOV		POSx,33
		MOV		POSy,13
		goto_xy	POSx,POSy
		XOR		SI, SI
		;XOR		CX,CX
last_caracter:
		CMP		Words[SI], '$'
		JE		COPIAR_PALAVRA
		INC 	SI
		JMP		last_caracter
COPIAR_PALAVRA:
		LE_CAR	POSx,POSy
		mov		al, Car
		mov		Words[SI], al
		inc		SI
		INC		POSx
		LE_CAR	POSx,POSy
		CMP		Car, ']'
		JE		FIM_PALAVRA
		CMP		Car, ' '
		JE		FIM_PALAVRA
		JMP		COPIAR_PALAVRA
FIM_PALAVRA:
		mov		Words[SI], '%'
		INC		SI
		mov		Words[SI], '$'
		CALL	PASTE_FILE
		;GOTO_XY	55,22								;DEBUG
		;LEA     DX, Words								; DEBUG
		;MOV     AH, 09h								; DEBUG
		;INT     21h									; DEBUG
		JMP		BACK_TO_MAIN_MENU	
BACKSPACE:
		CMP		POSx,46
		JE		END_RIGHT
		mov		dl, ' '		; imprime caracter no ecran 
        mov     ah,02h
		int		21h
		dec 	POSx
		CMP		POSx,32
		JE		END_LEFT
		jmp		CICLO
ESTEND:		
		cmp 	al,48h
		jne		BAIXO
		;dec		POSy		;cima
		jmp		CICLO

BAIXO:		
		cmp	al,50h
		jne		ESQUERDA
		;inc 	POSy		;Baixo
		jmp		CICLO

ESQUERDA:
		cmp		al,4Bh
		jne		DIREITA
		dec		POSx		;Esquerda
		CMP		POSx,32
		JE		END_LEFT
		jmp		CICLO
END_LEFT:
		INC		POSx
		jmp		CICLO
DIREITA:
		cmp		al,4Dh
		jne		CICLO 
		inc		POSx		;Direita
		CMP		POSx, 46
		JE		END_RIGHT
		jmp		CICLO
END_RIGHT:
		DEC		POSx
		jmp		CICLO
fim:	
		mov		ah,4CH
		INT		21H

BACK_TO_MAIN_MENU:
	MOV		DL, BackgroundColor
	MOV		Cor, DL
	XOR		DX, DX
	CALL	PAINT_CURRENT_SELECTION
	RET
NEW_WORD_ALT_EXIT: RET
NEW_WORD_ALT ENDP
;########################################################################	ALEX
;Cria novo ficheiro com as palavras existentes na string words
PASTE_FILE proc
	XOR		SI,SI
	CMP		LVL,1
	JE		FICHEIRO_LVL_LOW
	CMP		LVL,2
	JE		FICHEIRO_LVL_NORMAL
	CMP		LVL,3
	JE		FICHEIRO_LVL_HIGH
FICHEIRO_LVL_LOW:
	LEA		dx, WordsLow
	MOV		ah, 3ch
	INT		21h
	LEA		dx, WordsLow
	JMP		OPEN_FILE
FICHEIRO_LVL_NORMAL:
	LEA		dx, WordsNormal
	MOV		ah, 3ch
	INT		21h
	LEA		dx, WordsNormal
	JMP		OPEN_FILE
FICHEIRO_LVL_HIGH:
	LEA		dx, WordsHigh
	MOV		ah, 3ch
	INT		21h
	LEA		dx, WordsHigh
	JMP		OPEN_FILE
OPEN_FILE:
		mov     ah, 3ch
		mov		cx, 00H
        mov     al, 0
        int     21h
        jc      erro_abrir
        mov     HandleFich,ax
        jmp     write_ciclo
erro_abrir:
		GOTO_XY	70,25
        mov     ah,09h
        lea     dx,Erro_Open
        int     21h
        jmp     PASTE_FILE_EXT
write_ciclo:
		CMP		Words[SI], ' '
		JE		AVANCAR_ESPACO
        mov     ah,40h
		mov     bx,HandleFich
		XOR		dx,dx
        LEA		DX, Words[si]
		mov     cx,1
        int     21h
		jc		erro_escrever
		inc		si
		cmp		words[si],'$'		;EOF?
		je		fecha_ficheiro
		CMP		words[si],'%'
		JE		NOVA_PALAVRA
		jmp		write_ciclo
AVANCAR_ESPACO:
		INC		SI
		CMP		Words[SI], ' '
		JE		AVANCAR_ESPACO
		CMP		Words[SI], '%'
		JE		NOVA_PALAVRA
		JMP		write_ciclo
NOVA_PALAVRA:
		INC		SI
		cmp		words[si],'$'		;EOF?
		je		fecha_ficheiro
		mov     ah,40h
        mov     bx,HandleFich
        mov     cx,2
        ;mov     dl, 10			;suposto avançar linha
        XOR		DX,DX
		XOR		AX,AX
		;mov		ah, 10
		LEA		DX, NewLine
		mov     ah,40h
		int     21h
		jc		erro_escrever
		JMP		write_ciclo		
erro_escrever:
		GOTO_XY	70,25
        mov     ah,09h
        lea     dx,Erro_Ler_Msg
        int     21h
fecha_ficheiro:
        mov     ah,3eh
        mov     bx,HandleFich
        int     21h
        jnc     PASTE_FILE_EXT

        mov     ah,09h
        lea     dx,Erro_Close
        Int     21h	

PASTE_FILE_EXT:	RET	
PASTE_FILE  endp

;######################################################################## ALEX
;Navegar no menu "Alterar Palavras" e escolher adicionar, remover ou continuar
ALT_PALAVRAS_MENU_NAVIGATION PROC
	MOV		IndexMenu, 1
	MOV		IndexMenuLimit, 3
	MOV		POSx, 17
	MOV		POSy, 17
	MOV		Cor, 30h
	CALL	PAINT_CURRENT_SELECTION
	JMP		LER_SETA
LER_SETA:
	CALL 	LE_TECLA
	CMP		AH, 1
	JE		ARROWS
	
	CMP		AL, 13 		; ENTER
	JE		OPTION_SELECTED
	
	JMP		LER_SETA
ARROWS:
	CALL	ARROW_NAV
	JMP		LER_SETA
OPTION_SELECTED:
	CMP		IndexMenu, 1	;adicionar
	JE		ADICIONAR
	CMP		IndexMenu, 2	;remover
	JE		REMOVER
	CMP		IndexMenu, 3	; Continuar
	JE		ALT_PALAVRAS_MENU_NAVIGATION_EXIT
ADICIONAR:
	MOV		DL, BackgroundColor
	MOV		Cor, DL
	XOR		DX, DX
	CALL	PAINT_CURRENT_SELECTION
	CALL 	NEW_WORD_ALT
	JMP		ALT_PALAVRAS_MENU_NAVIGATION_EXIT
REMOVER:
	MOV		DL, BackgroundColor
	MOV		Cor, DL
	XOR		DX, DX
	CALL	PAINT_CURRENT_SELECTION
	CALL 	SELECT_WORD_ALT
ALT_PALAVRAS_MENU_NAVIGATION_EXIT:
	;MOV		DL, BackgroundColor
	;MOV		Cor, DL
	;XOR		DX, DX
	;CALL	PAINT_CURRENT_SELECTION
	RET
ALT_PALAVRAS_MENU_NAVIGATION endp
;######################################################################## ALEX
;Selecionar palavra a vermelho e esperar teclas  (MENU ALTERAR PALAVRAS)
SELECT_WORD_ALT PROC
		xor		bx,bx
		xor		ax,ax
		xor		dx,dx
		XOR		SI, SI
		MOV		POSx,22
		MOV		POSy,10
		MOV		Cor, 30h
		MOV		Cor, 40h
		CALL	PAINT_SELECTED_WORD
CICLO:	
		goto_xy	POSx,POSy
		call 	LE_TECLA
		cmp		ah,1
		je		ESTEND
		CMP 	AL,27		; ESCAPE
		JE		SELECT_WORD_ALT_EXIT
		CMP		AL, 13 		; ENTER - SELECT WORD
		JE		ENTER_KEY

		jmp	CICLO
ESTEND:		
		cmp 	al,48h
		jne		BAIXO
		MOV		DL, BackgroundColor
		MOV		Cor, DL
		XOR		DX, DX
		CALL	PAINT_SELECTED_WORD
		dec		POSy		;cima
		LE_CAR	POSx,POSy
		CMP		Car, '['
		JNE		CHECK_CIMA
		MOV		Cor, 40h
		CALL	PAINT_SELECTED_WORD
		jmp		CICLO
CHECK_CIMA:
		INC		POSy
		jmp		CICLO
BAIXO:	
		cmp	al,50h
		jne		ESQUERDA
		MOV		DL, BackgroundColor
		MOV		Cor, DL
		XOR		DX, DX
		CALL	PAINT_SELECTED_WORD	
		inc 	POSy		;Baixo
		LE_CAR	POSx,POSy
		CMP		Car, '['
		JNE		CHECK_BAIXO
		MOV		Cor, 40h
		CALL	PAINT_SELECTED_WORD
		jmp		CICLO
CHECK_BAIXO:
		dec		POSy
		JMP		CICLO
ESQUERDA:
		cmp		al,4Bh
		jne		DIREITA
		MOV		DL, BackgroundColor
		MOV		Cor, DL
		XOR		DX, DX
		CALL	PAINT_SELECTED_WORD
		MOV		POSx,22
		MOV		Cor, 40h
		CALL	PAINT_SELECTED_WORD
		jmp		CICLO

DIREITA:
		cmp		al,4Dh
		jne		CICLO
		MOV		DL, BackgroundColor
		MOV		Cor, DL
		XOR		DX, DX
		CALL	PAINT_SELECTED_WORD
		MOV		POSx,46		;Direita
		MOV		Cor, 40h
		CALL	PAINT_SELECTED_WORD
		jmp		CICLO
ENTER_KEY:
		MOV		DL, BackgroundColor
		MOV		Cor, DL
		XOR		DX, DX
		CALL	PAINT_SELECTED_WORD
		CALL	REMOVE_WORD
		;GOTO_XY	55,22								;DEBUG
		;LEA     DX, Words							; DEBUG
		;MOV     AH, 09h								; DEBUG
		;INT     21h									; DEBUG
		JMP		SELECT_WORD_ALT_EXIT



 
SELECT_WORD_ALT_EXIT: RET ;BACK_TO_MAIN_MENU
SELECT_WORD_ALT	ENDP
;########################################################################
;Percorrer String Words e eliminar palavra         ABC%DEF%GHI%$ ->  ABC%    GHI%$
REMOVE_WORD PROC
		XOR		SI,SI
		CMP 	POSx,46  ;Direito
		JE		DIREITA
		CMP 	POSx,22
		JE		ESQUERDA

ESQUERDA:
		CMP		POSy,10
		JE		WORD1
		CMP		POSy,11
		JE		WORD3
		CMP		POSy,12
		JE		WORD5
		CMP		POSy,13
		JE		WORD7
		CMP		POSy,14
		JE		WORD9
		CMP		POSy,15
		JE		WORD11
		CMP		POSy,16
		JE		WORD13
DIREITA:
		CMP		POSy,10
		JE		WORD2
		CMP		POSy,11
		JE		WORD4
		CMP		POSy,12
		JE		WORD6
		CMP		POSy,13
		JE		WORD8
		CMP		POSy,14
		JE		WORD10
		CMP		POSy,15
		JE		WORD12
		CMP		POSy,16
		JE		WORD14
WORD1:
		MOV		CountWords, 0		; %=0
		JMP		Contar_palavra
WORD2:
		MOV		CountWords, 1
		JMP		Contar_palavra
WORD3:
		MOV		CountWords, 2
		JMP		Contar_palavra
WORD4:
		MOV		CountWords, 3
		JMP		Contar_palavra				
WORD5:
		MOV		CountWords, 4
		JMP		Contar_palavra
WORD6:
		MOV		CountWords, 5
		JMP		Contar_palavra
WORD7:
		MOV		CountWords, 6
		JMP		Contar_palavra
WORD8:
		MOV		CountWords, 7
		JMP		Contar_palavra
WORD9:
		MOV		CountWords, 8
		JMP		Contar_palavra
WORD10:
		MOV		CountWords, 9
		JMP		Contar_palavra
WORD11:
		MOV		CountWords, 10
		JMP		Contar_palavra
WORD12:
		MOV		CountWords, 11
		JMP		Contar_palavra
WORD13:
		MOV		CountWords, 12
		JMP		Contar_palavra
WORD14:
		MOV		CountWords, 13
		JMP		Contar_palavra

Contar_palavra:
		CMP		CountWords,0
		JNE		PERCORRER_STRING
		JMP		REMOVER_CARACTERES
PERCORRER_STRING:
		INC		SI
		CMP		Words[SI], '%'
		JE		DECREASE_COUNTWORDS
		JMP		PERCORRER_STRING
DECREASE_COUNTWORDS:
		DEC		CountWords
		JMP 	Contar_palavra
REMOVER_CARACTERES:
		CMP		SI, 0
		JE		DEL_FIRST_CAR
		INC		SI
		CMP		WORDS[SI], '%'
		JE		REMOVER_LAST_CARACTER
		MOV		Words[SI], ' '
		JMP		REMOVER_CARACTERES
DEL_FIRST_CAR:
		MOV		Words[SI], ' '
		INC		SI
		MOV		Words[SI], ' '
		JMP		REMOVER_CARACTERES
REMOVER_LAST_CARACTER:
		MOV		Words[SI], ' '
		JMP		REMOVE_WORD_EXIT
REMOVE_WORD_EXIT: 
		CALL	PASTE_FILE
		RET
REMOVE_WORD ENDP
;########################################################################
;Pintar palavra selecionada de vermehlo
PAINT_SELECTED_WORD PROC
	MOV		wordPlaceholder, 13
	JMP		CURRENT_SELECTION_WORD

CURRENT_SELECTION_WORD:
	GOTO_XY	POSx, POSy	; Vai para nova posição
	MOV 	AH, 08h
	MOV		BH, 0		; Numero da página
	INT		10h			; [AL] Guarda o Caracter que está na posição do Cursor; [AH] Guarda a cor que está na posição do Cursor
	INC		POSx
	DEC		wordPlaceholder
	XOR		BX, BX
	MOV     AH, 09h
	MOV     BL, Cor		; Black Text, Cyan Background
	MOV     CX, 1		; Print one char
	INT     10h
	CMP		wordPlaceholder, 0
	JA		CURRENT_SELECTION_WORD
	JMP		Direita

Direita:
	CMP		POSx,46
	JB		ESQUERDA
	MOV		POSx,46
	GOTO_XY	POSx, POSy
	RET
Esquerda:
	MOV		POSx,22
	GOTO_XY	POSx, POSy
	RET
PAINT_SELECTED_WORD ENDP
;########################################################################

;########################################################################
;ROTINA PARA IMPRIMIR FICHEIRO NO ECRAN
imp_Ficheiro	proc
;abre ficheiro
        mov     ah, 3dh
        mov     al, 0
        LEA     DX, Fich1			; FILE_NAME_LVL_LOW
		CMP		LVL, 1
		JE		OPEN_FILE
		JMP		FILE_NAME_LVL_NORMAL
FILE_NAME_LVL_NORMAL:
        LEA     DX, Fich2
		CMP		LVL, 2
		JE		OPEN_FILE
		JMP		FILE_NAME_LVL_HIGH
FILE_NAME_LVL_HIGH:
		LEA     DX, Fich3
		JMP		OPEN_FILE
OPEN_FILE:	
        int     21h
        jc      erro_abrir
        mov     HandleFich,ax
        jmp     ler_ciclo
erro_abrir:
        mov     ah,09h
        lea     dx,Erro_Open
        int     21h
        jmp     sai
ler_ciclo:
        mov     ah,3fh
        mov     bx,HandleFich
        mov     cx,1
        lea     dx,car_fich
        int     21h
		jc		erro_ler
		cmp		ax,0		;EOF?
		je		fecha_ficheiro
        mov     ah,02h
		mov		dl,car_fich
		int		21h
		jmp		ler_ciclo
erro_ler:
        mov     ah,09h
        lea     dx,Erro_Ler_Msg
        int     21h
fecha_ficheiro:
        mov     ah,3eh
        mov     bx,HandleFich
        int     21h
        jnc     sai

        mov     ah,09h
        lea     dx,Erro_Close
        Int     21h		
sai: ret
imp_Ficheiro	endp
;########################################################################

;########################################################################
; Assinala caracter no ecran	
ASSINALA_P	PROC
CICLO:
	GOTO_XY	POSx,POSy	; Vai para nova posição
	mov 	ah, 08h		; Lê caractere
	mov		bh, 0		; numero da página
	int		10h		
	mov		Car, al		; Guarda o Caracter que está na posição do Cursor
	mov		Cor, ah		; Guarda a cor que está na posição do Cursor
;;;;DEBUG
	;GOTO_XY	78,0		; Mostra o caractere que estava na posição do AVATAR
	;mov		ah, 02h		; IMPRIME caracter da posição no canto
	;mov		dl, Car	
	;int		21H			
	;GOTO_XY	POSx,POSy	; Vai para posição do cursor
		
LER_SETA:
	CALL 	LE_TECLA
	CMP		PlayerScore, 0
	JNE		FIM

	cmp		ah, 1
	je		ESTEND
	
	CMP 	AL, 27		; ESC
	JE		FIM

	CMP		AL, 13
	je		ASSINALA

	CMP		AL, 114 ;r
	JE		RELOAD_WORD
	CMP		AL, 82	;R
	JE		RELOAD_WORD
	
	CMP		AL, 32
	JE		CHECK_PLAYER_WORD

	MOV		DL, AL
	MOV		AH, 02h
	INT		10H

	jmp		LER_SETA
	
ESTEND:
	cmp 	al,48h
	jne		BAIXO
	dec		POSy		;cima

	; Verifica se é parede ;MIGUEL
	LE_CAR	POSx, POSy
	CMP		Car, 177
	JNE		CICLO
	INC		POSy

	jmp		CICLO

BAIXO:
	cmp		al,50h
	jne		ESQUERDA
	inc 	POSy		;Baixo

	; Verifica se é parede ;MIGUEL
	LE_CAR	POSx, POSy
	CMP		Car, 177
	JNE		CICLO
	DEC		POSy
	
	jmp		CICLO

ESQUERDA:
	cmp		al,4Bh
	jne		DIREITA
	dec		POSx		;Esquerda
	dec		POSx		;Esquerda

	; Verifica se é parede ;MIGUEL
	LE_CAR	POSx, POSy
	cmp		Car, 177
	jne		CICLO
	inc		POSx
	inc		POSx

	jmp		CICLO

DIREITA:
	cmp		al, 4Dh
	jne		LER_SETA 
	inc		POSx		;Direita
	inc		POSx		;Direita

	; Verifica se é parede ;MIGUEL
	LE_CAR	POSx, POSy
	cmp		Car, 177
	jne		CICLO
	dec		POSx
	dec		POSx

	jmp		CICLO

RELOAD_WORD: ; PRESS R									;MIGUEL
	CALL	UNMARK_SELECTED_CHAR
	CALL	N_TENTATIVAS
	JMP		CICLO

CHECK_PLAYER_WORD:;PRESS SPACE							;MIGUEL
	CALL	CHECK_NON_INVERTED_AND_INVERTED_WORD
	JMP		CICLO

ASSINALA:
	MOV		bl, Cor
	NOT		bl
	MOV		Cor, bl
	MOV 	ah, 09h
	MOV		al, Car
	MOV		bh, 0
	MOV		cx, 1
	INT		10h

	CMP		LVL, 3
	JE		ASSINALA_VE
	CALL	ADD_PLAYERWORD								;MIGUEL
	CALL	CHECK_CHAR_POSITION 						;MIGUEL
	JMP		CICLO
ASSINALA_VE: ;Funcionalidade Extra						;MIGUEL
	CALL	SELECT_WORDS_VE
	JMP		CICLO

FIM: 	RET
ASSINALA_P	endp
;########################################################################

Main    Proc
	MOV     ax,dseg
	MOV     ds,ax
	MOV		ax,0B800h
	MOV		es,ax

	CALL 	APAGA_ECRAN
	CALL	PAINT_SCREEN
	CALL 	DISPLAY_MENU
	GOTO_XY	0, 0
	CALL	imp_Ficheiro
	CALL	READ_FILE_WORDS
	CALL	PRINT_RIGHT_WORDS

	CALL	ESCREVE_STRING
	CALL	words_position
	GOTO_XY	POSx,POSy
	CALL	ASSINALA_P

	GOTO_XY	0, 22
	MOV     AH, 4Ch
	INT     21h
Main    endp
cseg	ends
end     Main
