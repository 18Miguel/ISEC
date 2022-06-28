/* Trabalho Pratico Programacao - LEI */
/* DEIS-ISEC 2021-2022 */
/* Miguel Ferreira Neves - 2020146521 */

#include "main_header.h"


/* %%%%%%%%%%%%%%%%%%% INICIO DA FUNÇÃO %%%%%%%%%%%%%%%%%%% */
/* Inicia estrutura com mini-tabuleiro */
pMiniBoard initializeBoardList(pMiniBoard board, int id){
    pMiniBoard new, aux;
    new = malloc(sizeof(miniBoard));
    if(new == NULL){
        printf("Erro na alocacao de memoria dos mini-tabuleiros\n");
        return board;
    }

    new->miniBoard = initializeMatrix(BOARDSIZE);
    new->id = id;
    new->next = NULL;

    if(board == NULL){
        board = new;
    }else{
        aux = board;
        while(aux->next != NULL)
            aux = aux->next;
        aux->next = new;
    }
    return board;
}
/* %%%%%%%%%%%%%%%%%%%% FIM DA FUNÇÃO %%%%%%%%%%%%%%%%%%%% */


/* %%%%%%%%%%%%%%%%%%% INICIO DA FUNÇÃO %%%%%%%%%%%%%%%%%%% */
/* Imprime todos os mini-tabuleiros armazenados nas estruturas
   num formato mais legível e amigável para o utilizador */
void printBoardList(pMiniBoard board){
    putchar('\n');
    pMiniBoard nextBoard = NULL;
    int columnSeparator = 0, lineSeparator = 0, nLine = 1;

    printf("\t   1 2 3   1 2 3   1 2 3\n");
    while(board != NULL || nextBoard != NULL){
        
        for(int i = 0; i < 3; i++, nLine++){ /* Pecorre as linhas de cada matriz */
            nextBoard = board;
            printf("\t%d  ", i+1);
            for(int k = 0; k < 3; k++){ /* Pecorre a mesma linha para tres matrizes */
                for(int j = 0; j < 3; j++){
                    printf("%c ", nextBoard->miniBoard[i][j]);
                }
                
                /* Passa o ponteiro para a próxima estrutura (matriz seguinte da mesma linha) */
                /* Na ultima iteração fica apontar para a estrutura da proxima linha */
                nextBoard = nextBoard->next;

                /* Coloca separdores entre os mini-tabuleiros */
                columnSeparator++;
                if(columnSeparator == 3){
                    columnSeparator = 0;
                }else{
                    printf("| ");
                }
                
            }
            putchar('\n');
        }

        /* Coloca separdores entre os mini-tabuleiros */
        lineSeparator++;
        if(lineSeparator < 3){
            printf("\t   -----   -----   -----\n");
        }
        board = nextBoard;
    }
    putchar('\n');
    /*libertaListaTabuleiro(nextBoard);*/
}
/* %%%%%%%%%%%%%%%%%%%% FIM DA FUNÇÃO %%%%%%%%%%%%%%%%%%%% */


/* %%%%%%%%%%%%%%%%%%% INICIO DA FUNÇÃO %%%%%%%%%%%%%%%%%%% */
/* Procura o tabuleiro com o respetivo ID e devolve-o */
pMiniBoard searchMiniBoard(pMiniBoard board, int id){
    for(; board != NULL && board->id != id; board = board->next);

    if(board == NULL){
        printf("[ERROR] Algo de errado nao esta certo, o tabuleiro nao existe.\n");
        return NULL;
    }
    
    return board;
}
/* %%%%%%%%%%%%%%%%%%%% FIM DA FUNÇÃO %%%%%%%%%%%%%%%%%%%% */


