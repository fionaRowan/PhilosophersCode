/* Ocamlyacc parser for Philosopher's Code */

%{
open Ast
%}

/*keywords*/
%token PRINT

/*data types, literals, id*/
%token <int> INT_LITERAL
%token <int> CHAR_LITERAL
%token <float> FLOAT_LITERAL
%token <string> STRING_LITERAL
%token <bool> BOOL_LITERAL
%token INT STRING CHAR FLOAT BOOL
%token <string> ID

/*end of input*/ 
%token EOL 
%token EOF

%start program
%type <Ast.program> program
%%

program:
  exprs EOF { $1 }

exprs: 
	/* nothing */ { [] }
	| expr EOL exprs { $1 :: $3 }

expr: 
	PRINT INT_LITERAL 
	| PRINT STRING_LITERAL 
	| PRINT CHAR_LITERAL
	| PRINT FLOAT_LITERAL