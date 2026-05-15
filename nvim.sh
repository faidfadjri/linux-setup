#!/bin/bash

set -e

echo "======================================"
echo "       Neovim Auto Setup Script       "
echo "======================================"

# ── 1. Dependencies ──────────────────────────────────────────
echo ""
echo "[1/7] Installing system dependencies..."
sudo apt update -qq
sudo apt install -y curl git wget unzip tar fzf ripgrep python3 python3-pip php php-cli nodejs npm

# ── 2. Install Neovim ────────────────────────────────────────
echo ""
echo "[2/7] Installing Neovim..."
NVIM_VERSION="v0.10.0"
NVIM_TAR="nvim-linux-x86_64.tar.gz"
NVIM_URL="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/${NVIM_TAR}"
NVIM_DIR="/opt/nvim-linux-x86_64"

if [ -f "$NVIM_DIR/bin/nvim" ]; then
    echo "Neovim already installed at $NVIM_DIR, skipping..."
else
    wget -q "$NVIM_URL" -O /tmp/$NVIM_TAR
    sudo tar -C /opt -xzf /tmp/$NVIM_TAR
    rm /tmp/$NVIM_TAR
    echo "Neovim installed to $NVIM_DIR"
fi

# Add nvim to PATH if not already
if ! echo "$PATH" | grep -q "$NVIM_DIR/bin"; then
    echo "export PATH=\"$NVIM_DIR/bin:\$PATH\"" >> ~/.bashrc
    export PATH="$NVIM_DIR/bin:$PATH"
    echo "Added nvim to PATH in ~/.bashrc"
fi

# ── 3. Set nvim as default vim ───────────────────────────────
echo ""
echo "[3/7] Setting nvim as default vim..."
if command -v nvim &>/dev/null; then
    NVIM_PATH=$(which nvim)
    sudo update-alternatives --install /usr/bin/vim vim "$NVIM_PATH" 60 2>/dev/null || true
    sudo update-alternatives --set vim "$NVIM_PATH" 2>/dev/null || true
    echo "Default vim set to: $NVIM_PATH"
else
    echo "nvim not found in PATH, skipping update-alternatives..."
fi

# ── 4. Install vim-plug ──────────────────────────────────────
echo ""
echo "[4/7] Installing vim-plug..."
PLUG_PATH="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"
if [ -f "$PLUG_PATH" ]; then
    echo "vim-plug already installed, skipping..."
else
    curl -fLo "$PLUG_PATH" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo "vim-plug installed"
fi

# ── 5. Write init.vim ────────────────────────────────────────
echo ""
echo "[5/7] Writing init.vim config..."
mkdir -p ~/.config/nvim
cat > ~/.config/nvim/init.vim << 'EOF'
:set number
:set autoindent
:set tabstop=4
:set shiftwidth=4
:set smarttab
:set softtabstop=4
:set mouse=a

call plug#begin()
Plug 'http://github.com/tpope/vim-surround'
Plug 'https://github.com/preservim/nerdtree'
Plug 'https://github.com/tpope/vim-commentary'
Plug 'https://github.com/vim-airline/vim-airline'
Plug 'https://github.com/neoclide/coc.nvim'
Plug 'https://github.com/ap/vim-css-color'
Plug 'https://github.com/rafi/awesome-vim-colorschemes'
Plug 'https://github.com/ryanoasis/vim-devicons'
Plug 'https://github.com/preservim/tagbar'
Plug 'yaegassy/coc-intelephense', {'do': 'npm install --frozen-lockfile'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'https://github.com/terryma/vim-multiple-cursors'

" NERDTree keymaps
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-b> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" Terminal toggle
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

" coc.nvim tab completion
inoremap <expr> <Tab> pumvisible() ? coc#_select_confirm() : "<Tab>"

" FZF keymaps
nnoremap <C-p> :Files<CR>
nnoremap <C-g> :Rg<CR>

" NERDTree icons
let g:NERDTreeDirArrowExpandable="+"
let g:NERDTreeDirArrowCollapsible="-"

nmap <F8> :TagbarToggle<CR>
:set completeopt-=preview

call plug#end()
EOF
echo "init.vim written"

# ── 6. Install vim-plug plugins ──────────────────────────────
echo ""
echo "[6/7] Installing Neovim plugins via vim-plug..."
nvim --headless +PlugInstall +qall 2>/dev/null || true
echo "Plugins installed"

# ── 7. Build coc.nvim ────────────────────────────────────────
echo ""
echo "[7/7] Building coc.nvim..."
COC_PATH="$HOME/.local/share/nvim/plugged/coc.nvim"
if [ -d "$COC_PATH" ]; then
    cd "$COC_PATH" && npm ci --silent
    echo "coc.nvim built successfully"
else
    echo "coc.nvim directory not found, skipping build..."
fi

# ── Done ─────────────────────────────────────────────────────
echo ""
echo "======================================"
echo "         Setup Complete!              "
echo "======================================"
echo ""
echo "Restart terminal atau run this command:"
echo "  source ~/.bashrc"
echo ""
echo "Then open nvim and run this:"
echo "  :CocInstall coc-tsserver coc-json coc-html coc-css coc-go coc-phpls"
echo ""