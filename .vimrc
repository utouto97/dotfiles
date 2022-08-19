" プラグイン関連
source ~/.vim/autoload/plug.vim
call plug#begin('~/.vim/plugged')
  " ファイル操作
  "Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  "Plug 'junegunn/fzf.vim'

  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }

"  Plug 'lambdalisue/fern.vim'

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
set ambiwidth=single

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

function! DeleteBufferExceptTerm() abort
  let l:buffers = nvim_list_bufs()
  let l:term_buf = bufnr("terminal.buffer")
  for b in buffers
    if nvim_buf_is_loaded(b) && b != l:term_buf
      execute ("bd! ".b)
    endif
  endfor
endfunction
command! BD call DeleteBufferExceptTerm()

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'source': 'fd -t f -H -E .git'}), <bang>0)

let g:memo_dir = "~/.memo/"
function! MemoOpen(name) abort
  execute ("edit ".g:memo_dir.a:name.".md")
endfunction
command! -nargs=1 Memo call MemoOpen(<f-args>)

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

"nnoremap <silent><Leader>l :Buffers<CR>
"nnoremap <silent><Leader>e :Files<CR>
nnoremap <silent><Leader>l :Telescope buffers<CR>
nnoremap <silent><Leader>e :Telescope find_files hidden=true<CR>

nnoremap <silent><Leader>d :LspDefinition<CR>
nnoremap <silent><Leader>h :LspHover<CR>
nnoremap <silent><Leader>r :LspReferences<CR>
nnoremap <silent><Leader>i :LspImplementation<CR>

nnoremap <silent>F <Plug>(easymotion-bd-f2)
vnoremap <silent>F <Plug>(easymotion-bd-f2)

nnoremap <silent><Leader>gd :GitGutterLineHighlightsToggle<CR>

nnoremap <silent><Leader>m :MemoEdit<CR>

inoremap <silent>jj <esc>

" tnoremap <silent><Esc> <C-\><C-n>
tnoremap <silent><C-j> <C-\><C-n>
"tnoremap <silent><C-w>k <C-\><C-n><C-w>k
"tnoremap <silent><C-w>j <C-\><C-n><C-w>j
"tnoremap <silent><C-w>l <C-\><C-n><C-w>l
"tnoremap <silent><C-w>h <C-\><C-n><C-w>h

" 各種プラグインの設定
"
" previm ブラウザの設定
let g:previm_open_cmd = 'open -a Google\ Chrome'
" easymotion ignorecase
let g:EasyMotion_smartcase = 1
" lsp
let g:lsp_signs_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1

lua << EOF
require('telescope').setup{
  defaults = {
   file_ignore_patterns = {
     "node_modules", ".git"
   },
  }
}

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
colors = function(opts)
  vim.api.nvim_exec("LspDocumentDiagnostics", false)
  vim.api.nvim_exec("let g:LspDocumentDiagnosticsResult = getline(0, line('$'))", false)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "colors",
    finder = finders.new_table {
      results = vim.g["LspDocumentDiagnosticsResult"]
    },
    sorter = conf.generic_sorter(opts),
  }):find()
end

EOF
