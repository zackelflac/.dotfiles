source ~/.vim/bundle/coding_activator.vim
packadd rust.vim

let g:tagbar_type_rust = {
    \ 'ctagstype' : 'rust',
    \ 'kinds' : [
        \'T:types,type definitions',
        \'f:functions,function definitions',
        \'g:enum,enumeration names',
        \'s:structure names',
        \'m:modules,module names',
        \'c:consts,static constants',
        \'t:traits',
        \'i:impls,trait implementations',
    \]
\}

" Surround
let g:surround_{char2nr("t")} = "\1template: \1<\r>"

inoremap <expr> ' "\'"
inoremap <expr> <> "<>\<Left>"
inoremap <expr> > strpart(getline('.'), col('.')-1, 1) == ">" ? "\<Right>" : ">"

imap <expr> {<cr> "{<cr>}<esc>O"
inoremap [<cr> [<cr>]<c-o>O<tab>
inoremap (<cr> (<cr>)<c-o>O<tab>
inoremap <<cr> <<cr>><c-o>O<tab>

" Make options
let &makeprg='cargo'
"--manifest-path `pwd`/<tab><tab>
"
let g:make_extra='@ build -j4'

set expandtab
set tabstop=4
set shiftwidth=4

DefineLocalTagFinder TagFindStruct s,struct
DefineLocalTagFinder TagFindTrait t,trait

" Ignored patterns, and blank lines
set efm=%-G
set efm+=%-Gerror:\ aborting\ %.%#
set efm+=%-Gerror:\ Could\ not\ compile\ %.%#

" Meaningful lines (errors, notes, warnings, contextual information)
set efm+=%Eerror:\ %m
set efm+=%Eerror[E%n]:\ %m
set efm+=%Wwarning:\ %m
set efm+=%Inote:\ %m
set efm+=%C\ %#-->\ %f:%l:%c
