" Color settings
set termguicolors

" see https://jdhao.github.io/2020/09/22/highlight_groups_cleared_in_nvim/
" for the rationaly behind this
augroup opaque_background
  autocmd!
  " take a look at the existing groups with `:so
  " $VIMRUNTIME/syntax/hitest.vim:
  " if something looks wrong with backgrounds...
  au ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
  au ColorScheme * highlight NonText ctermbg=NONE guibg=NONE
  au ColorScheme * highlight CursorLineNr ctermbg=NONE guibg=NONE
  au ColorScheme * highlight LineNr ctermbg=NONE guibg=NONE
  au ColorScheme * highlight Folded ctermbg=NONE guibg=NONE
  au ColorScheme * highlight FoldColumn ctermbg=NONE guibg=NONE
  au ColorScheme * highlight DiffDelete ctermbg=NONE guibg=NONE
  au ColorScheme * highlight Conceal ctermbg=NONE guibg=NONE
  au ColorScheme * highlight Todo ctermbg=NONE guibg=NONE
  au ColorScheme * highlight SignColumn ctermbg=NONE guibg=NONE
  au ColorScheme * highlight GruvboxRedSign ctermbg=NONE guibg=NONE
  au ColorScheme * highlight GruvboxGreenSign ctermbg=NONE guibg=NONE
  au ColorScheme * highlight GruvboxYellowSign ctermbg=NONE guibg=NONE
  au ColorScheme * highlight GruvboxBlueSign ctermbg=NONE guibg=NONE
  au ColorScheme * highlight GruvboxPurpleSign ctermbg=NONE guibg=NONE
  au ColorScheme * highlight GruvboxAquaSign ctermbg=NONE guibg=NONE
  au ColorScheme * highlight GruvboxOrangeSign ctermbg=NONE guibg=NONE
augroup END

set background=dark

colorscheme base16-glowing-greens

" I have absolutely no idea why this is necessary now, lol
lua << EOF
vim.fn.sign_define("DiagnosticSignError", {text = "󰅚 ", texthl = "DiagnosticSignError"})
vim.fn.sign_define("DiagnosticSignWarn", {text = "󰀪 ", texthl = "DiagnosticSignWarn"})
vim.fn.sign_define("DiagnosticSignInfo", {text = "󰋽 ", texthl = "DiagnosticSignInfo"})
vim.fn.sign_define("DiagnosticSignHint", {text = "󰆂 ", texthl = "DiagnosticSignHint"})
EOF
