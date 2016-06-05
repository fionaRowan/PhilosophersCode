(* AST for Philosopher's Code *)
type op = Add | Subtract | Multiply | Divide | And | Or | Greater | Lesser
type uop = Not
type primitive = Int_Decl
type expr =
	| Int_Lit of int
	| Float_Lit of float
	| Char_Lit of int 
	| String_Lit of string
	| Bool_Lit of bool
	| Id of string
	| Call of string * expr list
	| Binop of expr * op * expr
	| Uniop of uop * expr
	| Assign of string * expr
	| Reassign of string * expr
	| Expr of expr
	| Noexpr

type formal = 
	|  Formal of string
type fun_decl = 
	{
		func_name: string;
		formals: formal list;	
	} 

type stmt = 
	| Expr of expr
	| Block of stmt list
	| If of expr * stmt * stmt
	| Return of expr
	| Fun_Def_Stmt of fun_def 

and fun_def = 
	| Fun_Def of fun_decl * stmt  

type program = Program of stmt list 

(*pretty-printing functions*)

let string_of_op = function
	| Add -> "+"
	| Subtract -> "-" 
	| Divide -> "/" 
	| Multiply -> "*"
	| And -> "&&"
	| Or -> "||" 
	| Greater -> ">"
	| Lesser -> "<" 

let string_of_uop = function
	| Not -> "!" 

let rec string_of_expr = function
	| Int_Lit(i) -> string_of_int i
	| Float_Lit(f) -> string_of_float f
	| Char_Lit(c) -> string_of_int c
	| String_Lit(s) -> s
	| Bool_Lit(true) -> "1"
	| Bool_Lit(false) -> "0" 
	| Binop(a, o, b) -> (string_of_expr a)^(string_of_op o)^(string_of_expr b)
	| Uniop(uo, a) -> (string_of_uop uo) ^ (string_of_expr a)
	| Id(s) -> s
	| Assign(v, e) -> "int "^v^ " = " ^ string_of_expr e
	| Reassign(v, e) -> v^" = " ^string_of_expr e
	| Call(f, el) -> (match f with 
		"aparecium" -> 
			"printf(\"%d\\n\", " ^ String.concat ", " (List.map string_of_expr el) ^")"
		| _ -> f ^ "(" ^ String.concat ", " (List.map string_of_expr el) ^ ")")
	| Noexpr -> ""
	| _ -> "did not match" 

let rec string_of_stmt = function 
	| Expr(e) -> (string_of_expr e)^";" 
	| If(e, s1, s2) -> 
		"if("^(string_of_expr e)^")\n "^(string_of_stmt s1)^" else "^(string_of_stmt s2)
	| Block(sl) -> "{ "^(String.concat " " (List.map string_of_stmt sl)) ^" }\n"
	| Return(e) -> "return "^string_of_expr e ^";"
	| Fun_Def_Stmt(f) -> string_of_fun f

and string_of_formal = function
	| Formal(f) -> "int "^ f

and string_of_formals_list fl = String.concat ", " (List.map string_of_formal fl) 

and string_of_fun_decl fd = 
	"int "^fd.func_name^"("^(string_of_formals_list fd.formals)^")\n"

	
and string_of_fun = function
	| Fun_Def(f, s) -> (string_of_fun_decl f) ^ (string_of_stmt s)
let string_of_program stmts = match stmts with 
	Program(stmt_list) -> let result =  
		String.concat "" (List.map string_of_stmt stmt_list) ^ "\n" in result
