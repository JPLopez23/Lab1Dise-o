/* =====================================================
   Ejercicio 6: Analizador Léxico Completo para Java
   ===================================================== 
   
   Este lexer completo combina todos los ejercicios:
   1. Identificadores
   2. Literales numéricos (enteros, flotantes, científicos, hex)
   3. Operadores (aritméticos, relacionales, lógicos)
   4. Comentarios (línea y multilínea)
   5. Strings con escape sequences
   
   Además incluye:
   - Palabras clave de Java
   - Símbolos (paréntesis, llaves, punto y coma, etc.)
   - Manejo de errores léxicos
*/

%{
#include <stdio.h>
#include <string.h>

/* Contadores de tokens */
int keywords = 0;
int identifiers = 0;
int numbers = 0;
int operators = 0;
int strings = 0;
int comments = 0;
int symbols = 0;
int errors = 0;

int line_num = 1;
int col_num = 1;
%}

/* Estados */
%x COMMENT
%x STRING

/* Patrones */
DIGIT       [0-9]
LETTER      [a-zA-Z]
HEX_DIGIT   [0-9a-fA-F]
UNDERSCORE  "_"

ID          ({LETTER}|{UNDERSCORE})({LETTER}|{DIGIT}|{UNDERSCORE})*

INTEGER     {DIGIT}+
HEX         0[xX]{HEX_DIGIT}+
FLOAT       {DIGIT}+\.{DIGIT}+
EXPONENT    [eE][+-]?{DIGIT}+
SCIENTIFIC  ({DIGIT}+{EXPONENT})|({FLOAT}{EXPONENT})

WHITESPACE  [ \t]+
NEWLINE     \n

%%

    /* ===== PALABRAS CLAVE ===== */
