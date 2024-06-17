{ pkgs, pkgs-unstable, inputs, ... }:
let
  USER = "daviddeadly";
  HOME = "/home/${USER}";
  icons-theme = import ./icons-theme.nix { inherit pkgs; };
  gtk-theme = import ./gtk-theme.nix { inherit pkgs; };
in
{
  nixpkgs.config.allowUnfree = true;

  home = {
    username = USER;
    homeDirectory = HOME;

    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "23.11"; # Please read the comment before changing.

    pointerCursor = {
      name = "Catppuccin-Mocha-Sky-Cursors";
      package = pkgs.catppuccin-cursors.mochaSky;
    };

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
      hyprpicker # color picker
      hyprcursor # cursor theme manager
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
      ".config/zellij".source = ./.config/zellij;
      ".config/wlogout/icons".source = ./.config/wlogout/icons;
      ".config/io.github.zefr0x.ianny".source = ./.config/io.github.zefr0x.ianny;
    };
  };

  xdg.configFile."lf/icons".source = ./.config/lf/icons;

  services = {
    copyq.enable = true;
    playerctld.enable = true;

    hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
          before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
          after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
        };

        listener = [
          {
            timeout = 150; # 2.5min.
            on-timeout = "brightnessctl -s set 10"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
            on-resume = "brightnessctl -r"; # monitor backlight restore.
          }
          {
            timeout = 300; # 5min
            on-timeout = "hyprlock --immediate"; # lock screen when timeout has passed
          }
          {
            timeout = 330; # 5.5min
            on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
            on-resume = "hyprctl dispatch dpms on"; # screen on when activity is detected after timeout has fired.
          }
          {
            timeout = 600; # 10min
            on-timeout = "systemctl suspend"; # suspend pc
          }
        ];
      };
    };

    mako = {
      enable = true;
      anchor = "top-center";
      font = "monospace 10";
      format = ''<b>%s</b>\n%b'';
      groupBy = "app-name,summary,body,urgency";
      layer = "overlay";
      icons = true;
      maxIconSize = 48;
      markup = true;
      actions = true;
      ignoreTimeout = false;
      maxVisible = 5;
      defaultTimeout = 5000;
      backgroundColor = "#1e1e2e";
      textColor = "#cdd6f4";
      borderSize = 2;
      borderRadius = 5;
      borderColor = "#89b4fa";
      padding = "12,10";
      progressColor = "over #943d90";

      extraConfig = ''
        text-alignment=center
        icon-location=left
        max-history=15
        history=1

        [urgency=low]

        border-color=#4C6F9E
        default-timeout=2000
        history=0

        [urgency=normal]

        border-color=#00C6BA
        default-timeout=5000
        on-notify=exec mpv /usr/share/sounds/freedesktop/stereo/message.oga

        [urgency=high]

        border-color=#f38ba8
        on-notify=exec mpv /usr/share/sounds/freedesktop/stereo/bell.oga

        [app-name="Ianny"]

        on-notify=none
      '';
    };
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    zellij.enable = true;
    htop.enable = true;
    lazygit.enable = true;
    gh.enable = true;

    wlogout = {
      enable = true;

      layout = [
        {
          label = "lock";
          action = "hyprlock -q";
          text = "Lock";
          keybind = "l";
        }
        {
          label = "logout";
          action = "hyprctl dispatch exit 0";
          text = "Logout";
          keybind = "e";
        }
        {
          label = "shutdown";
          action = "systemctl poweroff";
          text = "Shutdown";
          keybind = "s";
        }
        {
          label = "reboot";
          action = "systemctl reboot";
          text = "Reboot";
          keybind = "r";
        }
        {
          label = "suspend";
          action = "hyprlock --immediate -q && systemctl suspend";
          text = "Suspend";
          keybind = "u";
        }
      ];

      style = ''
        window {
          font-family: CaskaydiaCove Nerd Font, monospace;
          font-size: 12pt;
          color: #cdd6f4; 
          background-color: rgba(17, 17, 27, .88);
        }

        button {
          background-repeat: no-repeat;
          background-position: center;
          background-size: 60%;
          border: none;
          color: #ced7f4;
          text-shadow: none;
          border-radius: 20px 20px 20px 20px;
          background-color: rgba(30, 30, 46, 0);
          margin: 5px;
          outline-style: none;
          transition: box-shadow 0.2s ease-in-out, background, 0.2s ease-in-out;
        }

        button:focus {
          background-color: rgba(49, 50, 68, 0.1);
        }

        button:hover {
          background-color: rgba(30, 203, 225, 0.1)
        }

        #lock {
          background-image: image(url("/home/daviddeadly/.config/wlogout/icons/lock.png"));
          background-size: 70%;
        }

        #lock:hover {
          background-image: image(url("/home/daviddeadly/.config/wlogout/icons/lock-hover.png"));
        }

        #logout {
          background-image: image(url("/home/daviddeadly/.config/wlogout/icons/logout.png"));
        }

        #logout:hover {
          background-image: image(url("/home/daviddeadly/.config/wlogout/icons/logout-hover.png"));
        }

        #suspend {
          background-image: image(url("/home/daviddeadly/.config/wlogout/icons/sleep.png"));
        } 

        #suspend:hover {
          background-image: image(url("/home/daviddeadly/.config/wlogout/icons/sleep-hover.png"));
        }

        #shutdown {
          background-image: image(url("/home/daviddeadly/.config/wlogout/icons/power.png"));
        }

        #shutdown:hover {
          background-image: image(url("/home/daviddeadly/.config/wlogout/icons/power-hover.png"));
        }

        #reboot {
          background-image: image(url("/home/daviddeadly/.config/wlogout/icons/restart.png"));
        }

        #reboot:hover {
          background-image: image(url("/home/daviddeadly/.config/wlogout/icons/restart-hover.png"));
        }
      '';
    };

    hyprlock = {
      enable = true;
      settings = {
        general = {
          grace = 10;
          hide_cursor = true;
          ignore_empty_input = true;
        };

        background = {
          path = "${./images/mountain-view.png}";
          color = "rgb(84,147,171)";
          blur_passes = 3;
          blur_size = 3;
          noise = 0.0117;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        };

        image = {
          path = "${./images/me.jpeg}";
          size = 200;
          border_color = "rgb(84,147,171)";
          position = "0, 150";
          halign = "center";
          valign = "center";
        };

        label = {
          text = "$TIME";
          color = "rgb(10, 10, 10)";
          font_size = 90;
          font_family = "CaskaydiaCove NFM Bold";
          position = "0, -150";
          halign = "center";
          valign = "top";
        };

        input-field = {
          size = "300, 60";
          outline_thickness = 4;
          dots_size = 0.2;
          dots_spacing = 0.2;
          dots_center = true;
          outer_color = "rgb(84,147,171)";
          inner_color = "rgb(10, 10, 10)";
          font_color = "rgb(84,147,171)";
          fade_on_empty = false;
          placeholder_text = ''<span foreground="##cdd6f4"><i>󰌾 Logged in as </i><span foreground="##5493ab">$USER</span></span>'';
          hide_input = false;
          check_color = "rgb(204, 136, 34)";
          fail_color = "rgb(204, 34, 34)";
          fail_text = ''<i>$FAIL <b>($ATTEMPTS)</b></i>'';
          capslock_color = -1;
          position = "0, 0";
          halign = "center";
          valign = "center";
        };
      };
    };

    wofi = {
      enable = true;
      settings = {
        width = 700;
        allow_images = true;
      };

      style = ''
        * {
          border-radius: 15px;
        }

        window {
          font-size: 32px;
          font-family: "Roboto mono Medium";
          background-color: transparent;
          color: #cdd6f4;
        }

        #input {
          border: none;
          background-color: rgba(17, 17, 27, .9);
          color: #89b4fa;
          margin-bottom: 15px;
          padding: 10px;
        }

        #inner-box {
          background-color: rgba(30, 30, 46, .9);
        }

        image {
          margin-left: 10px;
          margin-right: 10px;
        }

        #entry {
          padding: 10px;
        }

        #entry:selected {
          outline: none;
          background-color: #94e2d5;
          background: linear-gradient(90deg, #94e2d5, #cba6f7);
        }

        #text:selected {
          color: #333333;
        }
      '';
    };

    kitty = {
      enable = true;
      theme = "Catppuccin-Mocha";
      shellIntegration.enableZshIntegration = true;

      settings = {
        font_size = 13;
        font_family = "CaskaydiaCove NFM Regular";
        bold_font = "CaskaydiaCove NFM Bold";
        italic_font = "CaskaydiaCove NFM Italic";
        bold_italic_font = "CaskaydiaCove NFM Bold Italic";

        disable_ligatures = "never";
        background_tint = "0.9";
        background_image = "${./images/solitude.png}";
        background_image_layout = "scaled";

        cursor_shape = "block";
        cursor_beam_thickness = "1.5";
        cursor_underline_thickness = "2.0";
        cursor_blink_interval = "-1";
        cursor_stop_blinking_after = "15.0";
        mouse_hide_wait = "3.0";

        scrollback_lines = 2000;

        url_style = "curly";
        open_url_with = "default";
        url_prefixes = "file ftp ftps gemini git gopher http https irc ircs kitty mailto news sftp ssh";
        detect_urls = true;

        enabled_layouts = "*";
        hide_window_decorations = true;

        tab_bar_style = "powerline";
        tab_powerline_style = "angled";
        tab_activity_symbol = "🔥";
        tab_title_template = "{index} {activity_symbol}{title[title.find(':')+1:]}";
        active_tab_font_style = "bold-italic";
        inactive_tab_font_style = "normal";
      };

      keybindings = {
        "alt+1" = "goto_tab 1";
        "alt+2" = "goto_tab 2";
        "alt+3" = "goto_tab 3";
        "alt+4" = "goto_tab 4";
        "alt+5" = "goto_tab 5";
        "alt+6" = "goto_tab 6";
        "alt+7" = "goto_tab 7";
        "alt+8" = "goto_tab 8";
        "alt+9" = "goto_tab 9";

        "ctrl+minus" = "change_font_size all -1.0";
        "ctrl+plus" = "change_font_size all +1.0";
        "ctrl+shift+backspace" = "change_font_size all 0";

        "shift+alt+t" = "set_tab_title";
        "ctrl+shift+." = "move_tab_forward";
        "ctrl+shift+," = "move_tab_backward";

        "ctrl+f2" = "launch --cwd=current";
        "ctrl+f3" = "launch --cwd=current --type=tab";

        "f4" = "toggle_layout stack";

        "ctrl+shift+z" = "scroll_to_prompt -1";
        "ctrl+shift+x" = "scroll_to_prompt 1";
      };
    };

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
        dragon-out = ''%${pkgs.xdragon}/bin/xdragon -a -x "$fx "'';
        editor-open = ''$$EDITOR $f'';
        preview = ''''$${pkgs.bat}/bin/bat --paging=always "$
            f "'';
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




