/* Trabalho Pratico Programacao - LEI */
/* DEIS-ISEC 2021-2022 */
/* Miguel Ferreira Neves - 2020146521 */

#ifndef MATRIX_H
#define MATRIX_H


/* Cria uma matriz quadrada dinâmica de caracteres com nlinhas e ncolunas */
/* Devolve endereço inicial da matriz */
char** initializeMatrix(int size);


/* Imprime o tabuleiro global num formato amigável para o utilizador */
void printMatrix(char **matrix);


/* Liberta uma matriz dinâmica de caracteres com nlinhas */
void freeMatrix(char** matrix);


/* Verifica se a matriz está totalmente completa */
int checkMatrix(char** matrix);


#endif /* MATRIX_H */