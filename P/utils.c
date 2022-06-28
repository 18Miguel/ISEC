/* Trabalho Pratico Programacao - LEI */
/* DEIS-ISEC 2021-2022 */
/* Miguel Ferreira Neves - 2020146521 */

#include "main_header.h"


/* %%%%%%%%%%%%%%%%%%% INICIO DA FUNÇÃO %%%%%%%%%%%%%%%%%%% */
/* Inicializa o gerador de numeros aleatorios. */
/* Esta funcao deve ser chamada apenas uma vez no inicio da execucao do programa */
void initRandom(){
    srand(time(NULL));
}
/* %%%%%%%%%%%%%%%%%%%% FIM DA FUNÇÃO %%%%%%%%%%%%%%%%%%%% */


/* %%%%%%%%%%%%%%%%%%% INICIO DA FUNÇÃO %%%%%%%%%%%%%%%%%%% */
/* Devolve um valor inteiro aleatorio distribuido uniformemente entre [a, b] */
int intUniformRnd(int A, int B){
    return A + rand()%(B-A+1);
}
/* %%%%%%%%%%%%%%%%%%%% FIM DA FUNÇÃO %%%%%%%%%%%%%%%%%%%% */


/* %%%%%%%%%%%%%%%%%%% INICIO DA FUNÇÃO %%%%%%%%%%%%%%%%%%% */
/* Devolve o valor 1 com probabilidade prob. Caso contrario, devolve 0 */
int probEvento(float prob){
    return prob > ((float)rand()/RAND_MAX);
}
/* %%%%%%%%%%%%%%%%%%%% FIM DA FUNÇÃO %%%%%%%%%%%%%%%%%%%% */


/* %%%%%%%%%%%%%%%%%%% INICIO DA FUNÇÃO %%%%%%%%%%%%%%%%%%% */
/* Selecionador de modo de jogo J1 VS J2 ou J1 VS Maquina */
void gameMode(int* bot){
    int mode;
    char charMode;

    printf("\n  Selecione o modo de jogo\n"
           "   [01] Jogador VS Jogador\n"
           "   [02] Jogador VS Maquina\n"
           "   Escolha: ");

    do{
        fflush(stdin); scanf("%c", &charMode);
        mode = charMode - '0';
        
        if(isdigit(charMode) != 1)
            mode = 0;

        if(mode == 1)
            *bot = 0;
        else if(mode == 2)
            *bot = 1;
        
        if(mode < 1 || mode > 2)
            printf("   Escolha: ");

    }while(mode < 1 || mode > 2);
}
/* %%%%%%%%%%%%%%%%%%%% FIM DA FUNÇÃO %%%%%%%%%%%%%%%%%%%% */


