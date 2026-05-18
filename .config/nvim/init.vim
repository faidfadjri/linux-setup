:set number
:set autoindent
:set tabstop=4
:set shiftwidth=4
:set smarttab
:set softtabstop=4
:set mouse=a
:set completeopt-=preview

" ============================================================================
" CONFIGURASI SEARCH & MATCH (BARU - Ditambahkan dari Artikel Byteable)
" ============================================================================
set showmatch      " Sorot pasangan tanda kurung {} () [] yang cocok
set matchtime=5    " Kecepatan kedipan penyorot tanda kurung
set hlsearch       " Highlight semua kata yang cocok saat pencarian
set ignorecase     " Abaikan huruf besar/kecil saat mencari kata
set smartcase      " Otomatis jadi sensitif huruf jika mencari dengan huruf kapital
set incsearch      " Mulai mencari secara bertahap saat kata baru diketik

" Disable unused providers
let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0

" =========================
" PLUGINS
" =========================
call plug#begin()

" Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Core
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" UI / Navigation
Plug 'preservim/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'ryanoasis/vim-devicons'
Plug 'preservim/tagbar'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Editing
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'terryma/vim-multiple-cursors'

" Styling / Syntax
Plug 'ap/vim-css-color'
Plug 'rafi/awesome-vim-colorschemes'

" Terminal
Plug 'tc50cal/vim-terminal'

" PHP
Plug 'yaegassy/coc-intelephense', {'do': 'npm install --frozen-lockfile'}

call plug#end()

" =========================
" COLORS
" =========================
syntax on

" =========================
" NERDTREE
" =========================
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-b> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

let g:NERDTreeDirArrowExpandable="+"
let g:NERDTreeDirArrowCollapsible="-"

autocmd BufEnter NERD_tree_* | execute 'normal R'

" =========================
" FZF
" =========================
nnoremap <C-p> :Files<CR>
nnoremap <C-g> :Rg<CR>

" =========================
" TAGBAR
" =========================
nmap <F8> :TagbarToggle<CR>

" =========================
" TERMINAL TOGGLE
" =========================
let g:term_buf = 0
let g:term_win = 0

function! TermToggle(height)
    if win_gotoid(g:term_win)
        hide
    else
        botright new
        exec "resize " . a:height
        try
            exec "buffer " . g:term_buf
        catch
            call termopen($SHELL)
            let g:term_buf = bufnr("")
            setlocal nobuflisted
        endtry
        let g:term_win = win_getid()
        startinsert
    endif
endfunction

nnoremap <C-t> :call TermToggle(12)<CR>
inoremap <C-t> <Esc>:call TermToggle(12)<CR>
tnoremap <C-t> <C-\><C-n>:call TermToggle(12)<CR>

" =========================
" ULTISNIPS CONFIG
" =========================
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" =========================
" TAB & ENTER KEYMAPPINGS (PRIORITY FIX)
" =========================
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ UltiSnips#CanExpandSnippet() ? "\<C-R>=UltiSnips#ExpandSnippet()<CR>" :
      \ pumvisible() ? "\<C-n>" :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()

inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() : "\<CR>"

" =========================
" FILETYPE TSX & SYNTAX SYNC (UPDATED)
" =========================
autocmd BufNewFile,BufRead *.tsx set filetype=typescriptreact

" Sinkronisasi render warna text agar performa editor stabil dan tidak lag di file React yang panjang
autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

" ============================================================================
" INTELLIGENT COC EXTENSIONS (BARU - Ditambahkan dari Artikel Byteable)
" ============================================================================
set updatetime=300
set shortmess+=c

" Daftarkan otomatis tsserver untuk Javascript/Typescript React
let g:coc_global_extensions = ['coc-tsserver']

" Cek otomatis apakah project Next.js/React kamu menggunakan Prettier
if isdirectory('./node_modules') && isdirectory('./node_modules/prettier')
  let g:coc_global_extensions += ['coc-prettier']
endif

" Cek otomatis apakah project Next.js/React kamu menggunakan Eslint
if isdirectory('./node_modules') && isdirectory('./node_modules/eslint')
  let g:coc_global_extensions += ['coc-eslint']
endif
