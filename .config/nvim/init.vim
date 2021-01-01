" Plugins {{{1
let s:plugin_dir = $HOME . '/.vim/plugged/'
if isdirectory(s:plugin_dir)
    call plug#begin(s:plugin_dir)

    " Style {{{2
    Plug 'itchyny/lightline.vim'
    " }}}

    " Miscellanious Utility {{{2
    Plug 'lifepillar/vim-mucomplete',       {'commit': '56ded939230b13ba5b93a38e79e2b61675a8f6ef'}
    Plug 'SirVer/ultisnips',                {'commit': 'e83c82099d9bd43dc7895e3cb5b114ee5a2a07c6'}
    Plug 'jiangmiao/auto-pairs',            {'commit': '39f06b873a8449af8ff6a3eee716d3da14d63a76'}
    Plug 'tpope/vim-surround',              {'commit': 'f51a26d3710629d031806305b6c8727189cd1935'}
    Plug 'tpope/vim-repeat',                {'commit': 'c947ad2b6a16983724a0153bdf7f66d7a80a32ca'}
    Plug 'tpope/vim-abolish',               {'commit': '7e4da6e78002344d499af9b6d8d5d6fcd7c92125'}
    Plug 'embear/vim-localvimrc',           {'commit': 'ac6444afb5fd11e3f7750f696a0c6b8b0b6ec116'}
    Plug 'majutsushi/tagbar',               {'commit': 'd7063c7484f0f99bfa182b02defef7f412a9289c'}
    Plug 'godlygeek/tabular',               {'commit': '339091ac4dd1f17e225fe7d57b48aff55f99b23a'}
    Plug 'mbbill/undotree',                 {'commit': 'be23eacb2a63380bd79e207a738c728214ecc9d3'}
    Plug 'kana/vim-textobj-user',           {'commit': '41a675ddbeefd6a93664a4dc52f302fe3086a933'}
    Plug 'kana/vim-textobj-line',           {'commit': '0a78169a33c7ea7718b9fa0fad63c11c04727291'}
    Plug 'christoomey/vim-titlecase',       {'commit': '6a290f916c19d8b2a23681824967fade011f7502'}
    Plug 'skywind3000/asyncrun.vim',        {'commit': '58d23e70569994b36208ed2a653f0a2d75c24fbc'}
    Plug '907th/vim-auto-save',             {'commit': '8c1d5dc919030aa712ad7201074ffb60961e9dda'}
    Plug 'Yggdroot/indentLine',             {'commit': '43dbd7092801637972b1d9fcecaaeee11f8e00cf', 'on': 'IndentLinesToggle'}
    " }}}

    " Languages {{{2
    Plug 'vim-scripts/indentpython.vim',    {'for': 'py',           'commit': '6aaddfde21fe9e7acbe448b92b3cbb67f2fe1fc1'}
    Plug 'nvie/vim-flake8',                 {'for': 'py',           'commit': '0c7cf6dc038223b44e3c0a702fe2acf997768e8a'}
    Plug 'tmhedberg/SimpylFold',            {'for': 'py',           'commit': 'aa0371d9d708388f3ba385ccc67a7504586a20d9'}
    Plug 'dhruvasagar/vim-table-mode',      {'for': 'pmarkdown',    'commit': '640400908075c50704e127448175d3ede6bba2e9'}
    Plug 'neovimhaskell/haskell-vim',       {'for': 'hs',           'commit': 'b1ac46807835423c4a4dd063df6d5b613d89c731'}
    Plug 'ndmitchell/ghcid',                {'for': 'hs',           'commit': 'e54c1ebcec8bf4313ef04a1c5f47ecdbb6d11db3'}
    Plug 'LnL7/vim-nix',                    {'for': 'nix',          'commit': 'd733cb96707a2a6bdc6102b6d89f947688e0e959'}
    Plug 'elzr/vim-json',                   {'for': 'json',         'commit': '3727f089410e23ae113be6222e8a08dd2613ecf2'}
    Plug 'idris-hackers/idris-vim',         {'for': 'idris',        'commit': '091ed6b267749927777423160eeab520109dd9c1'}
    Plug 'whonore/Coqtail',                 {'for': 'coq',          'commit': 'f2c48d99015bb4f8317c53b8eb0f3a39406ed4cb'}
    " }}}

    call plug#end()
