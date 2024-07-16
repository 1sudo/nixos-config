" map leader key to space
let mapleader="\<SPACE>"
let maplocalleader="\<SPACE>l"

" toggle file tree
nnoremap <Leader>ff :NERDTreeToggle<CR>

" window movement
nnoremap <Leader>wj <C-W>j
nnoremap <Leader>wk <C-W>k
nnoremap <Leader>wl <C-W>l
nnoremap <Leader>wh <C-W>h
nnoremap <Leader>wc :close<CR>
nnoremap <Leader>ws :split<CR>
nnoremap <Leader>wv :vsplit<CR>

" spelling
nnoremap <Leader>se :setlocal spell spelllang=en<CR>
nnoremap <Leader>sd :setlocal spell spelllang=de<CR>
nnoremap <Leader>so :setlocal invspell<CR>

" Buffers
nnoremap <Leader>bb <cmd>lua require('telescope.builtin').buffers()<CR>
nnoremap <Leader>bd :bd<CR> " close (aka delete) buffer
nnoremap <Leader>bw :bw<CR> " delete buffer from memory (wipe)
nnoremap <Leader>bwf :bw!<CR> " force deletion (e. g. discard unwritten changes)

" Reload configs 
nnoremap <Leader>rrr :source ~/.config/nvim/init.vim<CR>

" Search settings
nnoremap <Leader>sc :set ignorecase!<CR> " toggle case (in)sensitive search 
nnoremap <Leader>sh :nohlsearch<CR> " remove highlighting for the last search

nnoremap <leader>ep <cmd>lua require('telescope.builtin').builtin()<cr>
nnoremap <leader>es <cmd>lua require('telescope.builtin').grep_string()<cr>
nnoremap <Leader>esr <cmd>lua require('telescope.builtin').live_grep()<CR>
nnoremap <Leader>ef <cmd>lua require('telescope.builtin').find_files()<CR>
nnoremap <Leader>efa <cmd>lua require('telescope.builtin').find_files({hidden = true, no_ignore = true,})<CR>
nnoremap <Leader>eg <cmd>lua require('telescope.builtin').git_files()<cr>
nnoremap <Leader>ega <cmd>lua require('telescope.builtin').git_files({recurse_submodules = true,})<cr>

" Terminal
" nnoremap <silent> <leader>tf :FloatermNew<CR>
" let g:floaterm_keymap_new = '<leader>tf'
" let g:floaterm_keymap_prev = '<leader>tp'
" let g:floaterm_keymap_next = '<leader>tn'
" let g:floaterm_keymap_toggle = '<leader>tt'
" let g:floaterm_keymap_kill = '<leader>tk'

" I don't really like the idea of duplicating
" all mappings for terminal mode...
" Therefore: define an easily accessible escape key
" from terminal mode, so that using keybinds
" in terminals is the same as in normal buffers with insert mode...
" Additonally prevent entering terminal mode
" when switching/opening a terminal buffer
nnoremap <silent> <leader>tf :FloatermNew<CR>
nnoremap <silent> <leader>tp :FloatermPrev<CR>
nnoremap <silent> <leader>tn :FloatermNext<CR>
nnoremap <silent> <leader>tt :FloatermToggle<CR>
nnoremap <silent> <leader>tk :FloatermKill<CR>

function! ToggleFloatermPersisting(name, cmd)
	let bufnr = floaterm#terminal#get_bufnr(a:name)
	if bufnr == -1
		execute printf('FloatermNew --name=%s --width=0.9 --height=0.9 --title=%s --wintype=float %s', a:name, a:name, a:cmd)
	else
		execute printf('FloatermToggle %s', a:name)
	endif
endfunction

nnoremap <silent> <leader>th :call ToggleFloatermPersisting('htop', 'sudo htop')<CR>

xnoremap <silent> <leader>ts :FloatermSend<CR>

nnoremap <silent> <leader>tl :Telescope floaterm<CR>

tnoremap <silent> <C-]> <C-\><C-n>

function! MakeSession()
	NERDTreeClose
	mksession!
endfunc

" Exit 
nnoremap <Leader>q :call MakeSession()<CR>:q<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>wq :call MakeSession()<CR>:wq<CR>
nnoremap <Leader>qa :call MakeSession()<CR>:qa<CR>
nnoremap <Leader>wa :call MakeSession()<CR>:wqa<CR>
nnoremap <Leader>wr <C-w>=
nnoremap <Leader>qi :qa<CR>

" Swapping two windows
function! WinBufSwap()
	let thiswin = winnr()
	let thisbuf = bufnr("%")
	let lastwin = winnr("#")
	let lastbuf = winbufnr(lastwin)
	exec lastwin . " wincmd w" ."|".
		\ "buffer ". thisbuf ."|".
		\ thiswin ." wincmd w" ."|".
		\ "buffer ". lastbuf
endfunc

command! Wswap :call WinBufSwap()
map <Silent> <Leader>ws :call WinBufSwap()<CR>

" format after putting
function! FormatPut()
	let curLine = line(".")
	execute "normal gp"
	let afterPasteLine = line(".")
	let difference = afterPasteLine - curLine
	exec "normal " curLine . "G" 	
	if difference > 0
		exec "normal "difference . "=="
	endif
endfunc

nnoremap <Leader>pf :call FormatPut()<CR>

lua << EOF

vim.api.nvim_set_keymap("n", "<Space>ce", "<cmd>lua vim.diagnostic.open_float()<CR>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<Space>cE", "<cmd>lua vim.diagnostic.open_float()vim.diagnostic.open_float()<CR>",
  {silent = true, noremap = true}
)

vim.api.nvim_set_keymap("n", "<leader>ll", "<cmd>Trouble<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>lw", "<cmd>Trouble workspace_diagnostics<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>ld", "<cmd>Trouble document_diagnostics<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>lg", "<cmd>Trouble loclist<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>lq", "<cmd>Trouble quickfix<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>lr", "<cmd>Trouble lsp_references<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>a", "<cmd>AerialToggle!<cr>",
  {silent = true, noremap = true}
)

vim.api.nvim_set_keymap("n", "<leader>ln", '<cmd>lua require("trouble").next({skip_groups = true, jump = true})<CR>',
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>lp", '<cmd>lua require("trouble").previous({skip_groups = true, jump = true})<CR>',
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap('n', 'y', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'y', '"+y', { noremap = true, silent = true })

EOF

" autocompletion
" inoremap <expr> <C-J> pumvisible() ? "\<C-n>" : "\<C-J>"
" inoremap <expr> <C-K> pumvisible() ? "\<C-p>" : "\<C-K>"
" inoremap <silent><expr> <C-Leader> compe#complete()
" inoremap <silent><expr> <CR>      compe#confirm('<CR>')
" inoremap <silent><expr> <C-e>     compe#close('<C-e>')
" inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
" inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })
