
" プラグイン関連
source ~/.vim/autoload/plug.vim
call plug#begin('~/.vim/plugged')
  " fzf
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'

  " lsp
  Plug 'prabirshrestha/vim-lsp'
  Plug 'mattn/vim-lsp-settings'

  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'

  " git
  Plug 'airblade/vim-gitgutter'
  Plug 'tpope/vim-fugitive'

  " 操作系
  Plug 'easymotion/vim-easymotion'

  " 見た目系
  "Plug 'tomasr/molokai'
  Plug 'sickill/vim-monokai'

  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

  " markdown preview
  Plug 'previm/previm'

call plug#end()

" vscode neovim 用
if exists('g:vscode')
else
  inoremap <silent>jj <esc>
  set ambiwidth=double
endif

" 基本設定
colorscheme monokai

set encoding=utf-8
set relativenumber
set autoindent
set tabstop=2
set shiftwidth=2
set expandtab
set hls
set clipboard+=unnamedplus
set updatetime=250

set ignorecase

" キーバイディング
let mapleader = "\<Space>"

nnoremap j gj
nnoremap k gk

nnoremap <silent><leader><leader> :noh<CR>
nnoremap <silent><leader>l :Buffers<CR>
nnoremap <silent><leader>f :Files<CR>
nnoremap <silent><Leader>d :LspDefinition<CR>
nnoremap <silent><Leader>p :LspHover<CR>
nnoremap <silent><Leader>r :LspReferences<CR>
nnoremap <silent><Leader>ik :LspImplementation<CR>
nnoremap <silent>F <Plug>(easymotion-bd-f2)

nnoremap [fugitive] <Nop>
nmap <Leader>g [fugitive]
nnoremap <silent>[fugitive]s :Gstatus<CR><C-w>T
nnoremap <silent>[fugitive]a :Gwrite<CR>
nnoremap <silent>[fugitive]c :Gcommit-v<CR>
nnoremap <silent>[fugitive]b :Gblame<CR>
nnoremap <silent>[fugitive]d :Gdiff<CR>
nnoremap <silent>[fugitive]m :Gmerge<CR>

tnoremap <silent>jj <C-\><C-n>

" previm ブラウザの設定
let g:previm_open_cmd = 'open -a Google\ Chrome'
" easymotion ignorecase
let g:EasyMotion_smartcase = 1
