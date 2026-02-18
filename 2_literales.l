/* =====================================================
   Ejercicio 2: Reconocimiento de Literales Numéricos
   ===================================================== 
   
   Este lexer clasifica diferentes tipos de números:
   - Enteros: 123, 0, 9999
   - Flotantes: 3.14, 0.5, 123.456
   - Notación científica: 1.5e10, 3.2E-5, 1e3
   - Hexadecimales: 0xFF, 0x1A2B, 0xDEADBEEF
*/

%{
#include <stdio.h>
#include <stdlib.h>

int int_count = 0;
int float_count = 0;
int scientific_count = 0;
int hex_count = 0;
%}

/* Definiciones de patrones */
DIGIT       [0-9]
HEX_DIGIT   [0-9a-fA-F]

/* Números enteros */
INTEGER     {DIGIT}+

/* Números hexadecimales */
HEX         0[xX]{HEX_DIGIT}+

/* Números flotantes */
FLOAT       {DIGIT}+\.{DIGIT}+

/* Notación científica */
EXPONENT    [eE][+-]?{DIGIT}+
SCIENTIFIC  ({DIGIT}+{EXPONENT})|({DIGIT}+\.{DIGIT}+{EXPONENT})

WHITESPACE  [ \t\n\r]+

%%

{SCIENTIFIC}    {
                    scientific_count++;
                    double val = atof(yytext);
                    printf("SCIENTIFIC: %s = %e\n", yytext, val);
                }

{HEX}           {
                    hex_count++;
                    long val = strtol(yytext, NULL, 16);
                    printf("HEXADECIMAL: %s = %ld (decimal)\n", yytext, val);
                }

{FLOAT}         {
                    float_count++;
                    double val = atof(yytext);
                    printf("FLOAT: %s = %.6f\n", yytext, val);
                }

{INTEGER}       {
                    int_count++;
                    long val = atol(yytext);
                    printf("INTEGER: %s = %ld\n", yytext, val);
                }

{WHITESPACE}    { /* Ignorar espacios en blanco */ }

.               {
                    printf("ERROR: Invalid character '%c'\n", yytext[0]);
                }

%%

int yywrap() {
    return 1;
}

int main(int argc, char **argv) {
    printf("===========================================\n");
    printf("  Numeric Literals Lexer - Exercise 2\n");
    printf("===========================================\n\n");
    
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            fprintf(stderr, "Error: Cannot open file '%s'\n", argv[1]);
            return 1;
        }
        yyin = file;
    }
    
    printf("Enter numbers (Ctrl+D or Ctrl+Z to finish):\n\n");
    
    yylex();
    
    printf("\n===========================================\n");
    printf("  Summary:\n");
    printf("===========================================\n");
    printf("Integers: %d\n", int_count);
    printf("Floats: %d\n", float_count);
    printf("Scientific notation: %d\n", scientific_count);
    printf("Hexadecimals: %d\n", hex_count);
    printf("Total: %d\n", int_count + float_count + scientific_count + hex_count);
    printf("===========================================\n");
    
    if (argc > 1) {
        fclose(yyin);
    }
    
    return 0;
}
