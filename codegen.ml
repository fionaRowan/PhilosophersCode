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

	let tuple_of_funs_and_stmts ((fun_def_stmts_list: fun_def_stmt list), (stmt_list: stmt list)) : string list * string list = 
		(List.map (string_of_fun_def_stmt) (fun_def_stmts_list: fun_def_stmt list) , List.map (string_of_stmt) (stmt_list: stmt list)) in  

	let ((fun_def_stmts_list: string list), (stmts_string_list: string list)) = tuple_of_funs_and_stmts (match (program: program) with 
		| Program((fun_def_stmts : fun_def_stmt list), (stmts : stmt list)) -> ((fun_def_stmts: fun_def_stmt list), (stmts: stmt list))) in 
	
	let (stmts_string: string) = String.concat ("\n") (stmts_string_list: string list) in
	let (funs_string: string) = String.concat("\n") (fun_def_stmts_list: string list) in

	(*program string*)
	let (program_string: string) = includes ^ funs_string ^ main_str ^ stmts_string ^ main_end

in program_string

