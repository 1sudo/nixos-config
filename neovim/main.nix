{ pkgs, inputs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    defaultEditor = true;
    vimAlias = true;
    configure = (import ./customization.nix { pkgs = pkgs; lib = lib; inputs = inputs; });
  };

  environment = {
    systemPackages = with pkgs; [
      python3
      nodePackages.bash-language-server
      nodePackages.vscode-css-languageserver-bin
      nodePackages.dockerfile-language-server-nodejs
      nodePackages.vscode-html-languageserver-bin
      nodePackages.vscode-json-languageserver-bin
      python3Packages.python-lsp-server
      nodePackages.yaml-language-server
      nodePackages.vim-language-server
      nodePackages.diagnostic-languageserver
      shellcheck
      typst-lsp
      jdt-language-server
      clang-tools clang-manpages
      cmake-language-server
      rust-analyzer
      omnisharp-roslyn
      nerdfonts
      wl-clipboard
    ];
  };
}

