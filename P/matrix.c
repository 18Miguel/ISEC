/* Trabalho Pratico Programacao - LEI */
/* DEIS-ISEC 2021-2022 */
/* Miguel Ferreira Neves - 2020146521 */

#include "main_header.h"


/* %%%%%%%%%%%%%%%%%%% INICIO DA FUNÇÃO %%%%%%%%%%%%%%%%%%% */
/* Cria uma matriz quadrada dinâmica de caracteres com nlinhas e ncolunas */
/* Devolve endereço inicial da matriz */
char** initializeMatrix(int size){
    char **matrix = NULL;
    int i, j;

    matrix = malloc(sizeof(char*) * size);
    if(matrix == NULL){
        printf("Erro na alocacao de memoria\n");
        return NULL;
    }

    for(i = 0; i < size; i++){
        matrix[i] = malloc(sizeof(char) * size);
        if(matrix[i] == NULL){
            freeMatrix(matrix);
            return NULL;
        }
        for(j = 0; j < size; j++)
            matrix[i][j] = '_';
    }
    return matrix;
}
/* %%%%%%%%%%%%%%%%%%%% FIM DA FUNÇÃO %%%%%%%%%%%%%%%%%%%% */


/* %%%%%%%%%%%%%%%%%%% INICIO DA FUNÇÃO %%%%%%%%%%%%%%%%%%% */
/* Imprime o tabuleiro global num formato amigável para o utilizador */
void printMatrix(char **matrix){
    putchar('\n');

    int columnSeparator = 1, lineSeparator = 1;
    
    for(int i = 0; i < BOARDSIZE; i++, lineSeparator++){
        printf("\n\t ");
        for(int j = 0; j < BOARDSIZE; j++, columnSeparator++){
            printf("%c ", matrix[i][j]);

            if(columnSeparator == 1){
                columnSeparator = 0;
                if(j != BOARDSIZE-1)
                    printf("| ");
            }
        }
        
        if(lineSeparator == 1){
            lineSeparator = 0;
            if(i != BOARDSIZE-1){
                printf("\n\t");
                for(int j = 0; j < BOARDSIZE; j++)
                    printf("--- ");
            }
        }
    }

    putchar('\n');
}
/* %%%%%%%%%%%%%%%%%%%% FIM DA FUNÇÃO %%%%%%%%%%%%%%%%%%%% */


/* %%%%%%%%%%%%%%%%%%% INICIO DA FUNÇÃO %%%%%%%%%%%%%%%%%%% */
/* Liberta uma matriz dinâmica de caracteres com nlinhas */
void freeMatrix(char** matrix){
    for(int i = 0; i < BOARDSIZE; i++)
        free(matrix[i]);
    
    free(matrix);
}
/* %%%%%%%%%%%%%%%%%%%% FIM DA FUNÇÃO %%%%%%%%%%%%%%%%%%%% */


/* %%%%%%%%%%%%%%%%%%% INICIO DA FUNÇÃO %%%%%%%%%%%%%%%%%%% */
/* Verifica se a matriz está totalmente completa */
int checkMatrix(char** matrix){
    int checked = 0;
    for(int i = 0; i < BOARDSIZE; i++)
        for(int j = 0; j < BOARDSIZE; j++)
            if(matrix[i][j] != '_')
                checked++;
    
    if(checked == 9)
        return 1;
    
    return 0;
}
/* %%%%%%%%%%%%%%%%%%%% FIM DA FUNÇÃO %%%%%%%%%%%%%%%%%%%% */