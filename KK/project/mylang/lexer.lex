%option noinput
%option nounput
%option noyywrap

%{
#include <iostream>
#include <cstdlib>
#include <string>
#include "structs.hpp"
#include "parser.tab.hpp"
#include "driver.hpp"
static yy::location loc;
%}

%{
/* Code run each time pattern is matched */
#define YY_USER_ACTION loc.columns(yyleng);
%}

ID [a-zA-Z][a-zA-Z_0-9]*

%%

%{
/* Code run each time yylex() is called */
loc.step();
%}

"print" { return yy::parser::make_print_token(loc); }
"if" { return yy::parser::make_if_token(loc); }
"while" { return yy::parser::make_while_token(loc); }
"mod" { return yy::parser::make_mod_token(loc); }
"Int" { return yy::parser::make_int_kw_token(loc); }
"Bool" { return yy::parser::make_bool_kw_token(loc); }
"Real" { return yy::parser::make_real_kw_token(loc); }
"Char" { return yy::parser::make_char_kw_token(loc); }
"String" { return yy::parser::make_string_kw_token(loc); }
"True" { return yy::parser::make_bool_token(1, loc); }
"False" { return yy::parser::make_bool_token(0, loc); }
{ID} { return yy::parser::make_id_token(yytext, loc); }
"{" { return yy::parser::make_crl_lparen_token(loc); }
"}" { return yy::parser::make_crl_rparen_token(loc); }
"[" { return yy::parser::make_sqr_lparen_token(loc); }
"]" { return yy::parser::make_sqr_rparen_token(loc); }
"(" { return yy::parser::make_lparen_token(loc); }
")" { return yy::parser::make_rparen_token(loc); }
"." { return yy::parser::make_dot_token(loc); }
"," { return yy::parser::make_comma_token(loc); }
";" { return yy::parser::make_semicol_token(loc); }
":" { return yy::parser::make_col_token(loc); }
"+" { return yy::parser::make_plus_token(loc); }
"-" { return yy::parser::make_minus_token(loc); }
"*" { return yy::parser::make_asterix_token(loc); }
"/" { return yy::parser::make_slash_token(loc); }
"\\" { return yy::parser::make_backslash_token(loc); }
"==" { return yy::parser::make_eq_token(loc); }
"<=" { return yy::parser::make_leq_token(loc); }
">=" { return yy::parser::make_geq_token(loc); }
"<" { return yy::parser::make_lt_token(loc); }
">" { return yy::parser::make_gt_token(loc); }
"=" { return yy::parser::make_assign_token(loc); }
"&&" { return yy::parser::make_dbl_amp_token(loc); }
"||" { return yy::parser::make_dbl_pipe_token(loc); }
"&" { return yy::parser::make_amp_token(loc); }
"|" { return yy::parser::make_pipe_token(loc); }
"<<" { return yy::parser::make_shl_token(loc); }
">>" { return yy::parser::make_shr_token(loc); }

[1-9][0-9]* { int val = strtol(yytext, nullptr, 10);
	      return yy::parser::make_int_token(val, loc); }

"0b"[0-1]+ { int val = strtol(yytext, nullptr, 2);
	           return yy::parser::make_int_token(val, loc); }

"0"[0-7]+ { long val = strtol(yytext, nullptr, 8);
	    return yy::parser::make_int_token(val, loc); }

"0x"[0-9a-fA-F]+ { int val = strtol(yytext, nullptr, 16);
	           return yy::parser::make_int_token(val, loc); }

[0-9]*"."[0-9]+ { double val = strtod(yytext, nullptr); 
	          return yy::parser::make_real_token(val, loc); }

'(\\.|[^'\\])' {
	   return yy::parser::make_char_token(yytext[1], loc); }

\"(\\.|[^"\\])*\" {
	   std::string_view val(yytext); 
	   return yy::parser::make_string_token(std::string(val.substr(1, val.length() - 2)), loc); }

[\t ] { loc.step(); }

"\n" { loc.lines(yyleng); loc.step(); }

. { throw yy::parser::syntax_error(loc,
		"Lexical error, invalid character: " + std::string(yytext)); }

<<EOF>>	{ return yy::parser::make_eof_token(loc); }

%%
