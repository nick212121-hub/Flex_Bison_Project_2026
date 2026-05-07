%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "parser.tab.h"
int line_num = 1;
extern int lexical_error;
%}

%option noyywrap

%x COMMENT

%%

"/*"        { printf("/*"); BEGIN(COMMENT); }
<COMMENT>"*/"   { printf("*/"); BEGIN(INITIAL); }
<COMMENT>\n     { printf("\n"); line_num++; }
<COMMENT>.      { printf("%s", yytext); }
<COMMENT><<EOF>> { printf("\nLexical Error: Unclosed comment at line %d\n", line_num); exit(1); }

[Ii][Nn]                                    { printf("%s", yytext); return IN; }
[Ss][Ee][Ll][Ee][Cc][Tt]                    { printf("%s ", yytext); return SELECT; }
[Ff][Rr][Oo][Mm]                            { printf("%s ", yytext); return FROM; }
[Ww][Hh][Ee][Rr][Ee]                        { printf("%s ", yytext); return WHERE; }
[Ll][Ii][Mm][Ii][Tt]                        { printf("%s ", yytext); return LIMIT; }
[Gg][Rr][Oo][Uu][Pp]                        { printf("%s ", yytext); return GROUP; }
[Oo][Rr][Dd][Ee][Rr]                        { printf("%s ", yytext); return ORDER; }
[Bb][Yy]                                    { printf("%s ", yytext); return BY; }
[Aa][Ss]                                    { printf("%s ", yytext); return AS; }
[Jj][Oo][Ii][Nn]                            { printf("%s ", yytext); return JOIN; }
[Oo][Nn]                                    { printf("%s ", yytext); return ON; }
[Cc][Rr][Ee][Aa][Tt][Ee]                    { printf("%s ", yytext); return CREATE; }
[Tt][Aa][Bb][Ll][Ee]                        { printf("%s ", yytext); return TABLE; }
[Ii][Nn][Tt]                                { printf("%s ", yytext); return INT_TYPE; }
[Ff][Ll][Oo][Aa][Tt]                        { printf("%s ", yytext); return FLOAT_TYPE; }
[Vv][Aa][Rr][Cc][Hh][Aa][Rr]               { printf("%s ", yytext); return VARCHAR_TYPE; }
[Aa][Nn][Dd]                                { printf(" %s ", yytext); return AND; }
[Oo][Rr]                                    { printf(" %s ", yytext); return OR; }
[Nn][Oo][Tt]                                { printf(" %s ", yytext); return NOT; }

"*"         { printf("%s", yytext); return ASTERISK; }
","         { printf("%s ", yytext); return COMMA; }
";"         { printf("%s\n", yytext); return SEMICOLON; }
"("         { printf("%s", yytext); return LPAREN; }
")"         { printf("%s", yytext); return RPAREN; }
"."         { printf("%s", yytext); return DOT; }
"!="        { printf(" %s ", yytext); return NEQ; }
">="        { printf(" %s ", yytext); return GTE; }
"<="        { printf(" %s ", yytext); return LTE; }
"="         { printf(" %s ", yytext); return EQ; }
">"         { printf(" %s ", yytext); return GT; }
"<"         { printf(" %s ", yytext); return LT; }

-[0-9]+\.[0-9]+         { printf("%s", yytext); yylval.float_val = atof(yytext); return FLOAT_LITERAL; }
-[0-9]+                 { printf("%s", yytext); yylval.int_val = atoi(yytext); return INT_LITERAL; }
[0-9]+\.[0-9]+          { printf("%s", yytext); yylval.float_val = atof(yytext); return FLOAT_LITERAL; }
[0-9]+                  { printf("%s", yytext); yylval.int_val = atoi(yytext); return INT_LITERAL; }
[a-zA-Z_][a-zA-Z0-9_]* { printf("%s", yytext); yylval.str_val = strdup(yytext); return IDENTIFIER; }
\'([^'\n]|'')*\'        { printf("%s", yytext); yylval.str_val = strdup(yytext); return STRING_LITERAL; }

"--".*      { printf("%s", yytext); }
[ \t\r]+    { printf("%s", yytext); }
\n          { printf("\n"); line_num++; }
. { printf("\nLexical Error at line %d: %s\n", line_num, yytext); lexical_error = 1; exit(1); }
%%