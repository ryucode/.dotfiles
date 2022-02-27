
" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif


"call plug#begin('~/.config/nvim/plugged')
call plug#begin(stdpath('config').'/autoload/plugged')
    " Better Syntax Support
    Plug 'sheerun/vim-polyglot'
    " File Explorer
    Plug 'scrooloose/NERDTree'
    " Auto pairs for '(' '[' '{'
    Plug 'jiangmiao/auto-pairs'
    " lightline
    Plug 'itchyny/lightline.vim'
    " colorScheme
    Plug 'morhetz/gruvbox'
    "tabline

    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-lua/plenary.nvim'

    Plug 'nvim-telescope/telescope.nvim'
    Plug 'romgrk/barbar.nvim'
    Plug 'ryanoasis/vim-devicons'
    Plug 'neovim/nvim-lspconfig'

   " Comments
    Plug 'numToStr/comment.nvim'
    Plug 'JoosepAlviste/nvim-ts-context-commentstring'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

    Plug 'mhinz/vim-startify'

    Plug 'Valloric/YouCompleteMe'

   "EMMET
   Plug 'mattn/emmet-vim'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Terminal                                                                      "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
   Plug 'akinsho/toggleterm.nvim'

   Plug 'sbdchd/neoformat'
   Plug 'turbio/bracey.vim', {'do': 'npm install --prefix server'}



call plug#end()
set laststatus=2
colorscheme gruvbox


"setting for format on save
"
"
"
augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END
