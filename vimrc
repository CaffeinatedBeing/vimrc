" config.vim

let mapleader = ","
set nocompatible
set number                " Show numbers on the left
set hlsearch              " Highlight search results
set ignorecase            " Search ingnoring case
set smartcase             " Do not ignore case if the search patter has uppercase
set noerrorbells          " I hate bells
set belloff=esc
set tabstop=4             " Tab size of 4 spaces
set softtabstop=4         " On insert use 4 spaces for tab
set shiftwidth=4
set expandtab             " Use apropiate number of spaces
set nowrap                " Wrapping sucks (except on markdown)
autocmd BufRead,BufNewFile *.md,*.txt setlocal wrap " DO wrap on markdown files
set noswapfile            " Do not leve any backup files
set mouse=a               " Enable mouse on all modes
set clipboard=unnamed,unnamedplus     " Use the OS clipboard
set showmatch
set termguicolors
set splitright splitbelow
set list lcs=tab:>-      "(here is a space)
let &t_SI = "\e[6 q"      " Make cursor a line in insert
let &t_EI = "\e[2 q"      " Make cursor a line in insert
set modifiable

" Keep VisualMode after indent with > or <
vmap < <gv
vmap > >gv

"
" Move Visual blocks with J an K
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Autocomand to remember las editing position
augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END
" Install vim-plug for vim and neovim
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins
call plug#begin('~/.vim/plugged')
" Plugins here !!!!
Plug 'tpope/vim-sensible'         " Sensible defaults
Plug 'morhetz/gruvbox'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdtree', { 'on':  'NERDTreeToggle' } " File navigator
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }     " Install fuzzy finder binary
Plug 'junegunn/fzf.vim'
Plug 'vim-scripts/AutoComplPop'
Plug 'dense-analysis/ale'
Plug 'preservim/nerdcommenter'
"{{ Autopairs
"" ---> closing XML tags <---
Plug 'alvan/vim-closetag'
let g:closetag_filenames ='*.html,*.xhtml,*.xml,*.vue,*.phtml,*.js,*.jsx,*.coffee,*.erb'
Plug 'jiangmiao/auto-pairs'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
call plug#end()
syn match   cOctalError display contained "0\o*[89]\d*"
syntax enable

map <C-k><C-k> :NERDTreeToggle<CR>
nnoremap <C-p> :Files<CR>
nmap <C-b> :Buffers<CR>
inoremap jj <Esc>
command! -bang -nargs=* Ag
  \ call fzf#vim#grep(
  \   'ag --column --numbers --noheading --color --smart-case '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

map <C-g> :Ag 

set visualbell t_vb=
if has("autocmd") && has("gui")
    au GUIEnter * set t_vb=
endif

let g:airline_theme='simple'
colorscheme gruvbox
set bg=dark

set relativenumber
let g:fzf_layout = { 'down': '40%' } 
nmap <silent> <C-e> <Plug>(ale_next_wrap)

function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors
    return l:counts.total == 0 ? 'OK' : printf(
        \   '%d‚®â %d‚ö† ',
        \   all_non_errors,
        \   all_errors
        \)
endfunction
set statusline+=%=
set statusline+=\ %{LinterStatus()}
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 1
let g:ale_sign_warning = '.'

set encoding=utf-8
let g:ale_fixers = {'javascript': ['eslint']}

let g:airline_powerline_fonts = 1

