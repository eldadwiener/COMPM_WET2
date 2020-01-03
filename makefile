# Makefile for part2

part2: part2.tab.c part2.tab.h part2-lex.c part2-lex.h part2_helpers.c part2_helpers.h
	gcc -o $@ part2.tab.c part2-lex.c part2_helpers.c

part2-lex.c part2-lex.h: part2.lex part2_helpers.h part2.tab.h
	flex part2.lex

part2.tab.c part2.tab.h: part2.y part2_helpers.h
	bison -d part2.y

.PHONY: clean
clean:
	rm -f part2 part2-lex.c part2-lex.h *.o part2.tab.c part2.tab.h