/* %%%%%%%%%%%%%%%%%%% INICIO DA FUNÇÃO %%%%%%%%%%%%%%%%%%% */
/* Joga peça na posição indicada pelo o jogador */
int playMiniBoardPiece(pMiniBoard miniBoards, int player, int bot, pPlays* storage, int* storageTotalSize){
    int positionLine, positionColumn;
    printf("\nE a vez do [Jogador %d], jogar no [mini-tabuleiro %d].\n", player, miniBoards->id);

    /* Pede a posicao da peca enquanto a mesma nao for valida */
    do{
        if(bot && player == 2){
            //initRandom();
            do{ positionLine = intUniformRnd(0, 2); }while(positionLine < 0 || positionLine > 2);
            do{ positionColumn = intUniformRnd(0, 2); }while(positionColumn < 0 || positionColumn > 2);
        }else{
            /* Pede a linha onde o jogador pertende jogar */
            char charPositionLine, charPositionColumn;
            do{
                fflush(stdin);
                printf("\tIntroduza a linha em que pertende jogar: ");
                scanf("%c", &charPositionLine);

                positionLine = charPositionLine - '0';

                if(isdigit(charPositionLine) != 1)
                    positionLine = 0;
            }while(positionLine < 1 || positionLine > 3);

            /* Pede a coluna onde o jogador pertende jogar */
            do{
                fflush(stdin);
                printf("\tIntroduza a coluna em que pertende jogar: ");
                scanf("%c", &charPositionColumn); fflush(stdin);
                
                positionColumn = charPositionColumn - '0';

                if(isdigit(charPositionColumn) != 1)
                    positionColumn = 0;
            }while(positionColumn < 1 || positionColumn > 3);

            positionLine--; --positionColumn;
            if(miniBoards->miniBoard[positionLine][positionColumn] != '_')
                printf("\nEsta posicao ja esta ocupada por outra peca! :(\nIntruduza uma nova posicao\n");
        }
        
    }while(miniBoards->miniBoard[positionLine][positionColumn] != '_');
    
    /* Joga peça na posição indicada pelo o jogador */
    if(player == 1){
        miniBoards->miniBoard[positionLine][positionColumn] = 'X';
    }else{
        miniBoards->miniBoard[positionLine][positionColumn] = 'O';
    }

    /* Adiciona jogada feita pelo jogador a lista ligada */
    *storage = initializeStorageList(*storage, player, miniBoards->id, positionLine, positionColumn, storageTotalSize);
    if(bot && player == 2)
        printf("\nO jogador automatico jogou na linha %d, coluna %d.\n", positionLine+1, positionColumn+1);
    
    /* Retorna id do mini-tabuleiro para a jogada seguinte */
    /* Nota: Os ids vao de 1 a 9 */
    for(int i = 0, idNextBoard = 1; i < 3; i++)
        for(int j = 0; j < 3; j++, idNextBoard++)
            if(i == positionLine && j == positionColumn)
                return idNextBoard;
    
    printf("[ERROR] O id do mini-tabuleiro nao foi encontrado\n");
    return 0;
    
}
/* %%%%%%%%%%%%%%%%%%%% FIM DA FUNÇÃO %%%%%%%%%%%%%%%%%%%% */


/* %%%%%%%%%%%%%%%%%%% INICIO DA FUNÇÃO %%%%%%%%%%%%%%%%%%% */
/* Liberta as estrutura dos mini-tabuleiros */
void freeBoardList(pMiniBoard board){
    pMiniBoard aux;
    for(; board != NULL; board = board->next){
        aux = board;
        free(aux);
    }
}
/* %%%%%%%%%%%%%%%%%%%% FIM DA FUNÇÃO %%%%%%%%%%%%%%%%%%%% */


/* %%%%%%%%%%%%%%%%%%% INICIO DA FUNÇÃO %%%%%%%%%%%%%%%%%%% */
/* Verifica se existe linha, coluna ou diagonal com vencedor nos mini-tabuleiros */
/* Preenche tambem o tabuleiro principal com a respetiva peca do vencedor */
void checkMiniBoards(pMiniBoard miniBoards, char** board, int player){

    for(; miniBoards != NULL; miniBoards = miniBoards->next)
        for(int linha = 0, id = 1; linha < BOARDSIZE; linha++)
            for(int coluna = 0; coluna < BOARDSIZE; coluna++, id++)
                if(board[linha][coluna] == '_' && id == miniBoards->id)
                    if(checkLine(miniBoards->miniBoard) || checkColumn(miniBoards->miniBoard) || checkDiagonal(miniBoards->miniBoard)){
                            if(player == 1){
                                board[linha][coluna] = 'X';
                            }else{
                                board[linha][coluna] = 'O';
                            }
                            return;
                    }
}
/* %%%%%%%%%%%%%%%%%%%% FIM DA FUNÇÃO %%%%%%%%%%%%%%%%%%%% */


