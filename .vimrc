" プラグイン関連
source ~/.vim/autoload/plug.vim
call plug#begin('~/.vim/plugged')
  " ファイル操作
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'

  Plug 'lambdalisue/fern.vim'

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
  " Plug 'sickill/vim-monokai'
  Plug 'joshdick/onedark.vim'

  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

  Plug 'Yggdroot/indentLine'

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
colorscheme onedark

set encoding=utf-8
set relativenumber
set autoindent
set smartindent
set tabstop=2
set shiftwidth=2
set expandtab
set hls
set clipboard+=unnamedplus
set updatetime=250
set ignorecase

augroup T
  autocmd!
"  autocmd BufEnter * if &buftype == 'terminal' | :startinsert | endif
  autocmd TermOpen * setlocal nonumber
  autocmd TermOpen * setlocal norelativenumber
augroup END

function! OpenTerm() abort
  let l:curr_buf = bufnr()
  let l:term_buf = bufnr("terminal.buffer")
  if l:term_buf == -1
    execute ("terminal")
    execute ("f terminal.buffer")
  else
    execute ("buffer ".l:term_buf)
  endif
endfunction
command! OpenTerm call OpenTerm()

" 起動時
if has("vim_starting")
  call OpenTerm()
  buffer 1
endif

" キーバイディング
let mapleader = "\<Space>"


nnoremap ZZ <Nop>
nnoremap ZQ <Nop>

nnoremap <silent><C-t> :OpenTerm<CR>
nnoremap <silent><C-j> :bp<CR>
nnoremap <silent><C-k> :bn<CR>

nnoremap j gj
nnoremap k gk


nnoremap <silent><Leader>l :Buffers<CR>
nnoremap <silent><Leader>e :Files<CR>

nnoremap <silent><Leader>d :LspDefinition<CR>
nnoremap <silent><Leader>h :LspHover<CR>
nnoremap <silent><Leader>r :LspReferences<CR>
nnoremap <silent><Leader>i :LspImplementation<CR>
nnoremap <silent>F <Plug>(easymotion-bd-f2)

nnoremap <silent>,gd :GitGutterLineHighlightsToggle<CR>

" tnoremap <silent><Esc> <C-\><C-n>
tnoremap <silent><C-j> <C-\><C-n>
"tnoremap <silent><C-w>k <C-\><C-n><C-w>k
"tnoremap <silent><C-w>j <C-\><C-n><C-w>j
"tnoremap <silent><C-w>l <C-\><C-n><C-w>l
"tnoremap <silent><C-w>h <C-\><C-n><C-w>h

" previm ブラウザの設定
let g:previm_open_cmd = 'open -a Google\ Chrome'
" easymotion ignorecase
let g:EasyMotion_smartcase = 1

let g:lsp_signs_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'source': 'fd -t f -H -E .git'}), <bang>0)
