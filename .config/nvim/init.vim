:set number
:set autoindent
:set tabstop=4
:set shiftwidth=4
:set smarttab
:set softtabstop=4
:set mouse=a

call plug#begin()

let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0
Plug 'http://github.com/tpope/vim-surround' " Surrounding ysw)
Plug 'https://github.com/preservim/nerdtree' " NerdTree
Plug 'https://github.com/tpope/vim-commentary' " For Commenting gcc & gc
Plug 'https://github.com/vim-airline/vim-airline' " Status bar
Plug 'https://github.com/neoclide/coc.nvim'  " Auto Completion
Plug 'https://github.com/ap/vim-css-color' " CSS Color Preview
Plug 'https://github.com/rafi/awesome-vim-colorschemes' " Retro Scheme
Plug 'https://github.com/ryanoasis/vim-devicons' " Developer Icons
Plug 'https://github.com/tc50cal/vim-terminal' " Vim Terminal
Plug 'https://github.com/preservim/tagbar' " Tagbar for code navigation
Plug 'yaegassy/coc-intelephense', {'do': 'npm install --frozen-lockfile'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'https://github.com/terryma/vim-multiple-cursors' " CTRL + N for multiple cursors


nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-b> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

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
" Auto refresh NERDTree
autocmd BufEnter NERD_tree_* | execute 'normal R'

inoremap <expr> <Tab> pumvisible() ? coc#_select_confirm() : "<Tab>"
nnoremap <C-p> :Files<CR>
nnoremap <C-g> :Rg<CR>

let g:NERDTreeDirArrowExpandable="+"
let g:NERDTreeDirArrowCollapsible="-"

nmap <F8> :TagbarToggle<CR>

:set completeopt-=preview " For No Previews


call plug#end()
