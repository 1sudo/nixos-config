{ pkgs, inputs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    defaultEditor = true;
    configure = (import ./customization.nix { pkgs = pkgs; lib = lib; inputs = inputs; });
  };

  environment = {
    systemPackages = with pkgs; [
      deno
      python3
      ctags
      nodePackages.bash-language-server
      ccls
      nodePackages.vscode-css-languageserver-bin
      nodePackages.dockerfile-language-server-nodejs
      nodePackages.vscode-html-languageserver-bin
      nodePackages.vscode-json-languageserver-bin
      python3Packages.python-lsp-server
      nodePackages.yaml-language-server
      nodePackages.vim-language-server
      texlab
      nil
      nodePackages.diagnostic-languageserver
      shellcheck
      languagetool
      elixir_ls
      elmPackages.elm-language-server
      haskell-language-server
      metals
      typst-lsp
      jdt-language-server
      clang-tools clang-manpages
      cmake-language-server
      bear
    ];
  };
}