/* %%%%%%%%%%%%%%%%%%% INICIO DA FUNÇÃO %%%%%%%%%%%%%%%%%%% */
void playerActionsMenu1(int* escolha, pMiniBoard miniboards, pMiniBoard* aux, int* player, int bot, pPlays* storage, int* storageTotalSize, char** board, int* round){
    int NextBoardID;

    /* Imprime o tabuleiro num formato amigável para o utilizador */
    printBoardList(miniboards);

    /* Joga peça na posição indicada pelo o jogador */
    NextBoardID = playMiniBoardPiece(*aux, *player, bot, storage, storageTotalSize);

    /* Verifica se existe linha, coluna ou diagonal com vencedor nos mini-tabuleiros */
    /* Preenche tambem o tabuleiro principal com a respetiva peca do vencedor */
    checkMiniBoards(miniboards, board, *player);

    /* Verifica se o jogador ganhou no ponto de vista do tabuleiro principal */
    if(checkColumn(board) || checkLine(board) || checkDiagonal(board)){
        /* printf("\t\t\t###[ O jogador %d ganhou o jogo ! ]###", *player); */
        if(*player == 1){
            printf("  ____      _                   __           ___                 __                        _                  __\n"
                   " / __ \\    (_)__  ___ ____ ____/ /__  ____  <  / ___ ____ ____  / /  ___  __ __  ___      (_)__  ___ ____    / /\n"
                   "/ /_/ /   / / _ \\/ _ `/ _ `/ _  / _ \\/ __/  / / / _ `/ _ `/ _ \\/ _ \\/ _ \\/ // / / _ \\    / / _ \\/ _ `/ _ \\  /_/\n"
                   "\\____/ __/ /\\___/\\_, /\\_,_/\\_,_/\\___/_/    /_/  \\_, /\\_,_/_//_/_//_/\\___/\\_,_/  \\___/ __/ /\\___/\\_, /\\___/ (_)\n"
                   "      |___/     /___/                          /___/                                 |___/     /___/\n");
        }else{
            printf("  ____      _                   __           ___                   __                        _                  __\n"
                   " / __ \\    (_)__  ___ ____ ____/ /__  ____  |_  |  ___ ____ ____  / /  ___  __ __  ___      (_)__  ___ ____    / /\n"
                   "/ /_/ /   / / _ \\/ _ `/ _ `/ _  / _ \\/ __/ / __/  / _ `/ _ `/ _ \\/ _ \\/ _ \\/ // / / _ \\    / / _ \\/ _ `/ _ \\  /_/\n"
                   "\\____/ __/ /\\___/\\_, /\\_,_/\\_,_/\\___/_/   /____/  \\_, /\\_,_/_//_/_//_/\\___/\\_,_/  \\___/ __/ /\\___/\\_, /\\___/ (_)\n"
                   "      |___/     /___/                            /___/                                 |___/     /___/\n");
        }
        
        /* Imprime o tabuleiro num formato amigável para o utilizador */
        printBoardList(miniboards);

        /* Imprime o tabuleiro global num formato amigável para o utilizador */
        printMatrix(board);

        /* Exportação do jogo ficheiro texto */
        exportGame(*storage, *storageTotalSize);

        /* Remove ficheiro de jogadas anteriores */
        remove(GAMEBINFILE);
        
        /* FLAG para sair do loop */
        *escolha = 0;

    }else if(checkMatrix(board) || checkMiniBoard(miniboards)){
        /*printf("Houve um empate!\n");*/
        printf("   __ __                                                      __      __\n"
               "  / // /__  __ ___  _____   __ ____ _    ___ __ _  ___  ___ _/ /____ / /\n"
               " / _  / _ \\/ // / |/ / -_) / // /  ' \\  / -_)  ' \\/ _ \\/ _ `/ __/ -_)_/\n"
               "/_//_/\\___/\\_,_/|___/\\__/  \\_,_/_/_/_/  \\__/_/_/_/ .__/\\_,_/\\__/\\__(_)\n"
               "                                                /_/\n");

        /* FLAG para sair do loop */
        *escolha = 0;
        return;
    }

    /* Procura o tabuleiro com o respetivo ID */
    *aux = searchMiniBoard(miniboards, NextBoardID);

    /* Verifica se o tabuleiro é valido para a proxima jogada */
    for(; checkMatrix((*aux)->miniBoard); *aux = searchMiniBoard(miniboards, intUniformRnd(1, 9)));

    if(*player == 1)
        (*round)++;

    /* Muda de jogador */
    *player = *player % 2 + 1;
}
/* %%%%%%%%%%%%%%%%%%%% FIM DA FUNÇÃO %%%%%%%%%%%%%%%%%%%% */


/* %%%%%%%%%%%%%%%%%%% INICIO DA FUNÇÃO %%%%%%%%%%%%%%%%%%% */
/* Menu de jogo */
void gameMenu(int* bot, int* player, int* option){
    printf("\n  [############### Jogador %d ###############]", *player);
    printf("\n  [01] Jogar peca"
            "\n  [02] Regras"
            "\n  [03] Ver jogadas anteriores, 1 a 10 jogadas"
            "\n  [04] Ver tabuleiro"
            "\n  [05] Ver tabuleiro Global"
            "\n  [06] Retomar jogo mais tarde"
            "\n  [00] Sair\n");
    
    /* Verifica se o modo bot está ativado e se é a vez do jogador 2 */
    if(*bot && *player == 2){
        *option = 1;
    }else{
        do{
            printf("  Escolha: "); scanf("%d", option);
        }while(*option < 0 || *option > 6);
    }
}
/* %%%%%%%%%%%%%%%%%%%% FIM DA FUNÇÃO %%%%%%%%%%%%%%%%%%%% */