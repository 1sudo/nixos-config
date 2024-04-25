lua << EOF
require('gitsigns').setup({
  numhl = true,
  linehl = false,
  word_diff = false,
  current_line_blame = false,
  current_line_blame_opts = {
    virt_text_pos = 'right_align',
  },
})
EOF
