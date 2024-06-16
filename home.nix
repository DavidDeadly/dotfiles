{ pkgs, pkgs-unstable, inputs, ... }:
let
  USER = "daviddeadly";
  HOME = "/home/${USER}";
in
{
  home.username = USER;
  home.homeDirectory = HOME;

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  nixpkgs.config.allowUnfree = true;
  # $ nix search <package to search>
  home.packages = with pkgs; [
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
    hyprpicker # color picker
    inputs.swww.packages.${system}.swww # wallpaper-daemon
    xfce.thunar # file manager
    swaylock-effects # locker
    hyprlock # locker for hyprland
    swayidle # idle daemon
    hypridle # idle daemon for hyprland
    jq # json parser
    ripgrep # better grep
    rm-improved # better rm
    fd # better find
    fzf # fuzzy finder
    bat # better cat
    pamixer # volume control
    asusctl # power management

    kitty # terminal
    mako # notification daemon

    # Maybe you want to install Nerd Fonts with a limited number of fonts?
    (nerdfonts.override {
      fonts = [ "CascadiaCode" ];
    })
  ];

  # Home Manager is pretty good at managing dotfiles
  home.file = {
    ".config/wofi".source = ./.config/wofi;
    ".config/mako".source = ./.config/mako;
    ".config/zellij".source = ./.config/zellij;
    ".config/swaylock".source = ./.config/swaylock;
    ".config/io.github.zefr0x.ianny".source = ./.config/io.github.zefr0x.ianny;
    ".config/kitty".source = ./.config/kitty;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  services = {
    # mako.enable = true;
    copyq.enable = true;
    playerctld.enable = true;
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    wlogout.enable = true;
    zellij.enable = true;
    wofi.enable = true;
    htop.enable = true;
    # kitty.enable = true;
    lazygit.enable = true;
    gh.enable = true;
    eww = {
      enable = true;
      configDir = ./.config/eww;
    };

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        ll = "ls -l";
        ".." = "cd ..";
        rm = "rip";

        vi = "nvim";
        vim = "nvim";
        vimdiff = "nvim -d";

        # dotf = "git --git-dir=${HOME}/Dev/dotfiles --work-tree=${HOME}";
      };

      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "sudo"
        ];
      };
    };

    oh-my-posh = {
      enable = true;
      enableZshIntegration = true;
      useTheme = "catppuccin_macchiato";
      settings = builtins.fromJSON (
        builtins.unsafeDiscardStringContext (
          builtins.readFile "${HOME}/.dotfiles/.config/oh-my-posh/daviddeadly.omp.json"
        )
      );
    };

    git = {
      enable = true;
      userName = "DavidDeadly";
      userEmail = "jdrueda513@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      withNodeJs = true;
      package = pkgs-unstable.neovim-unwrapped;

      extraPackages = with pkgs; [
        gcc
        nodejs
        cargo
      ];
    };
  };

  gtk = {
    enable = true;
    # theme.name = "adw-gtk3";
    # cursorTheme.name = "Bibata-Modern-Ice";
    # iconTheme.name = "GruvboxPlus";

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
  };

  # wayland.windowManager.hyprland = {
  #   enable = true;
  #   package = pkgs.hyprland;
  #   xwayland.enable = true;
  #   systemd.enable = true;

  #   settings = {
  #   };
  # };
}
