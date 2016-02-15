%{
#include <vslc.h>

node_t* cNode( node_index_t type, void *data, uint64_t n_children, ... ){
    node_t *nd = (node_t* ) malloc (sizeof(node_t));

    va_list children;

    va_start(children, n_children);
    nd->children = malloc( n_children * sizeof(node_t*) );

    node_init( nd, type, data, n_children, children );

    va_end(children);
    return nd;
	
}

%}
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS

%token FUNC PRINT RETURN CONTINUE IF THEN ELSE WHILE DO OPENBLOCK CLOSEBLOCK
%token VAR NUMBER IDENTIFIER STRING

%%
program 				: global_list 																{ 	root = cNode( PROGRAM, NULL, 1, $1 );
																									}
;

global_list 			: global 																	{ 	$$ = cNode( GLOBAL_LIST, NULL, 1, $1 ); } 
						| global_list global 														{ 	$$ = cNode( GLOBAL_LIST, NULL, 2, $1, $2 ); } 
;

global 					: function  																{ 	$$ = cNode( GLOBAL, NULL, 1, $1 ); } 
						| declaration  																{ 	$$ = cNode( GLOBAL, NULL, 1, $1 ); }
;

statement_list			: statement 																{ 	$$ = cNode( STATEMENT_LIST, NULL, 1, $1 ); }
						| statement_list statement 													{ 	$$ = cNode( STATEMENT_LIST, NULL, 2, $1, $2 ); }
;
print_list 				: print_item 																{ 	$$ = cNode( PRINT_LIST, NULL, 1, $1 ); }
						| print_list ',' print_item 												{ 	$$ = cNode( PRINT_LIST, NULL, 2, $1, $3 ); }
;
expression_list			: expression 																{ 	$$ = cNode( EXPRESSION_LIST, NULL, 1, $1 ); }
						| expression_list ',' expression 											{ 	$$ = cNode( EXPRESSION_LIST, NULL, 2, $1, $3); }
;
variable_list			: identifier 																{ 	$$ = cNode( VARIABLE_LIST, NULL, 1, $1 ); }
						| variable_list ',' identifier 												{ 	$$ = cNode( VARIABLE_LIST, NULL, 2, $1, $3 ); }
;
argument_list			: expression_list 															{ 	$$ = cNode( ARGUMENT_LIST, NULL, 1, $1 ); }
						| /*EMPTY*/ 																{ 	$$ = NULL; }
;
parameter_list			: variable_list 															{ 	$$ = cNode( PARAMETER_LIST, NULL, 1, $1 ); }
						| /*EMPTY*/ 																{ 	$$ = NULL; }
;
declaration_list 		: declaration 																{ 	$$ = cNode( DECLARATION_LIST, NULL, 1, $1 ); }
				 		| declaration_list declaration 												{ 	$$ = cNode( DECLARATION_LIST, NULL, 2, $1, $2 ); }
;

function 				: FUNC identifier '(' parameter_list ')' statement 							{ 	$$ = cNode( FUNCTION, NULL, 3, $2, $4, $6 ); }
;
statement 				: assignment_statement 														{ 	$$ = cNode( STATEMENT, NULL, 1, $1 ); }
						| return_statement 															{ 	$$ = cNode( STATEMENT, NULL, 1, $1 ); }
;
statement 				: print_statement 															{ 	$$ = cNode( STATEMENT, NULL, 1, $1 ); }	
						| if_statement 																{ 	$$ = cNode( STATEMENT, NULL, 1, $1 ); }
;
statement 				: while_statement 															{ 	$$ = cNode( STATEMENT, NULL, 1, $1 ); }
						| null_statement 															{ 	$$ = cNode( STATEMENT, NULL, 1, $1 ); }
						| block 																	{ 	$$ = cNode( STATEMENT, NULL, 1, $1 ); }
;

