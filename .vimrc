syntax on
filetype off

" format and user interface
set nocompatible
set number
set softtabstop=4 tabstop=4 shiftwidth=4
set expandtab
set autoindent
set incsearch
set hlsearch
set laststatus=2
set backspace=2

" initialize vundle
if !isdirectory(expand("~/.vim/bundle/vundle/.git"))
    !git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle
endif
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" feature bundles
Bundle 'pyflakes'
Bundle 'gmarik/vundle'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/nerdcommenter'
Bundle 'jistr/vim-nerdtree-tabs'
Bundle 'kien/ctrlp.vim'
Bundle 'majutsushi/tagbar'
Bundle 'bling/vim-airline'
Bundle 'mattn/emmet-vim'
Bundle 'ervandew/supertab'
Bundle 'vim-scripts/AutoComplPop'
Bundle 'Blackrush/vim-gocode'
" Bundle 'davidhalter/jedi-vim'
Bundle 'vim-scripts/pythoncomplete'
" Bundle 'AutoComplPop'
" Bundle 'Valloric/YouCompleteMe'
" 决定不用solarized的配色了...
" Bundle 'altercation/vim-colors-solarized'

" file type bundles
Bundle 'sophacles/vim-bundle-mako'
Bundle 'Glench/Vim-Jinja2-Syntax'
Bundle 'othree/html5.vim'
Bundle 'sprsquish/thrift.vim'
Bundle 'tonyseek/rust.vim'
Bundle 'cakebaker/scss-syntax.vim'
Bundle 'wavded/vim-stylus'
Bundle 'jansenm/vim-cmake'
Bundle 'evanmiller/nginx-vim-syntax'
" Bundle 'jnwhiteh/vim-golang'

" key mapping
" let mapleader=","
imap jk <ESC>
imap Jk <ESC>
imap JK <ESC>
imap jK <ESC>
imap <C-L> <RIGHT>
nmap 1 ^
nmap <Leader>tb :TagbarToggle<CR>
nmap <Leader>tt :NERDTreeToggle<CR>
nmap <Leader>nt :tabnew<CR>
nmap <TAB> :tabn<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

autocmd FileType python map <Leader>pf :call Pyflakes()<CR>
autocmd FileType html set filetype=mako softtabstop=2 tabstop=2 shiftwidth=2
autocmd FileType javascript set softtabstop=2 tabstop=2 shiftwidth=2
autocmd FileType go set expandtab!

" configurations of plugins
let g:nerdtree_tabs_open_on_console_startup = 0
let g:nerdtree_tabs_open_on_gui_startup = 0
let g:ctrlp_custom_ignore = 'node_modules\|pyc\|git\|__pycache__'
let g:tagbar_ctags_bin='/usr/bin/ctags'
let g:ctrlp_use_caching = 1
let g:ctrlp_working_path_mode = 0
let g:jedi#popup_select_first = 0
let g:jedi#popup_on_dot = 1
" let g:jinja_syntax_html = 1
if filereadable('/usr/local/bin/ctags')
    let g:tagbar_ctags_bin = '/usr/local/bin/ctags'
endif
function! FiletypeHook(config)
    if has_key(a:config, 'language')
        let &filetype = a:config['language']
    endif
    return 0   " Return 0 to show no error happened
endfunction

" display style
colorscheme torte

filetype plugin on
filetype indent on
