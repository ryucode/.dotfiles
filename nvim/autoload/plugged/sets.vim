filetype plugin on
set mouse+=a
set autoindent
set guicursor=
set nohlsearch
set hidden
set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nu
set nowrap
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set termguicolors
set scrolloff=8
" set noshowmode
set signcolumn=yes
set isfname+=@-@
" set ls=0
set guifont=Fira\ Code:h12

" Give more space for displaying messages.
set cmdheight=1

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=50

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

set colorcolumn=80


let mapeader = " "



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BarBar config
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let bufferline = get(g:, 'bufferline', {})
let bufferline.animation = v:false
let bufferline.icons = v:false
let bufferline.closable = v:true
let bufferline.clickable = v:true
let bufferline.icon_close_tab = 'x'
let bufferline.icon_close_tab_modified = ''


augroup coder_2
    autocmd!
    autocmd BufWritePre lua,cpp,c,h,hpp,cxx,cc Neoformat
    autocmd BufWritePre * %s/\s\+$//e
    autocmd BufEnter,BufWinEnter,TabEnter *.rs :lua require'lsp_extensions'.inlay_hints{}

augroup END



""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   Bracey Settings
" """"""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:bracey_server_port=8080
let g:bracey_auto_start_browser=0
let g:bracey_server_allow_remote_connections=1






""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  Terminal
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set splitbelow


