%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int line_num;
extern char* yytext;
void yyerror(const char *s);
char last_col_name[50];

typedef struct Column {
    char name[50];
    int type;
    int max_len;
    struct Column* next;
} Column;

int current_decl_type = 0;

typedef struct Table {
    char name[50];
    Column* cols;
    struct Table* next;
} Table;

typedef struct Alias {
    char alias_name[50];
    char real_table_name[50];
    struct Alias* next;
} Alias;

typedef struct PendingCheck {
    char table_or_alias[50];
    char col_name[50];
    int line;
    struct PendingCheck* next;
} PendingCheck;

Table* table_list = NULL;
Column* current_cols = NULL;
Alias* current_aliases = NULL;
PendingCheck* pending_checks = NULL;
int has_alias = 0;

void add_col_to_list(char* name, int type, int len) {
    Column* temp = current_cols;
    while(temp) {
        if(strcmp(temp->name, name) == 0) {
            fprintf(stderr, "\n--- SEMANTIC ERROR ---\n");
            fprintf(stderr, "Column '%s' is already defined in this table! (Line %d)\n", name, line_num);
            fprintf(stderr, "----------------------\n");
            exit(1);
        }
        temp = temp->next;
    }
    Column* c = malloc(sizeof(Column));
    strcpy(c->name, name);
    c->type = type;
    c->max_len = len;
    c->next = current_cols;
    current_cols = c;
}

void create_table_entry(char* name) {
    Table* t = table_list;
    while(t) {
        if(strcmp(t->name, name) == 0) {
            fprintf(stderr, "\n--- SEMANTIC ERROR: Table '%s' already exists! (Line %d) ---\n", name, line_num);
            exit(1);
        }
        t = t->next;
    }
    Table* new_t = malloc(sizeof(Table));
    strcpy(new_t->name, name);
    new_t->cols = current_cols;
    new_t->next = table_list;
    table_list = new_t;
    current_cols = NULL;
}

void check_table_exists(char* name) {
    Table* t = table_list;
    while(t) {
        if(strcmp(t->name, name) == 0) return;
        t = t->next;
    }
    fprintf(stderr, "\n--- SEMANTIC ERROR: Table '%s' does not exist! (Line %d) ---\n", name, line_num);
    exit(1);
}

void add_alias(char* real, char* al) {
    Alias* a = malloc(sizeof(Alias));
    strcpy(a->real_table_name, real);
    strcpy(a->alias_name, al);
    a->next = current_aliases;
    current_aliases = a;

    if(strcmp(real, al) != 0) has_alias = 1;
}

void add_pending_check(char* t_al, char* col) {
    PendingCheck* p = malloc(sizeof(PendingCheck));
    strcpy(p->table_or_alias, t_al);
    strcpy(p->col_name, col);
    p->line = line_num;
    p->next = pending_checks;
    pending_checks = p;
}

void check_type_match(char* col_name, int lit_type) {
    Alias* a = current_aliases;
    while(a) {
        Table* t = table_list;
        while(t) {
            if(strcmp(t->name, a->real_table_name) == 0) {
                Column* c = t->cols;
                while(c) {
                    if(strcmp(c->name, col_name) == 0) {
                        if (c->type == 0 && lit_type != 0) {
                            fprintf(stderr, "Semantic Error: Column '%s' (INT) incompatible with non-int literal (Line %d)\n", col_name, line_num);
                            exit(1);
                        }
                        if (c->type == 2 && lit_type != 2) {
                            fprintf(stderr, "Semantic Error: Column '%s' (VARCHAR) incompatible with numeric literal (Line %d)\n", col_name, line_num);
                            exit(1);
                        }
                        if (c->type == 1 && lit_type == 2) {
                            fprintf(stderr, "Semantic Error: Column '%s' (FLOAT) incompatible with string literal (Line %d)\n", col_name, line_num);
                            exit(1);
                        }
                        int actual_len = strlen(yytext) - 2;
                        if (c->type == 2 && actual_len > c->max_len) {
                            fprintf(stderr, "Semantic Error: String too long for column '%s' (Max: %d, Found: %d) (Line %d)\n",
                            col_name, c->max_len, actual_len, line_num);
                            exit(1);
                        }
                        return;
                    }
                    c = c->next;
                }
            }
            t = t->next;
        }
        a = a->next;
    }
}

