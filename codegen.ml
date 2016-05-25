(*Code generation: translate takes AST and produces C code*) 

open Ast

let translate program = 
	(*preprocessing*)
	let include_stdio = "#include <stdio.h>\n" in
	let include_str = "#include <string.h>\n" in 
	let includes = include_stdio ^ include_str in

	(*main*) 
	let main_str = "int main(){ \n" in
	let main_end = "\n}\n" in

	(*
	let rec string_of_expr expression = match expression with
		| Call(funcName, exprList) -> (match funcName with
			|"aparecium" -> "printf(\"%d\\n\", "^string_of_actuals exprList^")"
			| _ -> "printf(\"%s\\n\", \"hello\")")
		| _ -> "" 

	and string_of_actuals actuals_list = match actuals_list with
		| [] -> ""
		| [s] -> string_of_expr s
		| _ -> "555"
	in 
	*)

(*	let rec string_of_expr expression = match expression with 
		|*)
	let rec string_of_expr_list expr_list = List.map string_of_expr expr_list in  
	
	let exprs_string_list = string_of_expr_list (match program with 
		Program(expressions) -> expressions) in 
	
	let exprs_string = String.concat "; " exprs_string_list in
	(*program string*)
	let program_string = includes ^ main_str ^ exprs_string^";" ^ main_end

in program_string