block 					: OPENBLOCK declaration_list statement_list CLOSEBLOCK 						{ 	$$ = cNode( BLOCK, NULL, 2, $2, $3 ); }
;
block 					: OPENBLOCK statement_list CLOSEBLOCK 										{ 	$$ = cNode( BLOCK, NULL, 1, $2 ); }
;
assignment_statement 	: identifier ':' '=' expression 											{ 	$$ = cNode( ASSIGNMENT_STATEMENT, NULL, 2, $1, $4 ); }
;
return_statement 		: RETURN expression 														{ 	$$ = cNode( RETURN_STATEMENT, NULL, 1, $2); }
;
print_statement			: PRINT print_list 															{ 	$$ = cNode( PRINT_STATEMENT, NULL, 1, $2 ); }
;
null_statement			: CONTINUE 																	{ 	$$ = cNode( NULL_STATEMENT, NULL, 0 ); }
;

if_statement			: IF relation THEN statement 												{ 	$$ = cNode( IF_STATEMENT, NULL, 2, $2, $4 ); }
;
if_statement 			: IF relation THEN statement ELSE statement 								{ 	$$ = cNode( IF_STATEMENT, NULL, 3, $2, $4, $6 ); }
;
while_statement 		: WHILE relation DO statement 												{ 	$$ = cNode( WHILE_STATEMENT, NULL, 2, $2, $4 ); }
;


relation				: expression '=' expression 												{ 	$$ = cNode( RELATION, strdup("="), 2, $1, $3 ); }
;
relation 				: expression '<' expression 												{ 	$$ = cNode( RELATION, strdup("<"), 2, $1, $3 ); }
;
relation 				: expression '>' expression 												{ 	$$ = cNode( RELATION, strdup(">"), 2, $1, $3 ); }
;


expression				: number 																	{ 	$$ = cNode( EXPRESSION, NULL, 1, $1 ); }
						| identifier 																{ 	$$ = cNode( EXPRESSION, NULL, 1, $1 ); }
						| identifier '(' argument_list ')' 											{ 	$$ = cNode( EXPRESSION, NULL, 2, $1, $3 ); }
;
expression 				: expression '+' expression 												{ 	$$ = cNode( EXPRESSION, strdup("+"), 2, $1, $3 ); }
;
expression 				: expression '-' expression 												{ 	$$ = cNode( EXPRESSION, strdup("-"), 2, $1, $3 ); }
;
expression 				: expression '*' expression 												{ 	$$ = cNode( EXPRESSION, strdup("*"), 2, $1, $3 ); }
;
expression 				: expression '/' expression 												{ 	$$ = cNode( EXPRESSION, strdup("/"), 2, $1, $3 ); }
;
expression 				: '-' expression %prec UMINUS   											{ 	$$ = cNode( EXPRESSION, strdup("-"), 1, $2 ); }
;
expression 				: '(' expression ')' 														{ 	$$ = $2; }
;

declaration 			: VAR variable_list 														{ 	$$ = cNode( DECLARATION, NULL, 1, $2 ); }
;
print_item				: expression 																{ 	$$ = cNode( PRINT_ITEM, NULL, 1, $1 ); }
						| string 																	{ 	$$ = cNode( PRINT_ITEM, NULL, 1, $1 ); }
;

identifier 				: IDENTIFIER 																{ 	$$ = cNode( IDENTIFIER_DATA, strdup(yytext), 0 ); }
;
number 					: NUMBER 																	{ 	
																										int64_t *i = malloc( sizeof(*i) );
																										*i = (int64_t) strtol( yytext, NULL, 10 );
																										$$ = cNode( NUMBER_DATA, i, 0 ); 
																									}
;
string 					: STRING 																	{ 	$$ = cNode( STRING_DATA, strdup(yytext), 0 ); }
;

%%

int
yyerror ( const char *error )
{
    fprintf ( stderr, "%s on line %d\n", error, yylineno );
    exit ( EXIT_FAILURE );
}
