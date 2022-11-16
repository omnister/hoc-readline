%{
#include <string.h>
#include <signal.h>
#include "hoc.h"
#include "rlgetc.h"
#include <errno.h>
#define	code2(c1,c2)	code(c1); code(c2)
#define	code3(c1,c2,c3)	code(c1); code(c2); code(c3)
double re, im;
extern int       indef;
void yyerror(char* s);
int yylex(void);
int yydebug;
%}
%union {
	Symbol	*sym;	/* symbol table pointer */
	Inst	*inst;	/* machine instruction */
	size_t	narg;	/* number of arguments */
}
%token	<sym>	I
%token	<sym>	NUMBER STRING PRINT VAR BLTIN UNDEF WHILE FOR IF ELSE
%token	<sym>	FUNCTION PROCEDURE RETURN FUNC PROC READ
%token	<narg>	ARG
%type	<inst>	expr stmt asgn prlist stmtlist
%type	<inst>	cond while for if begin end 
%type	<sym>	procname
%type	<narg>	arglist
%right	'=' ADDEQ SUBEQ MULEQ DIVEQ MODEQ
%left	OR
%left	AND
%left	GT GE LT LE EQ NE
%left	'+' '-'
%left	'*' '/' '%'
%left	UNARYMINUS NOT INC DEC
%right	'^'
%%
list:	  /* nothing */
	| list eos 
	| list defn eos
	| list asgn eos  { code2(xpop, STOP); return 1; }
	| list stmt eos  { code(STOP); return 1; } 
	| list expr eos  { code2(printtop, STOP); return 1; }
	| list error eos { yyerrok; }
	;
asgn:	  VAR '=' expr { code3(varpush,(Inst)$1,assign); $$=$3; }
	| VAR ADDEQ expr	{ code3(varpush,(Inst)$1,addeq); $$=$3; }
	| VAR SUBEQ expr	{ code3(varpush,(Inst)$1,subeq); $$=$3; }
	| VAR MULEQ expr	{ code3(varpush,(Inst)$1,muleq); $$=$3; }
	| VAR DIVEQ expr	{ code3(varpush,(Inst)$1,diveq); $$=$3; }
	| VAR MODEQ expr	{ code3(varpush,(Inst)$1,modeq); $$=$3; }
	| ARG '=' expr   { defnonly("$"); code2(argassign,(Inst)$1); $$=$3;}
	| ARG ADDEQ expr { defnonly("$"); code2(argaddeq,(Inst)$1); $$=$3;}
	| ARG SUBEQ expr { defnonly("$"); code2(argsubeq,(Inst)$1); $$=$3;}
	| ARG MULEQ expr { defnonly("$"); code2(argmuleq,(Inst)$1); $$=$3;}
	| ARG DIVEQ expr { defnonly("$"); code2(argdiveq,(Inst)$1); $$=$3;}
	| ARG MODEQ expr { defnonly("$"); code2(argmodeq,(Inst)$1); $$=$3;}
	;
stmt:	  expr	{ code(xpop); }
	| RETURN { defnonly("return"); code(procret); }
	| RETURN expr
	        { defnonly("return"); $$=$2; code(funcret); }
	| PROCEDURE begin '(' arglist ')'
		{ $$ = $2; code3(call, (Inst)$1, (Inst)$4); }
	| PRINT prlist	{ $$ = $2; }
	| while '(' cond ')' stmt end {
		($1)[1] = (Inst)$5;	/* body of loop */
		($1)[2] = (Inst)$6; }	/* end, if cond fails */
	| for '(' cond ';' cond ';' cond ')' stmt end {
		($1)[1] = (Inst)$5;	/* condition */
		($1)[2] = (Inst)$7;	/* post loop */
		($1)[3] = (Inst)$9;	/* body of loop */
		($1)[4] = (Inst)$10; }	/* end, if cond fails */
	| if '(' cond ')' stmt end {	/* else-less if */
		($1)[1] = (Inst)$5;	/* thenpart */
		($1)[3] = (Inst)$6; }	/* end, if cond fails */
	| if '(' cond ')' stmt end ELSE stmt end {	/* if with else */
		($1)[1] = (Inst)$5;	/* thenpart */
		($1)[2] = (Inst)$8;	/* elsepart */
		($1)[3] = (Inst)$9; }	/* end, if cond fails */
	| '{' stmtlist '}'	{ $$ = $2; }
	;
cond:	   expr 	{ code(STOP); }
	;
while:	  WHILE	{ $$ = code3(whilecode,STOP,STOP); }
	;
