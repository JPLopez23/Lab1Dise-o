/* =====================================================
   Ejercicio 7: Analizador Léxico para Rust
   ===================================================== 
   
   Este lexer reconoce características específicas de Rust:
   - Lifetimes: 'a, 'static, 'b
   - Macros: println!, vec!, format!
   - Palabras clave: fn, let, mut, impl, trait, match
   - Referencias: &, &mut
   - Range operators: .., ..=
   - Pattern matching
*/

%{
#include <stdio.h>
#include <string.h>

int keywords = 0;
int identifiers = 0;
int numbers = 0;
int operators = 0;
int strings = 0;
int comments = 0;
int lifetimes = 0;
int macros = 0;
int symbols = 0;
int errors = 0;

int line_num = 1;
%}

%x COMMENT
%x STRING

DIGIT       [0-9]
LETTER      [a-zA-Z]
UNDERSCORE  "_"
ID          ({LETTER}|{UNDERSCORE})({LETTER}|{DIGIT}|{UNDERSCORE})*

INTEGER     {DIGIT}+
FLOAT       {DIGIT}+\.{DIGIT}+
HEX         0[xX][0-9a-fA-F]+
BINARY      0[bB][01]+
OCTAL       0[oO][0-7]+

LIFETIME    '({LETTER}|{UNDERSCORE})({LETTER}|{DIGIT}|{UNDERSCORE})*
MACRO       {ID}!

WHITESPACE  [ \t]+
NEWLINE     \n

%%

    /* ===== PALABRAS CLAVE DE RUST ===== */
