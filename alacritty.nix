{ config, pkgs, ... }:

let
  alacrittyConfig = pkgs.writeTextFile {
    name = "alacritty.toml";
    text = ''
      [env]
      TERM = "xterm"

      [colors.bright]
      black = "0x282a35"
      blue = "0xcaa9fa"
      cyan = "0x9aedfe"
      green = "0x5af78e"
      magenta = "0xff92d0"
      red = "0xff6e67"
      white = "0xe6e6e6"
      yellow = "0xf4f99d"

      [colors.normal]
      black = "0x000000"
      blue = "0xcaa9fa"
      cyan = "0x8be9fd"
      green = "0x50fa7b"
      magenta = "0xff79c6"
      red = "0xff5555"
      white = "0xbfbfbf"
      yellow = "0xf1fa8c"

      [colors.primary]
      background = "0x282a36"
      foreground = "0xf8f8f2"

      [font.bold]
      family = "JetBrainsMono Nerd Font"
      style = "Bold"

      [font.bold_italic]
      family = "JetBrainsMono Nerd Font"
      style = "Bold Italic"

      [font.italic]
      family = "JetBrainsMono Nerd Font"
      style = "Italic"

      [font.normal]
      family = "JetBrainsMono Nerd Font"
      style = "Regular"

      [window]
      opacity = 1.0
      startup_mode = "Maximized"
      decorations = "none"
    '';
  };
in
{
  environment.systemPackages = with pkgs; [
    alacritty
  ];

  system.activationScripts = {
    createAlacrittyConfig = {
      text = ''
        mkdir -p /home/zac/.config/alacritty
        cp ${alacrittyConfig} /home/zac/.config/alacritty/alacritty.toml
        chown zac: /home/zac/.config/alacritty/alacritty.toml
      '';
      deps = [];
    };
  };
}
