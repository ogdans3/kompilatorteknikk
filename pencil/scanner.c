#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <ctype.h>

#include "pencil.h"


int transitionTable [9][360];
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
	transitionTable[0][(int)'t'] = 2;
	transitionTable[0][(int)'d'] = 3;

	transitionTable[1][(int)'o'] = 4;
	transitionTable[2][(int)'u'] = 5;
	transitionTable[3][(int)'r'] = 6;

	transitionTable[4][(int)'v'] = 7;
	transitionTable[5][(int)'r'] = 8;
	transitionTable[6][(int)'a'] = 9;

	transitionTable[7][(int)'e'] = -1;
    transitionTable[8][(int)'n'] = -1;
    transitionTable[9][(int)'w'] = -1;

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

		// Here we read the input again, iff it went from an accepting
		// step to state 0, means that mmove will be recognized
		if( newState == 0  ){
			newState = transitionTable[ newState ][(int)c];
		}
		//Since all the tokens are of the same length, we do not actually have to clean the token array
		//when a word fails, since it will automatically rewrite the values correctly.
		token[__index] = c;

		/*
		printf( "%s\n", token );
		printf( "%d\n", __index );
		printf( "%d\n", newState );
		*/	
		if( newState == -1 ){
	        	if( __index == 7 ){
                		return MOVE;
       			}
        		else if( __index == 8 ){
                		return TURN;
        		} 
        		else if( __index == 9 ){
                		return DRAW;
        		}else{
				return END;
			}
		}
		__index = newState;

	}while( c != EOF );
   	return END;
}
