#!/usr/local/bin/gawk -f

BEGIN{
	RS = "\n"
	FS = ";"
}

NR > 0 {printf("Nome=%s | Idade=%s | Cidade=%s\n",$1,$2,$3);}
