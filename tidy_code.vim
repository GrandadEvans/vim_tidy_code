"----------------------------------------------------------------------------------
" Filename:      tidy_code.vim
" VimScipt:      none as yet
"
" Maintainer:    John Evans <john@evanswebdesign.co.uk>
" Last Modified: 18 October 2012 by John Evans
"
" Copyright:     (C) 20012 John Evans
"
"                This program is free software; you can redistribute it and/or
"                modify it under the terms of the GNU General Public License as
"                published by the Free Software Foundation; either version 2 of
"                the License, or (at your option) any later version.
"
"                This program is distributed in the hope that it will be useful,
"                but WITHOUT ANY WARRANTY; without even the implied warranty of
"                MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
"                GNU General Public License for more details.
"
"                You should have received a copy of the GNU General Public
"                License along with this program; if not, write to the Free
"                Software Foundation, Inc., 59 Temple Place, Suite 330,
"                Boston, MA 02111-1307 USA _OR_ download at copy at
"                http://www.gnu.org/licenses/licenses.html#TOCGPL
"
" Description:   This script will attempt to tidy up files according to their
"                respective file formats and conventions. 
"                Currently I have only actioned PHP as this is my default language.
"                I am putting this file repo on githib early so that I can keep up 
"                with getting to know git tags etc and that more people can help me 
"                with the wa that I code as well as letting me know where I can 
"                improve on my coding techniques (particularly in vim scripts)
"                
"                Inspiration for PHP files comes mainly from 
"                http://www.dagbladet.no/development/phpcodingstandard
"                http://news.php.net/php.standards/2
"
" Install:       This script should ideally be copied into yourvim profile's
"                plugin dir.
"----------------------------------------------------------------------------------
"
function! Tidy_code()
    " TODO: find a way of identifying the filetype and use if else etc to
    "     seperate the sections and perfrom the relevant clean-up on the
    "     different filetypes
    "     
    "
    " keyword naming convention
    "     replace:
    "
    "     ^<optional space><keyword><space><possible function_name etc><optional space>()<optional
    "     spaces>{<optional space><new line>
    "
    "     with
    "
    "     <keyword> <possible function_name etc>()<new line><inherited space>{
    "
	silent! :%s/\(^\s*\)\<\(while\|if\|for\|do\|switch\|foreach\|require\|throw\|catch\|declare\|function\|require_once\|include\|include_once\|return\|try]\)\s\+\(.*\)\s\=(\(.*\))\s*{/\1\2 \3(\4)\r\1{
	
	" See to elseifs
	silent! :%s/\(^\s*\)}\s*else\s\=if\(\s*(.*)\)\s*{/\1}\r\1else if\2\r\1{

	" See to the first part ofelse
	silent! :%s/\(^\s*\)}\s*else/\1}\r\1else

	" See to the last part of else
	silent! :%s/\(^\s*\)else\s*{/\1else\r\1{

	" See to try
	silent! :%s/\(\s*\)try\s*{/\1try\r\1{

	" See to the Catch
	silent! :%s/\(.*\)\(}\)\s\=catch\s\=(\(.*\))\s\=\({\)/\1\2\r\1catch (\3)\r\1\4
    " Explained
    "    :%s      - start the substitution
    "    \(\s*\)  - match any space before the function call
    "                This level of indent will be the first callback \1
    "    function\s\+ - match the word function followed by an optional space
    "    \(.*\)       - The function name which will act as the second
    "                   callback
    "    \s\=(       - An optional space then the function opening parenthesis
    "    \(.\))\s*{  - Any function params which will form the 3rd callback
    "                  followed by the function closing bracket
    "                  followed by optional space 
    "                  followed by the opening curly brace
    "
    "     replaced with:
    "
    "     \1         - The opening space before the function call
    "     function   - The word function
    "      \2(       - A space after the word function 
    "                  followed by the name of the function
    "                  followed by the opening parenthesis
    "     \3         - The function params
    "     )          - The closing function call parenthesis
    "     \r         - A new line
    "     \1         - The opening space before the function call
    "                  This will ensure that we are now inline with the 
    "                  word 'function' on thew preceding line
    "     {          - The opening curly brace
    "-------------------------------------------------------------------

    " class:
    "    names should be PascalCase
    "        that is camelCase with an uppercase first character
    " TODO: update the calls to the classes as well as the class/function
    " names themselves.
    " For this reason I have not done any search and replace on the name sof
    " classes or variables as if I were to carry out this action at the moment
    " it would break when an attempt to call them were made.
    "
    " function:
    "    functions in classes:
    "        names should also be PascalCase
    "    standalone functions:
    "        lower_case_with_underscores
    "
    " variables:
    " arrays:
    "    name should be all_lower_case_and_underscored
    "    TODO: I should be able to do this but it is not for tonight as it's 2
    "    in the morning; my eyes are stinging and I still have a bit of admin
    "    to do
    "-----------------------------------------------------------------------
    "
    " Use 4 spaces instead of tabs
    silent! :%s/\t/    /g
    " Explain:
    "    This one is simple:
    "    replace any tabs \t
    "    with 4 spaces
    "    the /g flag will carry it out across all of the lines and not match
    "    just the first instance
    "-----------------------------------------------------------------------

    " DO NOT put parenthesis next to keywords
    " but instead seperate them with a space
    silent! :%s/\(while\|if\|for\|do\|switch\|foreach\|require\|throw\|catch\|declare\|function\|require_once\|include\|include_once\|return\|try\)(/\1 (
    " Explain:
    " silent!      - Do not throw an error if there are no matches
    " :%s          - Do a substitution across the whole file
    " \(\)         - We want to remember the keyword that is used
    "                The closing parens will come later
    " []           - We want to match one of the keywords inside the square
    "                braces
    "                The | pipe characters seperate the words and means
    "                'Match [this|or this|or this| or this
    " (            - After the remembered keyword we want to match a closing
    "                paren straight after it
    "
    " replace with
    "
    " \1           - The matched keyword
    "              - a single space
    " (            - Then the closing paren.
    " -----------------------------------------------------------------------
    "
    " Boolean checks on statements should ask if make sure that the function
    " does not retuen a false result as such
    " if (FALSE != funct())
    " so we want to replace anything that looks like this
    " if (FALSE != function())
    " with this
    " if (FALSE != function())
    silent! :%s/if\s*(!\s\=\(.*\)\s\=(/if (FALSE != \1(
    " TODO: Explain this
    "
    "
    " I think I will have a indenter here
    "
    " -----------------------------------------------------------------------
	"
	" Remove space at the end of the lines
	silent! :%s/\s*$
	
endfunction
