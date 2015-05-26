" Adapt on save hook
autocmd BufWritePre <buffer> silent! :Adapt

if has("gui_running")
  au BufEnter <buffer> if (!exists('b:created')) | :execute "SemanticHighlight" | let b:created=1 | endif
  "Triggered by :doautocmd
  "au User <buffer> :SemanticHighlight 
  au BufWritePost <buffer> :SemanticHighlight
endif

" Surround 
let g:surround_{char2nr("c")} = "\/*\n\r\n*\/"

"Makeprg erroformat
compiler gcc

setlocal foldlevel=1
setlocal foldnestmax=1
setlocal foldmarker={,}
setlocal foldminlines=1

" Stop parsing include files, use ctags instead
set complete-=i

"inoremap <expr> < "<>\<Left>"
inoremap <expr> > strpart(getline('.'), col('.')-1, 1) == ">" ? "\<Right>" : ">"
inoremap ;; <esc>g_a;
inoremap ;. <esc>g_a.

if !exists("*File_flip")
  function! File_flip()
    if match(expand("%"),'\.hh') > 0
      let s:flipname = substitute(expand("%"),'\.hh','.hxx',"")
      try
        exe ":find " s:flipname
      catch
        let s:flipname = substitute(expand("%"),'\.hh','.cc',"")
        exe ":find " s:flipname
      endtry
    elseif match(expand("%"),'\.hxx') > 0
      let s:flipname = substitute(expand("%"),'\.hxx','.hh',"")
      exe ":find " s:flipname
    elseif match(expand("%"),'\.h\(.*\)') > 0
      let s:flipname = substitute(expand("%"),'\.h\(.*\)','.c',"")
      exe ":find " s:flipname."*"
    elseif match(expand("%"),'\.c\(.*\)') > 0
      let s:flipname = substitute(expand("%"),'\.c\(.*\)','.h',"")
      exe ":find " s:flipname."*"
    endif
  endfun
endif
