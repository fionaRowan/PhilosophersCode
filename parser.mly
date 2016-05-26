/* Ocamlyacc parser for Philosopher's Code */

%{
open Ast
%}

/*keywords*/
%token ADD SUBTRACT MULTIPLY DIVIDE ASSIGN REASSIGN
%token NOT GREATER LESSER EQUALS AND OR TRUE FALSE 
%token IF THEN ELSE 

/*data types, literals, id*/
%token <int> INT_LITERAL
%token <int> CHAR_LITERAL
%token <float> FLOAT_LITERAL
%token <string> STRING_LITERAL
%token INT STRING CHAR FLOAT BOOL
%token <string> ID

/*terminators, separators*/ 
%token EOL 
%token EOF
%token COMMA
%token LPAREN RPAREN
%token LBRACE RBRACE

%right ASSIGN REASSIGN
%left ADD SUBTRACT MULTIPLE DIVIDE
%right NOT
%left LESSER GREATER EQUALS
%left AND OR
%nonassoc EOL 
%nonassoc NOELSE 
%nonassoc ELSE

%start program
%type <Ast.program> program
%%

program:
	stmt_list EOF		 	{ Program($1) }	

stmt_list:	
	/*nothing*/ 		{ [] }
	| stmt stmt_list	{ $1 :: $2 }

stmt: 
	expr EOL				{ Expr($1) }
	| LBRACE stmt_list RBRACE 		{ Block(List.rev $2) }
	| IF expr THEN stmt %prec NOELSE 	{ If($2, $4, Block([])) }
	| IF expr THEN stmt ELSE stmt 		{ If($2, $4, $6) }
	/*| fun_def				{ Fun_Def($1) }*/

expr: 
	literal			{ $1 }
	| ID			{ Id($1) }
	| LPAREN expr RPAREN	{ Expr($2) }
	| expr ADD expr 	{ Binop($1, Add, $3) }
	| expr SUBTRACT expr	{ Binop($1, Subtract, $3) }
	| expr MULTIPLY expr 	{ Binop($1, Multiply, $3) }
	| expr DIVIDE expr 	{ Binop($1, Divide, $3) }
	| ID actuals_opt	{ Call($1, $2) }
	| ID REASSIGN expr	{ Reassign($1, $3) }
	| ID ASSIGN expr 	{ Assign($1, $3) }
	| expr AND expr 	{ Binop($1, And, $3) }
	| expr OR expr 		{ Binop($1, Or, $3) } 
	| expr GREATER expr 	{ Binop($1, Greater, $3) }
	| expr LESSER expr 	{ Binop($1, Lesser, $3) }
	| NOT expr		{ Uniop(Not,$2) }

actuals_opt:
	{ [] }
	| actuals_list		{ List.rev $1 }
	
actuals_list:
	expr 			{ [$1] }
	| actuals_list COMMA expr 	{ $3 :: $1 }
literal: 
	INT_LITERAL		{ Int_Lit($1) }
	| FLOAT_LITERAL		{ Float_Lit($1) }
	| CHAR_LITERAL		{ Char_Lit($1) }
	| STRING_LITERAL	{ String_Lit($1) }
	| TRUE 			{ Bool_Lit(true) }
	| FALSE 		{ Bool_Lit(false) }	

