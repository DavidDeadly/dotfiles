{ pkgs, pkgs-unstable, inputs, ... }:
let
  USER = "daviddeadly";
  HOME = "/home/${USER}";
  icons-theme = import ./icons-theme.nix { inherit pkgs; };
  gtk-theme = import ./gtk-theme.nix { inherit pkgs; };
in
{
  home. username = USER;
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
    hyprcursor # cursor theme manager
    jq # json parser
    rm-improved # better rm
    pamixer # volume control

    kitty # terminal
    mako # notification daemon

    # Maybe you want to install Nerd Fonts with a limited number of fonts?
    (nerdfonts.override {
      fonts = [ "CascadiaCode" ];
    })
  ];

  # Home Manager is pretty good at managing dotfiles
  xdg.configFile."lf/icons".source = ./.config/lf/icons;
  home.file = {
    ".config/wofi".source = ./.config/wofi;
    ".config/mako".source = ./.config/mako;
    ".config/zellij".source = ./.config/zellij;
    ".config/swaylock".source = ./.config/swaylock;
    ".config/io.github.zefr0x.ianny".source = ./.config/io.github.zefr0x.ianny;
    ".config/kitty".source = ./.config/kitty;
  };

  home.pointerCursor = {
    name = "Catppuccin-Mocha-Sky-Cursors";
    package = pkgs.catppuccin-cursors.mochaSky;
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

    bat = {
      enable = true;
      config.theme = "OneHalfDark";
    };

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        ll = "ls -l";
        ".." = "cd ..";

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
        # python
        nodePackages.pyright
        (
          python3.withPackages (ps: with ps; [
            black
            isort
          ])
        )

        # lua
        pkgs-unstable.lua-language-server
        selene
        stylua

        # nix
        statix
        nixpkgs-fmt
        pkgs-unstable.nil

        # javascipt
        nodePackages.prettier
        nodePackages.eslint
        nodePackages.typescript-language-server
        nodePackages.volar

        # Go
        go
        gopls
        golangci-lint
        delve

        # Shell scripting
        shfmt
        shellcheck

        # C, C++
        clang-tools
        cppcheck

        # extras
        nodePackages.cspell
        nodePackages.vscode-langservers-extracted

        # telescope deps
        ripgrep
        fd
        fzf
      ];
    };

    lf = {
      enable = true;

      settings = {
        preview = true;
        icons = true;
        drawbox = true;
        ignorecase = true;
      };

      commands = {
        dragon-out = ''%${pkgs.xdragon}/bin/xdragon -a -x "$fx"'';
        editor-open = ''$$EDITOR $f'';
        preview = ''''$${pkgs.bat}/bin/bat --paging=always "$f"'';
        mkdir = ''
          ''${{
            printf "\nDirectory name: "
            read DIR
            mkdir -p $DIR
          }}
        '';
      };

      keybindings = {
        "<c-c>" = "exit";
        "." = "set hidden!";
        "<enter>" = "open";
        c = "mkdir";
        do = "dragon-out";
        ee = "editor-open";
        V = "preview";
      };


      previewer.source =
        pkgs.writeShellScript "pv.sh" ''
          file=$1
          w=$2
          h=$3
          x=$4
          y=$5
        
          if [[ "$( ${pkgs.file}/bin/file -Lb --mime-type "$file")" =~ ^image ]]; then
              ${pkgs.kitty}/bin/kitty +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$file" < /dev/null > /dev/tty
              exit 1
          fi
        
          ${pkgs.pistol}/bin/pistol "$file"
        '';

      extraConfig =
        let
          cleaner = pkgs.writeShellScriptBin "clean.sh" ''
            ${pkgs.kitty}/bin/kitty +kitten icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty
          '';
        in
        ''set cleaner ${cleaner}/bin/clean.sh'';
    };
  };

  gtk = {
    enable = true;
    theme = {
      package = gtk-theme;
      name = "Infinity-GTK";
    };

    iconTheme = {
      package = icons-theme;
      name = "vivid-glasy-dark";
    };

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
