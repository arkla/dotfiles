" automatic install vim plug for vim and nvim
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" turn filetype off while loading plugins
filetype off
filetype plugin indent off

call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'mileszs/ack.vim'

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git', { 'for': 'git' }

Plug 'airblade/vim-gitgutter'

if has('nvim')
Plug 'neovim/nvim-lsp'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/deoplete-lsp'
endif

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'morhetz/gruvbox'

Plug 'bfrg/vim-cpp-modern'
call plug#end()

set background=dark

let mapleader = ","

" setup deoplete/ccls
if has('nvim')
let g:deoplete#enable_at_startup = 1

" customise deoplete
" maximum candidate window length
call deoplete#custom#source('_', 'max_menu_width', 120)

" NVIM Built in lsp setup
lua require'nvim_lsp'.ccls.setup{}

" Keybindings
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>

" autocmd Filetype python setlocal omnifunc=v:lua.vim.lsp.omnifunc
autocmd Filetype cpp setlocal omnifunc=v:lua.vim.lsp.omnifunc
autocmd Filetype c setlocal omnifunc=v:lua.vim.lsp.omnifunc

endif

"do not behave like vi
set nocompatible

"enable file plugins
filetype on
filetype plugin indent on

"enable syntax
syntax on

"set pretty linenumbers
set number

"auto reload a file when it is modified
set autoread

"set scroll offset
set scrolloff=5
autocmd BufWinEnter * if &buftype == 'quickfix' | setlocal so=0 | endif

"enable wildmenu
set wildmenu
set wildmode=longest,full

set ruler

set cmdheight=1

"make backspace behavior normal
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

"ignore case in searches, expect when using capital letters
set ignorecase
set smartcase

"make search highlightning nice
set hlsearch
set incsearch

set showmatch

set showcmd
set showmode

"enable mouse
set mouse=a
"make mouse work within tmux
if !has('nvim')
  set ttymouse=xterm2
endif

"send more keys for smother scrolling
set ttyfast

colorscheme gruvbox

"disable backup stuff
set nobackup
set nowritebackup
set noswapfile

"configure tabs
set expandtab
set smarttab

set shiftwidth=2
set tabstop=2

"auto smart indent
set autoindent
set smartindent
set wrap

"always show status line
set laststatus=2

set cursorline
hi CursorLine term=bold cterm=bold

" Easier split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"use jj to return to normal mode
imap jj <Esc>

"use ; to enter command mode
nnoremap ; :
vnoremap ; :

"delete a buffer but don't close the split
nmap <leader>q :bp<bar>sp<bar>bn<bar>bd<CR>

" search for word under the cursor but do not jump
nmap <leader>h *N

" close quick fix and preview
nmap <leader>cc :cclose<bar>pc<CR>

nmap ]q :cn<CR>
nmap [q :cp<CR>
nmap ]Q :clast<CR>
nmap [Q :cfirst<CR>

" |                                |
" v plugin specific settings below v

" cscope
"==================================================
" To supress warnings
let GtagsCscope_Quiet = 1
" To use the default key/mouse mapping:
let GtagsCscope_Auto_Map = 1
" To ignore letter case when searching:
let GtagsCscope_Ignore_Case = 1
" To use absolute path name:
let GtagsCscope_Absolute_Path = 1
" To deterring interruption:
let GtagsCscope_Keep_Alive = 1
" If you hope auto loading:
let GtagsCscope_Auto_Load = 1
" To use 'vim -t ', ':tag' and '<C-]>'
set cscopetag

" cpp syntax
"==================================================
" Highlighting of class scope is disabled by default. To enable set
let g:cpp_class_scope_highlight = 1

" Highlighting of member variables is disabled by default. To enable set
let g:cpp_member_variable_highlight = 1

" Highlighting of class names in declarations is disabled by default. To enable set
let g:cpp_class_decl_highlight = 1

" There are two ways to highlight template functions. Either
" let g:cpp_experimental_simple_template_highlight = 1
" which works in most cases, but can be a little slow on large files. Alternatively set
let g:cpp_experimental_template_highlight = 1
" which is a faster implementation but has some corner cases where it doesn't work.

" Highlighting of library concepts is enabled by
let g:cpp_concepts_highlight = 1

" Highlighting of user defined functions can be disabled by
" let g:cpp_no_function_highlight = 1

" Disable function highlighting (affects both C and C++ files)
" let g:cpp_no_function_highlight = 1

" Put all standard C and C++ keywords under Vim's highlight group `Statement`
" (affects both C and C++ files)
" let g:cpp_simple_highlight = 1

" Enable highlighting of named requirements (C++20 library concepts)
let g:cpp_named_requirements_highlight = 1

" FZF
"==================================================
set rtp+=~/.fzf
nmap <leader>f :Files<CR>
nmap <leader>F :GFiles<CR>
nmap <leader>m :GFiles?<CR>

function! Gmbdiff()
  call fzf#run(fzf#wrap({'source': 'git diff --name-only $(git merge-base HEAD $GMB)', 'options': ['--ansi', '--multi', '--prompt', 'GMB> ', '--preview', 'sh -c "(git diff $GMB --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500"']}))
endfunction
nmap <leader>M :call Gmbdiff()<CR>

nmap <leader>b :Buffers<CR>
nmap <leader>c :Commits<CR>
nmap <leader>C :BCommits<CR>
nmap <leader>l :Lines<CR>
nmap <leader>L :BLines<CR>
nmap <leader>h :History<CR>
nmap <leader>H :History:<CR>

" NERDTree
"==================================================
nmap <leader>n :NERDTreeFind<CR>
nmap <leader>N :NERDTreeToggle<CR><C-W>p

" Ack/ag
"==================================================
let g:ackprg = 'ag --nogroup --nocolor --column'
nmap <leader>a :Ack! --ignore-dir=.ccls-cache -w -U -G'\.(cpp<bar>h<bar>cmake)$' <C-R>=expand("<cword>")<CR><CR>
nmap <leader>A :Ack! --ignore-dir=.ccls-cache -S -U -G'\.(cpp<bar>h<bar>cmake)$' ''<left>
