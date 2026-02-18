/* Ejercicio 5: Cadenas Literales con Escape Sequences */

%{
#include <stdio.h>
#include <string.h>

int string_count = 0;

void print_string_content(const char *str) {
    int len = strlen(str);
    printf("   Raw content: %s\n", str);
    printf("   Interpreted: \"");
    
    for (int i = 1; i < len - 1; i++) {
        if (str[i] == '\\' && i + 1 < len - 1) {
            switch (str[i + 1]) {
                case 'n':
                    printf("\\n");
                    i++;
                    break;
                case 't':
                    printf("\\t");
                    i++;
                    break;
                case '"':
                    printf("\\\"");
                    i++;
                    break;
                case '\\':
                    printf("\\\\");
                    i++;
                    break;
                default:
                    printf("%c", str[i]);
            }
        } else {
            printf("%c", str[i]);
        }
    }
    printf("\"\n");
}
%}

%x STRING

ESCAPE_SEQ  \\[nt"\\]

%%

\"              {
                    BEGIN(STRING);
                    string_count++;
                    printf("STRING #%d started:\n", string_count);
                }

<STRING>{ESCAPE_SEQ}    { }

<STRING>\"      {
                    printf("STRING: ");
                    print_string_content(yytext);
                    BEGIN(INITIAL);
                }

<STRING>\n      {
                    printf("ERROR: Unterminated string at line\n");
                    BEGIN(INITIAL);
                }

<STRING>.       { }

[a-zA-Z_][a-zA-Z0-9_]*  { printf("IDENTIFIER: %s\n", yytext); }

[0-9]+          { printf("NUMBER: %s\n", yytext); }

"+"             { printf("PLUS\n"); }
"="             { printf("ASSIGN\n"); }
";"             { printf("SEMICOLON\n"); }

[ \t\n]+        { }

.               { printf("UNKNOWN: '%c'\n", yytext[0]); }

%%

int yywrap() {
    return 1;
}

int main(int argc, char **argv) {
    printf("===========================================\n");
    printf("  String Literals Lexer - Exercise 5\n");
    printf("===========================================\n\n");
    
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            fprintf(stderr, "Error: Cannot open file '%s'\n", argv[1]);
            return 1;
        }
        yyin = file;
    }
    
    printf("Enter strings (Ctrl+D to finish):\n\n");
    
    yylex();
    
    printf("\n===========================================\n");
    printf("  Summary:\n");
    printf("===========================================\n");
    printf("Strings found: %d\n", string_count);
    printf("===========================================\n");
    
    if (argc > 1) {
        fclose(yyin);
    }
    
    return 0;
}
