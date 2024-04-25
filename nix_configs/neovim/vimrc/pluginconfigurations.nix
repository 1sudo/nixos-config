let
  airline = builtins.readFile ./plugins/airline.vim;
  completion = builtins.readFile ./plugins/completion.vim;
  camelCaseMotion = builtins.readFile ./plugins/CamelCaseMotion.vim;
  fzf = builtins.readFile ./plugins/fzf.vim;
  grammarous = builtins.readFile ./plugins/grammarous.vim;
  gruvbox = builtins.readFile ./plugins/gruvbox.vim;
  lspconfig = builtins.readFile ./plugins/lspconfig.vim;
  nerdtree = builtins.readFile ./plugins/nerdtree.vim;
  rainbow = builtins.readFile ./plugins/rainbow.vim;
  solarized = builtins.readFile ./plugins/solarized.vim;
  treesitter = builtins.readFile ./plugins/treesitter.vim;
  telescope = builtins.readFile ./plugins/telescope.vim;
  git = builtins.readFile ./plugins/git.vim;
  neorg = builtins.readFile ./plugins/neorg.vim;
  trouble = builtins.readFile ./plugins/trouble.vim;
  aerial = builtins.readFile ./plugins/aerial.vim;
  floaterm = builtins.readFile ./plugins/floaterm.vim;
in

''
  ${airline}  
  ${completion}
  ${camelCaseMotion}  
  ${grammarous}  
  ${gruvbox}
  ${lspconfig}  
  ${nerdtree}  
  ${rainbow}  
  ${solarized}  
  ${treesitter}
  ${telescope}
  ${git}
  ${trouble}
  ${aerial}
  ${floaterm}
''

# :luafile ${./plugins/heirline.lua}
