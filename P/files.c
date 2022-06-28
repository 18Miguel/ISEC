#include "main_header.h"
#include <stdio.h>

#define NAMESIZE 25


/* %%%%%%%%%%%%%%%%%%% INICIO DA FUNÇÃO %%%%%%%%%%%%%%%%%%% */
/* Le dados de uma estrura para um ficheiro binario */
void saveData(pPlays storage, int total, int bot){
    /* Abre ficheiro binario para guardar jogadas do jogo */
    FILE *storageFile = fopen(GAMEBINFILE, "wb");

    if(storageFile == NULL){
        printf("[SYSTEM] Erro ao abrir ficheiro para guardar jogo.\n");
        return;
    }

    int day, month;
    char name[NAMESIZE];

    printf("Introduza os seguites dados\n");
    do{ printf("Dia: "); scanf("%d", &day); }while(day < 1 || day > 31);
    do{ printf("Mes: "); scanf("%d", &month); }while(month < 1 || month > 12);
    printf("Nome para o ficheiro \"Save\": ");
    fflush(stdin); scanf("%s", name);
    
    fwrite(&day, sizeof(int), 1, storageFile);
    fwrite(&month, sizeof(int), 1, storageFile);
    fwrite(name, sizeof(char), NAMESIZE, storageFile);

    fwrite(&bot, sizeof(int), 1, storageFile);
    
    /* Guardar total e jogadas do jogo */
    fwrite(&total, sizeof(int), 1, storageFile);

    for(int i = 0; i < total; i++){

        fwrite(&(storage->nPlays), sizeof(int), 1, storageFile);
        fwrite(&(storage->player), sizeof(int), 1, storageFile);
        fwrite(&(storage->boardID), sizeof(int), 1, storageFile);
        fwrite(&(storage->linePlayed), sizeof(int), 1, storageFile);
        fwrite(&(storage->columnPlayed), sizeof(int), 1, storageFile);
        
        storage = storage->next;
    }

    /* Fecha ficheiro */
    fclose(storageFile);
}
/* %%%%%%%%%%%%%%%%%%%% FIM DA FUNÇÃO %%%%%%%%%%%%%%%%%%%% */


/* %%%%%%%%%%%%%%%%%%% INICIO DA FUNÇÃO %%%%%%%%%%%%%%%%%%% */
/* Le dados de um ficheiro binario para uma estrura */
void readData(pPlays* storage, int* total, int* player, int* round, int* bot){
    /* Abre ficheiro binario para ler jogadas do jogo anterior */
    FILE *storageFile = fopen(GAMEBINFILE, "rb");

    if(storageFile == NULL){
        printf("[SYSTEM] Erro ao abrir ficheiro para retomar jogo\n");
        return;
    }

    /* Pede dados ao utilizador */
    int day, month;
    char name[NAMESIZE];

    fread(&day, sizeof(int), 1, storageFile);
    fread(&month, sizeof(int), 1, storageFile);
    fread(name, sizeof(char), NAMESIZE, storageFile);

    fread(bot, sizeof(int), 1, storageFile);

    /* Guardar total e jogadas do jogo numa estrutura de jogadas */
    *total = 0;
    fread(total, sizeof(int), 1, storageFile);

    *storage = NULL;
    pPlays new = NULL, aux;
    
    for(int i = 0; i < *total; i++){

        new = malloc(sizeof(plays));
        if(new == NULL)
            printf("[SYSTEM] Erro na allocacao de memoria na funcao leDados\n");
        
        fread(&(new->nPlays), sizeof(int), 1, storageFile);
        fread(&(new->player), sizeof(int), 1, storageFile);
        fread(&(new->boardID), sizeof(int), 1, storageFile);
        fread(&(new->linePlayed), sizeof(int), 1, storageFile);
        fread(&(new->columnPlayed), sizeof(int), 1, storageFile);
        new->next = NULL;

        /* printf("[DEBUG] ID %d\n", novo->idTabuleiro); */

        if(*storage == NULL){
            *storage = new;
        }else{
            aux = *storage;
            for(; aux->next != NULL; aux = aux->next);
            aux->next = new;
        }
    }

    /* Redefine número da ronda */
    if(new->player == 1){
        *player = 2;
        *round = (new->nPlays + 1) / 2;
        printf("\n\n# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #"
               "\n# # # # # # # # # # # # # # # # # # # # # # # # # # # [ Ronda  %.2d ] # # # # # # # # # # # # # # # # # # # # # # # # # # #"
               "\n# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #\n", *round);
    }else{
        *player = 1;
        *round = new->nPlays / 2;
    }
    /* printf("[DEBUG] RONDA %d  nJogada %d\n", *round, new->nPlays); */
    
    /* Fecha ficheiro */
    fclose(storageFile);
}
/* %%%%%%%%%%%%%%%%%%%% FIM DA FUNÇÃO %%%%%%%%%%%%%%%%%%%% */


