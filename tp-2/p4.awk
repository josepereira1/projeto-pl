#!/usr/local/bin/gawk -f

@include "api.awk"


BEGIN {
	RS = "\n"
	FS = " "
}

#  VERBO     NOME     ADJETIVO    ADVERBIO   PREPOSIÇÂO  DETERMINANTE  CONJUNÇÂO    PRONOME
$4~/V.*/ || $4~/N.*/ || $4~/A.*/ || $4~/R.*/ || $4~/S.*/ || $4~/D.*/ || $4~/C.*/ || $4~/P.*/ { 	
	
	#      LEMA         WORD       TAG
	dic[tolower($3)][tolower($2)] = $4 
}


END {
	createHTMLdir()
	print beginHTML("DICIONÁRIO") > "html/index.html"

	# percorre a matriz com ordenação alfabética
	PROCINFO["sorted_in"] = "comparator" 

	# imprimir o link no index.html para cada letra 
	# e imprimir o header em cada página {A,B,C, ...}
	for(i=65; i<=90; i++) {
		href = sprintf("_%c_.html", i)
		text = sprintf("%c", i)
		print link(href, text) > "html/index.html"
		print beginHTML(text) > "html/" href
	}
	
	for (lema in dic) {
		
		split(lema, str, "")
		c = toupper(str[1]) 

		# garante que por exemplo a palavra "à" ou "á" fica na página "A"
		if (     c~/Á/ || c~/À/ || c~/Â/ || c~/Ã/) c = "A"
		else if (c~/É/ || c~/È/ || c~/Ê/ )         c = "E"
		else if (c~/Í/ || c~/Ì/ || c~/Î/ )         c = "I"
		else if (c~/Ó/ || c~/Ò/ || c~/Ô/ || c~/Õ/) c = "O"
		else if (c~/Ú/ || c~/Ù/ || c~/Û/ || c~/Û/) c = "U"

		# imprime o link para o lema no index.html
		print link(lema ".html", lema) > "html/_" c "_.html" 

		# imprimir a página de cada lema
		printLemaHTML() 
    }
 
    # imprimir o footer em cada página {A,B,C, ...}
    # e imprimir o botão (ir para o topo)
    for(i=65; i<=90; i++) {
		href = sprintf("_%c_.html", i)
		print "<br><br><button type=button><a href=>ir para o topo</a></button><br><br>" > "html/" href
		print endHTML() > "html/" href
	}

	printEstatistica()
	print endHTML() > "html/index.html"
}


function printEstatistica(){
	print "<br><h2>Estatística:</h2>" > "html/index.html"
	print "<ul><h4>" > "html/index.html"
	print "<li>nº nomes -> " n_nomes "<br></li>" > "html/index.html"
	print "<li>nº adjetivos -> " n_adjetivos "<br></li>" > "html/index.html"
	print "<li>nº adverbios -> " n_adverbios "<br></li>" > "html/index.html"
	print "<li>nº preposicoes -> " n_preposicoes "<br></li>" > "html/index.html"
	print "<li>nº determinantes -> " n_determinantes "<br></li>" > "html/index.html"
	print "<li>nº conjuncoes -> " n_conjuncoes "<br></li>" > "html/index.html"
	print "<li>nº pronomes -> " n_pronomes "<br></li>" > "html/index.html"
	total = n_verbos + n_nomes + n_adjetivos + n_adverbios + n_preposicoes + n_determinantes + n_conjuncoes + n_pronomes
	print "<li>total de palavras -> " total "<br><br></li>" > "html/index.html"
	print "</h4></ul>" > "html/index.html"
}