"abstract"      { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"boolean"       { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"break"         { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"byte"          { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"case"          { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"catch"         { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"char"          { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"class"         { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"const"         { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"continue"      { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"default"       { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"do"            { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"double"        { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"else"          { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"extends"       { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"final"         { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"finally"       { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"float"         { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"for"           { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"if"            { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"implements"    { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"import"        { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"instanceof"    { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"int"           { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"interface"     { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"long"          { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"new"           { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"package"       { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"private"       { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"protected"     { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"public"        { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"return"        { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"short"         { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"static"        { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"super"         { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"switch"        { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"this"          { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"throw"         { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"throws"        { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"try"           { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"void"          { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"while"         { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }

"true"          { keywords++; printf("Line %d: BOOLEAN_LITERAL: %s\n", line_num, yytext); }
"false"         { keywords++; printf("Line %d: BOOLEAN_LITERAL: %s\n", line_num, yytext); }
"null"          { keywords++; printf("Line %d: NULL_LITERAL: %s\n", line_num, yytext); }

    /* ===== COMENTARIOS ===== */
"//".*          { comments++; /* Comentario de línea - descartado */ }

"/*"            { BEGIN(COMMENT); }
<COMMENT>"*/"   { comments++; BEGIN(INITIAL); }
<COMMENT>\n     { line_num++; }
<COMMENT>.      { /* Dentro del comentario */ }

    /* ===== STRINGS ===== */
\"              { BEGIN(STRING); }
<STRING>\\[nt"\\]   { /* Escape sequence */ }
<STRING>\"      { 
                    strings++; 
                    printf("Line %d: STRING: %s\n", line_num, yytext);
                    BEGIN(INITIAL); 
                }
<STRING>\n      { 
                    errors++;
                    printf("Line %d: ERROR: Unterminated string\n", line_num);
                    line_num++;
                    BEGIN(INITIAL); 
                }
<STRING>.       { /* Carácter en el string */ }

    /* ===== LITERALES NUMÉRICOS ===== */
{SCIENTIFIC}    { numbers++; printf("Line %d: SCIENTIFIC: %s\n", line_num, yytext); }
{HEX}           { numbers++; printf("Line %d: HEX: %s\n", line_num, yytext); }
{FLOAT}         { numbers++; printf("Line %d: FLOAT: %s\n", line_num, yytext); }
{INTEGER}       { numbers++; printf("Line %d: INTEGER: %s\n", line_num, yytext); }

    /* ===== OPERADORES ===== */
"=="            { operators++; printf("Line %d: RELATIONAL_OP: ==\n", line_num); }
"!="            { operators++; printf("Line %d: RELATIONAL_OP: !=\n", line_num); }
"<="            { operators++; printf("Line %d: RELATIONAL_OP: <=\n", line_num); }
">="            { operators++; printf("Line %d: RELATIONAL_OP: >=\n", line_num); }
"<"             { operators++; printf("Line %d: RELATIONAL_OP: <\n", line_num); }
">"             { operators++; printf("Line %d: RELATIONAL_OP: >\n", line_num); }

"&&"            { operators++; printf("Line %d: LOGICAL_OP: &&\n", line_num); }
"||"            { operators++; printf("Line %d: LOGICAL_OP: ||\n", line_num); }
"!"             { operators++; printf("Line %d: LOGICAL_OP: !\n", line_num); }

"+="            { operators++; printf("Line %d: ASSIGN_OP: +=\n", line_num); }
"-="            { operators++; printf("Line %d: ASSIGN_OP: -=\n", line_num); }
"*="            { operators++; printf("Line %d: ASSIGN_OP: *=\n", line_num); }
"/="            { operators++; printf("Line %d: ASSIGN_OP: /=\n", line_num); }

"++"            { operators++; printf("Line %d: INCREMENT: ++\n", line_num); }
"--"            { operators++; printf("Line %d: DECREMENT: --\n", line_num); }

"+"             { operators++; printf("Line %d: ARITHMETIC_OP: +\n", line_num); }
"-"             { operators++; printf("Line %d: ARITHMETIC_OP: -\n", line_num); }
"*"             { operators++; printf("Line %d: ARITHMETIC_OP: *\n", line_num); }
"/"             { operators++; printf("Line %d: ARITHMETIC_OP: /\n", line_num); }
"%"             { operators++; printf("Line %d: ARITHMETIC_OP: %%\n", line_num); }

"="             { operators++; printf("Line %d: ASSIGN: =\n", line_num); }

    /* ===== SÍMBOLOS ===== */
"{"             { symbols++; printf("Line %d: LEFT_BRACE\n", line_num); }
"}"             { symbols++; printf("Line %d: RIGHT_BRACE\n", line_num); }
"("             { symbols++; printf("Line %d: LEFT_PAREN\n", line_num); }
")"             { symbols++; printf("Line %d: RIGHT_PAREN\n", line_num); }
"["             { symbols++; printf("Line %d: LEFT_BRACKET\n", line_num); }
"]"             { symbols++; printf("Line %d: RIGHT_BRACKET\n", line_num); }
";"             { symbols++; printf("Line %d: SEMICOLON\n", line_num); }
","             { symbols++; printf("Line %d: COMMA\n", line_num); }
"."             { symbols++; printf("Line %d: DOT\n", line_num); }

    /* ===== IDENTIFICADORES ===== */
{ID}            { identifiers++; printf("Line %d: IDENTIFIER: %s\n", line_num, yytext); }

    /* ===== ESPACIOS EN BLANCO ===== */
{WHITESPACE}    { /* Ignorar */ }
{NEWLINE}       { line_num++; }

    /* ===== ERRORES ===== */
.               { 
                    errors++; 
                    printf("Line %d: ERROR: Illegal character '%c' (ASCII: %d)\n", 
                           line_num, yytext[0], yytext[0]); 
                }

%%

int yywrap() {
    return 1;
}

int main(int argc, char **argv) {
    printf("==================================================\n");
    printf("  Complete Java Lexer - Exercise 6\n");
    printf("==================================================\n\n");
    
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            fprintf(stderr, "Error: Cannot open file '%s'\n", argv[1]);
            return 1;
        }
        yyin = file;
        printf("Analyzing file: %s\n\n", argv[1]);
    } else {
        printf("Enter Java code (Ctrl+D or Ctrl+Z to finish):\n\n");
    }
    
    yylex();
    
    printf("\n==================================================\n");
    printf("  Lexical Analysis Summary\n");
    printf("==================================================\n");
    printf("Keywords:      %d\n", keywords);
    printf("Identifiers:   %d\n", identifiers);
    printf("Numbers:       %d\n", numbers);
    printf("Strings:       %d\n", strings);
    printf("Operators:     %d\n", operators);
    printf("Symbols:       %d\n", symbols);
    printf("Comments:      %d\n", comments);
    printf("--------------------------------------------------\n");
    printf("Total tokens:  %d\n", keywords + identifiers + numbers + 
                                   strings + operators + symbols);
    printf("Errors:        %d\n", errors);
    printf("Lines:         %d\n", line_num);
    printf("==================================================\n");
    
    if (argc > 1) {
        fclose(yyin);
    }
    
    return 0;
}
