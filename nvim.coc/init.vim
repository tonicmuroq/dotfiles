" install vim-plug
let plugblob = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
let plugfile = expand('~/.local/share/nvim/site/autoload/plug.vim')
if !filereadable(plugfile)
  execute("!curl -fLo '".plugfile."' --create-dirs '".plugblob."'")
endif

call plug#begin()

" dialects
Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml'
Plug 'asciidoc/vim-asciidoc'

" extensions
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'ervandew/supertab'
Plug 'mattn/emmet-vim'
Plug 'preservim/nerdtree'
Plug 'majutsushi/tagbar'
Plug 'github/copilot.vim'

" syntax highlight
Plug 'maralla/gomod.vim'
Plug 'uarun/vim-protobuf'
Plug 'posva/vim-vue'
Plug 'sophacles/vim-bundle-mako'

" themes
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update

" colorscheme
Plug 'sainnhe/everforest'
Plug 'joshdick/onedark.vim'
Plug 'bluz71/vim-nightfly-guicolors'
Plug 'sainnhe/sonokai'
Plug 'ghifarit53/tokyonight-vim'
Plug 'tomasiser/vim-code-dark'
Plug 'tyrannicaltoucan/vim-quantum'
Plug 'tyrannicaltoucan/vim-deep-space'

call plug#end()

call coc#add_extension(
  \ 'coc-prettier',
  \ 'coc-java',
  \ 'coc-python',
  \ 'coc-yaml',
  \ 'coc-json',
  \ 'coc-eslint',
  \ 'coc-tsserver',
  \ 'coc-vetur',
  \ 'coc-rust-analyzer',
  \ 'coc-clangd',
  \ 'coc-sql',
  \ 'coc-texlab',
  \ 'coc-go',
  \ 'coc-diagnostic')

" format and user interface
set nofoldenable
set number
set softtabstop=4 tabstop=4 shiftwidth=4
set expandtab
set autoindent
set incsearch
set hlsearch
set cursorline
set laststatus=2
set backspace=2
set termguicolors
set signcolumn=yes
set updatecount=0

" key mapping
imap jk <ESC>
imap Jk <ESC>
imap JK <ESC>
imap jK <ESC>
imap <C-L> <RIGHT>
nmap 1  ^
nmap <leader>tb :TagbarToggle<CR>
nmap <leader>tt :NERDTreeToggle<CR>
nmap <leader>nt :tabnew<CR>
nmap <leader>pc :pclose<CR>
" nmap <leader>rn :set relativenumber<CR>
" nmap <leader>an :set norelativenumber<CR>
nmap <TAB> :tabn<CR>
nmap <S-TAB> :tabp<CR>
nmap <C-P> :FZF<CR>
nmap <C-J> <C-W>j<C-W>_
nmap <C-K> <C-W>k<C-W>_
nmap <C-L> <C-W>l<C-W>_
nmap <C-H> <C-W>h<C-W>_
nmap [g <Plug>(coc-diagnostic-prev)
nmap ]g <Plug>(coc-diagnostic-next)
nmap <leader>g <Plug>(coc-definition)
nmap <leader>gt <Plug>(coc-type-definition)
nmap <leader>gi <Plug>(coc-implementation)
nmap <leader>gr <Plug>(coc-references)
nmap <leader>gs :call CocActionAsync('showSignatureHelp')<CR>
nmap <leader>rn <Plug>(coc-rename)
xmap <leader>ff <Plug>(coc-format-selected)
nmap <leader>ff <Plug>(coc-format-selected)

" nmap <silent> gvd :call CocAction('jumpDefinition', 'vnew')<CR>
" nmap <silent> gxd :call CocAction('jumpDefinition', 'new')<CR>
" nmap <silent> gtd :call CocAction('jumpDefinition', 'tabnew')<CR>

" custom commands
com! -nargs=0 FormatJSON %!python -m json.tool
com! -nargs=0 Format     :call CocAction('format')
com! -nargs=0 OR         :call CocAction('runCommand', 'editor.action.organizeImport')

" automatic commands
autocmd SwapExists * let v:swapchoice = "o"
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" global options
let g:airline_powerline_fonts = 1
let g:NERDTreeIgnore = ['\.py[oc]$', '__pycache__', '\.egg-info']
let g:NERDTreeStatusline = "NERDTree"
let g:tagbar_ctags_bin='/usr/bin/ctags'
if filereadable('/usr/local/bin/ctags')
  let g:tagbar_ctags_bin = '/usr/local/bin/ctags'
endif

" display style
set background=dark
colorscheme deep-space
let g:airline_theme = 'onedark'

if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
