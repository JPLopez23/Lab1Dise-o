/* =====================================================
   Ejercicio 3: Reconocimiento de Operadores
   ===================================================== 
   
   Este lexer reconoce:
   - Operadores aritméticos: +, -, *, /
   - Operadores relacionales: ==, !=, <, >, <=, >=
   - Operadores lógicos: &&, ||, !
*/

%{
#include <stdio.h>

int arith_count = 0;
int relational_count = 0;
int logical_count = 0;
%}

/* Definiciones */
WHITESPACE  [ \t\n\r]+

%%

    /* Operadores relacionales (deben ir antes que < y >) */
"=="            {
                    relational_count++;
                    printf("RELATIONAL_OP: '%s' (Equal)\n", yytext);
                }

"!="            {
                    relational_count++;
                    printf("RELATIONAL_OP: '%s' (Not Equal)\n", yytext);
                }

"<="            {
                    relational_count++;
                    printf("RELATIONAL_OP: '%s' (Less or Equal)\n", yytext);
                }

">="            {
                    relational_count++;
                    printf("RELATIONAL_OP: '%s' (Greater or Equal)\n", yytext);
                }

"<"             {
                    relational_count++;
                    printf("RELATIONAL_OP: '%s' (Less Than)\n", yytext);
                }

">"             {
                    relational_count++;
                    printf("RELATIONAL_OP: '%s' (Greater Than)\n", yytext);
                }

    /* Operadores lógicos */
"&&"            {
                    logical_count++;
                    printf("LOGICAL_OP: '%s' (AND)\n", yytext);
                }

"||"            {
                    logical_count++;
                    printf("LOGICAL_OP: '%s' (OR)\n", yytext);
                }

"!"             {
                    logical_count++;
                    printf("LOGICAL_OP: '%s' (NOT)\n", yytext);
                }

    /* Operadores aritméticos */
"+"             {
                    arith_count++;
                    printf("ARITHMETIC_OP: '%s' (Addition)\n", yytext);
                }

"-"             {
                    arith_count++;
                    printf("ARITHMETIC_OP: '%s' (Subtraction)\n", yytext);
                }

"*"             {
                    arith_count++;
                    printf("ARITHMETIC_OP: '%s' (Multiplication)\n", yytext);
                }

"/"             {
                    arith_count++;
                    printf("ARITHMETIC_OP: '%s' (Division)\n", yytext);
                }

{WHITESPACE}    { /* Ignorar espacios en blanco */ }

[0-9]+          { printf("NUMBER: %s (ignored in this lexer)\n", yytext); }

[a-zA-Z_][a-zA-Z0-9_]*  { 
                    printf("IDENTIFIER: %s (ignored in this lexer)\n", yytext); 
                }

.               {
                    printf("UNKNOWN: '%c'\n", yytext[0]);
                }

%%

int yywrap() {
    return 1;
}

int main(int argc, char **argv) {
    printf("===========================================\n");
    printf("  Operators Lexer - Exercise 3\n");
    printf("===========================================\n\n");
    
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            fprintf(stderr, "Error: Cannot open file '%s'\n", argv[1]);
            return 1;
        }
        yyin = file;
    }
    
    printf("Enter expressions (Ctrl+D or Ctrl+Z to finish):\n\n");
    
    yylex();
    
    printf("\n===========================================\n");
    printf("  Summary:\n");
    printf("===========================================\n");
    printf("Arithmetic operators: %d\n", arith_count);
    printf("Relational operators: %d\n", relational_count);
    printf("Logical operators: %d\n", logical_count);
    printf("Total operators: %d\n", arith_count + relational_count + logical_count);
    printf("===========================================\n");
    
    if (argc > 1) {
        fclose(yyin);
    }
    
    return 0;
}