/* %%%%%%%%%%%%%%%%%%% INICIO DA FUNÇÃO %%%%%%%%%%%%%%%%%%% */
/* Exportação do jogo ficheiro texto */
void exportGame(pPlays storage, int total){
    char fileName[NAMESIZE];
    printf("\nIntruduza o nome do ficheiro para exportacao do jogo: ");
    fflush(stdin); scanf("%s", fileName);
    /* printf("[DEBUG] NOME \"%s\"\n", fileName); */

    char *pathFile = malloc(sizeof(char*) * 20); /* malloc para  "JogosGuardados/" + ".txt" + "\0" */
    strcpy(pathFile, "JogosGuardados/");
    pathFile = realloc(pathFile, sizeof(char*) * strlen(fileName));
    /* printf("[DEBUG] strlen(fileName) \"%d\"", strlen(fileName)); */
    strcat(pathFile, strcat(fileName, ".txt"));
    /* printf("[DEBUG] caminhoFicheiro \"%s\"", pathFile); */

    /* Abre ficheiro de texto para imprimir jogadas do jogo */
    FILE *storageFile = fopen(pathFile, "wt");

    if(storageFile == NULL){
        printf("[SYSTEM] Erro ao abrir ficheiro texto para exportacao do jogo\n");
        return;
    }

    int round = 1;

    fprintf(storageFile, "Este jogo teve um total de %d jogadas.\n", total);

    for(; storage != NULL; storage = storage->next){
        
        if(storage->player == 1)
            fprintf(storageFile, "\n\n***************************** Ronda %.2d *****************************", round++);

        fprintf(storageFile, "\nO [Jogador %d] jogou no [mini-tabuleiro %d] na [linha %d] e [coluna %d].",
                storage->player, storage->boardID, storage->linePlayed+1, storage->columnPlayed+1);
    }

    /* Liberta memória da string */
    free(pathFile);
    /* Fecha ficheiro */
    fclose(storageFile);
}
/* %%%%%%%%%%%%%%%%%%%% FIM DA FUNÇÃO %%%%%%%%%%%%%%%%%%%% */


/* %%%%%%%%%%%%%%%%%%% INICIO DA FUNÇÃO %%%%%%%%%%%%%%%%%%% */
/*  */
void checkPreviousGame(pPlays* storage, int* storageTotalSize, int* player, int* round, int* bot, pMiniBoard* miniboards, pMiniBoard* aux, char** board){
    FILE *storageFile;
    if((storageFile = fopen("jogo.bin", "rb")) != NULL){

        int day, month;
        char fileName[20];
        fread(&day, sizeof(int), 1, storageFile);
        fread(&month, sizeof(int), 1, storageFile);
        fread(fileName, sizeof(char), 20, storageFile);

        printf("Existe um jogo por acabar, com a data %.2d/%.2d e o seguinte nome \"%s\".\n", day, month, fileName);

        printf("Pertende continuar o jogo anterior ?\n(Y\\N): ");
        char gameContinues;
        do{ scanf("%c", &gameContinues); }while(toupper(gameContinues) != 'Y' && toupper(gameContinues) != 'N');

        if(toupper(gameContinues) == 'Y'){

            readData(storage, storageTotalSize, player, round, bot);
            (*round)++;
            *miniboards = refillBoard(*storage, *miniboards, aux, board);
        
        }else{
            gameMode(bot);
        }

        /* printf("[DEBUG] %d\n", storage->boardID); */
        fclose(storageFile);

    }else{
        /* printf("[DEBUG] storageFile == NULL\n"); */
        gameMode(bot);
    }
}
/* %%%%%%%%%%%%%%%%%%%% FIM DA FUNÇÃO %%%%%%%%%%%%%%%%%%%% */