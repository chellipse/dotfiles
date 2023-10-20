" LE PLUGINS
call plug#begin('~/.vim/plugged')
" Themes
Plug 'sainnhe/everforest'
Plug 'NLKNguyen/papercolor-theme'
Plug 'morhetz/gruvbox'
" Nav
Plug 'preservim/nerdtree'
" Syntax/Processing
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Info
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.4' }
" Git
Plug 'tpope/vim-fugitive'
" Editing
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
call plug#end()

""" COC stuff
" tries to remap the Next/Prev autocomplete binds, but these didn't work well
" inoremap <silent> <C-M-j> <C-n>
" inoremap <silent> <C-M-k> <C-p>
" let mapleader = " "
" inoremap <leader>j <C-n>
" inoremap <leader>k <C-p>

""" COLORS
let g:color_mode = 1
set termguicolors

if g:color_mode == 0
    let g:gruvbox_italic=1
    let g:gruvbox_bold=1
    let g:gruvbox_underline=1
    let g:gruvbox_undercurl=1
    let g:gruvbox_transparent_bg=1
    let g:gruvbox_contrast_dark='soft'
    colorscheme gruvbox
endif

if g:color_mode == 1
    set background=dark
    let g:everforest_background = 'soft'
    let g:everforest_enable_italic=1
    let g:everforest_transparent_background=0
    colorscheme everforest
    " sets the term env, was needed for theme to work in Vim w/ Alacritty
    "set term=xterm-256color
endif

if g:color_mode == 2
    colorscheme PaperColor
    hi vertsplit guifg=bg guibg=bg
    hi statusline guifg=#33393B
endif

if g:color_mode == 3
    set background=dark
    let g:everforest_enable_italic=1
    colorscheme everforest
endif

" what is your team's current indentation scheme?
set autoindent
set expandtab
set tabstop=4
set shiftwidth=4

" softwrap on word boundaries at 80 chars (ignoring gutter)
set wrap
set linebreak
" set textwidth=80

" see tabs, spaces, and trailing spaces easier
set list
" set lcs, each character can be specified in hex
set lcs=leadmultispace:\\x3e\\x20\\x20\\x20\\x20\\x20\\x20\\x20,trail:-

" default 4000, in milliseconds
" time between keystrokes for disc write
set updatetime=300

" yank uses system clipboard
set clipboard=unnamedplus

" turns off the mouse
set mouse=

filetype off

set number

" syntax highlighting
syntax on

" set minimum lines displayed above/below cursor
set scrolloff=5

" softwrap won't cut words
set linebreak

" highlight the line the cursor is one
set cursorline
"set cursorcolumn

" auto reload files when they're changed outside of vim
" " (I think) unless they're deleted
set autoread

" open new splits to the right or below like a non sicko
set splitbelow
set splitright

" ignore case when searching
set ignorecase

" ... unless there's a capital letter in the query
set smartcase

" use visual bells instead of audio (doesn't seem to work)
set noerrorbells
" (does seem to work...)
set belloff=all

" set code folding to use syntax (e.g. braces)
set foldmethod=indent

" don't fold the whole file on open
set foldlevel=99

" start search before enter
set incsearch
" highlight results
set hlsearch
" after doing a search, hit enter to silently clear highlighting until the
" next search. this doesn't remove the search term from vim's state, so you
" can still do "cgn" etc.
nnoremap <silent> <CR> :noh<CR>
" removed a bit from the end here, unsure what it served
"<CR>

" STATUSLINE
set laststatus=2
set statusline+=%#PmenuSel#
set statusline+=%#LineNr#
set statusline+=\ %f
set statusline+=%m\
set statusline+=%=
set statusline+=%#CursorColumn#
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\ 

