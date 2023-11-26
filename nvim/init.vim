" LE PLUGINS
call plug#begin('~/.vim/plugged')

" Themes
Plug 'sainnhe/everforest'
Plug 'NLKNguyen/papercolor-theme'
Plug 'morhetz/gruvbox'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
" Nav
Plug 'preservim/nerdtree'
Plug 'nvim-lua/plenary.nvim' " needed for Neorg
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.4' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Syntax/Processing
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'sheerun/vim-polyglot'
Plug 'rust-lang/rust.vim'
Plug 'neovim/nvim-lspconfig'
Plug 'simrat39/rust-tools.nvim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc-r-lsp'
Plug 'Alloyed/lua-lsp'
" Info
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
" Git
Plug 'tpope/vim-fugitive'
" Editing
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'windwp/nvim-autopairs'
" Other
Plug 'nvim-orgmode/orgmode'
Plug 'nvim-neorg/neorg', { 'do': ':Neorg sync-parsers'}


call plug#end()

lua require("nvim-autopairs").setup {}
lua require("lspconfig").rust_analyzer.setup({})

" set leader space
let mapleader = " "

""" COC stuff
" remap the Next/Prev autocomplete binds
inoremap <C-j> <C-n>
inoremap <C-k> <C-p>

nmap <silent> g[ <Plug>(coc-diagnostic-prev)
nmap <silent> g] <Plug>(coc-diagnostic-next)
map <leader>a <Plug>(coc-codeaction-selected)
map <leader>rn <Plug>(coc-rename)
map <leader>rf <Plug>(coc-refactor)
map <leader>gr <Plug>(coc-references)
map <leader>gi <Plug>(coc-implementation)
map <leader>gy <Plug>(coc-type-definition)
map <silent> gd <Plug>(coc-definition)
map <Leader>ca <Plug>(coc-codeaction-line)
map <Leader>ac <Plug>(coc-codeaction-cursor)
map <Leader>ao <Plug>(coc-codelens-action)

""" FZF
" files from current dir with preview
nnoremap <leader>ff :call fzf#vim#files('', fzf#vim#with_preview({'source': 'rg --files '}))<cr>
" files + hidden files
nnoremap <leader>fa :call fzf#vim#files('', fzf#vim#with_preview({'source': 'rg --files --hidden'}))<cr>
" commands
nnoremap <leader>fc :Commands<cr>

""" COLORS
let g:color_mode = 0
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

if g:color_mode == 4
    colorscheme catppuccin-macchiato
    let g:airline_theme = 'catppuccin'
endif

" what is your team's current indentation scheme?
set autoindent
set smartindent
set expandtab
set tabstop=4
set shiftround
set shiftwidth=4

" set code folding to use syntax (e.g. braces)
set foldmethod=indent

" don't fold the whole file on open
set foldlevel=1
set fdls=1

" softwrap on word boundaries at 80 chars (ignoring gutter)
set wrap
set linebreak
" set textwidth=80

" see tabs, spaces, and trailing spaces easier
set list
" set lcs, each character can be specified in hex
set lcs=leadmultispace:\\x3e\\x20\\x20\\x20\\x20\\x20\\x20\\x20,trail:-,tab:▸\ 

" default 4000, in milliseconds
" time between keystrokes for disc write
set updatetime=300

" yank uses system clipboard
set clipboard=unnamedplus

" turns off the mouse
set mouse=c

filetype off

set number rnu

" syntax highlighting
syntax on

" set minimum lines displayed above/below cursor
set scrolloff=6

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

nmap <S-u> :redo<CR>
" nmap u :undo<CR>

""" STATUSLINE
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

" autocmd stuff
" autocmd FileType norg setlocal foldmethod=expr
" autocmd FileType norg setlocal foldexpr=nvim_treesitter#foldexpr()
" autocmd FileType norg setlocal foldlevel=1

" autocmd BufRead,BufNewFile *.norg set tabstop=2 shiftwidth=2 foldmethod=syntax
" autocmd BufRead,BufNewFile *.norg :e
" autocmd BufWinEnter *.norg :e

lua << EOF

-- nvim-neorg setup
require('neorg').setup {
    load = {
        ["core.defaults"] = {}, -- Loads default behaviour
        ["core.concealer"] = {}, -- Adds pretty icons to your documents
        ["core.dirman"] = { -- Manages Neorg workspaces
            config = {
                workspaces = {
                    notes = "~/neorg-notes",
                },
            },
        },
    },
}

EOF
