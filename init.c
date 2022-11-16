#include "hoc.h"
#include "y.tab.h"
#include <math.h>

static struct {		/* Keywords */
	char	*name;
	int	kval;
} keywords[] = {
	{"I", 		I},	// sqrt(-1)
	{"proc",	PROC},
	{"func",	FUNC},
	{"return",	RETURN},
	{"if",		IF},
	{"else",	ELSE},
	{"while",	WHILE},
	{"for",		FOR},
	{"print",	PRINT},
	{"read",	READ},
	{0,		0}
};

static struct {		/* Constants */
	char *name;
	double cval;
} consts[] = {
	{"PI",	 3.14159265358979323846},
	{"E",	 2.71828182845904523536},
	{"GAMMA", 0.57721566490153286060},  	/* Euler */
	{"DEG",	57.29577951308232087680},  	/* deg/radian */
	{"PHI",   1.61803398874989484820},  	/* golden ratio */
	{"PREC",	15},			/* output precision */
	{0,	 0}
};

static struct {		/* Built-ins */
	char *name;
	COMPLEX	(*func)(COMPLEX);
} builtins[] = {
	{"abs",	Fabs},
	{"acos", Acos},		/* checks range */
	{"asin", Asin},		/* checks range */
	{"atan", Atan},
	{"cos",	Cos},
	{"cosh", Cosh},		/* checks range */
	{"erfc", Erfc},
	{"erf",	 Erf},
	{"exp",	Exp},		/* checks range */
	{"gamma", Gamma},	/* checks range */
	{"int",	integer},
	{"log10", Log10},	/* checks range */
	{"log",	 Log},		/* checks range */
	{"mag",	 Mag},		
	{"re",	 Re},		
	{"im",	 Im},		
	{"sinh", Sinh},		/* checks range */
	{"sin",	Sin},
	{"sqrt", Sqrt},		/* checks range */
	{"tanh", Tanh},
	{"tan",	Tan},
	{0,	0}
};

void
init(void)	/* install constants and built-ins in table */
{
	int i;
	Symbol *s;
	COMPLEX tmp;
	for (i = 0; keywords[i].name; i++) {
	    tmp.re = 0.0; tmp.im = 0.0;
	    install(keywords[i].name, keywords[i].kval, tmp);
	}
	for (i = 0; consts[i].name; i++) {
	    tmp.re = consts[i].cval; tmp.im = 0.0;
	    install(consts[i].name, VAR, tmp);
	}
	for (i = 0; builtins[i].name; i++) {
	        tmp.re = 0.0; tmp.im = 0.0;
		s = install(builtins[i].name, BLTIN, tmp);
		s->u.ptr = builtins[i].func;
	}
}