function printLemaHTML() {
	path = "html/" lema ".html" # caminho para a página do lema
	
	print beginHTML(lema) > path
	print "<ul><li>palavra - [TAG] - descrição extensa</li></ul>" > path

	print "<ul>" > path
	for(word in dic[lema]) {
		tag = dic[lema][word]
		split(tag, str, "")
		
		print "<li>" word " - " > path

		# imprimir a TAG
		print "<b style=color:gray;>[" tag "]</b> - " > path	

		if (tag~/V.*/) {
			printVerbo()
			n_verbos++
		}
		else if (tag~/N.*/) {
			printNome() 
			n_nomes++
		}
		else if (tag~/A.*/) {
			printAdjetivo()
			n_adjetivos++
		}
		else if (tag~/R.*/) {
			printAdverbio()
			n_adverbios++
		}
		else if (tag~/S.*/) {
			printPreposicao()
			n_preposicoes++
		}
		else if (tag~/D.*/) {
			printDeterminante()
			n_determinantes++
		}
		else if (tag~/C.*/) {
			printConjuncao()
			n_conjuncoes++
		}
		else if (tag~/P.*/) {
			printPronome()
			n_pronomes++
		}
		print "</li>" > path
	}
	print "</ul>" > path

	# imprime o botão para ir para o TOPO
	print "<br><br><button type=button><a href=>ir para o topo</a></button><br><br>" > path

	print endHTML() > path
}


function printPronome() {
	print "<b style=color:red;>pronome</b>" > path
}


function printConjuncao() {
	print "<b style=color:red;>conjuncão</b>" > path
}


function printDeterminante() {
	print "<b style=color:red;>determinante</b>" > path
}


function printPreposicao() {
	print "<b style=color:red;>preposição</b>" > path
}


function printAdverbio() {
	print "<b style=color:red;>advérbio</b>" > path
}


function printAdjetivo() {

	# 1 A -> nome
	# -----------------------
	# 2 t -> tipo
	# 3 gen -> género
	# 4 num -> cardinalidade

	print "<b style=color:red;>adjetivo</b>" > path
}


function printNome() {

	# 1 N -> nome
	# -----------------------
	# 2 t -> tipo
	# 3 gen -> género
	# 4 num -> cardinalidade

	print "<b style=color:red;>nome</b>" > path

	t = str[2]; # tipo -> tem sempre
	if (t != "0") {  
		print "<b style=color:red;>" > path
		if (t == "P") print " próprio" > path
		else if (t == "C") print " comum" > path
		else print "___AINDA_SEM_TIPO___" > path
		print "</b>" > path
	}

	printGenero(str[3])
	printCardinalidade(str[4])
}


function printVerbo() {

	# 1 V -> verbo
	# 2 M -> main
	# -----------------------
	# 3 m -> modo
	# 4 t -> tipo
	# 5 p -> pessoa
	# 6 num -> cardinalidade
	# 7 gen -> género	

	print "<b style=color:red;>verbo</b>" > path

	m = str[3] # modo -> tem sempre
	if (m != "0") {
		print " no modo <b style=color:red;>" > path
		if (m == "I") print "indicativo" > path
		else if (m == "S") print "conjuntivo" > path
		else if (m == "G") print "gerúndio" > path
		else if (m == "N") print "infinitivo" > path
		else if (m == "P") print "particípio" > path
		else print "___AINDA_SEM_MODO___" > path
		print "</b>" > path
	}
	
	t = str[4]; # tipo -> pode não não ter (ex: gerúndio ou infinitivo)
	if (t != "0") {  
		print " no <b style=color:red;>" > path
		if (t == "P") print "presente" > path
		else if (t == "S") print "pretérito perfeito" > path
		else if (t == "I") print "pretérito imperfeito" > path
		else if (t == "M") print "pretérito mais que perfeito" > path
		else if (t == "C") print "condicional" > path
		else if (t == "F") print "futuro" > path
		else print "___AINDA_SEM_TEMPO___" > path
		print "</b>" > path
	}
	
	p = str[5] # pessoa -> pode não ter 
	if (p != "0") print " na <b style=color:red;>" p "</b> pessoa" > path
	
	printCardinalidade(str[6])
	printGenero(str[7])
}


function printCardinalidade(num) {

	if (num != "0") {
		print " no <b style=color:red;>" > path
		if (num == "S") print "singular" > path
		else print "plural" > path
		print "</b>" > path
	}
}


function printGenero(gen) {
	if (gen != 0) {
		print " no" > path
		print "<b style=color:red;>" > path
		if (gen == "F") print "feminino" > path
		else print "masculino" > path
		print "</b>" > path
	}
}


function comparator(i1, v1, i2, v2) { # ordena por ordem alfabética

	word1 = i1
	word2 = i2

	if (word1 == word2) return 0;
    else if (word1 > word2) return 1;
    else return -1;
}