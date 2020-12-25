" fold regex; match region with same number: ... \_.\{-}\ze\1
" If exists... {{{
if exists("b:current_syntax")
    finish
endif
" }}}

" Autoformat {{{
let &l:formatlistpat='\v^\s*(([~:*+-]|(\#|\d|\l|\u)+[.)])\s+)+'
" let &formatlistpat='\v^\s*(([:*\+\-]|(#|\d+|\l+|\u+)[.)])\s+)'
" default: ^\s*\d\+[\]:.)}\t ]\s*
" }}}

" Comments {{{
setlocal comments=:>
setlocal commentstring=<!--%s-->
" default s1:/*,mb:*,ex:*/,://,b:#,:%,:XCOMM,n:>,fb:-
" }}}

" Equation {{{
" match literal "$", but not "\$" (look-behind for a single backslash,
" represented by \\)
syntax region markdown_equation_1    matchgroup=markdown_equation_ends                            start=:\v(\\)@<!\$:   end=:\v(\\)@<!\$:   concealends
syntax region markdown_equation_2    matchgroup=markdown_equation_ends                            start=:\v(\\)@<!\$\$: end=:\v(\\)@<!\$\$:
syntax region markdown_no_equation   matchgroup=markdown_equation containedin=markdown_equation.* start=:\vtext\(:    end=:\v\):   contained concealends
syntax region markdown_no_equation   matchgroup=markdown_equation containedin=markdown_equation.* start=:\v":    end=:\v":   contained
syntax region markdown_uni_equation  matchgroup=markdown_equation containedin=markdown_equation.* start=:\v`:    end=:\v`:   contained
" syntax region markdown_unit_equation matchgroup=markdown_equation containedin=markdown_equation.* start=:\v\\unit\{:    end=:\v\}:          contained contains=NONE
" syntax region markdown_unit_equation matchgroup=markdown_equation containedin=markdown_equation.* start=:\v\\unit\{:    end=:\v\}:          contained contains=NONE

highlight def link markdown_equation_1              Italic
highlight def link markdown_equation_2              Italic
highlight def link markdown_equation_ends           Comment
highlight clear markdown_no_equation
highlight clear markdown_unit_equation
" }}}

" Emphasis, Bold, Underline {{{
function! s:MarkdownEmphasisLevel(char, char_name, level, effect) abort
    let region_name = 'markdown_'.substitute(a:effect, ',', '_', "")
    execute 'syntax region' region_name
                \ 'matchgroup=markdown_no_hl'
                \ 'start=:\v(\\)@<!\zs' .a:char. '{'.a:level.'}\S@=:'
                \ 'skip=:\v\\'.a:char.':'
                \ 'end=:\v' .a:char. '{'.a:level.'}:'
                \ 'concealends'
    execute 'highlight' region_name 'cterm='.a:effect 'gui='.a:effect
endfunction


for [char, char_name] in items({'_': 'underscore', '\*': 'asterisk'})
    for [level, effect] in items({1: 'italic', 2: 'underline', 3: 'italic,underline'})
        call s:MarkdownEmphasisLevel(char, char_name, level, effect)
    endfor
endfor

" syntax region markdown_underline matchgroup=markdown_no_hl start="\\\@<!+\S\@=" end="+" skip="\\+" concealends
" highlight markdown_underline cterm=underline
" }}}

" Simple Things {{{
" Strikethrough {{{
syntax region markdown_strikethrough start=/\V~~/ end=/\V~~/
highlight def link markdown_strikethrough Comment
" }}}

