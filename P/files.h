/* Trabalho Pratico Programacao - LEI */
/* DEIS-ISEC 2021-2022 */
/* Miguel Ferreira Neves - 2020146521*/
#ifndef FILES_H
#define FILES_H

#include "main_header.h"

/* Le dados de uma estrura para um ficheiro binario */
void saveData(pPlays storage, int total, int bot);


/* Le dados de um ficheiro binario para uma estrura */
void readData(pPlays* storage, int* total, int* player, int* round, int* bot);


/* Exportação do jogo ficheiro texto */
void exportGame(pPlays storage, int total);


/* Verifica jogada anterior */
void checkPreviousGame(pPlays* storage, int* storageTotalSize, int* player, int* round, int* bot, pMiniBoard* miniboards, pMiniBoard* aux, char** board);

#endif /* FILES_H */