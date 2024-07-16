" Color settings
set termguicolors

set background=dark

" colorscheme catppuccin

colorscheme tokyonight
" colorscheme tokyonight-night
" colorscheme tokyonight-storm
" colorscheme tokyonight-day
" colorscheme tokyonight-moon

" I have absolutely no idea why this is necessary now, lol
lua << EOF
vim.fn.sign_define("DiagnosticSignError", {text = "󰅚 ", texthl = "DiagnosticSignError"})
vim.fn.sign_define("DiagnosticSignWarn", {text = "󰀪 ", texthl = "DiagnosticSignWarn"})
vim.fn.sign_define("DiagnosticSignInfo", {text = "󰋽 ", texthl = "DiagnosticSignInfo"})
vim.fn.sign_define("DiagnosticSignHint", {text = "󰆂 ", texthl = "DiagnosticSignHint"})
EOF