endif
" }}}

" Saving and Undo {{{
let g:auto_save = 1
if !isdirectory($HOME."/.vim/undo-dir")
    call mkdir($HOME."/.vim/undo-dir", "p", 0700)
endif
set undofile undodir=~/.vim/undo-dir
" }}}

" FilenameNoExtension {{{
function! s:FilenameNoExtension()
    return join(split(bufname('%'), '\.')[:-2], '.')
endfunction
" }}}

" General Settings {{{
autocmd!
set tags+=./.tags;/
set completeopt=menu,menuone,preview,noinsert,noselect
set number relativenumber
set nohlsearch
set ignorecase smartcase
set splitbelow splitright
set wildmenu path+=**       " File movement
filetype plugin indent on
filetype plugin on
syntax on
" }}}

" Constants {{{
let g:pi = 3.14159
" }}}

" Style {{{1
set background=light
colorscheme zander-eink
highlight clear SpellCap
set laststatus=2  " Always show status line
set t_Co=256      " number of terminal colors
set noshowmode    " have the status line rather than vim show the mode
highlight clear SignColumn
highlight link trailing_whitespace InlineCode
" " Plugins {{{
highlight CoqtailChecked ctermbg=Gray
highlight CoqtailSent    ctermbg=LightGray
" }}}
" }}}

" Utility Plugins {{{1
" " LocalVimrc {{{
autocmd BufNewFile,BufRead *.lvimrc set filetype=vim
let g:localvimrc_whitelist = $HOME."/school/"
let g:localvimrc_sandbox   = 0
" }}}
" " MUcomplete {{{
let g:mucomplete#enable_auto_at_startup = 1
let g:mucomplete#completion_delay       = 200
let g:mucomplete#cycle_with_trigger     = 1
let g:mucomplete#no_mappings            = 1
imap <C-B> <plug>(MUcompleteFwd)
imap <C-V> <plug>(MUcompleteBwd)
" Always insert new line on <Enter>
inoremap <expr> <CR> pumvisible() ? "<C-Y><CR>" : "<CR>"
let s:mu_text_chain = ['keyp', 'keyn', 'c-p', 'c-n', 'path', 'ulti', 'uspl', 'dict']
let g:mucomplete#chains = {
    \ 'default':   ['keyp', 'keyn', 'c-p', 'c-n', 'tags', 'omni', 'defs', 'path'],
    \ 'coq':       ['keyp', 'keyn', 'c-p', 'c-n', 'omni', 'path'],
    \ 'pmarkdown': s:mu_text_chain,
    \ 'text':      s:mu_text_chain,
    \ }
" }}}
" " Ultisnips {{{
let g:UltiSnipsSnippetDirectories   = [$HOME."/.config/nvim/UltiSnips/"]
let g:UltiSnipsExpandTrigger        = "<C-L>"
let g:UltiSnipsJumpForwardTrigger   = "<C-J>"
let g:UltiSnipsJumpBackwardTrigger  = "<C-G>b"
let g:UltiSnipsEditSplit            = "horizontal"
inoremap <C-J> <Nop>
" }}}
" " Auto Pairs {{{
autocmd Filetype pmarkdown let b:AutoPairs =
    \ {'(':')', '[':']', '{':'}',"'":"'",'"':'"', "`":"`",
    \  '```':'```', '"""':'"""', "'''":"'''",
    \  '$':'$', '$$':'$$', '{:':':}'}
autocmd Filetype nix let b:AutoPairs =
    \ {'(':')', '[':']', '{':'}',"'":"'",'"':'"',"''":"''"}
autocmd Filetype coq let b:AutoPairs =
    \ {'(':')', '[':']', '{':'}',"'":"'",'"':'"','(*':'*)'}
" }}}
" }}}

" Filetype Options {{{1
" " Most files {{{2
augroup au_most_files
    autocmd!
    autocmd Filetype *
        \ setlocal
        \ tabstop=8
        \ softtabstop=4
        \ shiftwidth=4
        \ expandtab
        \ autoindent
        \ encoding=utf-8
        \ conceallevel=2

    autocmd Filetype * let @j="\<Esc>080lBi\<CR>\<Esc>"
    autocmd Filetype * setlocal foldmethod=syntax
augroup end
" " }}}
"
" " shell {{{
augroup au_shell
    autocmd!
    autocmd Filetype sh setlocal noexpandtab softtabstop=0 shiftwidth=0
augroup end
" " }}}

" " No expand tab {{{2
augroup au_no_expand_tab
    autocmd!
    autocmd BufNewFile,BufRead Makefile,*.asm setlocal noexpandtab shiftwidth=0
augroup end
" " }}}

" two-space indent {{{2
augroup au_two_space_indent
    autocmd!
    autocmd Filetype html,css,nix,coq,haskell setlocal
        \ softtabstop=2
        \ shiftwidth=2
augroup end
" }}}
" " Text files {{{2
augroup au_text
    autocmd!
    autocmd Filetype text
        \ setlocal linebreak
        \ noexpandtab
        \ textwidth=0
augroup end
" " }}}

" " Markdown {{{2

" \/ underscores should not be treated as part of the adjoining words.
augroup au_markdown
    autocmd!
    autocmd Filetype pmarkdown,yaml
        \ setlocal
        \ linebreak
        \ shiftwidth=4
        \ softtabstop=4
        \ breakindent
        \ breakindentopt=shift:4,min:20
        \ nrformats+=alpha
        \ iskeyword-=_
        \ iskeyword-=$

    autocmd Filetype pmarkdown autocmd OptionSet textwidth
                \ if (v:option_new > 0 && v:option_type == "local") | setlocal formatoptions+=an | endif

    function! PMarkdownSettings() abort
        let b:surround_43 = "**\r**"    " surround with ** instead of +
        let b:surround_33 = "~~\r~~"    " surround with ~~ instead of !
        let @r="\<Esc>^r j"
        let @b="\<Esc>I- \<Esc>2j"
        let @n="\<Esc>I#.  \<Esc>2j"
        let @h='s=":s:\`::ge:s:\([.0-9]\+\)^\([-.0-9]\+\):pow(\1,\2):ge'
        let @i="\<Esc>^wys/\\v( -- | - |:)\<CR>_2j"
        let @c="vipjyvipjp"
    endfunction

    autocmd Filetype pmarkdown call PMarkdownSettings()
augroup end
" " }}

" " C {{{2
let c_no_curly_error=1
augroup au_c
    autocmd!
    autocmd Filetype c setlocal previewheight=3 completeopt+=menuone
augroup end
" " }}}

" " C++ {{{2
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
" " }}}

" " Vim {{{2
augroup au_vim
    autocmd!
    autocmd Filetype vim setlocal foldmethod=marker
augroup end
" " }}}

" " Latex {{{
let g:tex_conceal = "abdgms"
let g:vimtex_matchparen_enabled = 0
let g:vimtex_compiler_latexmk_engines = {
    \ '_'                : '-lualatex',
    \ 'pdflatex'         : '-pdf',
    \ 'dvipdfex'         : '-pdfdvi',
    \ 'lualatex'         : '-lualatex',
    \ 'xelatex'          : '-xelatex',
    \ 'context (pdftex)' : '-pdf -pdflatex=texexec',
    \ 'context (luatex)' : '-pdf -pdflatex=context',
    \ 'context (xetex)'  : '-pdf -pdflatex=''texexec --xtx''',
    \}

augroup au_latex
    autocmd!
    autocmd Filetype tex
        \ setlocal
        \ softtabstop=2
        \ shiftwidth=2
        \ linebreak
        \ breakindent
        \ breakindentopt=shift:2
augroup end
" }}}

" }}}

" Operators {{{
function! TabularizeOp(mode) abort
    execute "'[,']Tabularize /" . input("Tabularize: ")
endfunction

function! TabularizeOpNoRightSpace(mode) abort
    execute "'[,']Tabularize /" . input("Tabularize: ") . "/l1r0"
endfunction
" }}}

" Keybindings {{{
" " (Local)Leader {{{
let mapleader      = ","
let maplocalleader = "\\"
nnoremap , <Nop>
" " }}}
" " Operators{{{
nmap     <leader>a <Plug>Titlecase
vmap     <leader>a <Plug>Titlecase
nnoremap <leader>tb :set operatorfunc=TabularizeOp<CR>g@
nnoremap <leader>tB :set operatorfunc=TabularizeOpNoRightSpace<CR>g@
" " }}}
" " wrapped-line navigations {{{
vnoremap <C-j> gj
vnoremap <C-k> gk
vnoremap <C-4> g$
vnoremap <C-6> g^
vnoremap <C-0> g^

nnoremap <C-j> gj
nnoremap <C-k> gk
nnoremap <C-4> g$
nnoremap <C-6> g^
nnoremap <C-0> g^
" " }}}
" " ' Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
" " '
" " ' Paste from clipboard {{{
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P
" " ' }}}
" " Other {{{
nnoremap Y y$
nnoremap g<C-I> ^Wi
nnoremap _ <Nop>
nnoremap <leader>h :set hlsearch!<CR>
nnoremap <leader>s :set spell!<CR>

function! SetConcealLevel() abort
    if (&conceallevel ==# 0)
        set conceallevel=2
    else
        set conceallevel=0
    endif
endfunction
nnoremap <leader>l :call SetConcealLevel()<CR>

" remove trailing whitespace <F5>
nnoremap <F5> :.,$s:\v\s+$::c<CR><C-O>

let g:WhiteSpaceHighlight = 0
function! SwitchWhiteSpace() abort
    if g:WhiteSpaceHighlight == 0
        let g:WhiteSpaceHighlight = 1
        match trailing_whitespace :\s\+\%#\@<!$:
    else
        let g:WhiteSpaceHighlight = 0
        call clearmatches()
    endif
endfunction
nnoremap <leader>tw :call SwitchWhiteSpace()<CR>

nnoremap <leader>m :write<CR>:make
nnoremap <leader>w :set wrap!<CR>
nnoremap <leader>r :!./%<CR>
" " }}}
" " Insert Mode {{{
inoremap <C-F> <c-g>u<Esc>[s1z=`]a<c-g>u
inoremap <C-U> <Esc>A
inoremap <C-Y> <Esc>ea
" " }}}
" }}}

" Language-specific bindings {{{
" " C {{{2
augroup c_bindings
    autocmd!
    autocmd Filetype c    let g:c_compiler = "gcc"
    autocmd Filetype cpp  let g:c_compiler = "g++"
    autocmd Filetype cuda let g:c_compiler = "nvcc"
    autocmd Filetype c,cpp,cuda
        \ if !exists("g:c_compile_flags") | let g:c_compile_flags = "" | endif |
        \ if !exists("g:c_run_flags") | let g:c_run_flags = "" | endif |
        \ nnoremap <buffer> <leader>c :call CCompileCurrentFile()<CR>|
        \ nnoremap <buffer> <leader>r :call CRunCurrentFile()<CR>|
        \ nnoremap <buffer> <leader>d :call CDebugCurrentFile()<CR><CR> |
        \ nnoremap <buffer> <leader>t :execute '!ctags **/*.c **/*.h'<CR><CR> |
        " \ nmap <buffer> <leader>m :execute '!make' <CR>
augroup end
" " }}}

" " Python {{{2
augroup python_bindings
    autocmd!
    autocmd Filetype python let g:python_interpreter = "python3"
    autocmd Filetype python
        \ nnoremap <buffer> <leader>r :call PythonRunCurrentFile()<CR>|
        \ nnoremap <buffer> <leader>t :execute '!ctags **/*.py'<CR><CR>
augroup end
" " }}}

" " Markdown {{{
function! MarkdownBindings()
    let l:command = 's:\v(,\s*(and\|or)?|and|or)\s*:\r-   :<CR>'
    nnoremap K 1z=
    nnoremap <buffer> <leader>c :call MarkdownToPdf()<CR>
    nnoremap <buffer> <leader>r :call OpenPdf()<CR>
    nnoremap <buffer> <leader>j
        \ @=':s:\(,\s*\(and\\|or\)\?\\|\<and\\|\<or\)\s*:\r-   <C-V><CR>'<CR>
    nnoremap <buffer> <leader>b "byi>:!qutebrowser <C-R>b<CR>
    nnoremap <buffer> <leader>hy :call MarkdownCopyRichTextBuffer()<CR>
    nnoremap <buffer> <leader>hp :call MarkdownConvertClipboard()<CR>"+p
    nnoremap <buffer> <leader>hP :call MarkdownConvertClipboard()<CR>"+P
endfunction

function! MarkdownPasteImage()
    let l:path = input("Paste path: ", "", "file")
    " call jobstart("from-clipboard image/png > " . l:path)
    return l:path
endfunction

augroup markdown_bindings
    autocmd!
    autocmd Filetype pmarkdown call MarkdownBindings()
augroup end
" " }}}

" " YAML {{{
augroup yaml_bindings
    autocmd!
    autocmd Filetype yaml nnoremap <buffer> <leader>b "byi":!qutebrowser <C-R>b<CR>
augroup end

" }}}

" Functions {{{
" " General {{{
function! OpenPdf() abort
    silent !clear
    execute '!opdf "' . s:FilenameNoExtension() . '.pdf"'
endfunction
" " }}}

" " C {{{
function! CCompileCurrentFile() abort
    silent !clear
    execute '!' . g:c_compiler . ' "' . bufname('%') . '" -g -o "' . s:FilenameNoExtension() . '" ' . g:c_compile_flags
endfunction

function! CRunCurrentFile() abort
    silent !clear
    execute '!"./' . s:FilenameNoExtension() . '" ' . g:c_run_flags
endfunction

function! CDebugCurrentFile() abort
    silent !clear
    execute '!tmux split-window -h "gdb ''' . s:FilenameNoExtension() . '''"'
    "-ex ''b ' . line('.') . ''' -ex ''run''"'
endfunction
" " }}}

" " Python {{{
function! PythonRunCurrentFile() abort
    silent !clear
    execute '!' . g:python_interpreter . ' "' . bufname('%') . '"'
endfunction
" " }}}

" " Markdown {{{
function! MarkdownSetTableOptions() abort
    silent !clear
    let g:table_mode_corner='+'
    let b:table_mode_corner='+'
    let g:table_mode_corner_corner='+'
    let g:table_mode_fillchar='-'
    let g:table_mode_header_fillchar='='
endfunction

function! MarkdownToPdf() abort
    silent !clear
    write
    execute 'AsyncRun mdtopdf "' . bufname('%') . '" "' . s:FilenameNoExtension() . '.pdf"'
endfunction

function! MarkdownCopyRichTextBuffer() abort
    silent !clear
    write !pandoc
        \ --from markdown+lists_without_preceding_blankline
        \ --to html
        \ --filter pandoc-citeproc
        \ | to-clipboard text/html
endfunction

function! MarkdownConvertClipboard() abort
    silent !clear
    !xclip -selection clipboard -target text/html -out
    \   | pandoc --from html-native_divs-native_spans --to markdown
    \   | xclip -in -selection clipboard
endfunction
" " }}}

" " Assembly {{{
function! AssemblyIntelCompile() abort
    silent !clear
    execute '!nasm -o ' . s:FilenameNoExtension()  . '.o -f elf64 '
        \ . bufname('%') .  ' && ld -o ' . s:FilenameNoExtension()
        \ . ' ' . s:FilenameNoExtension() . '.o'
endfunction
" " }}}
