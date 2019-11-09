%{
	#define _GNU_SOURCE 
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "include/ArrayList.h"
	int yylex();
	void yyerror(char *s);

	typedef struct node{
		char* conceito;			//	nome do conceito
		char* traducao;			//	tradução do conceito
		char* scopeNote;		//	nota explicativa
		char* pai;
		TAD_ARRAY_LIST filhos;	//	filhos, relações inferiores
	}*NODE;

	char* tmpTraducoes[10];
	int indexTraducoes = 0;
	char* tmpPai;
	char* tmpFilho;
	
	TAD_ARRAY_LIST conceitos;

	char* conceito;
	char* traducao;
	char* scopeNote;
	char* pai;
	char* filho;

	FILE* file;
	char* ficheiro_atual;

	void print(TAD_ARRAY_LIST lista){
		if(getArraySize(lista) != 0){
			for(int i = 0; i < getArraySize(lista); i++){
				
				NODE node = getElem(lista, i);
				if(node != NULL){
					printf("conceito:%s\n", node->conceito);
					printf("tradução:%s\n", node->traducao);
					
					if(node->filhos != NULL){
						printf("------------------ filhos ------------------\n");
						print(node->filhos);
						printf("---------------------------------------------\n");
					}
				}
			}
		}
	}

	//	procura pelo pai e adiciona ao filho do mesmo
	int adicionarNode(TAD_ARRAY_LIST lista, NODE node){
		
		if(lista == NULL || node == NULL){
			perror("ERRO: a lista está a NULL!");
			exit(-1);
		}

		for(int i = 0; i < getArraySize(lista) ; i++){
			
			NODE nodeTmp = (NODE) getElem(lista, i);
			
			if(nodeTmp == NULL){
				perror("ERRO: nodeTmp está a NULL!");
				exit(-1);
			}
			
			if(strcmp(nodeTmp->conceito, node->pai) == 0){
				addElem(nodeTmp->filhos, node);
				return 1;
			}
			else{
				adicionarNode(nodeTmp->filhos, node);
			} 
		}

		return 0;
	}

	void beginHTML(FILE* file, char* title){
        fprintf(file, "<html>\n\t<head>\n\t\t<meta charset='UTF-8'/>\n\t</head>\n<body>\n<h1>%s</h1>\n<ul>", title);
    }

	void endHTML(FILE* file){
    	fprintf(file, "</ul></body></html>");
	}

	char* limparUnderscore(char* str){

		char* res = strdup(str);
		for(int i = 0; i < strlen(res); i++)if(res[i] == '_')str[i] = ' ';
		return str;
	}
%}

%token LANG BASELANG INV TXT FLAG NEWLINE

%union{
	char* texto;
	char* flag;
}

%type<flag> FLAG
%type<texto> TXT NEWLINE linguagens listaLinguagens linguagensBase listaLinguagensBase inversas conceitos conceito dado dados

%%

ficheiro: 				linguagens linguagensBase inversas conceitos	    {
																				printf("RELAÇÃO SUPERIOR=%s | RELAÇÃO INFERIOR=%s | traducoes[0] = %s | traducoes[1] = %s\n", tmpPai, tmpFilho, tmpTraducoes[0], tmpTraducoes[1]);
																				printf("linguagens:%s\nlinguagensBase:%s\ninversas:%s\nconceitos:\n%s\n", $1, $2, $3, $4);
																			}
						;

linguagens: 			LANG listaLinguagens  								{asprintf(&$$, "%s", $2);}
		   				;				

listaLinguagens:		FLAG listaLinguagens                                 {
																				tmpTraducoes[indexTraducoes] = strdup($1);	//	guardar as traduções existentes
																				indexTraducoes++;
																				asprintf(&$$, "%s %s", $1, $2);
																			}
						|													{$$="";}
						;


linguagensBase: 		BASELANG listaLinguagensBase  						{asprintf(&$$, "%s", $2);}
		   				;

listaLinguagensBase:	FLAG listaLinguagensBase                            {asprintf(&$$, "%s %s", $1, $2);}
						|													{$$="";}
						;

inversas: 				INV FLAG FLAG									
																			{	//	assumimos que apenas existem duas possíveis relaçõs
																				tmpFilho = strdup($2);
																				tmpPai = strdup($3);
																				asprintf(&$$, "%s %s", $2, $3);
																			}
		   				;

conceitos:				conceito conceitos									{asprintf(&$$, "%s %s", $1, $2);}
						| 													{$$="";}
						;

