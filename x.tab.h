#define I 257
#define NUMBER 258
#define STRING 259
#define PRINT 260
#define VAR 261
#define BLTIN 262
#define UNDEF 263
#define WHILE 264
#define FOR 265
#define IF 266
#define ELSE 267
#define FUNCTION 268
#define PROCEDURE 269
#define RETURN 270
#define FUNC 271
#define PROC 272
#define READ 273
#define ARG 274
#define ADDEQ 275
#define SUBEQ 276
#define MULEQ 277
#define DIVEQ 278
#define MODEQ 279
#define OR 280
#define AND 281
#define GT 282
#define GE 283
#define LT 284
#define LE 285
#define EQ 286
#define NE 287
#define UNARYMINUS 288
#define NOT 289
#define INC 290
#define DEC 291
#ifdef YYSTYPE
#undef  YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
#endif
#ifndef YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
typedef union {
	Symbol	*sym;	/* symbol table pointer */
	Inst	*inst;	/* machine instruction */
	size_t	narg;	/* number of arguments */
} YYSTYPE;
#endif /* !YYSTYPE_IS_DECLARED */
extern YYSTYPE yylval;
