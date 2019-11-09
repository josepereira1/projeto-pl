#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "ArrayList.h"

/**
@file ArrayList.c
Módulo que contém as funções de criação, manipulação e destruição de um ArrayList.
*/

/**\brief Estrutura que armazena e gere os elementos do ArrayList*/
typedef struct TCD_ARRAY_LIST{

	/**\brief array de apontadores*/
	void** array;
	/**\brief número de elementos contidos no ArrayList*/
	int ocupados;
	/**\brief capacidade do ArrayList*/
	int dim;

} TCD_ARRAY_LIST;	



/**
\brief Cria um ArrayList com capacidade inicial N.
@param N - capacidade inicial
@return retorna o novo ArrayList
*/
TAD_ARRAY_LIST ARRAY_LIST(int N){

    TAD_ARRAY_LIST list = (TAD_ARRAY_LIST) malloc(sizeof(TCD_ARRAY_LIST));

    list->dim = N;
    list->ocupados = 0;
    list->array = (void**) malloc(list->dim * sizeof(void *));

    return list;
}


/**
\brief Cria um novo array de apontadores (new_array) com uma nova dimensao (new_dim)\n
	   De seguida copia todos os elementos do array antigo (old_array) para o arrray novo (new_array).
@param old_array - array antigo
@param old_dim - dimensao do array antigo
@param new_dim - nova dimensao do array novo
@return novo array 
*/
static void** array_copy(void** old_array, int old_dim, long new_dim){

	#ifdef TESTA_ERRO_ARRAY_LIST
    if (old_array == NULL){
        perror("old_array == NULL: array_copy() on module ARRAY_LIST");
        exit(EXIT_FAILURE);
    }
    #endif

	void** new_array = (void**) malloc(new_dim * sizeof(void*));	

	memcpy(new_array, old_array, old_dim * sizeof(void*));

	free(old_array);

	return new_array;
}


/**
\brief Aumenta a capacidade do ArrayList, re-dimensionando o tamanho do array interno.
@param list - ArrayList
@param capacidade - capacidade necessária
*/
static void aumentaCapacidade(TAD_ARRAY_LIST list, int capacidade){ 

	#ifdef TESTA_ERRO_ARRAY_LIST
    if (list == NULL || capacidade <= 0){
        perror("list == NULL || capacidade <= 0: aumentaCapacidade() on module ARRAY_LIST");
        exit(EXIT_FAILURE);
    }
    #endif

	if ( capacidade > list->dim ){

		int nova_dim = list->dim * 2;
		list->array = array_copy(list->array, list->dim, nova_dim);
		list->dim = nova_dim;
	}
}



/**
\brief Adiciona o elemento na posição especificada.
@param list - ArrayList
@param elem - apontador
@param index - índice
*/
void addElemAtIndex(TAD_ARRAY_LIST list, void* elem, int index){

	#ifdef TESTA_ERRO_ARRAY_LIST
    if (index >= list->dim){
        perror("index >= list->dim: addElemAtIndex() on module ARRAY_LIST");
        exit(EXIT_FAILURE);
    }
    #endif
	
	list->array[index] = elem;
}


/**
\brief Adiciona o elemento no fim do ArrayList.  
@param list - ArrayList
@param elem - apontador
*/
void addElem(TAD_ARRAY_LIST list, void* elem){

	#ifdef TESTA_ERRO_ARRAY_LIST
    if (list == NULL || elem == NULL){
        perror("list == NULL || elem == NULL: addElem() on module ARRAY_LIST");
        exit(EXIT_FAILURE);
    }
    #endif

	aumentaCapacidade(list, list->ocupados + 1);
	list->array[list->ocupados++] = elem;
}


/**
\brief Retorna o elemento na posição especificada do ArrayList.  
@param list - ArrayList
@param index - índice
@return NULL (insucesso) ou o elemento (sucesso)
*/
void* getElem(TAD_ARRAY_LIST list, int index){

	#ifdef TESTA_ERRO_ARRAY_LIST
    if (index < 0 || list == NULL){
        perror("lindex < 0 || list == NULL: getElem() on module ARRAY_LIST");
        exit(EXIT_FAILURE);
    }
    #endif
	
	if ( index <= list->ocupados ) return list->array[index];
	else return NULL; // so para nao dar warning
}


/**
\brief Retorna o número de elementos num ArrayList.
@param list - ArrayList
@return número de elementos em list
*/
int getArraySize(TAD_ARRAY_LIST list){

	#ifdef TESTA_ERRO_ARRAY_LIST
    if (list == NULL){
        perror("list == NULL: getArraySize() on module ARRAY_LIST");
        exit(EXIT_FAILURE);
    }
    #endif

	return list->ocupados;
}

int getArrayDim(TAD_ARRAY_LIST list){

	#ifdef TESTA_ERRO_ARRAY_LIST
    if (list == NULL){
        perror("list == NULL: getArrayDim() on module ARRAY_LIST");
        exit(EXIT_FAILURE);
    }
    #endif

	return list->dim;
}


/**
\brief Liberta a zona de memória alocada para o ArrayList.
@param list - ArrayList
*/
void free_ARRAY_LIST(TAD_ARRAY_LIST list){

	if (list){

		if (list->array){
			free(list->array);
			list->array = NULL;
		}
		
		free(list);
		list = NULL;
	}
}