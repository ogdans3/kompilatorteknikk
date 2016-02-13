%{
#include <vslc.h>
%}
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS

%token FUNC PRINT RETURN CONTINUE IF THEN ELSE WHILE DO OPENBLOCK CLOSEBLOCK
%token VAR NUMBER IDENTIFIER STRING

%%
program :
	global_list { printf("Success\n");}
;

global_list: global{ printf("Global\n"); } | global_list global{}
;

global: function{ printf("Function\n"); } | decleration{};

decleration: NUMBER{};

statement_list	: statement { printf("Statement recognized\n"); }
				| statement_list statement { printf("List of statements\n"); }
;
print_list 		: print_item {}
				| print_list ',' print_item{}
;
print_item		: expression{}
				| string{}
;

expression_list	: expression{}
				| expression_list ',' expression{};
variable_list	: identifier{ printf("Identifier\n"); }
				| variable_list ',' identifier{}
;
argument_list	: expression_list{}
;
parameter_list	: variable_list{}
;
declaration_list : declaration{}
				 | declaration_list declaration{}
;
declaration 	 : number{}
;

function 		: FUNC OPENBLOCK identifier statement CLOSEBLOCK{ printf("!!!!!!!!!!!Function!!!!!!!!!!\n"); }
;


statement 		: if_statement { printf( "Then statement 213213123\n"); }
;

if_statement	: IF relation THEN expression { printf("Then found\n\n\n"); }
;

relation		: expression '=' expression { printf("Equals\n"); }
				| expression '<' expression { printf("Less than\n"); }
				| expression '>' expression { printf("Larger than\n"); }
;

expression	: number
			| identifier
			| expression '+' expression { printf("Addition\n"); }
			| expression '-' expression { printf("Subtraction\n"); }
			| expression '*' expression { printf("Multiplication\n"); }
			| expression '/' expression { printf("Division\n"); }
;

identifier 		: IDENTIFIER { printf("Identifier\n"); }
;
number 			: NUMBER { printf("Number\n"); }
;
string 			: STRING { printf{"String\n"} }
;

%%

int
yyerror ( const char *error )
{
    fprintf ( stderr, "%s on line %d\n", error, yylineno );
    exit ( EXIT_FAILURE );
}
