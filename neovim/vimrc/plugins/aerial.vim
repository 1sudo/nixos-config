lua << EOF
require('aerial').setup({
  on_attach = function(bufnr)
  end,
  backends = { "lsp", "markdown", "man" },
})
EOF

" for on_attach: but does not go away so is more anoying than helpful
" vim.keymap.set('n', 'k', '<cmd>AerialPrev<CR>', {buffer = bufnr})
" vim.keymap.set('n', 'j', '<cmd>AerialNext<CR>', {buffer = bufnr})
