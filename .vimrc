set nocompatible  " 关闭vi兼容模式

" XDG_Base_Directory support
set undodir=$XDG_DATA_HOME/vim/undo/
set directory=$XDG_DATA_HOME/vim/swap/
set backupdir=$XDG_DATA_HOME/vim/backup/
set viewdir=$XDG_DATA_HOME/vim/view/
set viminfo+='1000,n$XDG_DATA_HOME/vim/viminfo
set runtimepath=$XDG_CONFIG_HOME/vim/,$VIMRUNTIME,$XDG_CONFIG_HOME/vim/after/

" powerline
" https://wiki.archlinux.org/index.php/Powerline#Vim
let g:powerline_pycmd="py3"
set rtp+=/usr/share/powerline/bindings/vim
:set laststatus=2

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
"set cursorline " 高亮光标所在的当前行

set wrap " 自动折行
set linebreak " 只有遇到指定的符号，才发生折行
set scrolloff=10 " 垂直滚动时，光标距离顶部/底部的位置（单位：行）

set ignorecase " 搜索时忽略大小写
set smartcase " 对于只有一个大写字母的搜索词，将大小写敏感
set nowrapscan " 搜索到文件始末位置时会停止

set nobackup " 不创建备份文件
set autochdir " 自动切换工作目录
set autoread " 自动重新读取
set noerrorbells " 有错误信息时不响铃

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
