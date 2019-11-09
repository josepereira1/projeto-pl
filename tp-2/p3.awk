#!/usr/local/bin

@include "api.awk"

BEGIN{
	RS = "\n"
	FS = " "
}

$4~/V.*/{	# VERBO
	words["verbos"][tolower($2)]++
}

$4~/N.*/{	# SUBSTANTIVO
	words["substantivos"][tolower($2)]++
}

$4~/A.*/{	# ADJETIVO
	words["adjetivos"][tolower($2)]++
}

$4~/R.*/{	# ADVÉRBIO
	words["adverbios"][tolower($2)]++
}

END{
	createHTMLdir()	# remove e cria a pasta html/	
	listing()
	meta()
	footer()
}

# lista as palavras de cada tipo em cada ficheiro
function listing(){
	header("Verbos", "verbos.html")
	header("Substantivos", "substantivos.html")
	header("Adjetivos", "adjetivos.html")
	header("Advérbios", "adverbios.html")

	for(tipo in words){
		PROCINFO["sorted_in"] = "comparator"
		for(palavra in words[tipo]){

			if(tipo~"verbos")verbos = verbos + words[tipo][palavra]
			if(tipo~"substantivos")substantivos = substantivos + words[tipo][palavra]
			if(tipo~"adjetivos")adjetivos = adjetivos + words[tipo][palavra]
			if(tipo~"adverbios")adverbios = adverbios + words[tipo][palavra]

			# escrever para o ficheiro
			print "<li>" > "html/" tipo ".html"
			print palavra drawSpaces(palavra) words[tipo][palavra] > "html/" tipo ".html"
			print "</li>" > "html/" tipo ".html"
		}
	}
}

# usado para ordenar o array pelo número de ocorrências de cada palavra
function comparator(i1, v1, i2, v2){
    if (v1 == v2) return 0;
    else if (v1 > v2) return -1;
    else return 1;
}

# faz um header especial para os ficheiros que vão ter as palavras
function header(title, filename){
	print specialbeginHTML("Listas", "index.html", filename1,title) > "html/" filename
	print "<ul><h3>" > "html/" filename
	if(title~"Verbos") print "<li>Número de palavras do tipo verbo = " length(words["verbos"]) "</li>" > "html/" filename
	if(title~"Substantivos") print "<li>Número de palavras do tipo substantivo = " length(words["substantivos"]) "</li>" > "html/" filename
	if(title~"Adjetivos") print "<li>Número de palavras do tipo adjetivo = " length(words["adjetivos"]) "</li>" > "html/" filename
	if(title~"Advérbios") print "<li>Número de palavras do tipo advérbios= " length(words["adverbios"]) "</li>" > "html/" filename
	print "</ul><ul><li><h3>" title " ------------------> Nº de ocorrências</h2></li>" > "html/" filename 
}

function specialbeginHTML(t1,filename1, filename2, t2){
	return "<html><head><meta charset='UTF-8'/></head><body><h1><a href=" filename1 ">" t1 "</a><a href=" filename2 "> - " t2 "</a></h1>"
}

# cria e estrutura o index.html
function meta(){
	print beginHTML("Listas") > "html/index.html"
	linkListas()
	estatistica()
}

function linkListas(){
	print "<ul><h3>" > "html/index.html"
	print link("verbos.html", "Verbos") > "html/index.html"
	print link("substantivos.html", "Substantivos") > "html/index.html"
	print link("adjetivos.html", "Adjetivos") > "html/index.html"
	print link("adverbios.html", "Advérbios") > "html/index.html"
	print "</h3></ul>" > "html/index.html"
}

function estatistica(){
	print "<br><h2>Estatística:</h2>" > "html/index.html"
	print "<ul><h4>" > "html/index.html"
	print "<li>Número de palavras do tipo verbo = " length(words["verbos"]) "</li>"  > "html/index.html"
	print "<li>Número de palavras do tipo substantivo = " length(words["substantivos"]) "</li>"  > "html/index.html"
	print "<li>Número de palavras do tipo adjetivo = " length(words["adjetivos"]) "</li>"  > "html/index.html"
	print "<li>Número de palavras do tipo advérbio = " length(words["adverbios"]) "</li>"  > "html/index.html"
	print "<li>Total de palavras = " length(words["verbos"]) + length(words["substantivos"]) + length(words["adjetivos"]) + length(words["adverbios"]) "</li>"  > "html/index.html"
	print "<br>" > "html/index.html"
	print "<li>Número de ocorrências de verbos = " verbos "</li>"  > "html/index.html"
	print "<li>Número de ocorrências de substantivos = " substantivos "</li>"  > "html/index.html"
	print "<li>Número de ocorrências de adjetivos = " adjetivos "</li>"  > "html/index.html"
	print "<li>Número de ocorrências de advérbios = " adverbios "</li>"  > "html/index.html"
	print "<li>Total de ocorrências de palavras = " verbos + substantivos + adjetivos + adverbios "</li>"  > "html/index.html"

	print "</h4></ul>" > "html/index.html"
}

# finaliza todos os ficheiros
function footer(){
	finally("index.html",0)
	finally("verbos.html",1)
	finally("substantivos.html",1)
	finally("adjetivos.html",1)
	finally("adverbios.html",1)
}

# finaliza um ficheiro
function finally(filename, flag){
	print "</ul>" > "html/" filename
	if(flag == 1)print "<button type="button"><a href=\"\">IR PARA O TOPO!!!</a></button><br><br>" > "html/" filename
	print endHTML() > "html/" filename
}

function drawSpaces(word){
	res = ""
	spaces = 100 - length(word)
	while(spaces >=0){
		str = "-"
		res = res str
		spaces--
	}
	str = ">"
	res = res str

	return res
}

