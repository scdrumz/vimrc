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
set background=dark
set termguicolors
" }}}
" Misc {{{
set backspace=indent,eol,start
set autoread
set exrc
set scrolloff=10
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
set colorcolumn=80,100,120
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
set foldlevelstart=10
" }}}
" Line Shortcuts {{{
nnoremap <space> za
nnoremap <C-S-Up> ddkP
nnoremap <C-S-Down> ddp
nnoremap <C-a> ggVG
nnoremap <C-S-c> "+y
vnoremap <C-S-c> "+y
nnoremap <C-tab> :bNext<CR>
" }}}
" Leader Shortcuts {{{
let mapleader=","
nnoremap <leader>m :silent make\|redraw!\|cw<CR>
nnoremap <leader>h :A<CR>
nnoremap <leader><space> :nohlsearch<CR>
nnoremap <leader>s :mksession<CR>
nnoremap <leader>a :Ags<space>
nnoremap <leader>c :SyntasticCheck<CR>:Errors<CR>
nnoremap <leader>o :NERDTreeToggle<CR>
nnoremap <leader>u :GundoToggle<CR>
nnoremap <leader>v "+gP
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
" NERDTree {{{
autocmd StdinReadPre * let s:std_in = 1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" }}}
" YouCompleteMe {{{
let g:ycm_autoclose_preview_window_after_completion=1
" }}}
" AsyncRun {{{
let g:asyncrun_open = 8
" }}}
" Autogroups {{{
augroup configgroup
    autocmd!
    autocmd VimEnter * highlight clear SignColumn
    autocmd BufWritePre *.py,*.txt,*.md,*.cc,*.hh :call <SID>StripTrailingWhitespaces()

    autocmd BufEnter *.md setlocal ft=markdown
    autocmd BufNewFile,BufReadPost *.feature,*.story setlocal ft=cucumber
    
    " Format-specific file settings
    autocmd FileType cpp setlocal foldmethod=syntax
    autocmd FileType python setlocal commentstring=#\ %s
    autocmd FileType python setlocal autoindent
    autocmd FileType python setlocal fileformat=unix
    autocmd FileType python setlocal encoding=utf8
    autocmd FileType python setlocal textwidth=119
    autocmd FileType python nnoremap <buffer> <F9> :exec '!python' shellescape(@%, 1)<CR>
    
    " Auto-reload files changed on disk
    autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
    autocmd FileChangedShellPost * echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
augroup END
" }}}
" Backup {{{
set backup
set backupdir=~/vimfiles/tmp,~/.vim-tmp,~./.tmp,~/tmp,/var/tmp,/tmp,C:\\Users\\joe\\vimfiles\\tmp
set backupskip=~/vimfiles/tmp,~/tmp/*,/private/tmp/*,C:\\Users\\joe\\vimfiles\tmp
set directory=~/vimfiles/tmp,~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp,C:\\Users\\joe\\vimfiles\\tmp
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
Plugin 'sjl/gundo.vim'
Plugin 'powerline/powerline', {'rtp': 'powerline/bindings/vim'}
Plugin 'airblade/vim-gitgutter'
Plugin 'qpkorr/vim-bufkill'
Plugin 'skywind3000/asyncrun.vim'
Plugin 'tpope/vim-surround'

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
" Custom Cleanup {{{
set secure
" }}}
" vim:foldmethod=marker:foldlevel=0
