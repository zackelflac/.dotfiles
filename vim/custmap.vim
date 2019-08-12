" Custom map
nmap f <Plug>(easymotion-overwin-f)
nmap s <Plug>(easymotion-overwin-w)
nnoremap Q <nop>
nnoremap x "_x
vnoremap x "_d
nnoremap X "_X
inoremap jj <esc>j
inoremap kk <esc>k
nnoremap // /\<<C-r><C-w>\><cr>
vnoremap // "sy/<C-R>"<cr>
nnoremap ( :<c-u>call search("(", "bes")<cr>
nnoremap ) :<c-u>call search("(", "es")<cr>
nnoremap <leader>/ :nohlsearch<cr>
nnoremap <s-tab> :NERDTreeToggle<cr>
" search clipboard
nnoremap <S-Insert> q/p<cr>
" insert clipboard into command
cnoremap <S-Insert> <c-r>0
cnoremap <C-R> <esc>:<c-u>History:<cr>

function! IsLeftMostWindow()
    let curNr = winnr()
    wincmd h
    if winnr() == curNr
        return 1
    endif
    wincmd p " Move back.
    return 0
endfunction

function IsCursorTop()
    let cursline = winline()
    let middleline = winheight(0) /2
    if cursline <= middleline
        return 1
    endif
    return 0
endfunction

function SmartSplit()
    if IsCursorTop()
        normal H
        execute ":split"
        normal <C-w>k``<C-w>j
    else
        normal L
        execute ":topleft split"
        normal <C-w>j``<C-w>k
    endif
endfunction

function FixedScroll()
    let curline   = line(".") - 1
    let viewlines = winheight(0)
    let topviewline = line("w0") - 1
    "let line_pos = screenrow()

    let pagenum = curline / viewlines
    let pagestartline = pagenum * viewlines
    if topviewline < pagestartline
        let offset = pagestartline - topviewline
        exe "normal ".offset."\<c-n>"
    elseif topviewline > pagestartline
        let offset = topviewline - pagestartline
        exe "normal ".offset."\<c-y>"
    endif
endfunction

function FixedScrollKeepCursor(scrollCommand)
    let curline   = line(".")
    let topviewline = line("w0")
    call FixedScroll()
    exe "normal ".a:scrollCommand
    if curline != topviewline
        let offset = curline - topviewline
        execute "normal H".offset."j"
    endif
endfunction

function FixedScrollUp()
    call FixedScrollKeepCursor("\<c-b>\<c-y>\<c-y>")
endfunction

function FixedScrollDown()
    call FixedScrollKeepCursor("\<c-f>\<c-n>\<c-n>")
endfunction

command! AsyncCCL call asyncrun#quickfix_toggle(0, 0)

function AsyncGrep(word, path)
    call asyncrun#quickfix_toggle(0, 0)
    execute "AsyncRun -cwd=".a:path." -program=grep \"".a:word."\" ."
    let @/ = a:word
    set hls
    redraw
endfunction

function! WhichTab(filename)
    " Try to determine whether file is open in any tab.  
    " Return number of tab it's open in
    let buffername = bufname(a:filename)
    if buffername == ""
        return -1
    endif
    let buffernumber = bufnr(buffername)

    " tabdo will loop through pages and leave you on the last one;
    " this is to make sure we don't leave the current page
    let currenttab = tabpagenr()
    let tab_arr = []
    tabdo let tab_arr += tabpagebuflist()

    " return to current page
    exec "tabnext ".currenttab

    " Start checking tab numbers for matches
    let i = 0
    for tnum in tab_arr
        let i += 1
        if tnum == buffernumber
            return i
        endif
    endfor
endfunction

function OpenExplorer()
    let tabnum=WhichTab('NetrwTreeListing')
    if tabnum == -1
        exec "0tabnew"
        exec "Explore ."
    else
        let tabnum += 1
        exec "tabnext ".tabnum
    endif
endfunction

command! -nargs=* -complete=dir AsyncGrep call AsyncGrep(<f-args>)

cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-h> <S-Left>
cnoremap <C-l> <S-Right>
"cnoremap <C-k> <C-w><C-w>
"nnoremap <C-e> :<c-u>Files<cr>
"
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

