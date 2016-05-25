/* Ocamlyacc parser for Philosopher's Code */

%{
open Ast
%}

/*keywords*/

/*data types, literals, id*/
%token <int> INT_LITERAL
%token <int> CHAR_LITERAL
%token <float> FLOAT_LITERAL
%token <string> STRING_LITERAL
%token <bool> BOOL_LITERAL
%token INT STRING CHAR FLOAT BOOL
%token <string> ID

/*terminators, separators*/ 
%token EOL 
%token EOF
%token COMMA
%token LPAREN RPAREN

%start program
%type <Ast.program> program
%%

program:
  exprs EOF		 	{ Program($1) }	
	
exprs: 
	/* nothing */ 		{ [] }
	| expr EOL exprs 	{ $1 :: $3 }

expr: 
	literal			{ $1 }	
	| ID LPAREN expr_opt RPAREN	{ Call($1, $3) }

expr_opt:
	{ [] }
	| expr_list		{ List.rev $1 }
	
expr_list:
	expr { [$1] }
/*	| expr_list COMMA expr 	{ $3 :: $1 }*/
literal: 
	INT_LITERAL		{ Int_Lit($1) }
	| FLOAT_LITERAL		{ Float_Lit($1) }
	| CHAR_LITERAL		{ Char_Lit($1) }
	| STRING_LITERAL	{ String_Lit($1) }
	| BOOL_LITERAL		{ Bool_Lit($1) }
