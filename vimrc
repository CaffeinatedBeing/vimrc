" config.vim
" Remap leader to space
map <Space> <Leader>

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
set colorcolumn=120
autocmd ColorScheme * highlight ColorColumn ctermbg=red
highlight ExtraWhitespace ctermbg=red guibg=red
set list

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

" indentation for js files tabwidth 2
augroup FileTypeSpecificAutocommands
    autocmd FileType javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END

" Open NERDTree in the directory of the current file (or /home if no file is open)
nmap <silent> <C-k><C-i> :call NERDTreeToggleInCurDir()<cr>
function! NERDTreeToggleInCurDir()
  " If NERDTree is open in the current buffer
  if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
    exe ":NERDTreeClose"
  else
    exe ":NERDTreeFind"
  endif
endfunction

" Plugins
call plug#begin('~/.vim/plugged')
" Plugins here !!!!
Plug 'tpope/vim-sensible'         " Sensible defaults
Plug 'morhetz/gruvbox'
Plug 'preservim/nerdtree', { 'on':  'NERDTreeToggle' } " File navigator
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }     " Install fuzzy finder binary
Plug 'junegunn/fzf.vim'
Plug 'dense-analysis/ale'
Plug 'preservim/nerdcommenter'
Plug 'alvan/vim-closetag'
let g:closetag_filenames ='*.html,*.xhtml,*.xml,*.vue,*.phtml,*.js,*.jsx,*.coffee,*.erb'
Plug 'jiangmiao/auto-pairs'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
Plug 'maxmellon/vim-jsx-pretty'
Plug 'pechorin/any-jump.vim'
Plug 'eslint/eslint'
Plug 'nestorsalceda/vim-strip-trailing-whitespaces'
Plug 'vim-scripts/vim-gitgutter'
Plug 'neoclide/vim-jsx-improve'
Plug 'vim-ruby/vim-ruby' " For Facts, Ruby functions, and custom providers


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

" Prettier support with coc
command! -nargs=0 Prettier :CocCommand prettier.formatFile
" coc config
let g:coc_global_extensions = [
  \ 'coc-snippets',
  \ 'coc-pairs',
  \ 'coc-tsserver',
  \ 'coc-eslint',
  \ 'coc-prettier',
  \ 'coc-json',
  \ ]

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
map <C-g> :Git
map <C-f> :Ag
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
let g:ale_sign_error = '❌'
let g:ale_sign_warning = '⚠️'

set encoding=utf-8
let g:ale_fixers = {'javascript': ['eslint']}

let g:airline_powerline_fonts = 1
set guifont=DejaVu\ Sans\ Mono:h12
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
" let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'default'
let g:airline#extensions#tabline#fnamemod = ':t'

let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
