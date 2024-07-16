{ pkgs, lib, inputs, }:

let 
  vimrc = pkgs.callPackage ./vimrc.nix {};
in
{
  customRC = vimrc;

  packages.neovimPlugins = with pkgs.vimPlugins; {
    start = [
      # neovim lua library, dependency
      plenary-nvim
      # ui component lib, dependency
      nui-nvim

      nvim-lspconfig
      vim-vsnip

      # allows vim-snip to use lsp snippets
      # (integrated into completions via cmp-snip)
      vim-vsnip-integ
      # community snippet collection
      friendly-snippets

      # completions
      nvim-cmp
      # various completion sources
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-calc
      cmp-spell
      cmp-emoji
      cmp-treesitter
      cmp-latex-symbols
      cmp-omni
      cmp-vsnip
      cmp-nvim-lsp-signature-help
      cmp-nvim-lsp-document-symbol

      # strips whitespace on save,
      # but only from modified lines
      vim-strip-trailing-whitespace
      # automatically creating missing dirs on save
      vim-automkdir
      # support editorconfig files
      editorconfig-vim
      # grammar checking
      vim-grammarous
     # TODO: replace with neo-tree or smth
      # folder viewer
      pkgs.vimPlugins.nerdtree
      pkgs.vimPlugins.nerdtree-git-plugin
      # comment lines/blocks out via keybind
      vim-commentary
      # delete parts camelCase or PascalCase etc words
      camelcasemotion
      # autocloses (x)html tags
      vim-closetag
      # TODO: configure/use this
      # (allows to delete/change/etc pairs of surroundings, i.e. parentheses, etc)
      vim-surround
      # highlight parentheses in different colors
      # TODO: adjust colors to coloschem
      rainbow # original is frazrepo/vim-rainbow
      # show git status of files
      gitsigns-nvim

      # syntax/highlighting etc support
      # for *a lot* of filetypes
      vim-polyglot
      # part of vim-polyglot: plantuml-syntax
      # also part of vim-polyglot: vim-ledger
      # highlighting, syntax detection grammars
      nvim-treesitter.withAllGrammars
      # float-window fuzzy finder + integrations
      telescope-nvim
      telescope-fzf-native-nvim

      # bottom-bar list of quickfixes, diagnostics, telescope results,
      # lsp results, etc
      trouble-nvim
      # sidebar with outline of current document
      aerial-nvim
      # side/top/bottom-bar with lsp hover information
      # hoversplit_nvim

      # icons
      vim-devicons
      nvim-web-devicons

      vim-go

      dracula-nvim
      catppuccin-nvim
      tokyonight-nvim
    ];

    opt = [ ];
  };
}


