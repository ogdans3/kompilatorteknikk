%{
#include <vslc.h>


node_t* cNode( node_index_t type, void *data, uint64_t n_children, ... ){
	node_t* pointer = (node_t *) malloc (sizeof(node_t));
    va_list children;
    va_start(children, n_children);
	
	node_init( pointer, type, data, n_children, children);

    va_end(children);

    return pointer;
};


%}
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS

%token FUNC PRINT RETURN CONTINUE IF THEN ELSE WHILE DO OPENBLOCK CLOSEBLOCK
%token VAR NUMBER IDENTIFIER STRING

%%
program 				: global_list 																{ 	$$ = cNode( PROGRAM, NULL, 1, $1 );
																										printf("Success\n");
																									}
;

global_list 			: global 																	{ 	$$ = cNode( GLOBAL_LIST, NULL, 1, $1 ); } 
						| global_list global 														{ 	$$ = cNode( GLOBAL_LIST, NULL, 1, $1 ); } 
						| expression
;

global 					: function  																{ 	$$ = cNode( GLOBAL, NULL, 1, $1 ); } 
						| declaration  																{ 	$$ = cNode( GLOBAL, NULL, 1, $1 ); }
;

statement_list			: statement 																{ 	$$ = cNode( STATEMENT_LIST, NULL, 1, $1 ); }
						| statement_list statement 													{ 	$$ = cNode( STATEMENT_LIST, NULL, 1, $2 ); }
;
print_list 				: print_item 																{ 	$$ = cNode( PRINT_LIST, NULL, 1, $1 ); }
						| print_list ',' print_item 												{ 	$$ = cNode( PRINT_LIST, NULL, 1, $3 ); }
;
expression_list			: expression 																{ 	$$ = cNode( EXPRESSION_LIST, NULL, 1, $1 ); }
						| expression_list ',' expression 											{ 	$$ = cNode( EXPRESSION_LIST, NULL, 1, $3); }
;
variable_list			: identifier 																{ 	$$ = cNode( VARIABLE_LIST, NULL, 1, $1 ); }
						| variable_list ',' identifier 												{ 	$$ = cNode( VARIABLE_LIST, NULL, 1, $3 ); }
;
argument_list			: expression_list 															{ 	$$ = cNode( ARGUMENT_LIST, NULL, 1, $1 ); }
						| /*EMPTY*/ 																{ 	$$ = cNode( ARGUMENT_LIST, NULL, 0 ); }
;
parameter_list			: variable_list 															{ 	$$ = cNode( PARAMETER_LIST, NULL, 1, $1 ); }
						| /*EMPTY*/ 																{ 	$$ = cNode( PARAMETER_LIST, NULL, 0 ); }
;
declaration_list 		: declaration 																{ 	$$ = cNode( DECLARATION, NULL, 1, $1 ); }
				 		| declaration_list declaration 												{ 	$$ = cNode( DECLARATION, NULL, 1, $2 ); }
;

function 				: FUNC identifier '(' parameter_list ')' statement 							{ 	$$ = cNode( FUNCTION, NULL, 3, $2, $4, $6 ); }
;
statement 				: if_statement 																{ 	$$ = cNode( STATEMENT, NULL, 1, $1 ); }
						| assignment_statement 														{ 	$$ = cNode( STATEMENT, NULL, 1, $1 ); }
						| return_statement 															{ 	$$ = cNode( STATEMENT, NULL, 1, $1 ); }
						| while_statement 															{ 	$$ = cNode( STATEMENT, NULL, 1, $1 ); }
						| print_statement 															{ 	$$ = cNode( STATEMENT, NULL, 1, $1 ); }	
						| null_statement 															{ 	$$ = cNode( STATEMENT, NULL, 1, $1 ); }
						| block 																	{ 	$$ = cNode( STATEMENT, NULL, 1, $1 ); }
;


block 					: OPENBLOCK declaration_list statement_list CLOSEBLOCK 						{ 	$$ = cNode( BLOCK, NULL, 2, $2, $3 ); }
						| OPENBLOCK statement_list CLOSEBLOCK 										{ 	$$ = cNode( BLOCK, NULL, 1, $2 ); }
;
assignment_statement 	: identifier ':' '=' expression 											{ 	$$ = cNode( ASSIGNMENT_STATEMENT, NULL, 2, $1, $4 ); }
;
return_statement 		: RETURN expression 														{ 	$$ = cNode( RETURN_STATEMENT, NULL, 1, $2); }
;
print_statement			: PRINT print_list 															{ 	$$ = cNode( PRINT_STATEMENT, NULL, 1, $1 ); }
;
null_statement			: CONTINUE 																	{ 	$$ = cNode( NULL_STATEMENT, NULL, 1, $1 ); }
;
if_statement			: IF relation THEN statement 												{ 	$$ = cNode( IF_STATEMENT, NULL, 2, $2, $4 ); }
						| IF relation THEN statement ELSE statement 								{ 	$$ = cNode( IF_STATEMENT, NULL, 3, $2, $4, $6 ); }
;
while_statement 		: WHILE relation DO statement 												{ 	$$ = cNode( WHILE_STATEMENT, NULL, 2, $2, $4 ); }
;


relation				: expression '=' expression 												{ 	$$ = cNode( RELATION, '=', 2, $1, $3 ); }
						| expression '<' expression 												{ 	$$ = cNode( RELATION, '<', 2, $1, $3 ); }
						| expression '>' expression 												{ 	$$ = cNode( RELATION, '>', 2, $1, $3 ); }
;
expression				: number 																	{ 	$$ = cNode( EXPRESSION, NULL, 1, $1 ); }
						| identifier 																{ 	$$ = cNode( EXPRESSION, NULL, 1, $1 ); }
						| identifier '(' argument_list ')' 											{ 	$$ = cNode( EXPRESSION, NULL, 2, $1, $3 ); }
						| expression '+' expression 												{ 	$$ = cNode( EXPRESSION, '+', 2, $1, $3 ); }
						| expression '-' expression 												{ 	$$ = cNode( EXPRESSION, '-', 2, $1, $3 ); }
						| expression '*' expression 												{ 	$$ = cNode( EXPRESSION, '*', 2, $1, $3 ); }
						| expression '/' expression 												{ 	$$ = cNode( EXPRESSION, '/', 2, $1, $3 ); }
						| '-' expression     														{ 	$$ = cNode( EXPRESSION, NULL, 1, $2 ); }
						| '(' expression ')' 														{ 	$$ = cNode( EXPRESSION, NULL, 1, $2 ); }
;

declaration 			: VAR variable_list 														{ 	$$ = cNode( DECLARATION, NULL, 1, $2 ); }
;
print_item				: expression 																{ 	$$ = cNode( PRINT_ITEM, NULL, 1, $1 ); }
						| string 																	{ 	$$ = cNode( PRINT_ITEM, NULL, 1, $1 ); }
;

identifier 				: IDENTIFIER 																{ 	$$ = cNode( IDENTIFIER, strdup (yytext), 0 ); }
;
number 					: NUMBER 																	{ 	$$ = cNode( NUMBER, strtol ( yytext, NULL, 10 ), 0 ) }
;
string 					: STRING 																	{ 	$$ = cNode( STRING, strdup (yytext), 0 ); }
;

%%

int
yyerror ( const char *error )
{
    fprintf ( stderr, "%s on line %d\n", error, yylineno );
    exit ( EXIT_FAILURE );
}
