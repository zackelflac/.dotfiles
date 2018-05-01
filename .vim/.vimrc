" .Vimrc from Thomas Legris 28/06/2014
" Useful regex stuff:
" %s/\<word\>\C/new/g -> \< match begin \> match end \C case sensistiveness
" copy command output:
" redir @* | cmd | redir END
set shell=zsh
" Script Setting
let use_arrow=0
let use_gui=0
let username="Thomas Legris"

set nocompatible

"  If you need infrmation on parameters, use :h param
if has("gui_running")
  set shell=bash " better support
  " Gvim specific
  set lines=999
  set columns=999
  set guioptions=
  if use_gui
    set guioptions+=m  "menu bar
    set guioptions+=T  "toolbar
    set guioptions+=r  "scrollbar
  endif
else
endif

" vim --cmd 'let indexing=""'
if exists('indexing')
    let perforcecmd='bash -c "cat <(p4 opened) <(p4 have)" | cut -f1 -d\# | cut -f5-100 -d/ | grep "\.[c|h][a-zA-Z]*$" | grep "'.indexing.'"'
else
    let perforcecmd='bash -c "cat <(p4 opened) <(p4 have)" | cut -f1 -d\# | cut -f5-100 -d/ | grep "\.[c|h][a-zA-Z]*$" | grep "matlab/src\\|matlab/foundation\\|matlab/toolbox"'
endif

" Use surfraw to search on the web
command! -nargs=+ Cppman silent! call system("tmux split-window sr duckduckgo " . expand(<q-args>))
nnoremap <silent><buffer> K <Esc>:Cppman <cword><CR>

"set ttyfast
set scrolloff=0 " Keep no lines after/before the cursor

