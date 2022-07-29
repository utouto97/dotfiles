set relativenumber
set autoindent
set tabstop=2
set shiftwidth=2
set expandtab
set hls
set clipboard+=unnamedplus
set encoding=utf-8
set ambiwidth=double

nnoremap j gj
nnoremap k gk

if exists('g:vscode')
else
  inoremap <silent>jj <esc>
endif
