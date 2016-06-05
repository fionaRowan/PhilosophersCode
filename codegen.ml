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

	let string_of_stmt_list stmt_list = List.map string_of_stmt stmt_list in  

	let stmts_string_list = string_of_stmt_list (match program with 
		| Program(stmts) -> stmts) in 
	
	let stmts_string = String.concat "\n" stmts_string_list in
	(*program string*)
	let program_string = includes ^ main_str ^ stmts_string ^ main_end

in program_string