" Code {{{
syntax region markdown_inline_code concealends matchgroup=markdown_no_hl start=:\v(\\)@<!\`: end=:\v(\\)@<!\`: contains=@NoSpell
" execute 'syntax region markdown_inline_code '
"     \ . ((colors_name ==# "zander-eink") ? "concealends matchgroup=markdown_no_hl" : "")
"     \ . ' start=:\v(\\)@<!\`: end=:\v(\\)@<!\`:'
syntax region markdown_display_code start=:\v\`\`\`: end=:\v\`\`\`: contains=@NoSpell
syntax region markdown_display_code start=:\~\{3,}: end=:\~\{3,}: contains=@NoSpell

if colors_name ==# "zander-eink"
    highlight def link markdown_inline_code InlineCode
else
    highlight def link markdown_inline_code Constant
endif
highlight def link markdown_display_code Constant
" }}}

" Bullet/Numbered Lists {{{
" the purpose of the \ze($|\s+\S) at the end is to make sure that the bullet
" is either at the end of the line or has an item.
" this prevents matches such as the first character in "---".
" syntax match markdown_bullet_list :\v^[+*-]?(\s+[+*-])+\ze($|\s+\S):
" Start of line after whitespace, matches (1), A), b., or #., then a space
" syntax match markdown_ordered_list :\v((^|\s+)(\(?(\d*|\u*|\l*)[).]|\#\.))+:
" syntax match markdown_ordered_list :\v((^|\s+)(\(?(\d*|\u\u?|\l\l?)[).]|\#\.))+\ze($|\s+\w):
" syntax match markdown_ordered_list :\v^((^|\s+)(\(?\d*[).]|\#\.))+\ze($|\s+\S):
" syntax match markdown_list '\v^\s*(([-:*+]|(\#|\d|[a-z]|[A-Z])+[.)])\s+)+\ze($|\S)'
" highlight def link markdown_list Identifier
" highlight def link markdown_bullet_list  Identifier
" highlight def link markdown_ordered_list Identifier
" }}}

" Header {{{
syntax region markdown_header matchgroup=markdown_header_hash start=/\v^\#+ / end=/$/
    \ contains=markdown_emph_1,markdown_emph_1_underscore
" syntax match markdown_header :\v^\#+ .*$:
highlight def link markdown_header_hash Statement
highlight markdown_header cterm=italic
" }}}

" Block Quote (disabled) {{{
" syntax match markdown_block_quote :\v^\s*\> \ze.:
" highlight def link markdown_block_quote Comment
" }}}

" Fenced Div {{{
syntax region markdown_fenced_div matchgroup=markdown_fenced_div_surroundings start=/\v\:\:\:+/ end=/\:*$/
highlight def link markdown_fenced_div              Constant
highlight def link markdown_fenced_div_surroundings Statement
" }}}

" Brackets (disabled) {{{
" syntax match markdown_brackets "[\[\]]"
" highlight def link markdown_brackets Special
"
" syntax region markdown_inside_brackets contains=ALLBUT,markdown_brackets matchgroup=markdown_brackets start=:\[: end=:\]:
" syntax region markdown_link  matchgroup=markdown_link_surroundings start=:\v\!?\[: end=:\v\]:
" syntax region markdown_brackets_1 matchgroup=markdown_brackets_1 start=:\v[!^]\[: end=:\v\]: contains=markdown_brackets_1,markdown_brackets_2
" syntax region markdown_brackets_2 matchgroup=markdown_brackets_2 start=:\v\[: end=:\v\]: contains=markdown_brackets_1,markdown_brackets_2
" syntax match markdown_brackets_1 :\v[!^]\[.{-}\]:
" syntax match markdown_brackets_2 :\v\[.{-}\]:
" syntax match markdown_brackets_3 :\v\[.{-}\]\[.{-}\]:
" syntax match markdown_brackets_4 :\v\[.{-}\](\(.{-}\))@=:
" highlight def link markdown_brackets_1 Statement
" highlight def link markdown_brackets_2 Statement
" highlight def link markdown_brackets_highlight Statement
" highlight def link markdown_brackets_3 Statement
" highlight def link markdown_brackets_4 Statement
" syntax region markdown_inside_brackets matchgroup=markdown_brackets contains=ALL start=:\v[!^]?\[: end=:\v\]:
" }}}

" Braces (disabled) {{{
" syntax region markdown_braces matchgroup=markdown_braces start=:\v\{: end=:\v\}: contains=markdown_braces
" highlight def link markdown_braces Special
" }}}

" Attributes in Braces {{{
syntax region markdown_attribute conceal start=:[`~)\]]\@<={: end=:}:
highlight def link markdown_attribute Comment
" }}}

" URL {{{
syntax region markdown_url matchgroup=markdown_link_surroundings start=:\v(\[.{-}\])@<=\(: end=:\v\):
" syntax region markdown_url_2 matchgroup=markdown_link_surroundings start=:\v\<: end=:\v\>: concealends
syntax match markdown_url "<\zs[-A-Za-z0-9._~:/?#\[\]@!$&'()*+,;%=]\+\ze>"
highlight link markdown_url Underlined
" highlight def link markdown_link_surroundings Statement
" highlight def link markdown_url_1 Underlined
" highlight def link markdown_url_2 Underlined
" highlight def link markdown_link  Underlined
" }}}

