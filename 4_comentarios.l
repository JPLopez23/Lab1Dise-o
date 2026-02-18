/* Ejercicio 4: Reconocimiento de Comentarios */

%{
#include <stdio.h>

int single_line_comments = 0;
int multi_line_comments = 0;
int code_lines = 0;
%}

%x COMMENT

%%

"//".*          {
                    single_line_comments++;
                    printf("// Single-line comment: %s\n", yytext);
                }

"/*"            {
                    BEGIN(COMMENT);
                    printf("/* Multi-line comment started...\n");
                }

<COMMENT>"*/"   {
                    multi_line_comments++;
                    printf("   ...comment ended */\n");
                    BEGIN(INITIAL);
                }

<COMMENT>\n     { }

<COMMENT>.      { }

[a-zA-Z_][a-zA-Z0-9_]*  { 
                    code_lines++;
                    printf("IDENTIFIER: %s\n", yytext); 
                }

[0-9]+          { 
                    code_lines++;
                    printf("NUMBER: %s\n", yytext); 
                }

"+"             { printf("OPERATOR: +\n"); }
"-"             { printf("OPERATOR: -\n"); }
"*"             { printf("OPERATOR: *\n"); }
"/"             { printf("OPERATOR: /\n"); }
"="             { printf("OPERATOR: =\n"); }
";"             { printf("SEMICOLON\n"); }
"{"             { printf("LEFT_BRACE\n"); }
"}"             { printf("RIGHT_BRACE\n"); }
"("             { printf("LEFT_PAREN\n"); }
")"             { printf("RIGHT_PAREN\n"); }

[ \t]+          { }

\n              { }

.               { printf("UNKNOWN: '%c'\n", yytext[0]); }

%%

int yywrap() {
    return 1;
}

int main(int argc, char **argv) {
    printf("===========================================\n");
    printf("  Comments Lexer - Exercise 4\n");
    printf("===========================================\n\n");
    
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            fprintf(stderr, "Error: Cannot open file '%s'\n", argv[1]);
            return 1;
        }
        yyin = file;
    }
    
    printf("Enter code with comments (Ctrl+D to finish):\n\n");
    
    yylex();
    
    printf("\n===========================================\n");
    printf("  Summary:\n");
    printf("===========================================\n");
    printf("Single-line comments (//): %d\n", single_line_comments);
    printf("Multi-line comments: %d\n", multi_line_comments);
    printf("Total comments: %d\n", single_line_comments + multi_line_comments);
    printf("Code tokens: %d\n", code_lines);
    printf("===========================================\n");
    
    if (argc > 1) {
        fclose(yyin);
    }
    
    return 0;
}