for:	  FOR	{ $$ = code(forcode); code3(STOP,STOP,STOP); code(STOP); }
	;
if:	  IF	{ $$ = code(ifcode); code3(STOP,STOP,STOP); }
	;
begin:	  /* nothing */		{ $$ = progp; }
	;
end:	  /* nothing */		{ code(STOP); $$ = progp; }
	;
stmtlist: /* nothing */		{ $$ = progp; }
	| stmtlist eos
	| stmtlist stmt
	;
expr:	  NUMBER { $$ = code2(constpush, (Inst)$1); }
	| NUMBER I {
		re = $1->u.val.re;
		$1->u.val.re=0.0;
		$1->u.val.im=re;
		$$ = code2(constpush, (Inst)$1); 
	    }
	| I	 {
		$1->u.val.re=0.0;
		$1->u.val.im=1.0;
		$$ = code2(constpush, (Inst)$1); 
	}
	| VAR	 { $$ = code3(varpush, (Inst)$1, eval); }
	| ARG	 { defnonly("$"); $$ = code2(arg, (Inst)$1); }
	| asgn
	| FUNCTION begin '(' arglist ')'
		{ $$ = $2; code3(call,(Inst)$1,(Inst)$4); }
	| READ '(' VAR ')' { $$ = code2(varread, (Inst)$3); }
	| BLTIN '(' expr ')' { $$=$3; code2(bltin, (Inst)$1->u.ptr); }
	| '(' expr ')'	{ $$ = $2; }
	| expr '+' expr	{ code(add); }
	| expr '-' expr	{ code(sub); }
	| expr '*' expr	{ code(mul); }
	| expr '/' expr	{ code(divop); }	/* ansi has a div fcn! */
	| expr '%' expr	{ code(mod); }
	| expr '^' expr	{ code (power); }
	| '-' expr   %prec UNARYMINUS   { $$=$2; code(negate); }
	| expr GT expr	{ code(gt); }
	| expr GE expr	{ code(ge); }
	| expr LT expr	{ code(lt); }
	| expr LE expr	{ code(le); }
	| expr EQ expr	{ code(eq); }
	| expr NE expr	{ code(ne); }
	| expr AND expr	{ code(and); }
	| expr OR expr	{ code(or); }
	| NOT expr	{ $$ = $2; code(not); }
	| INC VAR	{ $$ = code2(preinc,(Inst)$2); }
	| DEC VAR	{ $$ = code2(predec,(Inst)$2); }
	| VAR INC	{ $$ = code2(postinc,(Inst)$1); }
	| VAR DEC	{ $$ = code2(postdec,(Inst)$1); }
	;
prlist:	  expr			{ code(prexpr); }
	| STRING		{ $$ = code2(prstr, (Inst)$1); }
	| prlist ',' expr	{ code(prexpr); }
	| prlist ',' STRING	{ code2(prstr, (Inst)$3); }
	;
defn:	  FUNC procname { $2->type=FUNCTION; indef=1; }
	    '(' ')' stmt { code(procret); define($2); indef=0; }
	| PROC procname { $2->type=PROCEDURE; indef=1; }
	    '(' ')' stmt { code(procret); define($2); indef=0; }
	;
procname: VAR
	| FUNCTION
	| PROCEDURE
	;
arglist:  /* nothing */ 	{ $$ = 0; }
	| expr			{ $$ = 1; }
	| arglist ',' expr	{ $$ = $1 + 1; }
	;
eos:      '\n'
        | ';'
        ;
    
%%


	/* end of grammar */
#include <math.h>
#include <stdio.h>
#include <ctype.h>
#include <signal.h>
#include <setjmp.h>
#include <errno.h>

#include <sys/types.h>
#include <sys/file.h>
#include <sys/stat.h>
#include <sys/errno.h>

jmp_buf	begin;
char	*progname;
int	lineno = 1;
int	indef;
char	*infile;	/* input file name */
FILE	*fin;		/* input file pointer */
char	**gargv;	/* global argument list */
/* extern	errno; */
int	gargc;

int c = '\n';	/* global for use by warning() */

int	backslash(int), follow(int, int, int);
void	defnonly(char*), run(void);
void	warning(char*, char*);
double  getdouble();

