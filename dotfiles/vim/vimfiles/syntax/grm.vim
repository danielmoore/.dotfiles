" Vim syntax file
" Language:         GRM (Gold PARSER)
" Maintainer:       Abderraouf El Gasser
" Last Change:      August 8, 2002

" Quit when a syntax file was already loaded	{{{
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif
"}}}

"	Syntax rules
"  

" Base data (or terminal nodes)
syn match 	grmOr 							"|" 											nextgroup=grmDefinition contained
syn match		grmString						+"[^"]*"+									contains=grmParam
syn match		grmString						+'[^']*'+				
syn	match		grmOperator					/[+*\/-]/
syn match		grmSetNode					"{[^}]*}"									contained 
syn match		grmTerminalNode					"[A-Z][^ ]*"							contained 
syn match		grmRuleNode					"<[^>]*>"									contained
syn match		grmEnumBlock				"\[[^\[]*\]"				
syn match		grmComment					"!.*$" 

" Parameter statement (Quoted Keyword followed by equal symbol followed by
" user data)
" With special handling for "Start Symbol"
syn match		grmParam						+"[^"]*"+									nextgroup=grmSepEqualParam
syn	match		grmSepEqualParam		"\s*=\s*" 								nextgroup=grmDefinitionParam contained 
syn	match		grmDefinitionParam	/.*$/ 										contained contains=grmString,grmComment
syn region	grmParamStart				start=+"Start Symbol"+ skip=+\s*=\s*+ end=/$/ 

" Terminal and Set statement
syn	match		grmSet							/{[A-Z][^}]*}/						nextgroup=grmSepEqual 
syn	match		grmTerminal					/[A-Z][^ ]*/							nextgroup=grmSepEqual 
syn	match		grmSepEqual					"\s*=\s*" 								nextgroup=grmDefinition contained 


" Rule statement
syn	match		grmRule							/<[^>$]*>/								nextgroup=grmSepInstr 
syn	match		grmSepInstr					"\s*::=\s*"								nextgroup=grmDefinition contained 

" Partial definition 
syn match		grmPartDef					/^\s*|/ 									contains=grmOr nextgroup=grmDefinition

" definition of rules, sets and terminals
syn	match		grmDefinition				/.*$/ 										contained contains=grmEnumBlock,grmSetNode,grmTerminalNode,grmRuleNode,grmString,grmOr,grmOperator,grmComment,grmConst


"  Color definition
"  
hi link grmConst						Constant
hi link grmRule							Statement
hi link grmTerminal 				Type
hi link grmSet 							Special 
hi link grmSetNode					Special
hi link	grmParam 						PreProc
hi link grmParamStart 			Statement
hi link grmString 					String
hi 			grmOperator 				ctermfg=1 guifg=red
hi link grmComment 					Comment
hi 			grmOr 							ctermfg=1 gui=bold guifg=red
hi link grmRuleNode 				Identifier
hi link	grmTerminalNode			Type
hi link grmEnumBlock 				Constant
hi 			grmDefinitionParam 	gui=italic guifg=lightblue
