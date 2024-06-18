{ pkgs, pkgs-unstable, inputs, ... }:
{
  imports = [ ./modules ];

  home = {
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.

    # targs.genericLinux.enable = true; # Enable in Non nixOS systems;;
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
  };

  xdg.configFile.".config/io.github.zefr0x.ianny/config.toml".text = ''
    [timer]
    idle_timeout = 300
    short_break_timeout = 5400
    long_break_timeout = 10800
    short_break_duration = 300
    long_break_duration = 600

    [notification]
    show_progress_bar = true
    minimum_update_delay = 1
  '';

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
