%{
#include <vslc.h>
%}
%option noyywrap
%option array
%option yylineno

%%
FUNC                    			{ printf("Recognized %s\n", "FUNC");return FUNC; }
BEGIN           			       	{ printf("Recognized %s\n", "BEGIN");return OPENBLOCK; }
END				                   	{ printf("Recognized %s\n", "END");return CLOSEBLOCK; }
RETURN 				                { printf("Recognized %s\n", "RETURN");return RETURN; }
PRINT               			    { printf("Recognized %s\n", "PRINT");return PRINT; }
CONTINUE			                { printf("Recognized %s\n", "CONTINUE");return CONTINUE; }
IF                			    	{ printf("Recognized %s\n", "IF");return IF; }
THEN                  				{ printf("Recognized %s\n", "THEN");return THEN; }
ELSE                   				{ printf("Recognized %s\n", "ELSE");return ELSE; }
WHILE                   			{ printf("Recognized %s\n", "WHILE");return WHILE; }
DO              			      	{ printf("Recognized %s\n", "DO");return DO; }
VAR 			                   	{ printf("Recognized %s\n", "VAR");return VAR; }

\/\/.*\n 							{ printf("Recognized %s\n", "Comment"); }

\t									{ printf("Recognized %s\n", "tab"); }
\n									{ printf("Recognized %s\n", "newline"); }
\r									{ printf("Recognized %s\n", "carriage return"); }
\v									{ printf("Recognized %s\n", "vertical tab"); }
"\ "		 						{ printf("Recognized %s\n", "space"); }

\".*\" 								{ printf("Recognized %s\n", "STRING"); return STRING;}
[0-9]+ 								{ printf("Recognized %s\n", "NUMBER"); return NUMBER;}
[a-z|A-Z][a-z|A-Z|0-9|_]+ 			{ printf("Recognized %s\n", "IDENTIFIER"); return IDENTIFIER; }

.                       			{ printf("Recognized %s\n", "+ and such");return yytext[0]; }

%%
