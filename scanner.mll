(* Ocamllex scanner for Philosopher's Code *)

{ 
  open Parser
  let unescape s = Scanf.sscanf("\"" ^ s ^ "\"") "%S%!" (fun x -> x) 
}

let digit = ['0'-'9']
let lowercase = ['a'-'z']
let uppercase = ['A'-'Z']
let letter = (lowercase | uppercase)

rule token = parse
  [' ' '\t' '\n' '\r' ]	{token lexbuf}
(* Data declarations *)
| "int"		{ INT }
| "string"      { STRING }
| "char"        { CHAR }
| "float"       { FLOAT }
| "bool"        { BOOL }
(* Keywords *)
| '(' 		{ LPAREN }
| ')'		{ RPAREN }
| '{'		{ LBRACE }
| '}'		{ RBRACE } 
| '!' 		{ EOL }
| ',' 		{ COMMA }
| "spell" 	{ FUN }
| "adhero" 	{ ADD }
| "convello"	{ SUBTRACT }
| "engorgio" 	{ MULTIPLY }
| "reducio" 	{ DIVIDE }
| "epoximise" 	{ ASSIGN }
| "repleo" 	{ REASSIGN }
| "est" 	{ EQUALS }
| "non" 	{ NOT }
| "quam" 	{ GREATER }
| "minor" 	{ LESSER }
| "et" 		{ AND }
| "aut" 	{ OR }
| "verum" 	{ TRUE }
| "falsum"	{ FALSE }
| "si" 		{ IF }
| "tunc" 	{ THEN }
| "aliter" 	{ ELSE }
| "finite" 	{ RETURN1 } 
| "incantatem"	{ RETURN2 }
(* Literals and identifiers *)
| digit+ as int_lit 				{ INT_LITERAL(int_of_string int_lit)}
| digit+ '.' digit* as float_lit 		{ FLOAT_LITERAL(float_of_string float_lit) }
| '\'' (digit | letter | '_') '\'' as char_lit 	{ CHAR_LITERAL(int_of_string char_lit) }
| '"' (('\\' '"'| [^'"'])* as str) '"' 		{ STRING_LITERAL(unescape str) } 
| letter (letter | digit | '_')* as lxm 	{ ID(lxm) }
| eof						{ EOF }