void run_pending_checks() {
    PendingCheck* p = pending_checks;
    while(p) {
        /* Αν υπάρχει alias και η στήλη είναι unqualified → ERROR */
        if(strcmp(p->table_or_alias, "ANY") == 0 && has_alias) {
            fprintf(stderr, "\n--- SEMANTIC ERROR ---\n");
            fprintf(stderr, "Column '%s' must be qualified with alias (e.g. alias.%s) (Line %d)\n", p->col_name, p->col_name, p->line);
            fprintf(stderr, "----------------------\n");
            exit(1);
        }

        int found = 0;
        if (strcmp(p->table_or_alias, "ANY") == 0) {
            Alias* a = current_aliases;
            while(a) {
                Table* t = table_list;
                while(t) {
                    if(strcmp(t->name, a->real_table_name) == 0) {
                        Column* c = t->cols;
                        while(c) {
                            if(strcmp(c->name, p->col_name) == 0) { found = 1; break; }
                            c = c->next;
                        }
                    }
                    if(found) break;
                    t = t->next;
                }
                if(found) break;
                a = a->next;
            }
        } else {
            char* real_table = p->table_or_alias;
            Alias* a = current_aliases;
            while(a) {
                if(strcmp(a->alias_name, p->table_or_alias) == 0) {
                    real_table = a->real_table_name;
                    break;
                }
                a = a->next;
            }
            Table* t = table_list;
            while(t) {
                if(strcmp(t->name, real_table) == 0) {
                    Column* c = t->cols;
                    while(c) {
                        if(strcmp(c->name, p->col_name) == 0) { found = 1; break; }
                        c = c->next;
                    }
                    break;
                }
                t = t->next;
            }
        }

        if(!found) {
            fprintf(stderr, "\n--- SEMANTIC ERROR ---\n");
            fprintf(stderr, "Column '%s' not found in selected tables! (Line %d)\n", p->col_name, p->line);
            fprintf(stderr, "----------------------\n");
            exit(1);
        }
        p = p->next;
    }
    pending_checks = NULL;
    current_aliases = NULL;
    has_alias = 0;
}
%}

%union {
    int int_val;
    float float_val;
    char* str_val;
}

%token <str_val> IDENTIFIER STRING_LITERAL
%token <int_val> INT_LITERAL
%token <float_val> FLOAT_LITERAL
%token SELECT FROM WHERE LIMIT GROUP ORDER BY AS JOIN ON CREATE TABLE
%token INT_TYPE FLOAT_TYPE VARCHAR_TYPE
%token ASTERISK COMMA SEMICOLON LPAREN RPAREN DOT
%token EQ NEQ GT LT GTE LTE
%token IN AND OR NOT

%left OR
%left AND
%right NOT
%nonassoc EQ NEQ GT LT GTE LTE

%%

program: stmts {
    printf("\n----------------------------------\n");
    printf("Code Parsed successfully!\n");
    printf("----------------------------------\n");
};

stmts: stmt | stmts stmt ;
stmt: create_stmt SEMICOLON | select_stmt SEMICOLON ;

create_stmt: CREATE TABLE IDENTIFIER LPAREN cols RPAREN { create_table_entry($3); } ;
cols: col | cols COMMA col ;
col: IDENTIFIER INT_TYPE                                { add_col_to_list($1, 0, 0); }
   | IDENTIFIER FLOAT_TYPE                              { add_col_to_list($1, 1, 0); }
   | IDENTIFIER VARCHAR_TYPE LPAREN INT_LITERAL RPAREN  { add_col_to_list($1, 2, $4); }
   ;

select_stmt: SELECT select_list FROM table_refs join_part where_part group_by_part order_by_part limit_part {
    run_pending_checks();
} ;

table_refs: t_ref | table_refs COMMA t_ref ;
t_ref: IDENTIFIER               { check_table_exists($1); add_alias($1, $1); }
     | IDENTIFIER AS IDENTIFIER { check_table_exists($1); add_alias($1, $3); } ;

join_part:
    | join_part JOIN t_ref ON col_ref EQ col_ref ;

where_part:
    | WHERE condition ;

condition:
      col_ref EQ expr
    | col_ref NEQ expr
    | col_ref GT expr
    | col_ref LT expr
    | col_ref GTE expr
    | col_ref LTE expr
    | col_ref IN LPAREN in_list RPAREN
    | col_ref NOT IN LPAREN in_list RPAREN
    | condition AND condition
    | condition OR condition
    | NOT condition
    | LPAREN condition RPAREN ;

in_list:
      in_list_element
    | in_list COMMA in_list_element ;

in_list_element:
      INT_LITERAL    { check_type_match(last_col_name, 0); }
    | FLOAT_LITERAL  { check_type_match(last_col_name, 1); }
    | STRING_LITERAL { check_type_match(last_col_name, 2); } ;

group_by_part:
    | GROUP BY col_refs ;

order_by_part:
    | ORDER BY col_refs ;

limit_part:
    | LIMIT INT_LITERAL {
        if ($2 <= 0) {
            fprintf(stderr, "\n--- SEMANTIC ERROR: LIMIT value must be strictly positive! (Line %d) ---\n", line_num);
            exit(1);
        }
    } ;

expr:
      INT_LITERAL    { check_type_match(last_col_name, 0); }
    | FLOAT_LITERAL  { check_type_match(last_col_name, 1); }
    | STRING_LITERAL { check_type_match(last_col_name, 2); }
    | col_ref ;

select_list: ASTERISK | col_refs ;
col_refs: col_ref | col_refs COMMA col_ref ;
col_ref: IDENTIFIER DOT IDENTIFIER
         {
            strcpy(last_col_name, $3);
            add_pending_check($1, $3);
         }
       | IDENTIFIER
         {
            strcpy(last_col_name, $1);
            add_pending_check("ANY", $1);
         } ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "\n[!] Syntax Error at line %d (near '%s')\n", line_num, yytext);
}

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            fprintf(stderr, "Could not open file %s\n", argv[1]);
            return 1;
        }
        extern FILE *yyin;
        yyin = file;
    }
    return yyparse();
}