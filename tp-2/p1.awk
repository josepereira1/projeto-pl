#!/usr/local/bin/gawk -f

BEGIN {
	RS = "\n\n"
}

END {
	print "Número de extratos => " NR
}