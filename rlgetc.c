#include <stdio.h>
#include <stdlib.h>
#include <readline/readline.h>
#include <readline/history.h>  

/* *************************************************** */
/* some routines to implement command line history ... */
/* *************************************************** */

extern char *xmalloc();
char *lineread = (char *) NULL;
int pushback = '\0';


int xrlgetc(fd) 
FILE *fd;
{
    int c;
    c=getc(fd);
    /* printf("->%2.2x %c\n",c,c); */
    return (c);
}

int xrl_ungetc(c,fd)
int c;
FILE *fd;
{
    /* printf("ungetting %2.2x %c\n",c,c); */
    return ungetc(c,fd);
}


/* expand and duplicate a string with malloc */

char * expdupstr(char *s, int n)
{
    char *r;

    r = xmalloc(strlen( (char *) s) + n);
    strcpy(r, (char *) s);
    return (r);
}

int rl_ungetc(c,fd) 
int c;
FILE *fd;
{
    /* printf("ungetting %2.2x %c\n",c,c); */

    if (fd != stdin) {
	return(ungetc(c,fd));
    } else {
	pushback=c;
	return(1);
    }
}


/* Read a string, and return a pointer to it.  Returns NULL on EOF. */
char * rl_gets (prompt)
char *prompt;
{

    char *s;

    /* If the buffer has already been allocated, return the memory
       to the free pool. */

    if (lineread) {
        free (lineread);
        lineread = (char *) NULL;
    }

    /* Get a line from the user. */
    /* printf("entering readline\n"); */
    lineread = readline (prompt);
    if (lineread == NULL) {
	/* printf("got a NULL\n"); */
	return(NULL);
    }
    fflush(stdout);

    /* If the line has any text in it, save it on the history. */
    if (lineread && *lineread)
	add_history (lineread);
    
    /* add a newline to return string */

    s = expdupstr(lineread,2);
    strcat(s,"\n");
    free (lineread);
    lineread = s;

    return (lineread);
}

void initialize_readline()
{
    /* Allow conditional parsing of the ~/.inputrc file. */
    rl_readline_name = "hoc";
}


int rlgetc(fd)
FILE *fd;
{
    int c;
    static char *lp = NULL;

    if (fd != stdin) {
	c=getc(fd);
    } else {
	if (pushback != '\0') {
	    c=pushback;
	    pushback='\0';
	} else if(lp != NULL && *lp != '\0') {
	    c=*(lp++);
	} else {
	    lineread=rl_gets("> ");
	    if (lineread == NULL) {
		c=EOF;
	    } else {
		lp = lineread;
		c=*(lp++);
	    }
	}
    }

    /* printf("->%2.2x %c\n",c,c); */
    return (c);
}