nnoremap <C-n> <C-e>
nnoremap <c-e> :<c-u>Files<cr>
nnoremap <C-n> <C-e>
nnoremap <C-g> :<c-u>Ag<cr>

"noremap <leader>a :set scb<cr> " just use vimdiff or Linediff
"noremap <leader>A :set scb!<cr>
"noremap <leader>b :FufBuffer<cr>
nnoremap <leader>a :<c-u>call AutoAdjustQFWindow()<cr>
noremap <leader>b :<c-u>Buffers<cr>
noremap <leader>c :<c-u>AsyncCCL<cr>:ccl\|lcl\|pcl<cr>
noremap <leader>C :AsyncStop<cr>
noremap <leader>d "_d
"noremap <leader>E :silent e <c-r>=expand("%:p:h")."/"<cr>
noremap <leader>e :<c-u>Files <c-r>=expand("%:p:h")<cr><cr>
noremap <leader>t :botright pta <C-r><C-w><cr>
noremap <leader>T "sy:botright pta /<C-R>"
vnoremap <leader>t "sy:botright pta /<C-R>"<cr>
vnoremap <leader>T "sy:botright pta /<C-R>"
nnoremap <leader>j :call coc#util#float_jump()<cr>
"Add --cpp or --type:
noremap <leader>g :Ag <C-r><C-w><cr>
vnoremap <silent> <leader>g "sy:Ag<space><C-R>"<C-f>
noremap <leader>ge :<c-u>ALENext -error<cr>
noremap <leader>gE :<c-u>ALEPrevious -error<cr>
noremap <leader>gg :AsyncGrep <C-r><C-w> `pwd`<tab>
vnoremap <leader>gg "sy:AsyncGrep <C-R>" `runcached brazil-path package-src-root`<tab>
nnoremap <silent> <leader>G <c-g>
vnoremap <leader>G "sy:AsyncGrep <C-R>" `pwd`<tab>
noremap gl :CocList<cr>
noremap <leader>h :<c-u>call File_flip()<cr>zz
"noremap <leader>H :0r ~/.vim/.header_template<cr>
noremap <leader>l :<c-u>let g:tagbar_left=IsLeftMostWindow()<cr>:TagbarOpen j<cr>
noremap <leader>L :<c-u>call OpenExplorer()<cr>
"noremap <leader>mk :mksession ~/mysession.vim
nnoremap <leader>m :Marks<cr>
noremap <leader>mm <esc>:SlimeSend1 cppman <C-r><C-w>
noremap <leader>o <c-w>w
noremap <leader>O <esc>:only<cr>:vsp<cr>
vnoremap <leader>pp "_dP
nnoremap <leader>ph "hp
nnoremap <leader>pj "jp
nnoremap <leader>pk "kp
nnoremap <leader>pl "lp
noremap <leader>q :<c-u>q<cr>
noremap <leader>Q :<c-u>q!<cr>
noremap <leader>r /\<<C-r><C-w>\><cr>:%s//<C-r><C-w>/g<left><left>
vnoremap <leader>r "sy/<C-R>"<cr>:%s//<C-R>"/g<left><left>
if has('nvim')
    vnoremap <leader>s :<c-u>TREPLSendSelection<cr>
else
    " slime based?
endif
noremap <leader>S :<c-u>SemanticHighlightToggle<cr>
"noremap <leader>t :<c-u>tj <C-r><C-w><cr>
noremap <leader>T :<c-u>tj /<C-r><C-w><C-b><right><right><right><right>
"vnoremap <leader>t "sy:tj /<C-R>"<cr>
vnoremap <leader>T "sy:tj /<C-R>"
nnoremap \| :<c-u>vsp<cr>
nnoremap _ :<c-u>call SmartSplit()<cr>``zz
noremap <leader>u :<c-u>UndotreeToggle<cr>:UndotreeFocus<cr>
noremap <leader>v <C-v>
nnoremap <leader>w :lcd %:p:h<cr>:pwd<cr>
nnoremap <leader>W :lcd -<cr>:pwd<cr>
noremap <leader>x :<c-u>bp\|bd #<cr>
noremap <leader>X :<c-u>bp\|bd! #<cr>
vnoremap <leader>yy "+y
vnoremap <leader>yh "hy
vnoremap <leader>yj "jy
vnoremap <leader>yk "ky
vnoremap <leader>yl "ly
noremap <leader>Y :<c-u>let @*=expand("%:p")<cr>
nnoremap <leader>z :<c-u>call FixedScroll()<cr>
"noremap <leader>z zR
"noremap <leader>Z zM

