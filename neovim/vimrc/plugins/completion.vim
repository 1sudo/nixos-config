set completeopt=menu,menuone,noselect

lua <<EOF
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    mapping = {
      ['<C-J>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i', 'c'}),
      ['<C-K>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i', 'c'}),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
      ['<C-e>'] = cmp.mapping(cmp.mapping.close(), {'i', 'c'}),
      ['<CR>'] = cmp.mapping(cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }), {'i'})
    },
    sources = {
      { name = 'nvim_lsp_signature_help' },

      { name = 'nvim_lsp' },

      { name = 'treesitter' },

      { name = 'buffer' },

      { name = 'path' },

      -- { name = 'neorg' },

      { name = 'calc' },

      { name = 'spell' },

      { name = 'emoji' },

      { name = 'latex_symbols' },

      { name = 'omni' },
      
      { name = 'vnsip' },
    }
  })
  cmp.setup.cmdline('/', {
    sources = cmp.config.sources({
      -- trigger symbol search with /@
      { name = 'nvim_lsp_document_symbol' },
      { name = 'buffer' },
    }),
  })
EOF

augroup cmp_custom 
  autocmd!
  " disable treesitter source for erlang
  au FileType erlang lua require('cmp').setup.buffer {
\   sources = {
\     { name = 'nvim_lsp' },
\     { name = 'buffer' },
\     { name = 'path' },
\     { name = 'calc' },
\     { name = 'spell' },
\     { name = 'emoji' },
\     { name = 'latex_symbols' },
\     { name = 'vsnip' },
\   }
\ }
augroup END

" set shortmess+=c

" let g:compe = {}
" let g:compe.enabled = v:true
" let g:compe.autocomplete = v:true
" let g:compe.debug = v:false
" let g:compe.min_length = 1
" let g:compe.preselect = 'enable'
" let g:compe.throttle_time = 80
" let g:compe.source_timeout = 200
" let g:compe.resolve_timeout = 800
" let g:compe.incomplete_delay = 400
" let g:compe.max_abbr_width = 100
" let g:compe.max_kind_width = 100
" let g:compe.max_menu_width = 100
" let g:compe.documentation = v:true

" let g:compe.source = {}
" let g:compe.source.path = v:true
" let g:compe.source.buffer = v:true
" let g:compe.source.calc = v:true
" let g:compe.source.nvim_lsp = v:true
" let g:compe.source.nvim_lua = v:true
" let g:compe.source.vsnip = v:false
" let g:compe.source.ultisnips = v:false
" let g:compe.source.luasnip = v:false
