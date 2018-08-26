" Joe Weidenbach
" Windows support {{{
let win_shell = (has('win32') || has('win64')) && &shellcmdflag =~ '/'
let vimDir = win_shell ? '$HOME/vimfiles' : '$HOME/.vim'
if win_shell
    set encoding=utf-8
    set rtp+=~/vimfiles/bundle/Vundle.vim/
    let confpath='~/vimfiles/'
else
    set rtp+=~/.vim/bundle/Vundle.vim
    let confpath='~/.vim/'
endif
" }}}
" Colors {{{
syntax enable
colorscheme monokai
set termguicolors
" }}}
" Misc {{{
set backspace=indent,eol,start
" }}}
" Spaces & Tabs {{{
set tabstop=4
set expandtab
set softtabstop=4
set shiftwidth=4
set modelines=1
filetype indent on
filetype plugin on
set autoindent
" }}}
" UI Layout {{{
set relativenumber
set number
set showcmd
set nocursorline
set wildmenu
set lazyredraw
set showmatch
" set fillchars+=vert:|
" }}}
" Searching {{{
set ignorecase
set incsearch
set hlsearch
" }}}
" Folding {{{
"=== folding ===
set foldmethod=indent
set foldnestmax=10
set foldenable
nnoremap <space> za
set foldlevelstart=10
" }}}
" Line Shortcuts {{{

" }}}
" Leader Shortcuts {{{
let mapleader=","
nnoremap <leader>m :silent make\|redraw!\|cw<CR>
nnoremap <leader>h :A<CR>
nnoremap <leader<space> :noh<CR>
nnoremap <leader>s :mksession<CR>
nnoremap <leader>a :Ags
nnoremap <leader>c :SyntasticCheck<CR>:Errors<CR>
nnoremap <leader>o :NERDTreeToggle<CR>
if win_shell
    nnoremap <leader>ev :vsp ~/vimfiles/.vimrc<CR>
    nnoremap <leader>sv :source ~/vimfiles/.vimrc<CR>
else
    nnoremap <leader>ev :vsp ~/.vim/.vimrc<CR>
    nnoremap <leader>ez :vsp ~/.zshrc<CR>
    nnoremap <leader>sv :source ~/.vim/.vimrc<CR>
endif
vnoremap <leader>y "+y
" }}}
" CtrlP {{{
let g:ctrlp_match_window  = 'bottom,order,ttb'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
let g:ctrlp_custom_ignore = '\vbuild/|dist/|venv/|target/|\.(o|swap|pyc|egg)$'
" }}}
" Syntastic {{{
let g:syntastic_python_flake8_args = '--ignore=E501'
let g:syntastic_python_python_exec = 'python'
" }}}
" Autogroups {{{
augroup configgroup
    autocmd!
    autocmd VimEnter * highlight clear SignColumn
    autocmd BufWritePre *.py,*.txt,*.md,*.cc,*.hh :call <SID>StripTrailingWhitespaces()
    autocmd FileType python nnoremap <buffer> <F9> :exec '!python' shellescape(@%, 1)<CR>
    autocmd BufNewFile,BufReadPost *.feature,*.story setlocal ft=cucumber
    autocmd BufEnter *.md setlocal ft=markdown
augroup END
" }}}
" Backup {{{
set backup
set backupdir=~/vimfiles/tmp,~/.vim-tmp,~./.tmp,~/tmp,/var/tmp,/tmp
set backupskip=~/vimfiles/tmp,~/tmp/*,/private/tmp/*
set directory=~/vimfiles/tmp,~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set writebackup
" }}}
" Vim Plugins {{{
set nocompatible
filetype off

let vundlepath=confpath.'bundle'
set rtp+=vundlepath/Vundle.vim
call vundle#begin(vundlepath)

Plugin 'VundleVim/Vundle.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-fugitive'
Plugin 'valloric/YouCompleteMe'
Plugin 'gabesoft/vim-ags'

call vundle#end()

filetype plugin indent on
" }}}
" Custom Functions {{{
function! <SID>StripTrailingWhitespaces()
    " save last search and cursor position
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s+$//e
    let @/=_s
    call cursor(l, c)
endfunc
function! <SID>CleanFile()
    " save last search and cursor position
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business
    %!git stripspace
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunc
" }}}

" vim:foldmethod=marker:foldlevel=0
