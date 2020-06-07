" # Plugin options
let g:polyglot_disabled = ['latex']

" rust.vim options
let g:rust_recommended_style='0'
let g:rust_fold='1'

" DetectIndent
let g:detectindent_preferred_indent = 4 
autocmd BufReadPost * :DetectIndent 

" # Useful indicators
set colorcolumn=81 " Highlight column 81
highlight ColorColumn guibg=#220000
set cursorline " Highlight the whole line where the cursor is located
set number " Numbered lines
set relativenumber
set showcmd " Show the current command being entered on the status line
set statusline=%-3.3n%f%h%m%r%w\ [type=%{strlen(&ft)?&ft:'none'}]
			\\ [enc=%{strlen(&fenc)?&fenc:&enc}]
			\\ %=char:\ %03b,0x%02B\ \ \ \ pos:\ %-10.(%l,%c%V%)\ %P

" # Vim backup configuration
set nobackup
set nowritebackup
set noswapfile
set shada='15,<50,s1,h

" # Search options
set ignorecase
set smartcase

" # Misc
set hidden
set scrolloff=16
set fileformats=unix,dos " Don't want cr+lf line on any platform
set tabstop=4
set expandtab
set shiftwidth=4
let g:terminal_scrollback_buffer_size=10000
set shortmess+=cI
set synmaxcol=160
set nowrapscan " Search usually wraps without me noticing, which is annoying.
set cpo+=y " Repeatable yank commands.
" Always show the sign column. Having it appear and disappear while editing is
" horribly annoying.
set signcolumn=yes
set nomodeline

" # Mappings / Functions

" Fzf
command! -bang -nargs=* Rgi
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always -i '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

command! -bang FdFiles
  \ call fzf#run(fzf#wrap('fdfiles', {
  \     'source': 'fd . -tf',
  \     'sink': 'e',
  \     'options': '-m --prompt "FdFiles> "'
  \ }, <bang>0))

nnoremap <c-l> :nohlsearch<CR><c-l>
" Automatically create a new undo point before link-break
inoremap <CR> <C-G>u<CR>
" Make Y behave analogous to C and D
nnoremap Y y$

" Make '&' preserve flags when repeating substitutions
nnoremap & :&&<CR>
xnoremap & :&&<CR>

nnoremap <Leader>ss :FdFiles<CR>
nnoremap <Leader>sg :GFiles<CR>
nnoremap <Leader>sb :Buffers<CR>

nnoremap <Leader>bd :call MyBufDelete()<CR>
nnoremap <Leader>w :call FixWsAndWrite()<CR>
nnoremap <Leader>q :q<CR>

nnoremap <silent> <Leader>f :call CocAction('format')<CR>
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> K :call CocAction('doHover')<CR>
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>ac  :<C-u>CocAction<CR>
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" slightly better movement keys
noremap ; l
sunmap ;
noremap l k
sunmap l
noremap k j
sunmap k
noremap j h
sunmap j

noremap h ;
sunmap h
noremap H ,
sunmap H

" Use the same movement keys for navigation between split windows
nnoremap <C-W>j <C-W>h
nnoremap <C-W>k <C-W>j
nnoremap <C-W>l <C-W>k
nnoremap <C-W>; <C-W>l

" Easier delete-to-black-hole
nnoremap <leader>d "_d
vnoremap <leader>d "_d

" Easier yank/paste to/from clipboard
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y "+y$
vnoremap <leader>Y "+Y
nnoremap <leader>p "+p
nnoremap <leader>P "+P

" # Utility functions

" Close a buffer without closing the split window.
function MyBufDelete()
	if &mod == 0
		bp
		bd #
	else
		" Just to show the 'file has unsaved changes' error
		bd
	endif
endfunction

function! ResCur()
	let l:oldline = line("'\"")
	if l:oldline <= line("$") && l:oldline > 0
		normal! g`"
		return 1
	endif
endfunction

augroup resCur
	autocmd!
	autocmd BufWinEnter ?* call ResCur()
augroup END

func! FixWsAndWrite()
	exe "normal mz"
	%s/\s\+$//ge
	exe "normal `z"
	w
endfunc
