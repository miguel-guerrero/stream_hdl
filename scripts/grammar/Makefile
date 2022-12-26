# VER=4.5.3
VER=4.11.1
CP=.:./bins/antlr-$(VER)-complete.jar
antlr4=java -cp ${CP} -jar /usr/local/lib/antlr-$(VER)-complete.jar 
grun=java org.antlr.v4.gui.TestRig

all: build test

build: shdlLexer.py shdlListener.py shdlParser.py

shdlLexer.py shdlListener.py shdlParser.py: shdl.g
	$(antlr4) -Dlanguage=Python3 shdl.g

#grun shdl top -tokens -tree test1.shdl

test: shdlLexer.py shdlListener.py shdlParser.py ./shdlTest.py test1.shdl
	./shdlTest.py test1.shdl

clean:
	$(RM) -r shdlLexer.py shdlListener.py shdlParser.py __pycache__ *.tokens
