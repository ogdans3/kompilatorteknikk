#include <vslc.h>


void
node_print ( node_t *root, int nesting )
{
    if ( root != NULL )
    {
        /* Print the type of node indented by the nesting level */
        printf ( "%*c%s", nesting, ' ', node_string[root->type] );

        /* For identifiers, strings, expressions and numbers,
         * print the data element also
         */
        if ( root->type == IDENTIFIER_DATA ||
             root->type == STRING_DATA ||
             root->type == EXPRESSION ) 
            printf ( "(%s)", (char *) root->data );
        else if ( root->type == NUMBER_DATA )
            printf ( "(%ld)", *((int64_t *)root->data) );

        /* Make a new line, and traverse the node's children in the same manner */
        putchar ( '\n' );
        for ( int64_t i=0; i<root->n_children; i++ )
            node_print ( root->children[i], nesting+1 );
    }
    else
        printf ( "%*c%p\n", nesting, ' ', root );
}


/* Take the memory allocated to a node and fill it in with the given elements */
void
node_init (node_t *nd, node_index_t type, void *data, uint64_t n_children, ...)
{
    nd->type = type;
    nd->data = data;
    nd->n_children = n_children;


    va_list valist;

    va_start(valist, n_children);

    nd->children = (node_t**) malloc( n_children * sizeof(node_t*) );

    for( int i = 0; i < n_children; i++ ){
        nd->children[i] = va_arg(valist, node_t*);
    }
    va_end(valist);
}


/* Remove a node and its contents */
void
node_finalize ( node_t *discard )
{
    free( discard->data );
    for( int i = 0; i < (int)discard->n_children; i++ ){
        destroy_subtree( discard->children[i] );
    }
}


/* Recursively remove the entire tree rooted at a node */
void
destroy_subtree ( node_t *discard )
{
    if( discard == NULL )
        return;
    printf( "Jeg har en fisk" );
    node_finalize( discard );
    free ( discard );
}