int yylex(void)		/* hoc6 */
{
	COMPLEX tmp;

	while ((c=rlgetc(fin)) == ' ' || c == '\t')
		;
	if (c == EOF)
		return 0;
	if (c == '\\') {
		c = rlgetc(fin);
		if (c == '\n') {
			lineno++;
			return yylex();
		}
	}
	if (c == '#') {		/* comment */
		while ((c=rlgetc(fin)) != '\n' && c != EOF)
			;
		if (c == '\n')
			lineno++;
		return c;
	}
	if (c == '.' || isdigit(c)) {   /* number */
	    double d;
	    rl_ungetc(c,fin);

	    /* printf("calling getdouble()..."); */
	    d = getdouble(fin); 
	    /* printf("returned with %e\n",d); */

	    /************ Engineering Notation <RCW> 10/1/93 **********/
	    switch(c=rlgetc(fin)) {
		case 'A':
		case 'a': d*=1e-18; break;
		case 'F':
		case 'f': d*=1e-15; break;
		case 'P':
		case 'p': d*=1e-12; break;
		case 'N':
		case 'n': d*=1e-9;  break;
		case 'U':
		case 'u': d*=1e-6;  break;
		case 'M':
		case 'm': 
		    if((c=rlgetc(fin)) == 'e' || c == 'E') {
			if((c=rlgetc(fin)) == 'g' || c == 'G') {
			    d*=1e6;
			} else {
			    execerror("bad engineering notation", (char *)0);
			}		
		    } else {
			rl_ungetc(c,fin);
			d*=1e-3; 
		    }
		    break;
		case 'K':
		case 'k': d*=1e3;  break;
		case 'G':
		case 'g': d*=1e9;  break;
		case 'T':
		case 't': d*=1e12;  break;
		default: rl_ungetc(c,fin);
	    }
	    /************************************************************/
	    tmp.re = d;
	    tmp.im = 0.0;
	    yylval.sym = install("", NUMBER, tmp);
	    return NUMBER;
	}
	if (isalpha(c) || c == '_') {
		Symbol *s;
		char sbuf[100], *p = sbuf;
		do {
			if (p >= sbuf + sizeof(sbuf) - 1) {
				*p = '\0';
				execerror("name too long", sbuf);
			}
			*p++ = c;
		} while ((c=rlgetc(fin)) != EOF && (isalnum(c) || c == '_'));
		rl_ungetc(c, fin);
		*p = '\0';
		if ((s=lookup(sbuf)) == 0) {
		    tmp.re = 0.0; tmp.im = 0.0;
		    s = install(sbuf, UNDEF, tmp);
		}
		yylval.sym = s;
		return s->type == UNDEF ? VAR : s->type;
	}
	if (c == '$') {	/* argument? */
		int n = 0;
		while (isdigit(c=rlgetc(fin)))
			n = 10 * n + c - '0';
		rl_ungetc(c, fin);
		if (n == 0)
			execerror("strange $...", (char *)0);
		yylval.narg = n;
		return ARG;
	}
	if (c == '"') {	/* quoted string */
		char sbuf[100], *p;
		for (p = sbuf; (c=rlgetc(fin)) != '"'; p++) {
			if (c == '\n' || c == EOF)
				execerror("missing quote", "");
			if (p >= sbuf + sizeof(sbuf) - 1) {
				*p = '\0';
				execerror("string too long", sbuf);
			}
			*p = backslash(c);
		}
		*p = 0;
		yylval.sym = (Symbol *)emalloc(strlen(sbuf)+1);
		strcpy((char*)yylval.sym, sbuf);
		return STRING;
	}
	switch (c) {
	case '+':	return follow('+', INC, follow('=', ADDEQ, '+'));
	case '-':	return follow('-', DEC, follow('=', SUBEQ, '-'));
	case '*':	return follow('=', MULEQ, '*');
	case '/':	return follow('=', DIVEQ, '/');
	case '%':	return follow('=', MODEQ, '%');
	case '>':	return follow('=', GE, GT);
	case '<':	return follow('=', LE, LT);
	case '=':	return follow('=', EQ, '=');
	case '!':	return follow('=', NE, NOT);
	case '|':	return follow('|', OR, '|');
	case '&':	return follow('&', AND, '&');
	case '\n':	lineno++; return '\n';
	default:	return c;
	}
}

/* parse an input of the form [0-9]*.[0-9]*[eE][+-][0-9]* */
/* using just rlgetc(fin) and rl_ungetc(c,fin) */

