syntax on
filetype on

set encoding=utf-8
set fileencoding=utf-8

set autoindent
set noexpandtab
set tabstop=4
set shiftwidth=4

set nu rnu

" Smart Home
noremap <expr> <silent> <Home> col('.') == match(getline('.'),'\S')+1 ? '0' : '^'
imap <silent> <Home> <C-O><Home>

autocmd VimEnter * GuiColorScheme hybrid
autocmd VimEnter * colorscheme hybrid
autocmd FileType python set autoindent noexpandtab tabstop=4 shiftwidth=4
