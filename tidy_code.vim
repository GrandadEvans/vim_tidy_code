" This is an attempt at a vim script that will clean up the files that I have
" created in the past
"
" Inspiration for PHP files comes mainly from 
"http://www.dagbladet.no/development/phpcodingstandard
"
" Things that I would like cleaning up are things such as:
"	fixing indenting from the function()<new line>{ 
"	to function() {

function! Tidy_code()
	" replace:
	"
	" ^<optional space>function<space>function_name<optional space>()<optional
	" spaces>{<optional space><new line>
	"
	" with
	"
	" function function_name()<new line><inherited space>{
	"
	silent! :%s/\(\s*\)function\s\+\(.*\)\s\=()\s*{/function \2()\r\1{

	" Accoring to this document
	" http://news.php.net/php.standards/2
	" class:
	"	names should be PascalCase
	"		that is camelCase with an uppercase first character
	"
	" function:
	"	functions in classes:
	"		names should also be PascalCase
	"	standalone functions:
	"		lower_case_with_underscores
	"
	"
	" variables:
	" arrays:
	"	name should be all_lower_case_and_underscored
	"
	" Use 4 spaces instead of tabs
	silent! :%s/\t/    /g

	" DO NOT put parenthesis next to keywords
	" but instead seperate them with a space
	silent! :%s/\([while|if|for|do|switch|foreach|require|throw|catch|declare|function|require_once|include|include_once|return|try]\)(/\1 (
	
	" Boolean checks on statements should ask if make sure that the function
	" does not retuen a false result as such
	" if (FALSE != funct())
	" so we want to replace anything that looks like this
	" if (!function())
	" with this
	" if (FALSE != function())
	silent! :%s/if\s*(!\s\=\(.*\)\s\=(/if (FALSE != \1(
endfunction