double getdouble(fin) 	
FILE *fin;
{
    int c;
    int state=0;
    int done=0;
    double val=0.0;
    double frac=1.0;
    double expsign=1.0;
    double exp=0.0;
    
    state=0;

    while (!done) {
	c = rlgetc(fin);
	switch (state) {
	    case 0: 	/* integer part */
		if (isdigit(c)) {
		    val=10.0*val+(double) (c-'0');	
		} else if (c=='.') {
		    state=1;
		} else if (c=='e' || c=='E') {
		    state=2;
		} else {
		    rl_ungetc(c,fin);
		    done++;
		}
		break;
	    case 1:	/* decimal part */
		if (isdigit(c)) {
		    frac /= 10.0;
		    val=val+((double) (c-'0'))*frac;
		} else if (c=='e' || c=='E') {
		    state=2;
		} else {
		    rl_ungetc(c,fin);
		    done++;
		}
		break;
	    case 2:	/* exponent sign */
		if (c=='+') {
		    state=3;
		} else if (c=='-') {
		    expsign=-1.0;
		    state=3;
		} else if (isdigit(c)) {
		    rl_ungetc(c,fin);
		    state=3;
		} else {
		    rl_ungetc(c,fin);
		    done++;
		}
		break;
	    case 3:	/* exponent value */
		if (isdigit(c)) {
		    exp=10.0*exp+(double) (c-'0');	
		} else {
		    rl_ungetc(c,fin);
		    done++;
		}
		break;
	}
/*	printf("state=%d, c=%c, val=%g, frac=%g exp=%e expsign=%e, pow=%e\n",
	    state,c,val,frac,exp,expsign, pow(10.0,exp*expsign)); */
    }

    return(val*pow(10.0,exp*expsign));
}

int backslash(int c)	/* get next char with \'s interpreted */
{
	static char transtab[] = "b\bf\fn\nr\rt\t";
	if (c != '\\')
		return c;
	c = rlgetc(fin);
	if (islower(c) && strchr(transtab, c))
		return strchr(transtab, c)[1];
	return c;
}

int follow(int expect, int ifyes, int ifno)	/* look ahead for >=, etc. */
{
	int c = rlgetc(fin);

	if (c == expect)
		return ifyes;
	rl_ungetc(c, fin);
	return ifno;
}

void yyerror(char* s)	/* report compile-time error */
{
/*rob
	warning(s, (char *)0);
	longjmp(begin, 0);
rob*/
	execerror(s, (char *)0);
}

void execerror(char* s, char* t)	/* recover from run-time error */
{
	warning(s, t);
	fseek(fin, 0L, 2);		/* flush rest of file */
	longjmp(begin, 0);
}

typedef void (*sighandler_t)(int);

void
fpecatch(void)	/* catch floating point exceptions */
{
	execerror("floating point exception", (char *) 0);
}

void
intcatch(void)	/* catch interrupts */
{
	execerror("interrupt", (char *) 0);
}

void
run(void)	/* execute until EOF */
{
	setjmp(begin);
	signal(SIGINT, (sighandler_t) intcatch);
	signal(SIGFPE, (sighandler_t) fpecatch);
	for (initcode(); yyparse(); initcode())
		execute(progbase);
}



int main(int argc, char* argv[])	/* hoc6 */
{
	static int first = 1;
#ifdef YYDEBUG
	extern int yydebug;
	yydebug=3;
#endif
	progname = argv[0];

        void initialize_readline();
        initialize_readline();	/* Bind our completer. */
	init();

	if (argc == 1) {	/* fake an argument list */
		static char *stdinonly[] = { "-" };

		gargv = stdinonly;
		gargc = 1;
	} else if (first) {	/* for interrupts */
		first = 0;
		gargv = argv+1;
		gargc = argc-1;
	}
	while (moreinput())
		run();
	signal(SIGINT, SIG_IGN);
	return 0;
}

int moreinput(void)
{
	if (gargc-- <= 0)
		return 0;
	if (fin && fin != stdin)
		fclose(fin);
	infile = *gargv++;
	lineno = 1;
	if (strcmp(infile, "-") == 0) {
		fin = stdin;
		infile = 0;
	} else if ((fin=fopen(infile, "r")) == NULL) {
		fprintf(stderr, "%s: can't open %s\n", progname, infile);
		return moreinput();
	}
	return 1;
}

void
warning(char *s, char *t)	/* print warning message */
{
	fprintf(stderr, "%s: %s", progname, s);
	if (t)
		fprintf(stderr, " %s", t);
	if (infile)
		fprintf(stderr, " in %s", infile);
	fprintf(stderr, " near line %d\n", lineno);
	while (c != '\n' && c != EOF)
		if((c = rlgetc(fin)) == '\n')	/* flush rest of input line */
			lineno++;
		else if (c == EOF && errno == EINTR) {
			clearerr(stdin);	/* ick! */
			errno = 0;
		}
}

void
defnonly(char *s)	/* warn if illegal definition */
{
	if (!indef)
		execerror(s, "used outside definition");
}

