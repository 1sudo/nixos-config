{ pkgs, lib, inputs, }:

let 
  vimrc = pkgs.callPackage ./vimrc.nix {};
  base16-custom-themes = pkgs.runCommand "base16-custom-themes" {} ''
    mkdir -p $out/colors
    cp ${./colors/glowing-greens.vim} $out/colors/base16-glowing-greens.vim
    mkdir -p $out/autoload/airline/themes
    cp ${./colors/glowing-greens.airline.vim} $out/autoload/airline/themes/base16_glowing_greens.vim
  '';
  hoversplit_nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "hoversplit_nvim";
    version = "2023-09-09";
    src = pkgs.fetchFromGitHub {
      owner = "roobert";
      repo = "hoversplit.nvim";
      rev= "c7c6b5596fed3287a3b20dbe772c8211a99cebc7";
      hash = "sha256-PSzfzoyo82aIVsVtVl/DOLN/qwPF1rUKEjkSIKmMFow=";
    };
  };
  # currently unused
  # base16-vim-airline-themes = pkgs.vimUtils.buildVimPlugin {
  #   pname = "base16-vim-airline-themes";
  #   version = "2021-11-05";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "dawikur";
  #     repo = "base16-vim-airline-themes";
  #     rev = "925a56f54c2d980db4ec986aae6e4ae29d27ee45";
  #     sha256 = "sha256-j2xMeu1r0j6bGYDu25jnb39j30iYXf6YoHWuDQJ/zl8=";
  #   };
  # };
  # currently unused
  # telescope-floaterm-nvim = (pkgs.vimUtils.buildVimPlugin rec {
  #   pname = "telescope-floaterm-nvim";
  #   version = "2023-02-02";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "dawsers";
  #     repo = "telescope-floaterm.nvim";
  #     rev = "37f59fd774811ab69d079440d695a86c75378b12";
  #     sha256 = "sha256-nbkehtQFpk12+7bqUZryjHnyGgLYm595lNynJuq+b5E=";
  #   };
  # }).overrideAttrs (oldAttrs: rec {
  #   dependencies = [ pkgs.vimPlugins.telescope-nvim ];
  # });
in
{
  customRC = vimrc;

  packages.neovimPlugins = with pkgs.vimPlugins; {
    start = [
      # neovim lua library, dependency
      plenary-nvim
      # ui component lib, dependency
      nui-nvim

      # hm, there are a lot of alternatives here and I'm not 100%
      # happy with the statusline (tbh, this was simply the goto at
      # the time I created my first (neo)vim config)
      heirline-nvim

      nvim-lspconfig
      # project-specific lsp configs in json files
      nlsp-settings-nvim

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
      # edit gpg encrypted files
      vim-gnupg

      # grammar checking
      vim-grammarous
      # check (ba)sh scripts
      pkgs.vimPlugins.vim-shellcheck

      # terminal organisation
      # I've stopped using this,terminals outside neovim just work better for me
      # vim-floaterm

      # TODO: replace with neo-tree or smth
      # folder viewer
      pkgs.vimPlugins.nerdtree
      pkgs.vimPlugins.nerdtree-git-plugin
      # folder viewer that can be used as a sidebar and window, etc
      neo-tree-nvim

      # jumping between () but also for language specific constructcs
      # (e.g. if/else,etc)
      vim-matchup
      # comment lines/blocks out via keybind
      vim-commentary
      # delete parts camelCase or PascalCase etc words
      camelcasemotion
      # autocloses (x)html tags
      vim-closetag
      # TODO: configure/use this
      # (allows to delete/change/etc pairs of surroundings, i.e. parentheses, etc)
      vim-surround
      # unused,doesn't work with current colorscheme: vim-indent-guides # original is thaerkh/vim-indentguides
      # . action support for plugin actions
      # TODO: configure/use this? Or am I using this withotu knowing?
      # not sure
      vim-repeat

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
      # eww config langauge
      yuck-vim
      # lfe (lisp flavored erlang)
      vim-lfe

      # float-window fuzzy finder + integrations
      telescope-nvim
      telescope-fzf-native-nvim
      # I've stopped using floaterm (see above)
      # telescope-floaterm-nvim

      # bottom-bar list of quickfixes, diagnostics, telescope results,
      # lsp results, etc
      trouble-nvim
      # sidebar with outline of current document
      aerial-nvim
      # side/top/bottom-bar with lsp hover information
      hoversplit_nvim

      # icons
      vim-devicons
      nvim-web-devicons

      # colorscheme
      # unused: NeoSolarized
      # unused: gruvbox
      # unused: base16-vim
      # unused: base16-vim-airline-themes
      base16-custom-themes
    ];

    opt = [ ];
  };
}


