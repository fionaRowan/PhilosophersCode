/* Ocamlyacc parser for Philosopher's Code */

%{
open Ast
%}

/*keywords*/
%token ADD SUBTRACT MULTIPLY DIVIDE ASSIGN
%token NOT GREATER LESSER EQUALS AND OR TRUE FALSE 

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

%right ASSIGN
%left ADD SUBTRACT MULTIPLE DIVIDE
%right NOT
%left LESSER GREATER EQUALS
%left AND OR 

%start program
%type <Ast.program> program
%%

program:
	stmt_list EOF		 	{ Program($1) }	
	
stmt_list:	
	/*nothing*/ 		{ [] }
	| stmt EOL stmt_list	{ $1 :: $3 }

stmt: 
	expr			{ Expr($1) }
	/*| fun_def		{ Fun_Def($1) }*/

expr: 
	literal			{ $1 }
	| TRUE 			{ Bool_Lit(true) }
	| FALSE 		{ Bool_Lit(false) }	
	| LPAREN expr RPAREN	{ Expr($2) }
	| expr ADD expr 	{ Binop($1, Add, $3) }
	| expr SUBTRACT expr	{ Binop($1, Subtract, $3) }
	| expr MULTIPLY expr 	{ Binop($1, Multiply, $3) }
	| expr DIVIDE expr 	{ Binop($1, Divide, $3) }
	| ID			{ Id($1) }
	| ID expr_opt		{ Call($1, $2) }
	| ID ASSIGN expr 	{ Assign($1, $3) }
	| expr AND expr 	{ Binop($1, And, $3) }
	| expr OR expr 		{ Binop($1, Or, $3) } 
	| expr GREATER expr 	{ Binop($1, Greater, $3) }
	| expr LESSER expr 	{ Binop($1, Lesser, $3) }
	| NOT expr		{ Uniop(Not,$2) }

expr_opt:
	{ [] }
	| expr_list		{ List.rev $1 }
	
expr_list:
	expr { [$1] }
	| expr_list COMMA expr 	{ $3 :: $1 }
literal: 
	INT_LITERAL		{ Int_Lit($1) }
	| FLOAT_LITERAL		{ Float_Lit($1) }
	| CHAR_LITERAL		{ Char_Lit($1) }
	| STRING_LITERAL	{ String_Lit($1) }
	| BOOL_LITERAL		{ Bool_Lit($1) }
