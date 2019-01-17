packadd vim-slime
packadd vim-ruby

source ~/.vim/bundle/coding_activator.vim

" activated with 'solargraph socket'
let g:LanguageClient_serverCommands = {
            \ 'ruby': ['tcp://localhost:7658']
            \ }

set omnifunc=LanguageClient#complete
let g:LanguageClient_autoStop =0
