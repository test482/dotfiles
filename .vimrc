set nocompatible  " 关闭vi兼容模式

" XDG_Base_Directory support
if empty($MYVIMRC) | let $MYVIMRC = expand('<sfile>:p') | endif

if empty($XDG_CACHE_HOME)  | let $XDG_CACHE_HOME  = $HOME."/.cache"       | endif
if empty($XDG_CONFIG_HOME) | let $XDG_CONFIG_HOME = $HOME."/.config"      | endif
if empty($XDG_DATA_HOME)   | let $XDG_DATA_HOME   = $HOME."/.local/share" | endif
if empty($XDG_STATE_HOME)  | let $XDG_STATE_HOME  = $HOME."/.local/state" | endif

set runtimepath^=$XDG_CONFIG_HOME/vim
set runtimepath+=$XDG_DATA_HOME/vim
set runtimepath+=$XDG_CONFIG_HOME/vim/after

set packpath^=$XDG_DATA_HOME/vim,$XDG_CONFIG_HOME/vim
set packpath+=$XDG_CONFIG_HOME/vim/after,$XDG_DATA_HOME/vim/after

let g:netrw_home = $XDG_DATA_HOME."/vim"
call mkdir($XDG_DATA_HOME."/vim/spell", 'p')

set backupdir=$XDG_STATE_HOME/vim/backup | call mkdir(&backupdir, 'p')
set directory=$XDG_STATE_HOME/vim/swap   | call mkdir(&directory, 'p')
set undodir=$XDG_STATE_HOME/vim/undo     | call mkdir(&undodir,   'p')
set viewdir=$XDG_STATE_HOME/vim/view     | call mkdir(&viewdir,   'p')

if !has('nvim') | set viminfofile=$XDG_STATE_HOME/vim/viminfo | endif

" powerline
" https://wiki.archlinux.org/index.php/Powerline#Vim
let g:powerline_pycmd="py3"
set rtp+=/usr/share/powerline/bindings/vim
:set laststatus=2

" jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

syntax on  " 语法高亮
set showmode " 在底部显示当前处于命令模式还是插入模式
set mouse=a  " 支持使用鼠标
set t_Co=256  " 启用256色
set encoding=utf-8

set autoindent " 按下回车键后，下一行的缩进会自动跟上一行的缩进保持一致
set smartindent " 智能缩进
set tabstop=4 " 按下 Tab 键时，Vim 显示的空格数
set shiftwidth=4 " 在文本上按下 >>、<< 或者 ==（取消全部缩进） 时，每一级的字符数
set expandtab " 由于Tab键在不同的编辑器缩进不一致，该设置自动将Tab转为空格
set softtabstop=4 " Tab转为多少个空格

set number " 显示行号
"set relativenumber " 显示光标所在行的行号，其他行都为相对于该行的相对行号
"高亮光标所在行的行号
set cursorline
set cursorlineopt=number

set wrap " 自动折行
set linebreak " 只有遇到指定的符号，才发生折行
set formatoptions+=m " 如遇Unicode值大于255的文本，不必等到空格再折行
set scrolloff=10 " 垂直滚动时，光标距离顶部/底部的位置（单位：行）

set ignorecase " 搜索时忽略大小写
set smartcase " 对于只有一个大写字母的搜索词，将大小写敏感
set nowrapscan " 搜索到文件始末位置时会停止

"set nobackup " 不创建备份文件
"set noswapfile " 关闭交换文件
set autochdir " 自动切换工作目录
set autoread " 自动重新读取
" 去掉输入错误的提示声音
set novisualbell
set noerrorbells

set showmatch " 显示括号配对情况

" 将行尾多余的空格显示
set listchars=tab:>-,trail:.
set list

filetype on  " 开启文件类型检查
filetype plugin on  " 载入与文件类型对应的插件
filetype indent on  " 载入与文件类型对应的缩进规则

" 新建指定格式的文件时
autocmd BufNewFile *.sh,*.py exec ":call AutoSetFileHead()"

function! AutoSetFileHead()
    if &filetype == 'sh'
        call setline(1, "\#!/bin/env bash")
    elseif &filetype == 'python'
        call setline(1, "\#!/usr/bin/env python3")
        call append(1, "\# encoding: utf-8")
"    elseif &filetype == ''
    endif
endfunc

" 打开指定格式文件时
autocmd FileType python set autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 ai

" Save when forgot sudo vim
:command Sudosave :w !sudo tee %

" let :Q do :q!
:command Q :q!

" make more :wq work
:command W :w
:command Wq :wq
:command WQ :wq

" paste mode toggler
set pastetoggle=<F3>

" line number toggler
nnoremap <F4> :set number!<CR>

