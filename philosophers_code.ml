(* philosophers-code.ml

to run:
$ ./philosophers-code < test.hp > test.c
$ gcc -o test test.c
$ ./test
*)

type action = Ast | Compile

let _ = 
	let action = if Array.length Sys.argv > 1 then 
		List.assoc Sys.argv.(1) [ ("-a", Ast); (*print AST*)
			("-c", Compile) ] (*generate, check C code*)
	else Compile in 
	(*pipe program file into compiler's lexbuf*)
		let lexbuf=Lexing.from_channel stdin in
		let ast = Parser.program Scanner.token lexbuf in
		match action with 
		Ast -> let pair =  Ast.string_of_program ast in let (funs, stmts) = pair in (print_string funs;  print_string stmts)
		| Compile -> let result = Codegen.translate ast
			in print_string result
