" appearance setting
syntax enable
set t_co=256
set background=dark
"colorscheme tokyonight-storm

"line number
set number
set relativenumber

" enable ruler
set ruler

" search
set hlsearch
set ignorecase
set incsearch
set smartcase

" set cursor line
set cursorline

" disable swap file
set noswapfile

" set tab to 2 spaces
set softtabstop=2
set shiftwidth=2

" always show tab line
set showtabline=2

" set default split view below or right
set splitbelow
set splitright

"file type and indent
filetype on
filetype indent on
filetype plugin on

" enable line break
set linebreak

" show command
set showcmd

" scroll
set scrolloff=5

" maping
imap jj <Esc>

"plug-ins
"call plug#begin()

"在此加入想要的外掛
"Plug 'folke/tokyonight.nvim'

"call plug#end()

" run .py, .c, .cpp, .sh in vim
nmap <F5> :call CompileRun()<CR>
func! CompileRun()
        exec "w"
if &filetype == 'python'
            exec "!time python3 %"
elseif &filetype == 'java'
            exec "!javac %"
            exec "!time java %<"
elseif &filetype == 'cpp'
                                                exec "!runc %"
elseif &filetype == 'c'
                                                exec "!runc %"
elseif &filetype == 'sh'
            :!time bash %
endif
    endfunc