conceito:				dados	 											{
																				asprintf(&$$, "%s", $1);
																			}											

dados:					dado dados											{asprintf(&$$, "%s\n%s", $1, $2);}
						|													{
																				//	este código foi a tentativa para o requisito 2 de guardar a info em memória
																				/*
																				NODE tmpNode = (NODE) malloc(sizeof(struct node));
																				tmpNode->filhos = ARRAY_LIST(10);

																				int flag = 0;

																				if(conceito != NULL){
																					flag++;
																					tmpNode->conceito = strdup(conceito);
																					conceito = NULL;
																				}
																				if(traducao != NULL){
																					
																					tmpNode->traducao = strdup(traducao);
																					traducao = NULL;
																				}
																				if(scopeNote != NULL){
																					
																					tmpNode->scopeNote = strdup(scopeNote);
																					scopeNote = NULL;
																				}
																				if(pai != NULL){
																					
																					tmpNode->pai = strdup(pai);
																					pai = NULL;
																				}

																				adicionarNode(conceitos, tmpNode);
																				*/
																				$$="";
																			}
						;

dado:					 FLAG TXT											{
																				if(strcmp(strdup($1), tmpTraducoes[0]) == 0 || strcmp(strdup($1), tmpTraducoes[1]) == 0){
																					traducao = strdup($2);
																					asprintf(&$$, "TRADUÇÃO=[%s %s]", $1, $2);
																					fprintf(file, "TRADUÇÃO: %s<br>", traducao);
																				}else if(strcmp(strdup($1), tmpPai) == 0){
																					asprintf(&$$, "PAI=[%s %s]", $1, $2);
																					pai = strdup($2);
																					
																					//	HTML -------------------------------------
																					fprintf(file, "RELAÇÃO INVERSA SUPERIOR: %s<br>", pai);
																					char* ref1 = malloc(((strlen($2)+6+8)*sizeof(char)));
																					char* ref2 = malloc((strlen($2)+6*sizeof(char)));
                                                									sprintf(ref1,"paginas/%s.html",$2);
                                                									sprintf(ref2,"%s.html",conceito);
																					FILE* tmpFile = fopen(ref1, "a");
																					fprintf(tmpFile, "<a href=\"%s\">%s</a><br>", ref2, conceito);
																					//	HTML -------------------------------------
																				
																				}else if(strcmp(strdup($1), tmpFilho) == 0){
																					asprintf(&$$, "FILHO=[%s %s]", $1, $2);
																					filho = strdup($2);
																					fprintf(file, "RELAÇÃO INVERSA INFERIOR: %s<br>", filho);
																				}else if(strcmp(strdup($1), "SN") == 0){
																					scopeNote = strdup($2);
																					asprintf(&$$, "StickNote=[%s %s]", $1, limparUnderscore($2));
																					fprintf(file, "NOTA EXPLICATIVA: %s<br>", limparUnderscore(scopeNote));
																				}
																			}
						| TXT                                               {
																				//	HTML -------------------------------------
																				char* ref = malloc(((strlen($1)+6+8)*sizeof(char)));
                                                								sprintf(ref,"paginas/%s.html",$1);
																				file = fopen(ref, "w");
																				beginHTML(file, strdup($1));
																				//	HTML -------------------------------------

																				conceito = strdup($1);
																				asprintf(&$$, "|%s|", $1);
																			}
						| NEWLINE 	                                        {$$="";}
						;

%%

#include "lex.yy.c"

void yyerror(char *s){
	fprintf(stderr,"Erro:%sLine:%d\n",s, yylineno);
}

int main(){

	system("rm -f -r paginas/");
    system("mkdir paginas/");
    system("rm -r *.html");

	file = fopen("index.html", "w");

	beginHTML(file, "Thesaurus");

	fprintf(file, "<a href=\"paginas/Life.html\">Life</a>");

	//	este código foi a tentativa para o requisito 2 de guardar a info em memória, mas não está funcional
	/*
	conceitos = ARRAY_LIST(10);
	
	NODE novoNo = (NODE)malloc(sizeof(struct node));
	
	novoNo->conceito = "Life";
	novoNo->traducao = "life";
	novoNo->filhos = ARRAY_LIST(10);
	
	addElem(conceitos, novoNo);
	*/

	file = fopen("paginas/Life.html", "w");

	beginHTML(file, "Life");
	yyparse();
}



