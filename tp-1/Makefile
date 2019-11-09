GLIB=`pkg-config --cflags --libs glib-2.0`
CFLAGS= -Wall $(GLIB)
CFILES=$(wildcard *.c) lex.yy.c

parse: parse.fl
	flex parse.fl
	cc $(CFLAGS) -o parse $(CFILES)

install: parse
	cp -f parse /usr/local/bin/

uninstall: clean
	rm -f /usr/local/bin/parse

clean:
	rm -f lex.yy.c 
	rm -f parse
	rm -f *.txt
	rm -f *.html
	rm -f -r paginas/
