/* Trabalho Pratico Programacao - LEI */
/* DEIS-ISEC 2021-2022 */
/* Miguel Ferreira Neves - 2020146521 */

#ifndef BOARD_H
#define BOARD_H


/* Estrutura que armazena os mini-tabuleiros */
typedef struct miniBoard miniBoard, *pMiniBoard;
struct miniBoard{
    int id;
    char **miniBoard;
    pMiniBoard next;
};


/* Estrutura que armazena jogadas feitas pelos os jogadores */
typedef struct plays plays, *pPlays;
struct plays{
    int nPlays;
    int player;
    int boardID;
    int linePlayed;
    int columnPlayed;
    pPlays next;
};


/* Inicia estrutura com mini-tabuleiro */
pMiniBoard initializeBoardList(pMiniBoard board, int id);


/* Imprime todos os mini-tabuleiros armazenados nas estruturas
   num formato mais legível e amigável para o utilizador */
void printBoardList(pMiniBoard board);


/* Procura o tabuleiro com o respetivo ID e devolve-o */
pMiniBoard searchMiniBoard(pMiniBoard board, int id);


/* Joga peça na posição indicada pelo o jogador */
int playMiniBoardPiece(pMiniBoard board, int player, int bot, pPlays* storage, int *storageTotalSize);


/* Liberta as estrura dos mini-tabuleiros */
void freeBoardList(pMiniBoard board);


/* Verifica se existe linha, coluna ou diagonal com vencedor nos mini-tabuleiros */
/* Preenche tambem o tabuleiro principal com a respetiva peca do vencedor */
void checkMiniBoards(pMiniBoard miniBoards, char** board, int player);


/* Verifica se existe linha com vencedor num mini-tabuleiro específico */
/* Devolve 1 caso se verifique caso devolve 0 */
int checkLine(char** board);


/* Verifica se existe coluna com vencedor num mini-tabuleiro específico */
/* Devolve 1 caso se verifique caso devolve 0 */
int checkColumn(char** board);


/* Verifica se existe diagonal com vencedor num mini-tabuleiro específico */
/* Devolve 1 caso se verifique caso devolve 0 */
int checkDiagonal(char** board);



/* Inicia nova estrutura para armazenar jogada */
pPlays initializeStorageList(pPlays storage, int player, int boardID, int line, int column, int *total);


/* Mostra 1 a 10 jogadas feitas anteriomente pelos os J1 e J2 */
void showPreviousPlays(pPlays storage, int storageTotalSize);


/* Liberta as estrutura dos mini-tabuleiros */
void freeStorageList(pPlays storage);


/* Repreenche o tabuleiro com base na informação armazenada numa lista ligada */
pMiniBoard refillBoard(pPlays storage, pMiniBoard miniBoards, pMiniBoard* miniBoardAux, char** board);


/* Verifica os 9 minitabuleiros, se os 9 estiverem totalmente preenciedos retorna 1 */
int checkMiniBoard(pMiniBoard miniBoards);


#endif /* BOARD_H */