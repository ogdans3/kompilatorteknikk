%{
#include <vslc.h>

%}
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS

%token FUNC PRINT RETURN CONTINUE IF THEN ELSE WHILE DO OPENBLOCK CLOSEBLOCK
%token VAR NUMBER IDENTIFIER STRING

%%
program 				: global_list 																{ 	root = node_init( PROGRAM, NULL, 1, $1 );
																									}
;

global_list 			: global 																	{ 	$$ = node_init( GLOBAL_LIST, NULL, 1, $1 ); } 
						| global_list global 														{ 	$$ = node_init( GLOBAL_LIST, NULL, 1, $1 ); } 
;

global 					: function  																{ 	$$ = node_init( GLOBAL, NULL, 1, $1 ); } 
						| declaration  																{ 	$$ = node_init( GLOBAL, NULL, 1, $1 ); }
;

statement_list			: statement 																{ 	$$ = node_init( STATEMENT_LIST, NULL, 1, $1 ); }
						| statement_list statement 													{ 	$$ = node_init( STATEMENT_LIST, NULL, 1, $2 ); }
;
print_list 				: print_item 																{ 	$$ = node_init( PRINT_LIST, NULL, 1, $1 ); }
						| print_list ',' print_item 												{ 	$$ = node_init( PRINT_LIST, NULL, 1, $3 ); }
;
expression_list			: expression 																{ 	$$ = node_init( EXPRESSION_LIST, NULL, 1, $1 ); }
						| expression_list ',' expression 											{ 	$$ = node_init( EXPRESSION_LIST, NULL, 1, $3); }
;
variable_list			: identifier 																{ 	$$ = node_init( VARIABLE_LIST, NULL, 1, $1 ); }
						| variable_list ',' identifier 												{ 	$$ = node_init( VARIABLE_LIST, NULL, 1, $3 ); }
;
argument_list			: expression_list 															{ 	$$ = node_init( ARGUMENT_LIST, NULL, 1, $1 ); }
						| /*EMPTY*/ 																{ 	$$ = node_init( ARGUMENT_LIST, NULL, 0 ); }
;
parameter_list			: variable_list 															{ 	$$ = node_init( PARAMETER_LIST, NULL, 1, $1 ); }
						| /*EMPTY*/ 																{ 	$$ = node_init( PARAMETER_LIST, NULL, 0 ); }
;
declaration_list 		: declaration 																{ 	$$ = node_init( DECLARATION_LIST, NULL, 1, $1 ); }
				 		| declaration_list declaration 												{ 	$$ = node_init( DECLARATION_LIST, NULL, 1, $2 ); }
;

function 				: FUNC identifier '(' parameter_list ')' statement 							{ 	$$ = node_init( FUNCTION, NULL, 3, $2, $4, $6 ); }
;
statement 				:assignment_statement 														{ 	$$ = node_init( STATEMENT, NULL, 1, $1 ); }
						| return_statement 															{ 	$$ = node_init( STATEMENT, NULL, 1, $1 ); }
;
statement 				: print_statement 															{ 	$$ = node_init( STATEMENT, NULL, 1, $1 ); }	
						| if_statement 																{ 	$$ = node_init( STATEMENT, NULL, 1, $1 ); }
;
statement 				: while_statement 															{ 	$$ = node_init( STATEMENT, NULL, 1, $1 ); }
						| null_statement 															{ 	$$ = node_init( STATEMENT, NULL, 1, $1 ); }
						| block 																	{ 	$$ = node_init( STATEMENT, NULL, 1, $1 ); }
;

block 					: OPENBLOCK declaration_list statement_list CLOSEBLOCK 						{ 	$$ = node_init( BLOCK, NULL, 2, $2, $3 ); }
;
block 					: OPENBLOCK statement_list CLOSEBLOCK 										{ 	$$ = node_init( BLOCK, NULL, 1, $2 ); }
;
assignment_statement 	: identifier ':' '=' expression 											{ 	$$ = node_init( ASSIGNMENT_STATEMENT, NULL, 2, $1, $4 ); }
;
return_statement 		: RETURN expression 														{ 	$$ = node_init( RETURN_STATEMENT, NULL, 1, $2); }
;
print_statement			: PRINT print_list 															{ 	$$ = node_init( PRINT_STATEMENT, NULL, 1, $1 ); }
;
null_statement			: CONTINUE 																	{ 	$$ = node_init( NULL_STATEMENT, NULL, 1, $1 ); }
;

if_statement			: IF relation THEN statement 												{ 	$$ = node_init( IF_STATEMENT, NULL, 2, $2, $4 ); }
;
if_statement 			: IF relation THEN statement ELSE statement 								{ 	$$ = node_init( IF_STATEMENT, NULL, 3, $2, $4, $6 ); }
;
while_statement 		: WHILE relation DO statement 												{ 	$$ = node_init( WHILE_STATEMENT, NULL, 2, $2, $4 ); }
;


relation				: expression '=' expression 												{ 	$$ = node_init( RELATION, strdup("="), 2, $1, $3 ); }
;
relation 				: expression '<' expression 												{ 	$$ = node_init( RELATION, strdup("<"), 2, $1, $3 ); }
;
relation 				: expression '>' expression 												{ 	$$ = node_init( RELATION, strdup(">"), 2, $1, $3 ); }
;
expression 				: expression '+' expression 												{ 	$$ = node_init( EXPRESSION, strdup("+"), 2, $1, $3 ); }
;
expression 				: expression '-' expression 												{ 	$$ = node_init( EXPRESSION, strdup("-"), 2, $1, $3 ); }
;
expression 				: expression '*' expression 												{ 	$$ = node_init( EXPRESSION, strdup("*"), 2, $1, $3 ); }
;
expression 				: expression '/' expression 												{ 	$$ = node_init( EXPRESSION, strdup("/"), 2, $1, $3 ); }
;

expression 				: '-' expression     														{ 	$$ = node_init( EXPRESSION, NULL, 1, $2 ); }
;
expression 				: '(' expression ')' 														{ 	$$ = node_init( EXPRESSION, NULL, 1, $2 ); }
;

expression				: number 																	{ 	$$ = node_init( EXPRESSION, NULL, 1, $1 ); }
						| identifier 																{ 	$$ = node_init( EXPRESSION, NULL, 1, $1 ); }
						| identifier '(' argument_list ')' 											{ 	$$ = node_init( EXPRESSION, NULL, 2, $1, $3 ); }
;

declaration 			: VAR variable_list 														{ 	$$ = node_init( DECLARATION, NULL, 1, $2 ); }
;
print_item				: expression 																{ 	$$ = node_init( PRINT_ITEM, NULL, 1, $1 ); }
						| string 																	{ 	$$ = node_init( PRINT_ITEM, NULL, 1, $1 ); }
;

identifier 				: IDENTIFIER 																{ 	$$ = node_init( IDENTIFIER_DATA, strdup (yytext), 0 ); }
;
number 					: NUMBER 																	{ 	
																										long *i = malloc( sizeof(*i) );
																										*i = (long) yylval;
																										/*strtol ( yytext, NULL, 10 )*/
																										$$ = node_init( NUMBER_DATA, i, 0 ); 
																									}
;
string 					: STRING 																	{ 	$$ = node_init( STRING_DATA, strdup (yytext), 0 ); }
;

%%

int
yyerror ( const char *error )
{
    fprintf ( stderr, "%s on line %d\n", error, yylineno );
    exit ( EXIT_FAILURE );
}
