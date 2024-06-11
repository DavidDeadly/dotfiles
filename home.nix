{ config, pkgs, ... }:
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

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # Maybe you want to install Nerd Fonts with a limited number of fonts?
    (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
    # # You can also create simple shell scripts directly inside your
    # # configuration.
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    ".config/kitty/kitty.conf".source = ./.config/kitty/kitty.conf;
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/daviddeadly/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        ll = "ls -l";
	".." = "cd ..";
	dotf = "git --git-dir=${HOME}/Dev/dotfiles --work-tree=${HOME}";
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
      settings = builtins.fromJSON (builtins.unsafeDiscardStringContext (builtins.readFile "${HOME}/.dotfiles/.config/oh-my-posh/daviddeadly.omp.json"));
    };

    lazygit = {
      enable = true;
    };

    git = {
      enable = true;
      userName = "DavidDeadly";
      userEmail = "jdrueda513@gmail.com";
      aliases = {
        pu = "push";
        co = "checkout";
        cm = "commit";
      };
      extraConfig = {
        init.defaultBranch = "main";
	pull.rebase = true;
      };
    };

    gh.enable = true;
  };

  gtk = {
    enable = true;
    theme.name = "adw-gtk3";
    cursorTheme.name = "Bibata-Modern-Ice";
    iconTheme.name = "GruvboxPlus";
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