/* %%%%%%%%%%%%%%%%%%% INICIO DA FUNÇÃO %%%%%%%%%%%%%%%%%%% */
/* Verifica se existe linha com vencedor num mini-tabuleiro específico */
/* Devolve 1 caso se verifique caso devolve 0 */
int checkLine(char** board){
    int i, j;
    for(i = 0; i < BOARDSIZE; i++){
        if(board[i][0] != '_'){

            for(j = 0; j < BOARDSIZE-1 && board[i][j] == board[i][j+1]; j++);

            if(j == BOARDSIZE-1)
                return 1;
        }
    }
    return 0;
}
/* %%%%%%%%%%%%%%%%%%%% FIM DA FUNÇÃO %%%%%%%%%%%%%%%%%%%% */


/* %%%%%%%%%%%%%%%%%%% INICIO DA FUNÇÃO %%%%%%%%%%%%%%%%%%% */
/* Verifica se existe coluna com vencedor num mini-tabuleiro específico */
/* Devolve 1 caso se verifique caso devolve 0 */
int checkColumn(char** board){
    int i, j;
    for(j = 0; j < BOARDSIZE; j++)
        if(board[0][j] != '_'){

            for(i = 0; i < BOARDSIZE-1 && board[i][j] == board[i+1][j]; i++);

            if(i == BOARDSIZE-1)
                return 1;
        }
    return 0;
}
/* %%%%%%%%%%%%%%%%%%%% FIM DA FUNÇÃO %%%%%%%%%%%%%%%%%%%% */


/* %%%%%%%%%%%%%%%%%%% INICIO DA FUNÇÃO %%%%%%%%%%%%%%%%%%% */
/* Verifica se existe diagonal com vencedor num mini-tabuleiro específico */
/* Devolve 1 caso se verifique caso devolve 0 */
int checkDiagonal(char** board){
    int i, j;

    if(board[0][0] != '_'){

        for(i = 0, j = 0; i < BOARDSIZE-1 && board[i][j] == board[i+1][j+1]; i++, j++);
        
        if(i == BOARDSIZE-1)
            return 1;
    }
    if(board[0][BOARDSIZE-1] != '_'){

        for(i = 0, j = BOARDSIZE-1; i < BOARDSIZE-1 && board[i][j] == board[i+1][j-1]; i++, j--);
        
        if(i == BOARDSIZE-1)
            return 1;
    }
    return 0;
}
/* %%%%%%%%%%%%%%%%%%%% FIM DA FUNÇÃO %%%%%%%%%%%%%%%%%%%% */


/* %%%%%%%%%%%%%%%%%%% INICIO DA FUNÇÃO %%%%%%%%%%%%%%%%%%% */
/* Inicia nova estrutura para armazenar jogada */
pPlays initializeStorageList(pPlays storage, int player, int boardID, int line, int column, int *total){
    pPlays new, aux;
    new = malloc(sizeof(plays));
    if(new == NULL){
        printf("Erro na alocacao de memoria para armazenacao de jogadas!\n");
    }

    new->nPlays = ++(*total);
    new->player = player;
    new->boardID = boardID;
    new->linePlayed = line;
    new->columnPlayed = column;
    new->next = NULL;

    if(storage == NULL){
        storage = new;
    }else{
        aux = storage;
        for(; aux->next != NULL; aux = aux->next);
        aux->next = new;
    }
    return storage;
}
/* %%%%%%%%%%%%%%%%%%%% FIM DA FUNÇÃO %%%%%%%%%%%%%%%%%%%% */


