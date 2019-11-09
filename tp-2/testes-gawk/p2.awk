#!/usr/local/bin/awk

BEGIN{
	FS=";"
	RS="\n"
	print beginHTML("Página html de teste")
}

NR >= 0			{ 
					pessoas[$1] = "id = " $1 " | nome = " $2 " | idade = " $3 " | cidade = " $4
				}

END{
	for(id in pessoas){
		print link(id ".html", pessoas[id])
		print beginHTML(pessoas[id]) > id ".html"
		print endHTML()
	}
	print endHTML()
}

function beginHTML(t){
	return "<html><head><meta charset='UTF-8'/></head><body><h1>" t "</h1>"
}

function endHTML(){
	return "</body></html>"
}
	
function link(u,pessoa){
	return "<li><a href='" u "'>" pessoa "</a></li><br>"
}