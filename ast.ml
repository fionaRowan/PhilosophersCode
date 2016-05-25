(* AST for Philosopher's Code *)
type op = Add | Subtract | Multiply | Divide 
type expr =
	| Int_Lit of int
	| Float_Lit of float
	| Char_Lit of int 
	| String_Lit of string
	| Bool_Lit of bool
	| Id of string
	| Call of string * expr list
	| Binop of expr * op * expr
	| Noexpr

type program = Program of expr list 

(*pretty-printing functions*)

let string_of_op = function
	| Add -> "+"
	| Subtract -> "-" 
	| Divide -> "/" 
	| Multiply -> "*"


let rec string_of_expr = function
	| Int_Lit(i) -> string_of_int i
	| Float_Lit(f) -> string_of_float f
	| Char_Lit(c) -> string_of_int c
	| String_Lit(s) -> s
	| Bool_Lit(true) -> "true"
	| Bool_Lit(false) -> "false" 
	| Binop(a, o, b) -> (string_of_expr a)^(string_of_op o)^(string_of_expr b)
	| Id(s) -> s
	| Call(f, el) -> (match f with 
		"aparecium" -> 
			"printf(\"%d\\n\", " ^ String.concat ", " (List.map string_of_expr el) ^")"
		| _ -> f ^ "(" ^ String.concat ", " (List.map string_of_expr el) ^ ")")
	| Noexpr -> ""


(*
let string_of_typ = function
	Int -> "int" 
	| Bool -> "bool"
	| Void -> "void" *)
(*let string_of_program expression = match expression with 
	Program(expressn) -> (let result =
	""^(string_of_expr expressn)^"" in result^"\n")*)
let string_of_program exprs = match exprs with 
	Program(expr_list) -> let result =  
		String.concat "" (List.map string_of_expr expr_list) ^ "\n" in result