/* %%%%%%%%%%%%%%%%%%% INICIO DA FUNÇÃO %%%%%%%%%%%%%%%%%%% */
/* Mostra 1 a 10 jogadas feitas anteriomente pelos os J1 e J2 */
void showPreviousPlays(pPlays storage, int storageTotalSize){
    if(storage == NULL){
        printf("  Ainda nao foram feitas jogadas.\n");
        return;
    }
    storageTotalSize++;

    int i;
    printf("  Neste momento foram feitas %d jogadas\n", storageTotalSize-1);
    do{
        printf("  Quantas jogadas que pertende ver entre 1 e 10 ?\n  Numero de jogadas: ");
        scanf("%d", &i);

        if(i >= storageTotalSize)
            printf("\n  Ainda nao foram feitas jogadas suficientes para o numero que introduziu!\n");
    }while(i >= storageTotalSize || i < 1 || i > 10);
    
    int nJogadasAnteriores = storageTotalSize - i;

    /* Aponta para as nJogadas anteriores */
    for(; storage != NULL && storage->nPlays != nJogadasAnteriores;  storage = storage->next);
    
    for(; storage != NULL && nJogadasAnteriores <= storageTotalSize; nJogadasAnteriores++, storage = storage->next)
        printf("  \tO [Jogador %d] jogou no [mini-tabuleiro %d] na [linha %d] e [coluna %d].\n",
                storage->player, storage->boardID,
                storage->linePlayed+1, storage->columnPlayed+1);
}
/* %%%%%%%%%%%%%%%%%%%% FIM DA FUNÇÃO %%%%%%%%%%%%%%%%%%%% */


/* %%%%%%%%%%%%%%%%%%% INICIO DA FUNÇÃO %%%%%%%%%%%%%%%%%%% */
/* Liberta as estrutura dos mini-tabuleiros */
void freeStorageList(pPlays storage){
    pPlays aux;
    for(; storage != NULL; storage = storage->next){
        aux = storage;
        free(aux);
    }
}
/* %%%%%%%%%%%%%%%%%%%% FIM DA FUNÇÃO %%%%%%%%%%%%%%%%%%%% */


/* %%%%%%%%%%%%%%%%%%% INICIO DA FUNÇÃO %%%%%%%%%%%%%%%%%%% */
/* Repreenche o tabuleiro com base na informação armazenada numa lista ligada */
pMiniBoard refillBoard(pPlays storage, pMiniBoard miniBoards, pMiniBoard* miniBoardAux, char** board){
    pMiniBoard miniBoardsAux;
    int i, j, idNextBoard = 1;

    for(; storage != NULL; storage = storage->next){

        miniBoardsAux = miniBoards;

        miniBoardsAux = searchMiniBoard(miniBoards, storage->boardID);

        if(storage->player == 1){
            miniBoardsAux->miniBoard[storage->linePlayed][storage->columnPlayed] = 'X';
        }else{
            miniBoardsAux->miniBoard[storage->linePlayed][storage->columnPlayed] = 'O';
        }

        checkMiniBoards(miniBoards, board, storage->player);
        
        if(storage->next == NULL){
            for(i = 0, idNextBoard = 1; i < 3; i++)
                for(j = 0; j < 3; j++, idNextBoard++)
                    if(i == storage->linePlayed && j == storage->columnPlayed)
                        *miniBoardAux = searchMiniBoard(miniBoards, idNextBoard);
            
            for(; checkMatrix((*miniBoardAux)->miniBoard); *miniBoardAux = searchMiniBoard(miniBoards, intUniformRnd(1, 9)));
        }
    }


    return miniBoards;
}
/* %%%%%%%%%%%%%%%%%%%% FIM DA FUNÇÃO %%%%%%%%%%%%%%%%%%%% */


/* %%%%%%%%%%%%%%%%%%% INICIO DA FUNÇÃO %%%%%%%%%%%%%%%%%%% */
/* Verifica os 9 minitabuleiros, se os 9 estiverem totalmente preenciedos retorna 1 */
int checkMiniBoard(pMiniBoard miniBoards){
    int i = 0;
    for(; miniBoards != NULL; miniBoards = miniBoards->next){
        if(checkMatrix(miniBoards->miniBoard))
            i++;
    }
    /* printf("[DEBUG] checkMiniBoard [i = %d]\n", i); */

    if(i >= 9)
        return 1;

    return 0;
}
/* %%%%%%%%%%%%%%%%%%%% FIM DA FUNÇÃO %%%%%%%%%%%%%%%%%%%% */