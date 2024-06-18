{ pkgs, pkgs-unstable, inputs, ... }:
{
  imports = [ ./modules ];

  home = {
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "23.11"; # Please read the comment before changing.
    username = "daviddeadly";
    homeDirectory = "/home/daviddeadly";

    sessionVariables = {
      EDITOR = "nvim";
    };

    # $ nix search <package to search>
    packages = with pkgs; [
      vivaldi # browser
      ianny # breaks utility
      neofetch # system stats
      playerctl # media player
      pavucontrol # audio player
      wl-clipboard # clipboard manager
      grim # image graber
      slurp # area selection
      swappy # snapshots
      wf-recorder # video recorder
      brightnessctl # brightness service
      networkmanagerapplet # network indicator
      inputs.swww.packages.${system}.swww # wallpaper-daemon
      xfce.thunar # file manager
      jq # json parser
      rm-improved # better rm
      pamixer # volume control

      # Maybe you want to install Nerd Fonts with a limited number of fonts?
      (nerdfonts.override {
        fonts = [ "CascadiaCode" ];
      })
    ];

    # Home Manager is pretty good at managing dotfiles
    file = {
      ".config/zellij".source = ../../.config/zellij;
      ".config/wlogout/icons".source = ../../.config/wlogout/icons;
      ".config/io.github.zefr0x.ianny".source = ../../.config/io.github.zefr0x.ianny;
    };
  };

  xdg.configFile."lf/icons".source = ../../.config/lf/icons;

  services = {
    copyq.enable = true;
    playerctld.enable = true;
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    eww = {
      enable = true;
      configDir = ../../.config/eww;
    };
  };
}

