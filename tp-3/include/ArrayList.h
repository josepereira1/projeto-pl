#ifndef ARRAYLIST_H
#define ARRAYLIST_H

/**
@file arrayList.h
Módulo que contém as funções de criação, manipulação e destruição de um ArrayList.
*/

/**\brief Cria a modularidade para a estrutura TCD_ARRAY_LIST*/
typedef struct TCD_ARRAY_LIST *TAD_ARRAY_LIST;

// Construtor
TAD_ARRAY_LIST ARRAY_LIST(int N);

// setters
void addElem(TAD_ARRAY_LIST list, void* elem);
void addElemAtIndex(TAD_ARRAY_LIST list, void* elem, int index);

// getters
void* getElem(TAD_ARRAY_LIST list, int index);
int getArraySize(TAD_ARRAY_LIST list);
int getArrayDim(TAD_ARRAY_LIST list);

// libertar memória
void free_ARRAY_LIST(TAD_ARRAY_LIST list);

#endif