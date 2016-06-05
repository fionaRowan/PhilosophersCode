/* Ocamlyacc parser for Philosopher's Code */

%{
open Ast
%}

/*keywords*/
%token ADD SUBTRACT MULTIPLY DIVIDE ASSIGN REASSIGN
%token NOT GREATER LESSER EQUALS AND OR TRUE FALSE 
%token IF THEN ELSE 
%token RETURN1 RETURN2
%token FUN

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
	stmt_list EOF			{ Program($1) }

stmt_list:	
	/*nothing*/ 		{ [] }
	| block stmt_list	{ $1 :: $2 }

stmt: 
	binop_expr EOL				{ Expr($1) }
	| IF binop_expr THEN block %prec NOELSE 	{ If($2, $4, Block([])) }
	| IF binop_expr THEN block ELSE block 		{ If($2, $4, $6) }
	| RETURN1 RETURN2 EOL 			{ Return(Noexpr) }
	| RETURN1 RETURN2 binop_expr EOL		{ Return($3) }
	| fun_def				{ Fun_Def_Stmt($1) }

block: 
	stmt					{ $1 }
	| LBRACE stmt_list RBRACE		{ Block(List.rev $2) }

expr: 
	literal			{ $1 }
	| ID			{ Id($1) }
	| LPAREN expr RPAREN	{ Expr($2) }
	| ID actuals_opt	{ Call($1, $2) }
	| ID REASSIGN expr	{ Reassign($1, $3) }
	| ID ASSIGN expr 	{ Assign($1, $3) }
	| NOT expr		{ Uniop(Not,$2) }

binop_expr:
	| expr				{ $1 } 
	| binop_expr ADD expr 		{ Binop($1, Add, $3) }
	| binop_expr SUBTRACT expr	{ Binop($1, Subtract, $3) }
	| binop_expr MULTIPLY expr 	{ Binop($1, Multiply, $3) }
	| binop_expr DIVIDE expr 	{ Binop($1, Divide, $3) }
	| binop_expr AND expr 		{ Binop($1, And, $3) }
	| binop_expr OR expr 		{ Binop($1, Or, $3) } 
	| binop_expr GREATER expr 	{ Binop($1, Greater, $3) }
	| binop_expr LESSER expr 	{ Binop($1, Lesser, $3) }


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

fun_decl:
	| FUN ID formals_opt
	    { {	func_name = $2;
		formals = $3 } }
formals_opt: 
	{ [] }
	| formals_list			{ List.rev $1 }

formal: 
	| ID				{ Formal($1) }

formals_list:
	formal				{ [$1] }
	| formals_list COMMA formal 	{ $3 :: $1 }

fun_def: 
	fun_decl block 			{ Fun_Def($1, $2) }
