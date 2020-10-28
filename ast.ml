(* AST for Philosopher's Code *)
type op = Add | Subtract | Multiply | Divide | And | Or | Greater | Lesser;;
type uop = Not;;
type primitive = Int_Decl;;
type expr =
	| Literal of literal
	| Id of string
	| Call of string * expr list
	| Binop of expr * op * expr
	| Uniop of uop * expr
	| Expr of expr
	| Noexpr

and literal = 
	| Int_Lit of int
	| Float_Lit of float
	| Char_Lit of int 
	| String_Lit of string
	| Bool_Lit of bool;;

type formal = 
	|  Formal of string;;

type fun_decl = 
	{
		func_name: string;
		formals: formal list;	
	};;

type stmt = 
	| Expr of expr
	| Block of stmt list
	| SimpleStmt of simple_stmt
	| CompoundStmt of compound_stmt

and simple_stmt = 
	| Reassign of string * expr
	| Assign of string * expr
	| Return of expr
	| No_Print

and compound_stmt = 
	| If of expr * stmt * stmt 
	| DoWhile of stmt * expr;;

(* function definitions must be defined separately from statements because they must be generated outside the "main" method *)
type fun_def_stmt = 	
	| Fun_Def_Stmt of fun_def 
and fun_def = 
	| Fun_Def of fun_decl * stmt;;

type program = Program of stmt list;; (* * func_def_stmt list;;*)

(*pretty-printing functions*)

let string_of_op = function
	| Add -> "+"
	| Subtract -> "-" 
	| Divide -> "/" 
	| Multiply -> "*"
	| And -> "&&"
	| Or -> "||" 
	| Greater -> ">"
	| Lesser -> "<";;

let string_of_uop = function
	| Not -> "!" ;;

let rec string_of_expr = function
	(*| Expr(e) -> "(" ^ string_of_expr e ^ ")"*)
	| Literal(e) -> (string_of_literal e)
	| Binop(a, o, b) -> (string_of_expr a)^(string_of_op o)^(string_of_expr b)
	| Uniop(uo, a) -> (string_of_uop uo) ^ (string_of_expr a)
	| Id(s) -> s
	| Call(f, el) -> (match f with 
		"aparecium" -> 
			"printf(\"%d\\n\", " ^ String.concat ", " (List.map string_of_expr el) ^")"
		| "avis" -> "printf(\"%s\\n\", \"bird bird bird bird\")"
		| _ -> f ^ "(" ^ String.concat ", " (List.map string_of_expr el) ^ ")")
	| Noexpr -> ""
	| _ -> "did not match"

and string_of_literal = function
	| Int_Lit(i) -> string_of_int i
	| Float_Lit(f) -> string_of_float f
	| Char_Lit(c) -> string_of_int c
	| String_Lit(s) -> s
	| Bool_Lit(true) -> "1"
	| Bool_Lit(false) -> "0" ;;

let rec string_of_stmt = function 
	| Expr(e) -> (string_of_expr e)^";" 
	| SimpleStmt(s) ->  (string_of_simple_stmt s)
	| CompoundStmt(s) -> (string_of_compound_stmt s)
	| Block(sl) -> "{ "^(String.concat " " (List.map string_of_stmt sl)) ^" }\n"

and string_of_simple_stmt = function
	| Assign(v, e) -> "int "^v^ " = " ^ string_of_expr e ^ ";"
	| Reassign(v, e) -> v^" = " ^string_of_expr e ^ ";"
	| Return(e) -> "return "^string_of_expr e ^";"
	| No_Print -> "int noPrint;"

and string_of_compound_stmt = function
	| If(e, s1, s2) -> 
		"if("^(string_of_expr e)^")\n "^(string_of_stmt s1)^" else "^(string_of_stmt s2)	
	| DoWhile(b, c) -> "do\n" ^string_of_stmt b ^ "while (" ^ string_of_expr c ^");\n"


let rec string_of_fun_def_stmt = function
	| Fun_Def_Stmt(f) -> string_of_fun f

and string_of_fun = function	
	| Fun_Def(f, s) -> (string_of_fun_decl f) ^ (string_of_stmt s)

and string_of_fun_decl fd = 
	"int "^fd.func_name^"("^(string_of_formals_list fd.formals)^")\n"

and string_of_formals_list fl = String.concat ", " (List.map string_of_formal fl)

and string_of_formal = function
	| Formal(f) -> "int "^ f;;


let string_of_program stmts = match stmts with 
	Program(stmt_list) -> let result =  
		String.concat "" (List.map string_of_stmt stmt_list) ^ "\n" in result;;
