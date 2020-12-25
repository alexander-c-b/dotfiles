" Vim syntax file
" Language: Zork Implementation Language
" Maintainer: Alexander Bodoh Latest Revision: May 27 2019 
if exists("b:current_syntax")
    finish
endif

let b:current_syntax = "zil"

" Keywords
syn case ignore
syn match zilNumber :\v[+-]?\d+:
" syn match Float '[+-][0-9.]\+'
" start=:\v\<(\w|\-)*:
" matchgroup=zilArrowBrackets
syn match zilObjectName :\v(\<)@<=(\w|\-)+:
syn region zilObject matchgroup=zilBracket start=:\v\<: end=:\v\>: fold
            \ contains=ALL
syn region zilList matchgroup=zilParenthesis start=:\v\(: end=:\v\): fold
            \ contains=ALL
" syn match zilBracketOrParenthesis :[<>()]:
syn region zilString start=:\v": skip=:\v\\[^\\;]: end=:\v":
syn match zilComment :\v(\;"\_.{-}"|\;.*$):
syn keyword zilConditional else cond and or not
syn match zilConditional :\vif(\w|-)*:
syn keyword zilDefinition routine room object
syn keyword zilKeyword sorry per


hi def link zilNumber                   Number
hi def link zilString                   String
hi def link zilComment                  Comment
hi def link zilBracket                  Comment
hi def link zilParenthesis              PreProc
hi def link zilKeyword                  Keyword
" hi def link zilObject                 Comment
hi def link zilObjectName               Identifier
hi def link zilConditional              Conditional
hi def link zilDefinition               Type
" hi def link zilBracketOrParenthesis   Comment