set path+=../**

" Start to be a good vimmer
if !use_arrow
  inoremap  <Left>   <NOP>
  inoremap  <Right>  <NOP>
  nnoremap  <Up>     <NOP>
  nnoremap  <Down>   <NOP>
  nnoremap  <Left>   <NOP>
  nnoremap  <Right>  <NOP>
endif

set guifont=Monospace\ 9
set cmdheight=1

set vb                         " visual bell
syntax on                      " enable
set background=dark
colorscheme myslate

set ruler                      " Show cursor position, line, col
set textwidth=0                " Max text width, 0 to disable it
" map @# gwap                  " Wrappe à 72 caractères avec la touche '@#'
" map @ {v}! par 72j           " Wrappe et justifie à 72 caractères avec la touche '@'
"set columns=80
set history=50                 " History entries max number
set viminfo='20,\"50           " ~/.viminfo's Options
set backspace=2                " Activate backspace
set whichwrap=<,>,[,]          " Ok let's use arrow to naviguate
set showcmd                    " Show cmd on status bar
set showmatch                  " Show paried symbols
set startofline
set wildmode=list:full:longest
set autoindent
set smartindent
set cino+=j1,(0,b1,+0,t0,<0      " C file option
set autoread
set clipboard=unnamed          " ^=

" Prevent RO file editing: use 'set modifiable' manually if needed
autocmd BufRead * let &modifiable = !&readonly

" set terminal as tmux
set term=screen-256color

" Show space and tab as blue
"set list
"set listchars=tab:>-,trail:-

"set ignorecase
" as ignore case but not if one Capital letter
set smartcase

" Folding
" Trigger manual after indent method
augroup vimrc
  au BufReadPre * setlocal foldmethod=expr
  au BufWinEnter * if &fdm == 'expr' | setlocal foldmethod=manual | normal zM | endif
augroup END

set foldlevel=99
set foldnestmax=0

set incsearch      " Search as we type
set hlsearch       " Highlight

set mouse=a

set matchpairs+=<:>

filetype off

" Ale
let &runtimepath.=',~/.vim/bundle/ale'
"let g:ale_linters = {
"\   'cpp': ['g++', 'cppcheck', 'clangtidy', 'clangcheck', 'clang'],
"\}
let g:ale_cpp_gcc_options = '$(cat ~/.compiler_options)' "Options can be easily retrieved using 'bear' (github)
let g:ale_cpp_clang_options = '$(cat ~/.compiler_options)' "Options can be easily retrieved using 'bear' (github)
let g:ale_cpp_clangtidy_options = '$(cat ~/.compiler_options)'
let g:ale_echo_msg_error_str = 'Error'
let g:ale_echo_msg_warning_str = 'Warning'
let g:ale_echo_msg_format = '[%linter%]%s[%severity%]'
"!Ale

" airline plugin
set laststatus=2 "status bar
let &runtimepath.=',~/.vim/bundle/airline'
let &runtimepath.=',~/.vim/bundle/airline-themes'
" Let us use arline instead
"set statusline=%<%f%h%m%r:\ %{tagbar#currenttag('%s','')}%=%l,%c\ %P "status' bar content
let g:airline_theme='light'
let g:airline_detect_whitespace=0
  let g:airline_mode_map = {
      \ '__' : '',
      \ 'n'  : '',
      \ 'i'  : '',
      \ 'R'  : '',
      \ 'c'  : '',
      \ 'v'  : '',
      \ 'V'  : '',
      \ '' : '',
      \ 's'  : '',
      \ 'S'  : '',
      \ '' : '',
      \ }
let g:airline_section_error = airline#section#create_right(['%{g:asyncrun_status}'])
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#ale#enabled = 1
"!Airline

"Rainbow plugin
let &runtimepath.=',~/.vim/bundle/rainbow'
let g:rainbow_active = 1
let g:rainbow_conf = {
   \ 'operators' : '_,\|=\|+\|\*\|-\|\.\|;\||\|&\|?\|:\|<\|>\|%\|/[^/*]_',
   \ 'separately': {
   \   'cpp': {
   \     'parentheses': [
   \       'start=/(/ end=/)/ fold',
   \       'start=/\[/ end=/\]/ fold',
   \       'start=/{/ end=/}/ fold',
   \       'start=/\(\(\<operator\>\)\@<!<\)\&[a-zA-Z0-9_]\@<=<\ze[^<]/ end=/>/'] } } }
"!Rainbow

"Slime plugin
let &runtimepath.=',~/.vim/bundle/slime'
let g:slime_target = "tmux"
"!Slime

" Tagbar options
let &runtimepath.=',~/.vim/bundle/tagbar'
let g:tagbar_compact = 1
let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 0
let g:tagbar_sort = 0
" !Tagbar

" AsyncRun
let &runtimepath.=',~/.vim/bundle/asyncrun'
let g:asyncrun_bell=1
" !AsyncRun

" Restful-console
let &runtimepath.=',~/.vim/bundle/vim-rest-console'
let g:vrc_curl_opts = {
            \ '--connect-timeout' : 10,
            \ '-L': '',
            \ '-i': '',
            \ '--max-time': 60,
            \ '--ipv4': '',
            \ '-k': '',
            \ '-v': '',
            \}
"!Restful-console

" Unite.vim
let &runtimepath.=',~/.vim/bundle/unite.vim'
call unite#custom#profile('default', 'context', {
	\   'start_insert': 1,
	\   'winheight': 10,
	\   'direction': 'botright'
\ })
"!Unite.vim

" javascript
let &runtimepath.=',~/.vim/bundle/vim-javascript'
" !javascript

" Clang-format
let &runtimepath.=',~/.vim/bundle/vim-clang-format'
let g:clang_format#command="clang-format-3.5"
let g:clang_format#detect_style_file=0
let g:clang_format#style_options = {
            \ "AlwaysBreakTemplateDeclarations" : "true",
            \ "Standard" : "C++11",
            \ "BasedOnStyle": "Google",
            \"IndentWidth": 4,
            \"AccessModifierOffset": -2,
            \"IndentCaseLabels": "false",
            \"MaxEmptyLinesToKeep": 3,
            \"KeepEmptyLinesAtTheStartOfBlocks": "true",
            \"SpacesBeforeTrailingComments": 1,
            \"AllowShortFunctionsOnASingleLine": "None",
            \"DerivePointerAlignment": "false",
            \"BinPackParameters": "false",
            \"AllowAllParametersOfDeclarationOnNextLine": "false",
            \"BreakConstructorInitializersBeforeComma": "true",
            \"ConstructorInitializerAllOnOneLineOrOnePerLine": "false",
            \"AllowShortIfStatementsOnASingleLine": "false",
            \"AllowShortLoopsOnASingleLine": "false",
            \"BreakBeforeBraces": "Linux",
            \"ColumnLimit": 140,
            \"NamespaceIndentation": "All"}
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>= :ClangFormat<CR>
" !Clang-format

" Kotlin
let &runtimepath.=',~/.vim/bundle/kotlin-vim'
" !Kotlin

" Gutentags
let &runtimepath.=',~/.vim/bundle/vim-gutentags'
let g:gutentags_project_root=['.perforce', '.git']
let g:gutentags_file_list_command = {
            \ 'markers': {
            \ '.git': 'git ls-files',
            \ '.hg': 'hg files',
            \ '.perforce': perforcecmd,
            \ },
            \ }
set statusline+=%{gutentags#statusline()}
set tags=./tags;,tags;
" /!\ Change plugin from setlocal to set
" !Gutentags

" Undotree
let &runtimepath.=',~/.vim/bundle/undotree'
" !Undotree

" Linediff
let &runtimepath.=',~/.vim/bundle/linediff.vim'
" !Linediff
"
" vim-snippets
let &runtimepath.=',~/.vim/bundle/vim-snippets'
" !

" Snipmate
let &runtimepath.=',~/.vim/bundle/tlib'
let &runtimepath.=',~/.vim/bundle/vim-addon-mw-utils'
let &runtimepath.=',~/.vim/bundle/vim-snipmate'
imap <C-J> <Plug>snipMateNextOrTrigger
smap <C-J> <Plug>snipMateNextOrTrigger
" !Snipmate

" OCC
let &runtimepath.=',~/.vim/bundle/OmniCppComplete'
set nocp
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
au BufNewFile,BufRead,BufEnter *.cpp,*.hpp,*.hxx,*.hh,*.cc set omnifunc=omni#cpp#complete#Main
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
" !OCC

" tagfinder
let &runtimepath.=',~/.vim/bundle/tagfinder'
" !tagfinder

filetype on
filetype plugin on
filetype indent on
set ruler          " Relative cursor position
set is             " inc search
set cul            " Highlight current line

set spelllang=en
set nospell
" c-x c-k feature:
set dictionary+=/usr/share/dict/words
" Language Tools
"let g:languagetool_jar='$HOME/usr/bin/languagetool-commandline.jar'

" Make options
let &makeprg='mw gmake'

" Ced: let this be the default CTAGS file location
"map tags :!exctags -R --c++-kinds=+p --fields=+iaS --extra=+q . <CR>
"set tags+=./tags

" Automatically open, but do not go to (if there are errors) the quickfix /
" location list window, or close it when is has become empty.
"
" Note: Must allow nesting of autocmds to enable any customizations for quickfix
" buffers.
" Note: Normally, :cwindow jumps to the quickfix window if the command opens it
" (but not if it's already open). However, as part of the autocmd, this doesn't
" seem to happen.
augroup vimrc
  "autocmd QuickFixCmdPost [^l]* nested botright cwindow " Botright to open widely
  "autocmd QuickFixCmdPost    l* nested botright lwindow
  "autocmd QuickFixCmdPost * call asyncrun#quickfix_toggle(8, 1)
  " The pre is to counter the copen from leaders aliases
  autocmd User AsyncRunStart setl nomodifiable | setl foldlevel=99 | wincmd p
  "autocmd User AsyncRunStop botright copen | setl foldlevel=0
augroup END

" Handle space and tabs
set expandtab
set tabstop=4
set shiftwidth=4

" Allow real tab in leader mapping
set wildcharm=<tab>
set timeoutlen=1000

let mapleader=" "
source ~/.vim/custmap.vim

" Explorer options
""""""""""""""""""
let g:netrw_liststyle=3
autocmd FileType netrw setl bufhidden=delete
"set winfixwidth

" Ced: for auto-completion popup menu
highlight Pmenu    guifg=black  guibg=grey
highlight PmenuSel guifg=grey guibg=black gui=bold
" Thomas: let's change it for term as well
highlight Pmenu    ctermbg=grey gui=bold
highlight PmenuSel ctermbg=cyan gui=bold
"hi Search cterm=NONE ctermfg=grey ctermbg=blue

" Thanks to Pablo !
set completeopt=menu,menuone,longest,preview
set previewheight=1
"To close automatically the preview window:
"autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
"autocmd InsertLeave * if pumvisible() == 0|pclose|endif

set showbreak=↪
set wrap
set cpo+=n

set autochdir

hi CursosLine gui=underline

" Jump to the last position when reopening a file
augroup vimrc
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
augroup END

" Keep buffers hidden instead of closing it
set hidden

" More natural split opening
set splitbelow
set splitright

"Timestamp
let g:AutoAdapt_FilePattern = ''
let g:AutoAdapt_FirstLines = 10
let g:AutoAdapt_LastLines = 0
let g:AutoAdapt_Rules = [
\   {
\       'name': 'Copyright notice',
\       'patternexpr': '''\c\<Copyright:\?\%(\s\+\%((C)\|&copy;\|\%xa9\)\)\?\s\+\zs\(\%('' . strftime("%Y") . ''\)\@!\d\{4}\)\%(\ze\k\@![^-]\|\(-\%('' . strftime("%Y") . ''\)\@!\d\{4}\)\>\)''',
\       'replacement': '\=submatch(1) . "-" . strftime("%Y")',
\	    'range': '1,10'
\   },
\   {
\       'name': 'Copyright notice modelines',
\       'patternexpr': '''\c\<Copyright:\?\%(\s\+\%((C)\|&copy;\|\%xa9\)\)\?\s\+\zs\(\%('' . strftime("%Y") . ''\)\@!\d\{4}\)\%(\ze\k\@![^-]\|\(-\%('' . strftime("%Y") . ''\)\@!\d\{4}\)\>\)''',
\       'replacement': '\=submatch(1) . "-" . strftime("%Y")',
\       'range': 'modelines'
\   },
\   {
\       'name': 'Last Change notice',
\       'pattern': '\v\C%(<Last %([uU]pdate?|[Mm]odified)\s+)@<=.*$',
\       'replacement': '\=strftime("%a %b %d %H:%M:%S %Y '.username.'")',
\	    'range': '1,10'
\   }
\]
autocmd BufWritePre <buffer> silent! :Adapt

" Semantic Highlight
let g:semanticGUIColors = ['#72d572', '#c5e1a5', '#e6ee9c', '#fff59d', '#ffe082', '#ffcc80', '#ffab91', '#bcaaa4', '#b0bec5', '#ffa726', '#ff8a65', '#f9bdbb', '#f9bdbb', '#f8bbd0', '#e1bee7', '#d1c4e9', '#ffe0b2', '#c5cae9', '#d0d9ff', '#b3e5fc', '#b2ebf2', '#b2dfdb', '#a3e9a4', '#dcedc8' , '#f0f4c3', '#ffb74d' ]
let g:semanticTermColors = [28,1,2,3,4,5,6,7,25,9,10,34,12,13,14,15,16,125,124,19]

" Backup part
set nobackup
"set backupdir=~/.vim/vimfiles/backup

" Swap files
set noswapfile
"set directory=~/.vim/vimfiles/swap

" Undo files
if has('persistent_undo')
    set undodir=~/.vim/vimfiles/undo
    set undofile
    "let &undodir=&directory
    set undolevels=1024
    set undoreload=1024
endif

" start up message short
set shortmess+=I

" Colorizer
let g:colorizer_nomap = 1
let g:colorizer_startup = 0

let g:syntastic_tex_checkers = ['chktex']

let g:ConqueGdb_Leader = '\'
let g:ConqueTerm_CloseOnEnd = 1
let g:ConqueTerm_ReadUnfocused=1
let g:ConqueTerm_Color = 1
let g:ConqueGdb_SaveHistory = 1
let g:ConqueTerm_InsertOnEnter = 1
let g:ConqueTerm_CWInsert = 1

" vim --cmd 'let debug=1'
if exists('debug')
let g:ConqueGdb_Disable = 0
nnoremap <silent> <bslash>l :ConqueGdbCommand record<CR>
nnoremap <silent> <bslash>L :ConqueGdbCommand record stop<CR>
nnoremap <silent> <bslash>N :ConqueGdbCommand reverse-next<CR>
nnoremap <silent> <bslash>S :ConqueGdbCommand reverse-step<CR>
" Start ConqueGdb up without glitching
autocmd VimEnter * :ConqueGdb --ex "dashboard -output /dev/null"
else
let g:ConqueGdb_Disable = 1
endif

set modeline

let g:atp_Compiler = "python"

" session
set ssop-=options    " do not store global and local values in a session
set ssop-=folds      " do not store folds
set ssop+=localoptions

" word-motion setup
" w/e/b/W replaced by default

""""""""""""" Standard cscope/vim boilerplate
" use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
"set cscopetag
"" check cscope for definition of a symbol before checking ctags: set to 1
"" if you want the reverse search order.
"set csto=0
"" add any cscope database in current directory
"if filereadable("cscope.out")
"    cs add cscope.out
"" else add the database pointed to by environment variable
"elseif $CSCOPE_DB != ""
"    cs add $CSCOPE_DB
"endif
"" show msg when any other cscope db added
"set cscopeverbose

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --vimgrep\ $*
  set grepformat=%f:%l:%c:%m
endif

" Adapt on save hook
autocmd BufWritePre <buffer> %s/\s\+$//e
autocmd BufWritePre <buffer> silent! :Adapt
