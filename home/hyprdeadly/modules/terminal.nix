{ pkgs, pkgs-unstable, ... }:
{

  xdg.configFile = {
    "lf/icons".source = ../../../.config/lf/icons;
    "zellij".source = ../../../.config/zellij;
  };

  programs = {
    btop.enable = true;
    zellij.enable = true;

    bat = {
      enable = true;
      config.theme = "OneHalfDark";
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
      package = pkgs-unstable.oh-my-posh;
      enableZshIntegration = true;
      useTheme = "catppuccin_mocha";
      settings = builtins.fromJSON (
        builtins.unsafeDiscardStringContext (
          builtins.readFile ../../../.config/oh-my-posh/daviddeadly.omp.json
        )
      );
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
        background_image = "${../../../images/solitude.png}";
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
  };
}