"vnoremap <leader>=, :Tab /,\zs/l1r0<cr>gv=
vnoremap <leader>== :Tab /=<cr>gv=
vnoremap <leader>=<space> :Tab /\s\zs/l1r0<cr>gv=
vnoremap <leader>=; :Tabularize /\S\+;$/l1<cr>gv=
vnoremap <leader>=( :Tabularize /\S\+($/l1<cr>gv=
vnoremap <leader>=. :call BreakDotHere()<cr>
vnoremap <leader>=, :call BreakCommaHere()<cr>

nnoremap <leader>=. V<esc>:call BreakDotHere()<cr>
nnoremap <leader>=, V<esc>:call BreakCommaHere()<cr>

function! BreakDotHere()
    '<,'>s/\./\r\./g
    normal V``=
    call histdel("/", -1)
endfunction

function! BreakCommaHere()
    '<,'>s/,/,\r/g
    normal V``=
    call histdel("/", -1)
endfunction

noremap <leader>1 "1
noremap <leader>2 "2
noremap <leader>3 "3
noremap <leader><cr> a<cr><esc>
noremap <leader>> x<esc>wP
noremap <leader>< x<esc>bep

nnoremap <bs> <C-O>
nnoremap <leader><bs> <C-I>

" Custom hard remap
inoremap        [ []<Left>
inoremap <expr> ] strpart(getline('.'), col('.')-1, 1) == "]" ? "\<Right>" : "]"
inoremap        ( ()<Left>
inoremap <expr> ) strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"
inoremap <expr> ' strpart(getline('.'), col('.')-1, 1) == "\'" ? "\<Right>" : "\'\'\<Left>"
inoremap <expr> " strpart(getline('.'), col('.')-1, 1) == "\"" ? "\<Right>" : "\"\"\<Left>"
inoremap <expr> { "{}\<Left>"
inoremap <expr> } strpart(getline('.'), col('.')-1, 1) == "}" ? "\<Right>" : "}"

nnoremap <c-h> :<c-u>History<cr>
inoremap <c-k> <c-o>:call LanguageClient#textDocument_signatureHelp()<cr>
nnoremap <silent> <leader>k <Esc>:MyMan <cword><CR>
vnoremap <silent> <leader>k "sy:MyMan <C-R>"<CR>

" scroll remap
nnoremap <c-j> :call search('\%' . virtcol('.') . 'v\S', 'wW')<CR>
nnoremap <c-k> :call search('\%' . virtcol('.') . 'v\S', 'bW')<CR>
nnoremap <PageUp> :<c-u>call FixedScrollUp()<cr>
nnoremap <PageDown> :<c-u>call FixedScrollDown()<cr>
nnoremap - <PageUp>
nnoremap + <PageDown>
nmap <S-ScrollWheelUp> <PageUp>
nmap <S-ScrollWheelDown> <PageDown>

map <ScrollWheelUp> <C-Y>
map <ScrollWheelDown> <C-N>

" Simulate <down> after CTRL-N
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
            \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"
inoremap <expr> <tab>      pumvisible() ? "\<lt>Down>" : "\<c-r>=Smart_TabComplete()\<CR>"
inoremap <expr> <s-tab>    pumvisible() ? "\<lt>Up>" : "\<s-tab>"

function! CaptureExtOutputInNewBuffer(cmd)
    let out = system(a:cmd)
    ene
    silent put=out
    set nomodified
endfunction
command! -nargs=+ -complete=command CaptureExtOutputInNewBuffer call CaptureExtOutputInNewBuffer(<q-args>)

noremap <F1> :<c-u>!git add %<cr>
noremap <F2> :<c-u>set modifiable\|set noro\|set write<cr>

if has('nvim')
    au TermOpen * tnoremap <Esc> <c-\><c-n>
    au FileType fzf tunmap <Esc>

    nnoremap <F3> :<c-u>let g:neoterm_size=winheight(0)/3 \| topleft Ttoggle<cr>
    tnoremap <F3> <C-\><C-n>: Ttoggle<cr>

    " mappings for putting
    "nmap p <Plug>(extract-put)
    "nmap P <Plug>(extract-Put)
    "" mappings for visual
    "vmap p <Plug>(extract-put)
    "vmap P <Plug>(extract-Put)

    nmap <leader>y :ExtractPin<cr>

    "" mappings for cycling
    "nmap <c-s> <Plug>(extract-sycle)
    "nmap <c-S> <Plug>(extract-Sycle)

    "" mappings for insert
    "imap <m-v> <Plug>(extract-completeReg)
    "imap <c-v> <Plug>(extract-completeList)

endif

function! SetMyManHost(choice)
    if a:choice == 0
        echom "none"
    elseif a:choice == 1
        let g:man_host_command="tmux"
        command! -nargs=+ MyMan exe "silent !tmux ".g:man_tmux_command." ".man_focus."'".g:man_provider." \"" . expand(<q-args>) . "\"'"
    elseif a:choice == 2
        let g:man_host_command="neoterm"
        command! -nargs=+ MyMan exe "silent T ".g:man_provider." \"" . expand(<q-args>) . "\""
    endif
endfunction

function! ChangeMyManHost()
    let choice = confirm("Which provider?", "&Tmux\n&Neoterm\n", 1)
    call SetMyManHost(choice)
endfunction

function! SetMyMan()
    let choice = confirm("Which provider?", "&Google\n&Duckduckgo\n&Cppman\n&man", 2)
    if choice == 0
        echom "none"
    elseif choice == 1
        let g:man_provider = "sr google"
    elseif choice == 2
        let g:man_provider = "sr duckduckgo"
    elseif choice == 3
        let g:man_provider = "cppman"
    elseif choice == 4
        let g:man_provider = "man"
    endif
endfunction

if has("gui_running")
    let g:man_tmux_command="new-window"
    let g:man_focus="-d"
    let g:man_silent="silent"
else
    let g:man_host_command="tmux"
    let g:man_tmux_command="split-window"
    let g:man_focus=""
    let g:man_silent=""
endif

let g:man_provider = "sr duckduckgo "
if has('nvim')
    call SetMyManHost(2)
else
    call SetMyManHost(1)
endif

" Need to manually call copen first so that directories are correctly set
" (issue with asyncrun?)

noremap <expr> <F4> exists('g:debug') ? ":<c-u>AsyncRun -program=make @ -j4 DEBUG=1 -C `pwd`/<tab><tab>" : ":<c-u>AsyncRun -program=make @ -j4 -C `pwd`/<tab><tab>"
nnoremap <F5> :<c-u>AsyncCCL<cr>:up<cr>:AsyncRun -program=make<Up><cr>
inoremap <F5> <esc>:<c-u>AsyncCCL<cr>:up<cr>:AsyncRun -program=make<Up><cr>

fun IsQFOrLocOrTagOpen()
    silent exec 'redir @a | ls | redir END'
    if match(@a,'\[Location List\]') >= 0
        return 2
    elseif match(@a,'\[Quickfix List\]') >= 0
        return 1
    else
        return 3
    endif
endfun

fun NextWinOrQFError()
    try
        let l:res = IsQFOrLocOrTagOpen()
        if l:res == 1
            :cn
            :foldopen
            return 0
        elseif l:res == 2
            :ln
        elseif l:res == 3
            ":ptn
        endif
        return 0
    catch /.*/
        echohl WarningMsg | echon v:exception | echohl None
    endtry
endfun

fun PrevWinOrQFError()
    try
        let l:res = IsQFOrLocOrTagOpen()
        if l:res == 1
            :cp
            :foldopen
            return 0
        elseif l:res == 2
            :lp
        elseif l:res == 3
            ":ptp
        endif
        return 0
    catch /.*/
        echohl WarningMsg | echon v:exception | echohl None
    endtry
endfun

fun CurrWinOrQFError()
    try
        let l:res = IsQFOrLocOrTagOpen()
        if l:res == 1
            if exists('g:jumpfirst')
                :cfirst
                :cn
                if g:asyncrun_status != 'running'
                    unlet g:jumpfirst
                endif
            else
                :cc
            endif
            :cp
            return 0
        elseif l:res == 2
            :ll
        elseif l:res == 3
            ":ptr
        endif
        :foldopen
        return 0
    catch /.*/
        echohl WarningMsg | echon v:exception | echohl None
    endtry
endfun

if has('nvim')
    noremap <expr> <F6> bufwinnr('Shell') != -1 ? ":<c-u>VBGstepOut<cr>"  : bufwinnr('gdb') != -1 ? ":<c-u>GdbFinish<cr>" : ":<c-u>call PrevWinOrQFError()<cr>"
    noremap <expr> <F7> bufwinnr('Shell') != -1 ? ":<c-u>VBGstepOver<cr>" : bufwinnr('gdb') != -1 ? ":<c-u>GdbNext<cr>"   : ":<c-u>call NextWinOrQFError()<cr>"
    noremap <expr> <F8> bufwinnr('Shell') != -1 ? ":<c-u>VBGstepIn<cr>"   : bufwinnr('gdb') != -1 ? ":<c-u>GdbStep<cr>"   : ":<c-u>call CurrWinOrQFError()<cr>"
else
    noremap <expr> <F6> bufwinnr('!gdb') != -1 ? ":<c-u>Finish<cr>" : ":<c-u>call PrevWinOrQFError()<cr>"
    noremap <expr> <F7> bufwinnr('!gdb') != -1 ? ":<c-u>Over<cr>"   : ":<c-u>call NextWinOrQFError()<cr>"
    noremap <expr> <F8> bufwinnr('!gdb') != -1 ? ":<c-u>Step<cr>"   : ":<c-u>call CurrWinOrQFError()<cr>"
endif

function SetDebug()
    let choice = confirm("Debug mode", "&Yes\n&No", 2)
    if choice == 0
    elseif choice == 1
        let g:debug=1
    elseif choice == 2
        let g:debug=1
        unlet g:debug
    endif
endfunction

noremap <expr> <F9> "<esc>:<c-u>call SetDebug()<cr>"

function ToggleSpell()
    if &spell
        set nospell
    else
        set spell
    endif
endfunction

noremap <F10> :<c-u>call ToggleSpell()<cr>
inoremap <F10> <Esc>:call ToggleSpell()<cr>
noremap <F11> :<c-u>call SetMyMan()<cr>

function Smart_TabComplete()
    let line = getline('.')                         " current line

    let substr = strpart(line, -1, col('.'))      " from the start of the current
    " line to one character right
    " of the cursor
    let substr = matchstr(substr, "[^ \t]*$")       " word till cursor
    if (strlen(substr)==0)                          " nothing to match on empty string
        return "\<tab>"
    endif
    let has_period = match(substr, '\.') != -1      " position of period, if any
    let has_slash = match(substr, '\/') != -1       " position of slash, if any
    let has_colon = match(substr, '::') != -1     " position of ::, if any
    "if (!has_period && !has_slash && !has_colon)
    "    return "\<C-X>\<C-O>"                         " existing text matching
    if ( has_slash )
        return "\<C-X>\<C-F>"                         " file matching
    elseif &omnifunc != ""
        return "\<C-X>\<C-O>"                         " plugin matching
    else
        return "\<C-n>"
    endif
endfunction

"command! -nargs=? Gdiff diffthis |
"      \ let gdiffpath=fnamemodify(resolve(expand('%:p')),':h') |
"      \ vnew |
"      \ set buftype=nofile |
"      \ set bufhidden=wipe |
"      \ set noswapfile |
"      \ execute "cd ".gdiffpath." | r!git show ".(!"<args>"?'HEAD~0':"<args>").":./".expand('#') |
"      \ 1d_ |
"      \ let &filetype=getbufvar('#', '&filetype') |
"      \ execute 'autocmd BufWipeout <buffer> diffoff!' |
"      \ diffthis

nnoremap <silent> <2-LeftMouse> :let @/='\V\<'.escape(expand('<cword>'), '\').'\>'<cr>:set hls<cr>viw

if &diff
endif
