/* Trabalho Pratico Programacao - LEI */
/* DEIS-ISEC 2021-2022 */
/* Miguel Ferreira Neves - 2020146521*/
#ifndef UTILS_H
#define UTILS_H

/* Inicializa o gerador de numeros aleatorios. */
/* Esta funcao deve ser chamada apenas uma vez no inicio da execucao do programa */
void initRandom();


/* Devolve um valor inteiro aleatorio distribuido uniformemente entre [a, b] */
int intUniformRnd(int A, int B);


/* Devolve o valor 1 com probabilidade prob. Caso contrario, devolve 0 */
int probEvento(float prob);


/* Selecionador de modo de jogo J1 VS J2 ou J1 VS Maquina */
void gameMode(int* bot);


/* Ações derivadas ao jogar peça */
void playerActionsMenu1(int* escolha, pMiniBoard miniboards, pMiniBoard* aux, int* player, int bot, pPlays* storage, int* storageTotalSize, char** board, int* round);


/* Menu de jogo */
void gameMenu(int* bot, int* player, int* option);

#endif /* UTILS_H */