/* =====================================================
   Ejercicio 1: Reconocimiento de Identificadores Java
   ===================================================== 
   
   Este lexer reconoce identificadores válidos en Java:
   - Comienzan con letra (a-z, A-Z) o guion bajo (_)
   - Seguidos de letras, dígitos (0-9) o guiones bajos
   
   Ejemplos válidos:
     variable, _temp, count123, myVar, _private
   
   Ejemplos inválidos:
     123abc (comienza con dígito)
     my-var (contiene guion)
     @variable (contiene carácter ilegal)
*/

%{
#include <stdio.h>
#include <string.h>

int identifier_count = 0;
int error_count = 0;
%}

/* Definiciones de patrones */
LETTER      [a-zA-Z]
DIGIT       [0-9]
UNDERSCORE  "_"
IDENTIFIER  ({LETTER}|{UNDERSCORE})({LETTER}|{DIGIT}|{UNDERSCORE})*
WHITESPACE  [ \t\n\r]+

%%

{IDENTIFIER}    {
                    identifier_count++;
                    printf("✓ IDENTIFIER: '%s' (length: %lu)\n", 
                           yytext, strlen(yytext));
                }

{WHITESPACE}    { /* Ignorar espacios en blanco */ }

{DIGIT}+        {
                    error_count++;
                    printf("✗ ERROR: '%s' - Cannot start with digit\n", yytext);
                }

.               {
                    error_count++;
                    printf("✗ ERROR: Illegal character '%c' (ASCII: %d)\n", 
                           yytext[0], yytext[0]);
                }

%%

int yywrap() {
    return 1;
}

int main(int argc, char **argv) {
    printf("===========================================\n");
    printf("  Java Identifier Lexer - Exercise 1\n");
    printf("===========================================\n\n");
    
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            fprintf(stderr, "Error: Cannot open file '%s'\n", argv[1]);
            return 1;
        }
        yyin = file;
    }
    
    printf("Enter identifiers (Ctrl+D or Ctrl+Z to finish):\n\n");
    
    yylex();
    
    printf("\n===========================================\n");
    printf("  Summary:\n");
    printf("===========================================\n");
    printf("Valid identifiers found: %d\n", identifier_count);
    printf("Errors found: %d\n", error_count);
    printf("===========================================\n");
    
    if (argc > 1) {
        fclose(yyin);
    }
    
    return 0;
}
