#include <math.h>
#include <errno.h>
extern	int	errno;

#include "hoc.h"

double errcheck(double, char*);

COMPLEX Mag(COMPLEX x) {
   COMPLEX result;
   result.re = sqrt(x.re*x.re + x.im*x.im);
   result.im = 0.0;
   return(result);
}

COMPLEX Re(COMPLEX x) {
   COMPLEX result;
   result.re = x.re;
   result.im = 0.0;
   return(result);
}

COMPLEX Im(COMPLEX x) {
   COMPLEX result;
   result.re = x.im;
   result.im = 0.0;
   return(result);
}

COMPLEX Erf(COMPLEX x) {
   COMPLEX result;
   result.re = erf(x.re);
   result.im = 0.0;
   return(result);
}

COMPLEX Erfc(COMPLEX x) {
   COMPLEX result;
   result.re = erfc(x.re);
   result.im = 0.0;
   return(result);
}

COMPLEX Sin(COMPLEX x) {
   COMPLEX result;
   result.re = sin(x.re);
   result.im = 0.0;
   return(result);
}

COMPLEX Cos(COMPLEX x) {
   COMPLEX result;
   result.re = cos(x.re);
   result.im = 0.0;
   return(result);
}

COMPLEX Tan(COMPLEX x) {
   COMPLEX result;
   result.re = tan(x.re);
   result.im = 0.0;
   return(result);
}

COMPLEX Tanh(COMPLEX x) {
   COMPLEX result;
   result.re = tanh(x.re);
   result.im = 0.0;
   return(result);
}

COMPLEX Atan(COMPLEX x) {
   COMPLEX result;
   result.re = atan(x.re);
   result.im = 0.0;
   return(result);
}

COMPLEX Fabs(COMPLEX x) {
   COMPLEX result;
   result.re = fabs(x.re);
   result.im = 0.0;
   return(result);
}

COMPLEX Log(COMPLEX x)
{
   COMPLEX result;
   result.re = errcheck(log(x.re), "log");
   result.im = 0.0;
   return(result);
}

COMPLEX Log10(COMPLEX x)
{
   COMPLEX result;
   result.re = errcheck(log10(x.re), "log10");
   result.im = 0.0;
   return(result);
}

COMPLEX
Sqrt(COMPLEX x)
{
   COMPLEX result;
   result.re = errcheck(sqrt(x.re), "sqrt");
   result.im = 0.0;
   return(result);
}

COMPLEX
Gamma(COMPLEX x)
{
        COMPLEX result;
	double y;
	extern int signgam;
	y=errcheck(gamma(x.re), "gamma");
	if(y>88.0)
		execerror("gamma result out of range", (char *)0);
	result.re = signgam*exp(y);
	result.im = 0.0;
	return result;
}

COMPLEX
Exp(COMPLEX x)
{
   COMPLEX result;
   result.re = errcheck(exp(x.re), "exp");
   result.im = 0.0;
   return(result);
}

COMPLEX
Asin(COMPLEX x)
{
   COMPLEX result;
   result.re = errcheck(asin(x.re), "asin");
   result.im = 0.0;
   return(result);
}

COMPLEX
Acos(COMPLEX x)
{
   COMPLEX result;
   result.re = errcheck(acos(x.re), "acos");
   result.im = 0.0;
   return(result);
}

COMPLEX
Sinh(COMPLEX x)
{
   COMPLEX result;
   result.re = errcheck(sinh(x.re), "sinh");
   result.im = 0.0;
   return(result);
}

COMPLEX
Cosh(COMPLEX x)
{
   COMPLEX result;
   result.re = errcheck(cosh(x.re), "cosh");
   result.im = 0.0;
   return(result);
}

// fixme should do complex equivalent, not just real parts

COMPLEX
Pow(COMPLEX x, COMPLEX y)
{
   COMPLEX result;
   result.re = errcheck(pow(x.re, y.re), "exponentiation");
   result.im = 0.0;
   return(result);
}

COMPLEX
integer(COMPLEX x)
{
   COMPLEX result;
   result.re = (long) x.re;
   result.im = 0.0;
   return(result);
}

double
errcheck(double d, char* s)	/* check result of library call */
{
	if (errno == EDOM) {
		errno = 0;
		execerror(s, "argument out of domain");
	} else if (errno == ERANGE) {
		errno = 0;
		execerror(s, "result out of range");
	}
	return d;
}
