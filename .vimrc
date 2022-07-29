set relativenumber
set autoindent
set tabstop=2
set shiftwidth=2
set expandtab
set hls
set clipboard+=unnamedplus
set encoding=utf-8

nnoremap j gj
nnoremap k gk

if exists('g:vscode')
else
  inoremap <silent>jj <esc>
  set ambiwidth=double
endif
