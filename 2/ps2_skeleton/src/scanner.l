%{
#include <vslc.h>
%}
%option noyywrap
%option array
%option yylineno

%%
FUNC                    			{ return FUNC; }
BEGIN           			       	{ return OPENBLOCK; }
END				                   	{ return CLOSEBLOCK; }
RETURN 				                { return RETURN; }
PRINT               			    { return PRINT; }
CONTINUE			                { return CONTINUE; }
IF                			    	{ return IF; }
THEN                  				{ return THEN; }
ELSE                   				{ return ELSE; }
WHILE                   			{ return WHILE; }
DO              			      	{ return DO; }
VAR 			                   	{ return VAR; }

\/\/.*\n 							{ }

\t									{ }
\n									{ }
\r									{ }
\v									{ }
"\ "		 						{ }

\"([^"]|(\\\"))*\" 					{ return STRING;}
[0-9]+ 								{ return NUMBER;}
[a-z|A-Z|_][a-z|A-Z|0-9|_]* 		{ return IDENTIFIER; }

.                       			{ return yytext[0]; }

%%
