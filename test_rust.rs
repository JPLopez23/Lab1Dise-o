// Test file for Rust lexer
// Este archivo contiene diversas construcciones de Rust

// Función con lifetimes
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() {
        x
    } else {
        y
    }
}

// Struct con lifetimes
struct ImportantExcerpt<'a> {
    part: &'a str,
}

// Implementación de trait
impl<'a> ImportantExcerpt<'a> {
    fn level(&self) -> i32 {
        3
    }
}

// Función principal con macros
fn main() {
    // Variables mutables e inmutables
    let x = 5;
    let mut y = 10;
    
    // Referencias mutables e inmutables
    let r1 = &x;
    let r2 = &mut y;
    
    // Tipos numéricos
    let entero: i32 = 42;
    let flotante: f64 = 3.14159;
    let hexadecimal: u32 = 0xFF;
    let binario: u8 = 0b1010;
    let octal: u16 = 0o77;
    
    // Strings
    let mensaje = "Hola mundo";
    let escapado = "Línea 1\nLínea 2\t\"quoted\"";
    
    // Macros comunes
    println!("El valor de x es: {}", x);
    vec![1, 2, 3, 4, 5];
    format!("x = {}, y = {}", x, y);
    
    // Rangos
    for i in 0..10 {
        println!("{}", i);
    }
    
    for i in 0..=10 {
        println!("{}", i);
    }
    
    // Pattern matching
    match x {
        1 => println!("uno"),
        2 => println!("dos"),
        3..=5 => println!("entre tres y cinco"),
        _ => println!("otro"),
    }
    
    // Operadores
    let suma = x + y;
    let resta = x - y;
    let multi = x * y;
    let div = x / y;
    let modulo = x % y;
    
    // Operadores de comparación
    let igual = x == y;
    let diferente = x != y;
    let menor = x < y;
    let mayor = x > y;
    let menor_igual = x <= y;
    let mayor_igual = x >= y;
    
    // Operadores lógicos
    let and_logico = true && false;
    let or_logico = true || false;
    let negacion = !true;
    
    // Operadores de asignación
    y += 5;
    y -= 2;
    y *= 3;
    y /= 2;
}

// Enum con pattern matching
enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    ChangeColor(i32, i32, i32),
}

// Trait
trait Summary {
    fn summarize(&self) -> String;
}

// Implementación de trait para struct
struct NewsArticle {
    headline: String,
    location: String,
    author: String,
    content: String,
}

impl Summary for NewsArticle {
    fn summarize(&self) -> String {
        format!("{}, by {} ({})", self.headline, self.author, self.location)
    }
}

// Función genérica con lifetime
fn first_word<'a>(s: &'a str) -> &'a str {
    let bytes = s.as_bytes();
    
    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
            return &s[0..i];
        }
    }
    
    &s[..]
}

// Closure con move
fn crear_closure() -> impl Fn(i32) -> i32 {
    let num = 5;
    move |x| x + num
}

/* Comentario multilínea
   que puede abarcar
   varias líneas
   para probar el lexer */

// Más macros
assert_eq!(2 + 2, 4);
panic!("Error crítico");
unimplemented!();
todo!();

// Path separators
use std::collections::HashMap;
use std::io::Result;

// Lifetimes especiales
fn lifetime_static() -> &'static str {
    "Soy un string estático"
}

// Referencias y dereferencing
fn referencias() {
    let x = 5;
    let y = &x;
    let z = &mut 10;
}
