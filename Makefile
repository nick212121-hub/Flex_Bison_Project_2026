
CC = gcc
LIBS = -lfl

TARGET = my_sql_parser
all: $(TARGET)

$(TARGET): lex.yy.c parser.tab.c
	$(CC) -o $(TARGET) parser.tab.c lex.yy.c $(LIBS)

parser.tab.c parser.tab.h: parser.y
	bison -d parser.y

lex.yy.c: lexer.l parser.tab.h
	flex lexer.l


clean:
	rm -f $(TARGET) lex.yy.c parser.tab.c parser.tab.h *.exe