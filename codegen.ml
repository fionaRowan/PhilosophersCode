(*Code generation: translate takes AST and produces C code*) 

open Ast

let translate (program: program) : string = 
	(*preprocessing*)
	let (include_stdio: string) = "#include <stdio.h>\n" in
	let (include_str: string) = "#include <string.h>\n" in 
	let (includes: string) = include_stdio ^ include_str in

	(*main*) 
	let (main_str: string) = "int main(){ \n" in
	let (main_end: string) = "\n}\n" in

	let string_of_stmt_list (stmt_list: stmt list) : string list = List.map (string_of_stmt) (stmt_list: stmt list) in  

	let (stmts_string_list: string list) = string_of_stmt_list (match (program: program) with 
		| Program(stmts : stmt list) -> (stmts: stmt list)) in 
	
	(*TODO function definitions*)
	
	let (stmts_string: string) = String.concat ("\n") (stmts_string_list: string list) in
	(*program string*)
	let (program_string: string) = includes ^ main_str ^ stmts_string ^ main_end

in program_string

