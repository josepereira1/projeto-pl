#!/usr/local/bin/gawk -f

BEGIN {
	RS = "\n"  			# Register Seprator
	FS = ";" 			# Field Separator 

	print beginHTML("HTML GENERATED FILE")
}

{ 
	tFields += NF

	split($2, str, "")
	c = str[1]

	if (c == "R" || c == "J") {
		pLines++
		pFields += NF

		id = $1
		nome = $2
		idade = $3
		cidade = $4

		data[id "id"] = id
		data[id "nome"] = nome
		data[id "idade"] = idade
		data[id "cidade"] = cidade

		len++;
	}
	
}

END {
	printData()
	printEstatisticas()
	print endHTML()
}

function printData() {
	print "<ul>"
	for(i=0; i<len; i++) {
		id = data[i "id"]
		nome = data[i "nome"]
		idade = data[i "idade"]
		cidade = data[i "cidade"]
		
		genPersonHTML(id, nome, idade, cidade)
	}
	print "</ul>"
}


function genPersonHTML(id, nome, idade, cidade) {
	print "<li><a href=" id ".html> [" id "] " nome "</a></li>"

	print beginHTML(nome) > id ".html"

	print "<ul>" > id ".html"
	print "<li>id=" id "</li>" > id ".html"
	print "<li>idade=" idade "</li>" > id ".html"
	print "<li>cidade=" cidade "</li>" > id ".html"
	print "</ul>" > id ".html"

	print endHTML() > id ".html" 
}


function printEstatisticas() {
	print "<h2>Estatisticas</h2>"
	print "<b>number of processed lines: " pLines" </b><br>"
	print "<b>number of processed fields " pFields "</b>"
	print "<br><br>"
	print "<b>total number of lines: " NR "</b><br>"
	print "<b>total number of fields " tFields "</b>"
}


function beginHTML(title) {
	return "<html><head><meta charset='UTF-8'/></head><body><h1>" title "</h1>"
}


function endHTML() {
	return "</body></html>"
}