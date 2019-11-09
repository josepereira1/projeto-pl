#!/usr/local/bin/gawk -f

@include "api.awk"

BEGIN {
	RS = "\n"
	FS = " "
}


$4~/NP.*/ {
	counter[tolower($2)]++
}


END {
	createHTMLdir()
	print beginHTML("Contador de Ocorrências de Nomes Próprios") > "html/index.html"
	print "<ul>" > "html/index.html"
	
	# https://www.gnu.org/software/gawk/manual/html_node/Controlling-Array-Traversal.html#Controlling-Array-Traversal
	# alterar a forma como o for() itera o array
	PROCINFO["sorted_in"] = "comparator"
	for(nome in counter) {
		c = counter[nome]
		print listItem(nome " -> " c) > "html/index.html"
	}

	print "</ul>" > "html/index.html"
	print endHTML() > "html/index.html"
}


function comparator(i1, v1, i2, v2)
{
    if (v1 == v2) return 0;
    else if (v1 > v2) return -1;
    else return 1;
}