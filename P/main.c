/* Trabalho Pratico Programacao - LEI */
/* DEIS-ISEC 2021-2022 */
/* Miguel Ferreira Neves - 2020146521 */

#include "main_header.h"


void main(){

    /* Cria uma lista ligada com 9 mini-tabuleiros dinamicamente */
    pMiniBoard miniboards = NULL, aux;
    for(int id = 1; id <= 9; id++){
        miniboards = initializeBoardList(miniboards, id);
    }
    /* Cria dinamicamente o tabuleiro principal do jogo */
    char **board = initializeMatrix(BOARDSIZE);

    /* Procura o tabuleiro para a jogada inicial */
    initRandom();
    aux = searchMiniBoard(miniboards, intUniformRnd(1, 9)); /* 5 */

    /* Lista ligada para armazenamento de jogadas */
    pPlays storage = NULL, playsAux;

    /* Variaveis */
    int bot = 0, option, player = 1, NextBoardID, storageTotalSize = 0, round = 1;

    checkPreviousGame(&storage, &storageTotalSize, &player, &round, &bot, &miniboards, &aux, board);

    do{
        if(player == 1)
            printf("\n\n# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #"
                   "\n# # # # # # # # # # # # # # # # # # # # # # # # # # # [ Ronda  %.2d ] # # # # # # # # # # # # # # # # # # # # # # # # # # #"
                   "\n# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #\n", round);
        
        gameMenu(&bot, &player, &option);

        switch (option){
            /* Jogar peca */
            case 1:
                playerActionsMenu1(&option, miniboards, &aux, &player, bot, &storage, &storageTotalSize, board, &round);
                break;
            
            /* Regras */
            case 2:
                printf("\n  ################################################[Regras]################################################"
                       "\n  # A posicao do mini-tabuleiro em que se joga nao e livre, sendo determinada pela jogada anterior do    #"
                       "\n  # adversario, sendo assim a selecao do tabuleiro onde e feita a primeira jogada e escolhida ao caso.   #"
                       "\n  # Quando um mini-tabuleiro ja tiver um vencedor continuar a ser possivel jogar nesse mini-tabuleiro    #"
                       "\n  # permanecendo o mesmo vencedor ate ao fim do jogo.                                                    #"
                       "\n  ########################################################################################################\n");
                break;
            
            /* Jogadas Anteriores */
            case 3:
                printf("\n  [Jogadas Anteriores]\n");
                playsAux = storage;
                showPreviousPlays(playsAux, storageTotalSize);
                break;
            
            /* Mostra Tabuleiro */
            case 4:
                printf("\n  [Tabuleiro]\n");
                /* Imprime o tabuleiro num formato amigável para o utilizador */
                printBoardList(miniboards);
                break;
            
            /* Mostra Tabuleiro Global */
            case 5:
                printf("\n  [Tabuleiro Global]\n");
                /* Imprime o tabuleiro global num formato amigável para o utilizador */
                printMatrix(board);
                break;
            
            /* Guarda O Jogo Para Retomar Mais Tarde */
            case 6:
                printf("\n  [Guardar o jogo para retomar mais tarde]\n");
                /* Guarda os dados armazenados em 'storage' num ficheiro bin */
                saveData(storage, storageTotalSize, bot);
                option = 0;
                break;
            
            /* Termina Programa */
            case 0:
                printf("\n  [Sair do jogo]\n");
                printf("  Pertende guardar o jogo para retomar mais tarde ?\n");
                char guardaJogo;
                fflush(stdin);
                do{ printf("  (Y\\N): "); fflush(stdin); scanf("%c", &guardaJogo); }while(toupper(guardaJogo) != 'Y' && toupper(guardaJogo) != 'N');
                
                /* Se 'Y' guarda o jogo para retomar mais tarde */
                if(toupper(guardaJogo) == 'Y'){
                    /* Guarda os dados armazenados em 'storage' num ficheiro bin */
                    saveData(storage, storageTotalSize, bot);
                }
                /* FLAG para sair do loop */
                option = 0;
                break;
        }

    }while(option != 0);
    

    /* Liberta memoria do tabuleiro */
    printf("\n[SYSTEM] A libertar memoria..\n");
    freeMatrix(board);
    freeBoardList(miniboards);
    freeStorageList(storage);
    printf("[SYSTEM] O programa terminou\n");
}