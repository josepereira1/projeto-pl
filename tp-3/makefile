compile: thesaurus.fl thesaurus.y
	flex thesaurus.fl
	yacc -W thesaurus.y
	cc -o thesaurus y.tab.c -ly -lm include/ArrayList.c -I include/ArrayList.h

run: exemplos/exemplo4
	./thesaurus < exemplos/exemplo4

install: compile thesaurus lex.yy.c y.tab.c
	cp -f thesaurus /usr/local/bin/

uninstall: clean
	rm -f /usr/local/bin/thesaurus

clean: 
	rm -f -r paginas/
	rm -f -r index.html
	rm -f -r lex.yy.c
	rm -f -r thesaurus
	rm -f -r y.tab.c
