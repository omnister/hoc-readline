
#include <math.h>
#include <stdio.h>


/* parse an input of the form [0-9]*.[0-9]*[eE][+-][0-9]* */
/* using just rlgetc(fin) and rl_ungetc(c,fin) */

double getdouble();

main() {
    int c;

    while(1) {
	while( !isdigit(c=getc(stdin)) && c!='.' ) {
	    ;
	}
	ungetc(c,stdin);
	printf("getdouble got: %g\n",getdouble(stdin));
    }
}

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
	c = getc(fin);
	switch (state) {
	    case 0: 	/* integer part */
		if (isdigit(c)) {
		    val=10.0*val+(double) (c-'0');	
		} else if (c=='.') {
		    state=1;
		} else if (c=='e' || c=='E') {
		    state=2;
		} else {
		    ungetc(c,fin);
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
		    ungetc(c,fin);
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
		    ungetc(c,fin);
		    state=3;
		} else {
		    ungetc(c,fin);
		    done++;
		}
		break;
	    case 3:	/* exponent value */
		if (isdigit(c)) {
		    exp=10.0*exp+(double) (c-'0');	
		} else {
		    ungetc(c,fin);
		    done++;
		}
		break;
	}
/*	printf("state=%d, c=%c, val=%g, frac=%g exp=%e expsign=%e, pow=%e\n",
	    state,c,val,frac,exp,expsign, pow(10.0,exp*expsign)); */
    }

    return(val*pow(10.0,exp*expsign));
}