" Comment {{{
syntax region markdown_html_comment matchgroup=markdown_html_comment_ends start=:\V<!--: end=:\V-->:
highlight def link markdown_html_comment      Comment
highlight def link markdown_html_comment_ends Comment
" }}}

" Citation {{{
syntax match markdown_citation :\v\-?\@[_A-Za-z0-9]*:

highlight def link markdown_citation Statement
" }}}

" Yaml {{{
syntax region markdown_yaml_block matchgroup=markdown_yaml_delimiters start=:\v(%^|^)\zs\-\-\-\ze(\n\S): end=:\v\n(\-\-\-|\.\.\.): contains=ALLBUT,markdown_yaml_block
" syntax region markdown_yaml_block matchgroup=markdown_yaml_delimiters start=:\v(%^|^)\zs\-\-\-\ze(\n\S): end=:\v\n(\-\-\-|\.\.\.): contains=ALLBUT,markdown_yaml_block

" syntax match markdown_yaml_field contained /\v[-A-Za-z_0-9]+\:/

syntax region markdown_yaml_string contained start=:\v(\\)@<!\": end=:\v(\\)@<!\":
" syntax region markdown_yaml_string contained start=:\v(\\)@<!\': end=:\v(\\)@<!\':

" highlight def link markdown_yaml_delimiters Statement
highlight def link markdown_yaml_string     String
" highlight def link markdown_yaml_field      Identifier
" }}}
" Trailing whitespace {{{
" \%#\@<! -- match only if the cursor does not follow
" syntax match markdown_trailing_whitespace :\s\+\%#\@<!$:
" highlight def link markdown_trailing_whitespace InlineCode
" }}}
" }}}

" HTML Color Highlighting {{{
" To color [dog]{color=red} use
" :call s:TextColorHighlight('color\=red', "red", "red", "red", false)
" function! s:TextColorOrHighlight(get_color_regex, color_name, color_cterm, color_gui, highlight) abort
"     let l:name = 'markdown_' . (a:highlight ? 'highlight_' : 'color_') . a:color_name
"                 " .'_container'
"     execute 'syntax match' l:name.'_container'
"                 \ 'contains='.l:name
"                 \ '+\v\[[^{}]{-}\]\{'.a:get_color_regex.'.{-}\}+'
"                 " \ '+\v\[[^{}]{-}\]\{style\=\"color\:blue\"\}+'
"
"     execute 'syntax region' l:name
"                 \ 'contained concealends matchgroup=markdown_around_highlight'
"                 \ 'start=+\v\[+'
"                 \ 'end=+\v\]\{'.a:get_color_regex.'.{-}\}+'
"
"     execute 'highlight' l:name.' '. (a:highlight ? 'ctermbg=' : 'ctermfg=').a:color_cterm .' '.
"                                   \ (a:highlight ? 'guibg='   : 'guifg=').a:color_gui
" endfunction
"
" highlight def link markdown_around_highlight Special
"
" " ["color name", "vim gui color (number)", "vim terminal color (closest approximation)"],
" " the slash before each line is important
" " See the aqua example -- LightCyan is the closest available terminal
" "   approxmation of aqua.  Gui Vim uses the #00FFFF value.
" "   Add the terminal colors because you're nice and I need them and it will
" "   break otherwise.
" let s:colors = [
"     \ ["red",           "Red",          "Red"],
"     \ ["pink",          "Red",          "Red"],
"     \ ["green",         "Green",        "Green"],
"     \ ["blue",          "Blue",         "Blue"],
"     \ ["cyan",          "Cyan",         "Cyan"],
"     \ ["magenta",       "Magenta",      "Magenta"],
"     \ ["yellow",        "Yellow",       "Yellow"],
"     \ ["gray",          "Gray",         "Gray"],
"     \ ["aqua",          "LightCyan",    "#00FFFF"],
"     \ ]
"
" for [color, term_color, gui_color] in s:colors
"     call s:TextColorOrHighlight('color\='.color,     color, term_color, gui_color, 0)
"     call s:TextColorOrHighlight('highlight\='.color, color, term_color, gui_color, 1)
" endfor

" }}}
