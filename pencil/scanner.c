#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <ctype.h>

#include "pencil.h"


int transitionTable [4][128];
char token[4];
int __index = 0;


// char legalChars = ["m", "o", "v", "e", "t", "u", "r", "n", "d", "a", "w" ]

/*
 * This function is called before anything else, to initialize the
 * state machine. It is certainly possible to create implementations
 * which don't require any initialization, so just leave this blank if
 * you don't need it.
 */

void
init_transtab ( void ){
	transitionTable[0][(int)'m'] = 1;
	transitionTable[0][(int)'t'] = 1;
	transitionTable[0][(int)'d'] = 1;

	transitionTable[1][(int)'o'] = 2;
	transitionTable[1][(int)'u'] = 2;
	transitionTable[1][(int)'r'] = 2;

	transitionTable[2][(int)'v'] = 3;
	transitionTable[2][(int)'r'] = 3;
	transitionTable[2][(int)'a'] = 3;

	transitionTable[3][(int)'e'] = -1;
        transitionTable[3][(int)'n'] = -1;
        transitionTable[3][(int)'w'] = -1;

}





/*
 * Return the next token from reading the given input stream.
 * The words to be recognized are 'turn', 'draw' and 'move',
 * while the returned tokens may be TURN, DRAW, MOVE or END (as
 * enumerated in 'pencil.h').
 */

char c;
int newState; 

command_t
next ( FILE *input )
{
	__index = 0;
	do{
		c = tolower(fgetc( input ));
		newState = transitionTable[__index][(int)c];

		//Since all the tokens are of the same length, we do not actually have to clean the token array
		//when a word fails, since it will automatically rewrite the values correctly.
		token[__index] = c;
		__index = newState;
		/*
		printf( "%s\n", token );
		printf( "%d\n", __index );
		printf( "%d\n", newState );
		*/	
		if( __index == -1 ){
	        	if( token[0] == 'm' ){
                		return MOVE;
       			}
        		else if( token[0] == 'd' ){
                		return DRAW;
        		} 
        		else if( token[0] == 't' ){
				printf( "%s\n", "Turn Recognized");
                		return TURN;
        		}else{
				return END;
			}
		}
	}while( c != EOF );
   	return END;
}
