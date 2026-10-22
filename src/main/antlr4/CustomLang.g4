grammar CustomLang;

// ==========================================
// PARSER (Syntactic rules)
// ==========================================


// this says where is the code file
@header {
    package org.example;
}

// ============================= program definition ======================
// this is the name of the code at the top of the file, const procedure and fuctions block are not mandatory, code is
program
    : PROGRAM ID SEMI constBlock? procBlock? funcBlock? codeBlock EOF
    ;

// ==================================================================
// ========================== Blocks =================================
// block for constants multiple constants or not any, LBRACE and RBRACE are {}
constBlock
    : CONST LBRACE constDecl* RBRACE
    ;

constDecl
    : type ID ASSIGN expr SEMI
    ;

procBlock
    : PROCEDURES LBRACE procDecl* RBRACE
    ;

// LPAREN and RPAREN are the ()
procDecl
    : ID LPAREN paramList? RPAREN block
    ;

funcBlock
    : FUNCTIONS LBRACE funcDecl* RBRACE
    ;

funcDecl
    : ID LPAREN paramList? RPAREN COLON type block
    ;

codeBlock
    : CODE block
    ;

block
    : LBRACE statement* RBRACE
    ;

// ========================================================================
// ================================ Parameters ============================

paramList
    : param (COMMA param)*
    ;

param
    : ID COLON type
    ;

// ========================================================================
// ============================== Commands ================================

statement
    : varDecl     // assigment and declaration of new
    | idStat   // addigment of existing and calling of fnction
    | forStat     // for cycle
    | whileStat  // while cycle
    | doWhileStat   // do while cyle
    | repeatStat   // repeat cycle
    | ifStat     // if condition
    | returnStat  // return from fnc
    ;

varDecl
    : VAR type ID ( (ASSIGN) expr )? SEMI
    ;

// ============ this is so that there isnt a collison in callStat =====================
idStat
    : ID ( assignTail | callTail )
    ;

assignTail
    : ASSIGN expr SEMI
    ;

callTail
    : LPAREN argList? RPAREN SEMI
    ;

// ==============================================================================

assignStat
    : ID (ASSIGN | EQUAL) expr SEMI
    ;

// cycles

forInit
    : ID (ASSIGN | EQUAL) expr
    ;

forStat
    : FOR LPAREN forInit TO expr RPAREN DO block
    ;

whileStat
    : WHILE LPAREN expr RPAREN DO block
    ;

doWhileStat
    : DO block WHILE LPAREN expr RPAREN SEMI
    ;

repeatStat
    : REPEAT block UNTIL LPAREN expr RPAREN SEMI
    ;

// ---------------

ifStat
    : IF LPAREN expr RPAREN THEN block (ELSE block)?
    ;

returnStat
    : RETURN expr SEMI
    ;

argList
    : expr (COMMA expr)*
    ;

type
    : INT_TYPE | BOOL_TYPE | REAL_TYPE
    ;

// expressions
expr
    : prefixOp LPAREN expr COMMA expr RPAREN  // Binary op +(2, 2) or <(a, b)
    | NOT LPAREN expr RPAREN                  // negation
    | ID ( LPAREN argList? RPAREN )?              // call of function or a variable: myFunc(1, 2), its united so that it doenst do colisions
    | MINUS ( LPAREN expr COMMA expr RPAREN | expr )    // minus: -5 or -+(2, 2)
    | INT_LITERAL                             // numbers, text, booleans
    | REAL_LITERAL
    | STRING_LITERAL
    | BOOL_LITERAL
    ;

// prefix calling of the operators +(a, 8) or <(i, 10)
prefixExpr
    : prefixOp LPAREN expr COMMA expr RPAREN
    ;

prefixOp
    : PLUS | MUL | DIV | MOD | compareOp
    ;

compareOp
    : LESS | GREATER | LESS_EQ | GREATER_EQ | NEQ_OP | EQUAL
    ;

// ==========================================
// LEXER (lexical rules), keywords
// ==========================================

PROGRAM    : 'Program' ;
CONST      : 'Const' ;
PROCEDURES : 'Procedures' ;
FUNCTIONS  : 'Functions' ;
CODE       : 'Code' ;
VAR        : 'var' ;
RETURN     : 'return' ;
FOR        : 'for' ;
TO         : 'to' ;
DO         : 'do' ;
WHILE      : 'while' ;
REPEAT     : 'repeat' ;
UNTIL      : 'until' ;
IF         : 'if' ;
THEN       : 'then' ;
ELSE       : 'else' ;

// Data types
INT_TYPE   : 'int';
BOOL_TYPE  : 'bool';
REAL_TYPE  : 'real';

// values of the types
BOOL_LITERAL   : 'true' | 'false' ;
INT_LITERAL    : [0-9]+ ;
REAL_LITERAL   : [0-9]+ '.' [0-9]+ ;
STRING_LITERAL : '"' ~["]* '"' ; 

// operators
ASSIGN     : ':=' ;
EQUAL      : '=' ;
PLUS       : '+' ;
MINUS      : '-' ;
MUL        : '*' ;
DIV        : '/' ;
MOD        : '%' ;
LESS       : '<' ;
GREATER    : '>' ;
LESS_EQ    : '<=' ;
GREATER_EQ : '>=' ;
NEQ_OP     : '!=' ;

// wrapping and ending of the commands
LPAREN : '(' ;
RPAREN : ')' ;
LBRACE : '{' ;
RBRACE : '}' ;
SEMI   : ';' ;
COLON  : ':' ;
COMMA  : ',' ;

// Identificators, names of variables/fucntions...
ID : [a-zA-Z_][a-zA-Z0-9_]* ;

// ignoring of the whitespace and comments
WS            : [ \t\r\n]+ -> skip ;
LINE_COMMENT  : '//' ~[\r\n]* -> skip ;
BLOCK_COMMENT : '/*' .*? '*/' -> skip ;