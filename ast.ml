(* AST for Philosopher's Code *)

type expr =
	| Int_Lit of int
	| Float_Lit of float
	| Char_Lit of int 
	| String_Lit of string
	| Bool_Lit of bool
	| Id of string
	| Call of string * expr list
	| Noexpr

type program = Program of expr list 

(*pretty-printing functions*)
let rec string_of_expr = function
	| Int_Lit(i) -> string_of_int i
	| Float_Lit(f) -> string_of_float f
	| Char_Lit(c) -> string_of_int c
	| String_Lit(s) -> s
	| Bool_Lit(true) -> "true"
	| Bool_Lit(false) -> "false" 
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
