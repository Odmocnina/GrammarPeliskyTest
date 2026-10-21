grammar CustomLang;

// ==========================================
// PARSER (Syntactic rules)
// ==========================================


// this says where is the code file
@header {
    package org.example;
}

// case insencitivity
options { 
    caseInsensitive = true; 
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
    : type ID EQUAL expr SEMI
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
    | assignStat   // addigment of existing
    | forStat     // for cycle
    | whileStat  // while cycle
    | doWhileStat   // do while cyle
    | repeatStat   // repeat cycle
    | ifStat     // if condition
    | returnStat  // return from fnc
    | callStat   // cat to different fnc/proc
    ;

varDecl
    : VAR type ID ( (ASSIGN | EQUAL) expr )? SEMI
    ;

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

callStat
    : ID LPAREN argList? RPAREN SEMI
    ;

argList
    : expr (COMMA expr)*
    ;

type
    : INT_TYPE | BOOL_TYPE | REAL_TYPE
    ;

// expressions
expr
    : prefixExpr                     // prefix expression
    | ID LPAREN argList? RPAREN    // calling of the expression
    | MINUS expr
    | expr (MUL | DIV) expr
    | expr (PLUS | MINUS) expr
    | expr compareOp expr
    | LPAREN expr RPAREN
    | ID
    | INT_LITERAL
    | REAL_LITERAL
    | STRING_LITERAL
    ;

// prefix calling of the operators +(a, 8) or <(i, 10)
prefixExpr
    : prefixOp LPAREN expr COMMA expr RPAREN
    ;

prefixOp
    : PLUS | MINUS | MUL | DIV | EQUAL | ASSIGN | compareOp
    ;

compareOp
    : LESS | GREATER | LESS_EQ | GREATER_EQ | EQ_OP | NEQ_OP
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
INT_TYPE   : 'int' | 'Int' ;
BOOL_TYPE  : 'bool' | 'Bool' ;
REAL_TYPE  : 'real' | 'Real' ;

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
LESS       : '<' ;
GREATER    : '>' ;
LESS_EQ    : '<=' ;
GREATER_EQ : '>=' ;
EQ_OP      : '==' ;
NEQ_OP     : '!=' ;

// wrapping and ending of the commands
LPAREN : '(' ;
RPAREN : ')' ;
LBRACE : '{' ;
RBRACE : '}' ;
SEMI   : ';' ;
COLON  : ':' ;
COMMA  : ',' ;

// Identificators
ID : [a-zA-Z_][a-zA-Z0-9_]* ;

// ignoring of the whitespace and comments
WS            : [ \t\r\n]+ -> skip ;
LINE_COMMENT  : '//' ~[\r\n]* -> skip ;
BLOCK_COMMENT : '/*' .*? '*/' -> skip ;