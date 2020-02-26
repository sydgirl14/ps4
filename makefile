all: ps4 expression_tests

ps4: expression.ml
	ocamlbuild -use-ocamlfind expression.byte

expression_tests: expression_tests.ml
	ocamlbuild -use-ocamlfind expression_tests.byte

clean:
	rm -rf _build *.byte
