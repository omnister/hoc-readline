/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    I = 258,                       /* I  */
    NUMBER = 259,                  /* NUMBER  */
    STRING = 260,                  /* STRING  */
    PRINT = 261,                   /* PRINT  */
    VAR = 262,                     /* VAR  */
    BLTIN = 263,                   /* BLTIN  */
    UNDEF = 264,                   /* UNDEF  */
    WHILE = 265,                   /* WHILE  */
    FOR = 266,                     /* FOR  */
    IF = 267,                      /* IF  */
    ELSE = 268,                    /* ELSE  */
    FUNCTION = 269,                /* FUNCTION  */
    PROCEDURE = 270,               /* PROCEDURE  */
    RETURN = 271,                  /* RETURN  */
    FUNC = 272,                    /* FUNC  */
    PROC = 273,                    /* PROC  */
    READ = 274,                    /* READ  */
    ARG = 275,                     /* ARG  */
    ADDEQ = 276,                   /* ADDEQ  */
    SUBEQ = 277,                   /* SUBEQ  */
    MULEQ = 278,                   /* MULEQ  */
    DIVEQ = 279,                   /* DIVEQ  */
    MODEQ = 280,                   /* MODEQ  */
    OR = 281,                      /* OR  */
    AND = 282,                     /* AND  */
    GT = 283,                      /* GT  */
    GE = 284,                      /* GE  */
    LT = 285,                      /* LT  */
    LE = 286,                      /* LE  */
    EQ = 287,                      /* EQ  */
    NE = 288,                      /* NE  */
    UNARYMINUS = 289,              /* UNARYMINUS  */
    NOT = 290,                     /* NOT  */
    INC = 291,                     /* INC  */
    DEC = 292                      /* DEC  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif
/* Token kinds.  */
#define YYEMPTY -2
#define YYEOF 0
#define YYerror 256
#define YYUNDEF 257
#define I 258
#define NUMBER 259
#define STRING 260
#define PRINT 261
#define VAR 262
#define BLTIN 263
#define UNDEF 264
#define WHILE 265
#define FOR 266
#define IF 267
#define ELSE 268
#define FUNCTION 269
#define PROCEDURE 270
#define RETURN 271
#define FUNC 272
#define PROC 273
#define READ 274
#define ARG 275
#define ADDEQ 276
#define SUBEQ 277
#define MULEQ 278
#define DIVEQ 279
#define MODEQ 280
#define OR 281
#define AND 282
#define GT 283
#define GE 284
#define LT 285
#define LE 286
#define EQ 287
#define NE 288
#define UNARYMINUS 289
#define NOT 290
#define INC 291
#define DEC 292

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 15 "hoc.y"

	Symbol	*sym;	/* symbol table pointer */
	Inst	*inst;	/* machine instruction */
	size_t	narg;	/* number of arguments */

#line 147 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