"as"            { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"async"         { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"await"         { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"break"         { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"const"         { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"continue"      { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"crate"         { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"dyn"           { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"else"          { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"enum"          { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"extern"        { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"false"         { keywords++; printf("Line %d: BOOLEAN: %s\n", line_num, yytext); }
"fn"            { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"for"           { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"if"            { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"impl"          { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"in"            { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"let"           { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"loop"          { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"match"         { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"mod"           { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"move"          { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"mut"           { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"pub"           { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"ref"           { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"return"        { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"self"          { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"Self"          { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"static"        { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"struct"        { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"super"         { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"trait"         { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"true"          { keywords++; printf("Line %d: BOOLEAN: %s\n", line_num, yytext); }
"type"          { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"unsafe"        { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"use"           { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"where"         { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }
"while"         { keywords++; printf("Line %d: KEYWORD: %s\n", line_num, yytext); }

    /* Tipos primitivos */
"i8"|"i16"|"i32"|"i64"|"i128"|"isize"       { keywords++; printf("Line %d: TYPE: %s\n", line_num, yytext); }
"u8"|"u16"|"u32"|"u64"|"u128"|"usize"       { keywords++; printf("Line %d: TYPE: %s\n", line_num, yytext); }
"f32"|"f64"                                 { keywords++; printf("Line %d: TYPE: %s\n", line_num, yytext); }
"bool"|"char"|"str"                         { keywords++; printf("Line %d: TYPE: %s\n", line_num, yytext); }

    /* ===== LIFETIMES ===== */
{LIFETIME}      {
                    lifetimes++;
                    printf("Line %d: LIFETIME: %s\n", line_num, yytext);
                }

    /* ===== MACROS ===== */
{MACRO}         {
                    macros++;
                    printf("Line %d: MACRO: %s\n", line_num, yytext);
                }

    /* ===== COMENTARIOS ===== */
"//".*          { comments++; /* Comentario de línea */ }

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
{BINARY}        { numbers++; printf("Line %d: BINARY: %s\n", line_num, yytext); }
{OCTAL}         { numbers++; printf("Line %d: OCTAL: %s\n", line_num, yytext); }
{HEX}           { numbers++; printf("Line %d: HEX: %s\n", line_num, yytext); }
{FLOAT}         { numbers++; printf("Line %d: FLOAT: %s\n", line_num, yytext); }
{INTEGER}       { numbers++; printf("Line %d: INTEGER: %s\n", line_num, yytext); }

    /* ===== OPERADORES ESPECÍFICOS DE RUST ===== */
"..="           { operators++; printf("Line %d: RANGE_INCLUSIVE: ..=\n", line_num); }
".."            { operators++; printf("Line %d: RANGE: ..\n", line_num); }
"->"            { operators++; printf("Line %d: ARROW: ->\n", line_num); }
"=>"            { operators++; printf("Line %d: FAT_ARROW: =>\n", line_num); }
"::"            { operators++; printf("Line %d: PATH_SEP: ::\n", line_num); }

    /* Referencias y mutabilidad */
"&mut"          { operators++; printf("Line %d: MUT_REF: &mut\n", line_num); }
"&"             { operators++; printf("Line %d: REF: &\n", line_num); }

    /* Operadores relacionales */
"=="            { operators++; printf("Line %d: EQUAL: ==\n", line_num); }
"!="            { operators++; printf("Line %d: NOT_EQUAL: !=\n", line_num); }
"<="            { operators++; printf("Line %d: LESS_EQUAL: <=\n", line_num); }
">="            { operators++; printf("Line %d: GREATER_EQUAL: >=\n", line_num); }
"<"             { operators++; printf("Line %d: LESS: <\n", line_num); }
">"             { operators++; printf("Line %d: GREATER: >\n", line_num); }

    /* Operadores lógicos */
"&&"            { operators++; printf("Line %d: AND: &&\n", line_num); }
"||"            { operators++; printf("Line %d: OR: ||\n", line_num); }
"!"             { operators++; printf("Line %d: NOT: !\n", line_num); }

    /* Operadores de asignación */
"+="            { operators++; printf("Line %d: ADD_ASSIGN: +=\n", line_num); }
"-="            { operators++; printf("Line %d: SUB_ASSIGN: -=\n", line_num); }
"*="            { operators++; printf("Line %d: MUL_ASSIGN: *=\n", line_num); }
"/="            { operators++; printf("Line %d: DIV_ASSIGN: /=\n", line_num); }

    /* Operadores aritméticos */
"+"             { operators++; printf("Line %d: PLUS: +\n", line_num); }
"-"             { operators++; printf("Line %d: MINUS: -\n", line_num); }
"*"             { operators++; printf("Line %d: STAR: *\n", line_num); }
"/"             { operators++; printf("Line %d: SLASH: /\n", line_num); }
"%"             { operators++; printf("Line %d: PERCENT: %%\n", line_num); }

"="             { operators++; printf("Line %d: ASSIGN: =\n", line_num); }

    /* ===== SÍMBOLOS ===== */
"{"             { symbols++; printf("Line %d: LEFT_BRACE\n", line_num); }
"}"             { symbols++; printf("Line %d: RIGHT_BRACE\n", line_num); }
"("             { symbols++; printf("Line %d: LEFT_PAREN\n", line_num); }
")"             { symbols++; printf("Line %d: RIGHT_PAREN\n", line_num); }
"["             { symbols++; printf("Line %d: LEFT_BRACKET\n", line_num); }
"]"             { symbols++; printf("Line %d: RIGHT_BRACKET\n", line_num); }
";"             { symbols++; printf("Line %d: SEMICOLON\n", line_num); }
":"             { symbols++; printf("Line %d: COLON\n", line_num); }
","             { symbols++; printf("Line %d: COMMA\n", line_num); }
"."             { symbols++; printf("Line %d: DOT\n", line_num); }
"|"             { symbols++; printf("Line %d: PIPE\n", line_num); }

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
    printf("  Rust Lexer - Exercise 7\n");
    printf("==================================================\n\n");
    
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            fprintf(stderr, "Error: Cannot open file '%s'\n", argv[1]);
            return 1;
        }
        yyin = file;
        printf("Analyzing Rust file: %s\n\n", argv[1]);
    } else {
        printf("Enter Rust code (Ctrl+D or Ctrl+Z to finish):\n\n");
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
    printf("Lifetimes:     %d (Rust-specific)\n", lifetimes);
    printf("Macros:        %d (Rust-specific)\n", macros);
    printf("Comments:      %d\n", comments);
    printf("--------------------------------------------------\n");
    printf("Total tokens:  %d\n", keywords + identifiers + numbers + 
                                   strings + operators + symbols + 
                                   lifetimes + macros);
    printf("Errors:        %d\n", errors);
    printf("Lines:         %d\n", line_num);
    printf("==================================================\n");
    
    if (argc > 1) {
        fclose(yyin);
    }
    
    return 0;
}
