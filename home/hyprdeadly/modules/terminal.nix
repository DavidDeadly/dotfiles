{ pkgs, pkgs-unstable, ... }:
{

  xdg.configFile = {
    "zellij".source = ../../../.config/zellij;
  };

  home.packages = with pkgs; [
    jq # json parser
    fd # file finder
    fzf # fuzzy finder
    rm-improved # better rm
    delta # git diff
  ];

  programs = {
    btop.enable = true;
    zellij.enable = true;

    bat = {
      enable = true;
      config.theme = "OneHalfDark";
    };

    eza = {
      enable = true;
      enableZshIntegration = true;
      git = true;
      icons = true;
      extraOptions = [
        "--long"
        "--color=always"
        "--no-time"
        "--no-user"
        "--no-filesize"
        "--no-permissions"
      ];
    };

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      initExtra = ''
        eval "$(fzf --zsh)"

        PATH=$PATH:~/AppImages

        # -- Use fd instead of fzf --

        export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

        # Use fd (https://github.com/sharkdp/fd) for listing path candidates.
        # - The first argument to the function ($1) is the base path to start traversal
        # - See the source code (completion.{bash,zsh}) for the details.
        _fzf_compgen_path() {
          fd --hidden --exclude .git . "$1"
        }

        # Use fd to generate the list for directory completion
        _fzf_compgen_dir() {
          fd --type=d --hidden --exclude .git . "$1"
        }

        source ${pkgs.fzf-git-sh}/share/fzf-git-sh/fzf-git.sh # git integration for fzf

        # fzf theme
        export FZF_DEFAULT_OPTS=" \
        --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
        --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
        --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
        --color=selected-bg:#45475a \
        --multi"

        dir_tree="eza --tree --color=always {} | head -200"
        show_file_or_dir_preview="if [ -d {} ]; then $dir_tree; else bat -n --color=always --line-range :500 {}; fi"

        export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
        export FZF_ALT_C_OPTS="--preview '$dir_tree'"

        # Advanced customization of fzf options via _fzf_comprun function
        # - The first argument to the function is the name of the command.
        # - You should make sure to pass the rest of the arguments to fzf.
        _fzf_comprun() {
          local command=$1
          shift

          case "$command" in
            cd)           fzf --preview "$dir_tree" "$@" ;;
            export|unset) fzf --preview "eval 'printenv {}'" "$@" ;;
            ssh)          fzf --preview '${pkgs.dogdns}/bin/dog {}' "$@" ;;
            *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
          esac
        }
      '';
      shellAliases = {
        ".." = "cd ..";
        vi = "nvim";
        vim = "nvim";
        vimdiff = "nvim -d";
        cat = "bat --theme=Dracula";
        ls = "eza";
        rm = "rip";
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

    foot = {
      enable = true;
      settings = {
        main = {
          term = "xterm-256color";

          font = "CaskaydiaCove NFM:size=8";
          dpi-aware = "yes";
        };

        cursor = {
          style = "block";
        };

        mouse = {
          hide-when-typing = true;
        };

        colors = {
          foreground = "cdd6f4";
          background = "1e1e2e";

          regular0 = "45475a";
          regular1 = "f38ba8";
          regular2 = "a6e3a1";
          regular3 = "f9e2af";
          regular4 = "89b4fa";
          regular5 = "f5c2e7";
          regular6 = "94e2d5";
          regular7 = "bac2de";

          bright0 = "585b70";
          bright1 = "f38ba8";
          bright2 = "a6e3a1";
          bright3 = "f9e2af";
          bright4 = "89b4fa";
          bright5 = "f5c2e7";
          bright6 = "94e2d5";
          bright7 = "a6adc8";

          selection-foreground = "cdd6f4";
          selection-background = "414356";

          search-box-no-match = "11111b f38ba8";
          search-box-match = "cdd6f4 313244";

          jump-labels = "11111b fab387";
          urls = "89b4fa";
        };
      };
    };

    yazi = {
      enable = true;

      theme = {
        manager = {

          cwd = {
            fg = "#94e2d5";
          };

          hovered = { fg = "#1e1e2e"; bg = "#89b4fa"; };
          preview_hovered = {
            underline = true;
          };

          # find
          find_keyword = { fg = "#f9e2af"; italic = true; };
          find_position = { fg = "#f5c2e7"; bg = "reset"; italic = true; };

          # marker
          marker_copied = { fg = "#a6e3a1"; bg = "#a6e3a1"; };
          marker_cut = { fg = "#f38ba8"; bg = "#f38ba8"; };
          marker_selected = { fg = "#89b4fa"; bg = "#89b4fa"; };

          # tab
          tab_active = { fg = "#1e1e2e"; bg = "#cdd6f4"; };
          tab_inactive = { fg = "#cdd6f4"; bg = "#45475a"; };
          tab_width = 1;

          # count
          count_copied = { fg = "#1e1e2e"; bg = "#a6e3a1"; };
          count_cut = { fg = "#1e1e2e"; bg = "#f38ba8"; };
          count_selected = { fg = "#1e1e2e"; bg = "#89b4fa"; };

          # border
          border_symbol = "│";
          border_style = { fg = "#7f849c"; };
        };

        status = {
          separator_open = "";
          separator_close = "";
          separator_style = { fg = "#45475a"; bg = "#45475a"; };

          # mode
          mode_normal = { fg = "#1e1e2e"; bg = "#89b4fa"; bold = true; };
          mode_select = { fg = "#1e1e2e"; bg = "#a6e3a1"; bold = true; };
          mode_unset = { fg = "#1e1e2e"; bg = "#f2cdcd"; bold = true; };

          # progress
          progress_label = { fg = "#ffffff"; bold = true; };
          progress_normal = { fg = "#89b4fa"; bg = "#45475a"; };
          progress_error = { fg = "#f38ba8"; bg = "#45475a"; };

          # permissions
          permissions_t = { fg = "#89b4fa"; };
          permissions_r = { fg = "#f9e2af"; };
          permissions_w = { fg = "#f38ba8"; };
          permissions_x = { fg = "#a6e3a1"; };
          permissions_s = { fg = "#7f849c"; };
        };

        input = {
          border = { fg = "#89b4fa"; };
          title = { };
          value = { };
          selected = { reversed = true; };
        };

        select = {
          border = { fg = "#89b4fa"; };
          active = { fg = "#f5c2e7"; };
          inactive = { };
        };

        tasks = {
          border = { fg = "#89b4fa"; };
          title = { };
          hovered = {
            underline = true;
          };
        };

        which = {
          mask = { bg = "#313244"; };
          cand = { fg = "#94e2d5"; };
          rest = { fg = "#9399b2"; };
          desc = { fg = "#f5c2e7"; };
          separator = "  ";
          separator_style = { fg = "#585b70"; };
        };

        help = {
          on = { fg = "#f5c2e7"; };
          exec = { fg = "#94e2d5"; };
          desc = { fg = "#9399b2"; };
          hovered = { bg = "#585b70"; bold = true; };
          footer = { fg = "#45475a"; bg = "#cdd6f4"; };
        };

        filetype = {
          rules = [
            # images
            { mime = "image/*"; fg = "#94e2d5"; }

            # videos
            { mime = "video/*"; fg = "#f9e2af"; }
            { mime = "audio/*"; fg = "#f9e2af"; }

            # archives
            { mime = "application/zip"; fg = "#f5c2e7"; }
            { mime = "application/gzip"; fg = "#f5c2e7"; }
            { mime = "application/x-tar"; fg = "#f5c2e7"; }
            { mime = "application/x-bzip"; fg = "#f5c2e7"; }
            { mime = "application/x-bzip2"; fg = "#f5c2e7"; }
            { mime = "application/x-7z-compressed"; fg = "#f5c2e7"; }
            { mime = "application/x-rar"; fg = "#f5c2e7"; }

            # fallback
            { name = "*"; fg = "#cdd6f4"; }
            { name = "*/"; fg = "#89b4fa"; }
          ];
        };

        icon = {
          prepend_rules = [
            { name = ".srcinfo"; text = "󰣇"; fg = "#89b4fa"; }
            { name = ".xauthority"; text = ""; fg = "#fab387"; }
            { name = ".xresources"; text = ""; fg = "#fab387"; }
            { name = ".babelrc"; text = ""; fg = "#f9e2af"; }
            { name = ".bash_profile"; text = ""; fg = "#a6e3a1"; }
            { name = ".bashrc"; text = ""; fg = "#a6e3a1"; }
            { name = ".dockerignore"; text = "󰡨"; fg = "#89b4fa"; }
            { name = ".ds_store"; text = ""; fg = "#45475a"; }
            { name = ".editorconfig"; text = ""; fg = "#f5e0dc"; }
            { name = ".env"; text = ""; fg = "#f9e2af"; }
            { name = ".eslintignore"; text = ""; fg = "#585b70"; }
            { name = ".eslintrc"; text = ""; fg = "#585b70"; }
            { name = ".gitattributes"; text = ""; fg = "#fab387"; }
            { name = ".gitconfig"; text = ""; fg = "#fab387"; }
            { name = ".gitignore"; text = ""; fg = "#fab387"; }
            { name = ".gitlab-ci.yml"; text = ""; fg = "#fab387"; }
            { name = ".gitmodules"; text = ""; fg = "#fab387"; }
            { name = ".gtkrc-2.0"; text = ""; fg = "#f5e0dc"; }
            { name = ".gvimrc"; text = ""; fg = "#a6e3a1"; }
            { name = ".justfile"; text = ""; fg = "#7f849c"; }
            { name = ".luaurc"; text = ""; fg = "#89b4fa"; }
            { name = ".mailmap"; text = "󰊢"; fg = "#45475a"; }
            { name = ".npmignore"; text = ""; fg = "#f38ba8"; }
            { name = ".npmrc"; text = ""; fg = "#f38ba8"; }
            { name = ".nvmrc"; text = ""; fg = "#a6e3a1"; }
            { name = ".prettierrc"; text = ""; fg = "#89b4fa"; }
            { name = ".settings.json"; text = ""; fg = "#6c7086"; }
            { name = ".vimrc"; text = ""; fg = "#a6e3a1"; }
            { name = ".xinitrc"; text = ""; fg = "#fab387"; }
            { name = ".xsession"; text = ""; fg = "#fab387"; }
            { name = ".zprofile"; text = ""; fg = "#a6e3a1"; }
            { name = ".zshenv"; text = ""; fg = "#a6e3a1"; }
            { name = ".zshrc"; text = ""; fg = "#a6e3a1"; }
            { name = "freecad.conf"; text = ""; fg = "#f38ba8"; }
            { name = "pkgbuild"; text = ""; fg = "#89b4fa"; }
            { name = "prusaslicer.ini"; text = ""; fg = "#fab387"; }
            { name = "prusaslicergcodeviewer.ini"; text = ""; fg = "#fab387"; }
            { name = "qtproject.conf"; text = ""; fg = "#a6e3a1"; }
            { name = "r"; text = "󰟔"; fg = "#6c7086"; }
            { name = "_gvimrc"; text = ""; fg = "#a6e3a1"; }
            { name = "_vimrc"; text = ""; fg = "#a6e3a1"; }
            { name = "avif"; text = ""; fg = "#7f849c"; }
            { name = "brewfile"; text = ""; fg = "#313244"; }
            { name = "bspwmrc"; text = ""; fg = "#313244"; }
            { name = "build"; text = ""; fg = "#a6e3a1"; }
            { name = "build.gradle"; text = ""; fg = "#585b70"; }
            { name = "build.zig.zon"; text = ""; fg = "#fab387"; }
            { name = "cantorrc"; text = ""; fg = "#89b4fa"; }
            { name = "checkhealth"; text = "󰓙"; fg = "#89b4fa"; }
            { name = "cmakelists.txt"; text = ""; fg = "#7f849c"; }
            { name = "commit_editmsg"; text = ""; fg = "#fab387"; }
            { name = "compose.yaml"; text = "󰡨"; fg = "#89b4fa"; }
            { name = "compose.yml"; text = "󰡨"; fg = "#89b4fa"; }
            { name = "config"; text = ""; fg = "#7f849c"; }
            { name = "containerfile"; text = "󰡨"; fg = "#89b4fa"; }
            { name = "copying"; text = ""; fg = "#f9e2af"; }
            { name = "copying.lesser"; text = ""; fg = "#f9e2af"; }
            { name = "docker-compose.yaml"; text = "󰡨"; fg = "#89b4fa"; }
            { name = "docker-compose.yml"; text = "󰡨"; fg = "#89b4fa"; }
            { name = "dockerfile"; text = "󰡨"; fg = "#89b4fa"; }
            { name = "ext_typoscript_setup.txt"; text = ""; fg = "#fab387"; }
            { name = "favicon.ico"; text = ""; fg = "#f9e2af"; }
            { name = "fp-info-cache"; text = ""; fg = "#f5e0dc"; }
            { name = "fp-lib-table"; text = ""; fg = "#f5e0dc"; }
            { name = "gemfile$"; text = ""; fg = "#313244"; }
            { name = "gnumakefile"; text = ""; fg = "#7f849c"; }
            { name = "gradle-wrapper.properties"; text = ""; fg = "#585b70"; }
            { name = "gradle.properties"; text = ""; fg = "#585b70"; }
            { name = "gradlew"; text = ""; fg = "#585b70"; }
            { name = "groovy"; text = ""; fg = "#585b70"; }
            { name = "gruntfile.babel.js"; text = ""; fg = "#fab387"; }
            { name = "gruntfile.coffee"; text = ""; fg = "#fab387"; }
            { name = "gruntfile.js"; text = ""; fg = "#fab387"; }
            { name = "gruntfile.ts"; text = ""; fg = "#fab387"; }
            { name = "gtkrc"; text = ""; fg = "#f5e0dc"; }
            { name = "gulpfile.babel.js"; text = ""; fg = "#f38ba8"; }
            { name = "gulpfile.coffee"; text = ""; fg = "#f38ba8"; }
            { name = "gulpfile.js"; text = ""; fg = "#f38ba8"; }
            { name = "gulpfile.ts"; text = ""; fg = "#f38ba8"; }
            { name = "hyprland.conf"; text = ""; fg = "#74c7ec"; }
            { name = "i3blocks.conf"; text = ""; fg = "#f5e0dc"; }
            { name = "i3status.conf"; text = ""; fg = "#f5e0dc"; }
            { name = "justfile"; text = ""; fg = "#7f849c"; }
            { name = "kalgebrarc"; text = ""; fg = "#89b4fa"; }
            { name = "kdeglobals"; text = ""; fg = "#89b4fa"; }
            { name = "kdenlive-layoutsrc"; text = ""; fg = "#89b4fa"; }
            { name = "kdenliverc"; text = ""; fg = "#89b4fa"; }
            { name = "kritadisplayrc"; text = ""; fg = "#cba6f7"; }
            { name = "kritarc"; text = ""; fg = "#cba6f7"; }
            { name = "license"; text = ""; fg = "#f9e2af"; }
            { name = "lxde-rc.xml"; text = ""; fg = "#9399b2"; }
            { name = "lxqt.conf"; text = ""; fg = "#89b4fa"; }
            { name = "makefile"; text = ""; fg = "#7f849c"; }
            { name = "mix.lock"; text = ""; fg = "#7f849c"; }
            { name = "mpv.conf"; text = ""; fg = "#1e1e2e"; }
            { name = "node_modules"; text = ""; fg = "#f38ba8"; }
            { name = "package-lock.json"; text = ""; fg = "#313244"; }
            { name = "package.json"; text = ""; fg = "#f38ba8"; }
            { name = "platformio.ini"; text = ""; fg = "#fab387"; }
            { name = "pom.xml"; text = ""; fg = "#313244"; }
            { name = "procfile"; text = ""; fg = "#7f849c"; }
            { name = "py.typed"; text = ""; fg = "#f9e2af"; }
            { name = "r"; text = "󰟔"; fg = "#6c7086"; }
            { name = "rakefile"; text = ""; fg = "#313244"; }
            { name = "rmd"; text = ""; fg = "#74c7ec"; }
            { name = "settings.gradle"; text = ""; fg = "#585b70"; }
            { name = "svelte.config.js"; text = ""; fg = "#fab387"; }
            { name = "sxhkdrc"; text = ""; fg = "#313244"; }
            { name = "sym-lib-table"; text = ""; fg = "#f5e0dc"; }
            { name = "tailwind.config.js"; text = "󱏿"; fg = "#74c7ec"; }
            { name = "tailwind.config.mjs"; text = "󱏿"; fg = "#74c7ec"; }
            { name = "tailwind.config.ts"; text = "󱏿"; fg = "#74c7ec"; }
            { name = "tmux.conf"; text = ""; fg = "#a6e3a1"; }
            { name = "tmux.conf.local"; text = ""; fg = "#a6e3a1"; }
            { name = "tsconfig.json"; text = ""; fg = "#74c7ec"; }
            { name = "unlicense"; text = ""; fg = "#f9e2af"; }
            { name = "vagrantfile$"; text = ""; fg = "#6c7086"; }
            { name = "vlcrc"; text = "󰕼"; fg = "#fab387"; }
            { name = "webpack"; text = "󰜫"; fg = "#74c7ec"; }
            { name = "weston.ini"; text = ""; fg = "#f9e2af"; }
            { name = "workspace"; text = ""; fg = "#a6e3a1"; }
            { name = "xmobarrc"; text = ""; fg = "#f38ba8"; }
            { name = "xmobarrc.hs"; text = ""; fg = "#f38ba8"; }
            { name = "xmonad.hs"; text = ""; fg = "#f38ba8"; }
            { name = "xorg.conf"; text = ""; fg = "#fab387"; }
            { name = "xsettingsd.conf"; text = ""; fg = "#fab387"; }
            { name = "*.3gp"; text = ""; fg = "#fab387"; }
            { name = "*.3mf"; text = "󰆧"; fg = "#7f849c"; }
            { name = "*.7z"; text = ""; fg = "#fab387"; }
            { name = "*.dockerfile"; text = "󰡨"; fg = "#89b4fa"; }
            { name = "*.a"; text = ""; fg = "#f5e0dc"; }
            { name = "*.aac"; text = ""; fg = "#74c7ec"; }
            { name = "*.ai"; text = ""; fg = "#f9e2af"; }
            { name = "*.aif"; text = ""; fg = "#74c7ec"; }
            { name = "*.aiff"; text = ""; fg = "#74c7ec"; }
            { name = "*.android"; text = ""; fg = "#a6e3a1"; }
            { name = "*.ape"; text = ""; fg = "#74c7ec"; }
            { name = "*.apk"; text = ""; fg = "#a6e3a1"; }
            { name = "*.app"; text = ""; fg = "#45475a"; }
            { name = "*.applescript"; text = ""; fg = "#7f849c"; }
            { name = "*.asc"; text = "󰦝"; fg = "#6c7086"; }
            { name = "*.ass"; text = "󰨖"; fg = "#f9e2af"; }
            { name = "*.astro"; text = ""; fg = "#f38ba8"; }
            { name = "*.awk"; text = ""; fg = "#585b70"; }
            { name = "*.azcli"; text = ""; fg = "#6c7086"; }
            { name = "*.bak"; text = "󰁯"; fg = "#7f849c"; }
            { name = "*.bash"; text = ""; fg = "#a6e3a1"; }
            { name = "*.bat"; text = ""; fg = "#a6e3a1"; }
            { name = "*.bazel"; text = ""; fg = "#a6e3a1"; }
            { name = "*.bib"; text = "󱉟"; fg = "#f9e2af"; }
            { name = "*.bicep"; text = ""; fg = "#74c7ec"; }
            { name = "*.bicepparam"; text = ""; fg = "#7f849c"; }
            { name = "*.bin"; text = ""; fg = "#45475a"; }
            { name = "*.blade.php"; text = ""; fg = "#f38ba8"; }
            { name = "*.blend"; text = "󰂫"; fg = "#fab387"; }
            { name = "*.blp"; text = "󰺾"; fg = "#89b4fa"; }
            { name = "*.bmp"; text = ""; fg = "#7f849c"; }
            { name = "*.brep"; text = "󰻫"; fg = "#a6e3a1"; }
            { name = "*.bz"; text = ""; fg = "#fab387"; }
            { name = "*.bz2"; text = ""; fg = "#fab387"; }
            { name = "*.bz3"; text = ""; fg = "#fab387"; }
            { name = "*.bzl"; text = ""; fg = "#a6e3a1"; }
            { name = "*.c"; text = ""; fg = "#89b4fa"; }
            { name = "*.c++"; text = ""; fg = "#f38ba8"; }
            { name = "*.cache"; text = ""; fg = "#f5e0dc"; }
            { name = "*.cast"; text = ""; fg = "#fab387"; }
            { name = "*.cbl"; text = "⚙"; fg = "#585b70"; }
            { name = "*.cc"; text = ""; fg = "#f38ba8"; }
            { name = "*.ccm"; text = ""; fg = "#f38ba8"; }
            { name = "*.cfg"; text = ""; fg = "#7f849c"; }
            { name = "*.cjs"; text = ""; fg = "#f9e2af"; }
            { name = "*.clj"; text = ""; fg = "#a6e3a1"; }
            { name = "*.cljc"; text = ""; fg = "#a6e3a1"; }
            { name = "*.cljd"; text = ""; fg = "#74c7ec"; }
            { name = "*.cljs"; text = ""; fg = "#74c7ec"; }
            { name = "*.cmake"; text = ""; fg = "#7f849c"; }
            { name = "*.cob"; text = "⚙"; fg = "#585b70"; }
            { name = "*.cobol"; text = "⚙"; fg = "#585b70"; }
            { name = "*.coffee"; text = ""; fg = "#f9e2af"; }
            { name = "*.conf"; text = ""; fg = "#7f849c"; }
            { name = "*.config.ru"; text = ""; fg = "#313244"; }
            { name = "*.cp"; text = ""; fg = "#74c7ec"; }
            { name = "*.cpp"; text = ""; fg = "#74c7ec"; }
            { name = "*.cppm"; text = ""; fg = "#74c7ec"; }
            { name = "*.cpy"; text = "⚙"; fg = "#585b70"; }
            { name = "*.cr"; text = ""; fg = "#f5e0dc"; }
            { name = "*.crdownload"; text = ""; fg = "#94e2d5"; }
            { name = "*.cs"; text = "󰌛"; fg = "#585b70"; }
            { name = "*.csh"; text = ""; fg = "#585b70"; }
            { name = "*.cshtml"; text = "󱦗"; fg = "#585b70"; }
            { name = "*.cson"; text = ""; fg = "#f9e2af"; }
            { name = "*.csproj"; text = "󰪮"; fg = "#585b70"; }
            { name = "*.css"; text = ""; fg = "#89b4fa"; }
            { name = "*.csv"; text = ""; fg = "#a6e3a1"; }
            { name = "*.cts"; text = ""; fg = "#74c7ec"; }
            { name = "*.cu"; text = ""; fg = "#a6e3a1"; }
            { name = "*.cue"; text = "󰲹"; fg = "#f38ba8"; }
            { name = "*.cuh"; text = ""; fg = "#7f849c"; }
            { name = "*.cxx"; text = ""; fg = "#74c7ec"; }
            { name = "*.cxxm"; text = ""; fg = "#74c7ec"; }
            { name = "*.d"; text = ""; fg = "#a6e3a1"; }
            { name = "*.d.ts"; text = ""; fg = "#fab387"; }
            { name = "*.dart"; text = ""; fg = "#585b70"; }
            { name = "*.db"; text = ""; fg = "#f5e0dc"; }
            { name = "*.dconf"; text = ""; fg = "#f5e0dc"; }
            { name = "*.desktop"; text = ""; fg = "#45475a"; }
            { name = "*.diff"; text = ""; fg = "#45475a"; }
            { name = "*.dll"; text = ""; fg = "#11111b"; }
            { name = "*.doc"; text = "󰈬"; fg = "#585b70"; }
            { name = "*.docx"; text = "󰈬"; fg = "#585b70"; }
            { name = "*.dot"; text = "󱁉"; fg = "#585b70"; }
            { name = "*.download"; text = ""; fg = "#94e2d5"; }
            { name = "*.drl"; text = ""; fg = "#eba0ac"; }
            { name = "*.dropbox"; text = ""; fg = "#6c7086"; }
            { name = "*.dump"; text = ""; fg = "#f5e0dc"; }
            { name = "*.dwg"; text = "󰻫"; fg = "#a6e3a1"; }
            { name = "*.dxf"; text = "󰻫"; fg = "#a6e3a1"; }
            { name = "*.ebook"; text = ""; fg = "#fab387"; }
            { name = "*.edn"; text = ""; fg = "#74c7ec"; }
            { name = "*.eex"; text = ""; fg = "#7f849c"; }
            { name = "*.ejs"; text = ""; fg = "#f9e2af"; }
            { name = "*.el"; text = ""; fg = "#7f849c"; }
            { name = "*.elc"; text = ""; fg = "#7f849c"; }
            { name = "*.elf"; text = ""; fg = "#45475a"; }
            { name = "*.elm"; text = ""; fg = "#74c7ec"; }
            { name = "*.eln"; text = ""; fg = "#7f849c"; }
            { name = "*.env"; text = ""; fg = "#f9e2af"; }
            { name = "*.eot"; text = ""; fg = "#f5e0dc"; }
            { name = "*.epp"; text = ""; fg = "#fab387"; }
            { name = "*.epub"; text = ""; fg = "#fab387"; }
            { name = "*.erb"; text = ""; fg = "#313244"; }
            { name = "*.erl"; text = ""; fg = "#f38ba8"; }
            { name = "*.ex"; text = ""; fg = "#7f849c"; }
            { name = "*.exe"; text = ""; fg = "#45475a"; }
            { name = "*.exs"; text = ""; fg = "#7f849c"; }
            { name = "*.f#"; text = ""; fg = "#74c7ec"; }
            { name = "*.f3d"; text = "󰻫"; fg = "#a6e3a1"; }
            { name = "*.f90"; text = "󱈚"; fg = "#585b70"; }
            { name = "*.fbx"; text = "󰆧"; fg = "#7f849c"; }
            { name = "*.fcbak"; text = ""; fg = "#f38ba8"; }
            { name = "*.fcmacro"; text = ""; fg = "#f38ba8"; }
            { name = "*.fcmat"; text = ""; fg = "#f38ba8"; }
            { name = "*.fcparam"; text = ""; fg = "#f38ba8"; }
            { name = "*.fcscript"; text = ""; fg = "#f38ba8"; }
            { name = "*.fcstd"; text = ""; fg = "#f38ba8"; }
            { name = "*.fcstd1"; text = ""; fg = "#f38ba8"; }
            { name = "*.fctb"; text = ""; fg = "#f38ba8"; }
            { name = "*.fctl"; text = ""; fg = "#f38ba8"; }
            { name = "*.fdmdownload"; text = ""; fg = "#94e2d5"; }
            { name = "*.fish"; text = ""; fg = "#585b70"; }
            { name = "*.flac"; text = ""; fg = "#6c7086"; }
            { name = "*.flc"; text = ""; fg = "#f5e0dc"; }
            { name = "*.flf"; text = ""; fg = "#f5e0dc"; }
            { name = "*.fnl"; text = ""; fg = "#f9e2af"; }
            { name = "*.fs"; text = ""; fg = "#74c7ec"; }
            { name = "*.fsi"; text = ""; fg = "#74c7ec"; }
            { name = "*.fsscript"; text = ""; fg = "#74c7ec"; }
            { name = "*.fsx"; text = ""; fg = "#74c7ec"; }
            { name = "*.gcode"; text = "󰐫"; fg = "#6c7086"; }
            { name = "*.gd"; text = ""; fg = "#7f849c"; }
            { name = "*.gemspec"; text = ""; fg = "#313244"; }
            { name = "*.gif"; text = ""; fg = "#7f849c"; }
            { name = "*.git"; text = ""; fg = "#fab387"; }
            { name = "*.glb"; text = ""; fg = "#fab387"; }
            { name = "*.gnumakefile"; text = ""; fg = "#7f849c"; }
            { name = "*.go"; text = ""; fg = "#74c7ec"; }
            { name = "*.godot"; text = ""; fg = "#7f849c"; }
            { name = "*.gql"; text = ""; fg = "#f38ba8"; }
            { name = "*.graphql"; text = ""; fg = "#f38ba8"; }
            { name = "*.gresource"; text = ""; fg = "#f5e0dc"; }
            { name = "*.gv"; text = "󱁉"; fg = "#585b70"; }
            { name = "*.gz"; text = ""; fg = "#fab387"; }
            { name = "*.h"; text = ""; fg = "#7f849c"; }
            { name = "*.haml"; text = ""; fg = "#f5e0dc"; }
            { name = "*.hbs"; text = ""; fg = "#fab387"; }
            { name = "*.heex"; text = ""; fg = "#7f849c"; }
            { name = "*.hex"; text = ""; fg = "#6c7086"; }
            { name = "*.hh"; text = ""; fg = "#7f849c"; }
            { name = "*.hpp"; text = ""; fg = "#7f849c"; }
            { name = "*.hrl"; text = ""; fg = "#f38ba8"; }
            { name = "*.hs"; text = ""; fg = "#7f849c"; }
            { name = "*.htm"; text = ""; fg = "#fab387"; }
            { name = "*.html"; text = ""; fg = "#fab387"; }
            { name = "*.huff"; text = "󰡘"; fg = "#585b70"; }
            { name = "*.hurl"; text = ""; fg = "#f38ba8"; }
            { name = "*.hx"; text = ""; fg = "#fab387"; }
            { name = "*.hxx"; text = ""; fg = "#7f849c"; }
            { name = "*.ical"; text = ""; fg = "#313244"; }
            { name = "*.icalendar"; text = ""; fg = "#313244"; }
            { name = "*.ico"; text = ""; fg = "#f9e2af"; }
            { name = "*.ics"; text = ""; fg = "#313244"; }
            { name = "*.ifb"; text = ""; fg = "#313244"; }
            { name = "*.ifc"; text = "󰻫"; fg = "#a6e3a1"; }
            { name = "*.ige"; text = "󰻫"; fg = "#a6e3a1"; }
            { name = "*.iges"; text = "󰻫"; fg = "#a6e3a1"; }
            { name = "*.igs"; text = "󰻫"; fg = "#a6e3a1"; }
            { name = "*.image"; text = ""; fg = "#f2cdcd"; }
            { name = "*.img"; text = ""; fg = "#f2cdcd"; }
            { name = "*.import"; text = ""; fg = "#f5e0dc"; }
            { name = "*.info"; text = ""; fg = "#f9e2af"; }
            { name = "*.ini"; text = ""; fg = "#7f849c"; }
            { name = "*.ino"; text = ""; fg = "#74c7ec"; }
            { name = "*.ipynb"; text = ""; fg = "#74c7ec"; }
            { name = "*.iso"; text = ""; fg = "#f2cdcd"; }
            { name = "*.ixx"; text = ""; fg = "#74c7ec"; }
            { name = "*.java"; text = ""; fg = "#f38ba8"; }
            { name = "*.jl"; text = ""; fg = "#7f849c"; }
            { name = "*.jpeg"; text = ""; fg = "#7f849c"; }
            { name = "*.jpg"; text = ""; fg = "#7f849c"; }
            { name = "*.js"; text = ""; fg = "#f9e2af"; }
            { name = "*.json"; text = ""; fg = "#f9e2af"; }
            { name = "*.json5"; text = ""; fg = "#f9e2af"; }
            { name = "*.jsonc"; text = ""; fg = "#f9e2af"; }
            { name = "*.jsx"; text = ""; fg = "#74c7ec"; }
            { name = "*.jwmrc"; text = ""; fg = "#6c7086"; }
            { name = "*.jxl"; text = ""; fg = "#7f849c"; }
            { name = "*.kbx"; text = "󰯄"; fg = "#6c7086"; }
            { name = "*.kdb"; text = ""; fg = "#a6e3a1"; }
            { name = "*.kdbx"; text = ""; fg = "#a6e3a1"; }
            { name = "*.kdenlive"; text = ""; fg = "#89b4fa"; }
            { name = "*.kdenlivetitle"; text = ""; fg = "#89b4fa"; }
            { name = "*.kicad_dru"; text = ""; fg = "#f5e0dc"; }
            { name = "*.kicad_mod"; text = ""; fg = "#f5e0dc"; }
            { name = "*.kicad_pcb"; text = ""; fg = "#f5e0dc"; }
            { name = "*.kicad_prl"; text = ""; fg = "#f5e0dc"; }
            { name = "*.kicad_pro"; text = ""; fg = "#f5e0dc"; }
            { name = "*.kicad_sch"; text = ""; fg = "#f5e0dc"; }
            { name = "*.kicad_sym"; text = ""; fg = "#f5e0dc"; }
            { name = "*.kicad_wks"; text = ""; fg = "#f5e0dc"; }
            { name = "*.ko"; text = ""; fg = "#f5e0dc"; }
            { name = "*.kpp"; text = ""; fg = "#cba6f7"; }
            { name = "*.kra"; text = ""; fg = "#cba6f7"; }
            { name = "*.krz"; text = ""; fg = "#cba6f7"; }
            { name = "*.ksh"; text = ""; fg = "#585b70"; }
            { name = "*.kt"; text = ""; fg = "#6c7086"; }
            { name = "*.kts"; text = ""; fg = "#6c7086"; }
            { name = "*.lck"; text = ""; fg = "#bac2de"; }
            { name = "*.leex"; text = ""; fg = "#7f849c"; }
            { name = "*.less"; text = ""; fg = "#45475a"; }
            { name = "*.lff"; text = ""; fg = "#f5e0dc"; }
            { name = "*.lhs"; text = ""; fg = "#7f849c"; }
            { name = "*.lib"; text = ""; fg = "#11111b"; }
            { name = "*.license"; text = ""; fg = "#f9e2af"; }
            { name = "*.liquid"; text = ""; fg = "#a6e3a1"; }
            { name = "*.lock"; text = ""; fg = "#bac2de"; }
            { name = "*.log"; text = "󰌱"; fg = "#f5e0dc"; }
            { name = "*.lrc"; text = "󰨖"; fg = "#f9e2af"; }
            { name = "*.lua"; text = ""; fg = "#74c7ec"; }
            { name = "*.luac"; text = ""; fg = "#74c7ec"; }
            { name = "*.luau"; text = ""; fg = "#89b4fa"; }
            { name = "*.m"; text = ""; fg = "#89b4fa"; }
            { name = "*.m3u"; text = "󰲹"; fg = "#f38ba8"; }
            { name = "*.m3u8"; text = "󰲹"; fg = "#f38ba8"; }
            { name = "*.m4a"; text = ""; fg = "#74c7ec"; }
            { name = "*.m4v"; text = ""; fg = "#fab387"; }
            { name = "*.magnet"; text = ""; fg = "#45475a"; }
            { name = "*.makefile"; text = ""; fg = "#7f849c"; }
            { name = "*.markdown"; text = ""; fg = "#f5e0dc"; }
            { name = "*.material"; text = "󰔉"; fg = "#f38ba8"; }
            { name = "*.md"; text = ""; fg = "#f5e0dc"; }
            { name = "*.md5"; text = "󰕥"; fg = "#7f849c"; }
            { name = "*.mdx"; text = ""; fg = "#74c7ec"; }
            { name = "*.mint"; text = "󰌪"; fg = "#a6e3a1"; }
            { name = "*.mjs"; text = ""; fg = "#f9e2af"; }
            { name = "*.mk"; text = ""; fg = "#7f849c"; }
            { name = "*.mkv"; text = ""; fg = "#fab387"; }
            { name = "*.ml"; text = ""; fg = "#fab387"; }
            { name = "*.mli"; text = ""; fg = "#fab387"; }
            { name = "*.mm"; text = ""; fg = "#74c7ec"; }
            { name = "*.mo"; text = "∞"; fg = "#7f849c"; }
            { name = "*.mobi"; text = ""; fg = "#fab387"; }
            { name = "*.mojo"; text = ""; fg = "#fab387"; }
            { name = "*.mov"; text = ""; fg = "#fab387"; }
            { name = "*.mp3"; text = ""; fg = "#74c7ec"; }
            { name = "*.mp4"; text = ""; fg = "#fab387"; }
            { name = "*.mpp"; text = ""; fg = "#74c7ec"; }
            { name = "*.msf"; text = ""; fg = "#89b4fa"; }
            { name = "*.mts"; text = ""; fg = "#74c7ec"; }
            { name = "*.mustache"; text = ""; fg = "#fab387"; }
            { name = "*.nfo"; text = ""; fg = "#f9e2af"; }
            { name = "*.nim"; text = ""; fg = "#f9e2af"; }
            { name = "*.nix"; text = ""; fg = "#74c7ec"; }
            { name = "*.nswag"; text = ""; fg = "#a6e3a1"; }
            { name = "*.nu"; text = ">"; fg = "#a6e3a1"; }
            { name = "*.o"; text = ""; fg = "#45475a"; }
            { name = "*.obj"; text = "󰆧"; fg = "#7f849c"; }
            { name = "*.ogg"; text = ""; fg = "#6c7086"; }
            { name = "*.opus"; text = ""; fg = "#6c7086"; }
            { name = "*.org"; text = ""; fg = "#94e2d5"; }
            { name = "*.otf"; text = ""; fg = "#f5e0dc"; }
            { name = "*.out"; text = ""; fg = "#45475a"; }
            { name = "*.part"; text = ""; fg = "#94e2d5"; }
            { name = "*.patch"; text = ""; fg = "#45475a"; }
            { name = "*.pck"; text = ""; fg = "#7f849c"; }
            { name = "*.pcm"; text = ""; fg = "#6c7086"; }
            { name = "*.pdf"; text = ""; fg = "#585b70"; }
            { name = "*.php"; text = ""; fg = "#7f849c"; }
            { name = "*.pl"; text = ""; fg = "#74c7ec"; }
            { name = "*.pls"; text = "󰲹"; fg = "#f38ba8"; }
            { name = "*.ply"; text = "󰆧"; fg = "#7f849c"; }
            { name = "*.pm"; text = ""; fg = "#74c7ec"; }
            { name = "*.png"; text = ""; fg = "#7f849c"; }
            { name = "*.po"; text = ""; fg = "#74c7ec"; }
            { name = "*.pot"; text = ""; fg = "#74c7ec"; }
            { name = "*.pp"; text = ""; fg = "#fab387"; }
            { name = "*.ppt"; text = "󰈧"; fg = "#f38ba8"; }
            { name = "*.prisma"; text = ""; fg = "#6c7086"; }
            { name = "*.pro"; text = ""; fg = "#f9e2af"; }
            { name = "*.ps1"; text = "󰨊"; fg = "#6c7086"; }
            { name = "*.psb"; text = ""; fg = "#74c7ec"; }
            { name = "*.psd"; text = ""; fg = "#74c7ec"; }
            { name = "*.psd1"; text = "󰨊"; fg = "#7f849c"; }
            { name = "*.psm1"; text = "󰨊"; fg = "#7f849c"; }
            { name = "*.pub"; text = "󰷖"; fg = "#f9e2af"; }
            { name = "*.pxd"; text = ""; fg = "#89b4fa"; }
            { name = "*.pxi"; text = ""; fg = "#89b4fa"; }
            { name = "*.py"; text = ""; fg = "#f9e2af"; }
            { name = "*.pyc"; text = ""; fg = "#f9e2af"; }
            { name = "*.pyd"; text = ""; fg = "#f9e2af"; }
            { name = "*.pyi"; text = ""; fg = "#f9e2af"; }
            { name = "*.pyo"; text = ""; fg = "#f9e2af"; }
            { name = "*.pyx"; text = ""; fg = "#89b4fa"; }
            { name = "*.qm"; text = ""; fg = "#74c7ec"; }
            { name = "*.qml"; text = ""; fg = "#a6e3a1"; }
            { name = "*.qrc"; text = ""; fg = "#a6e3a1"; }
            { name = "*.qss"; text = ""; fg = "#a6e3a1"; }
            { name = "*.query"; text = ""; fg = "#a6e3a1"; }
            { name = "*.r"; text = "󰟔"; fg = "#6c7086"; }
            { name = "*.rake"; text = ""; fg = "#313244"; }
            { name = "*.rar"; text = ""; fg = "#fab387"; }
            { name = "*.razor"; text = "󱦘"; fg = "#585b70"; }
            { name = "*.rb"; text = ""; fg = "#313244"; }
            { name = "*.res"; text = ""; fg = "#f38ba8"; }
            { name = "*.resi"; text = ""; fg = "#f38ba8"; }
            { name = "*.rlib"; text = ""; fg = "#fab387"; }
            { name = "*.rmd"; text = ""; fg = "#74c7ec"; }
            { name = "*.rproj"; text = "󰗆"; fg = "#a6e3a1"; }
            { name = "*.rs"; text = ""; fg = "#fab387"; }
            { name = "*.rss"; text = ""; fg = "#fab387"; }
            { name = "*.sass"; text = ""; fg = "#f38ba8"; }
            { name = "*.sbt"; text = ""; fg = "#f38ba8"; }
            { name = "*.sc"; text = ""; fg = "#f38ba8"; }
            { name = "*.scad"; text = ""; fg = "#f9e2af"; }
            { name = "*.scala"; text = ""; fg = "#f38ba8"; }
            { name = "*.scm"; text = "󰘧"; fg = "#f5e0dc"; }
            { name = "*.scss"; text = ""; fg = "#f38ba8"; }
            { name = "*.sh"; text = ""; fg = "#585b70"; }
            { name = "*.sha1"; text = "󰕥"; fg = "#7f849c"; }
            { name = "*.sha224"; text = "󰕥"; fg = "#7f849c"; }
            { name = "*.sha256"; text = "󰕥"; fg = "#7f849c"; }
            { name = "*.sha384"; text = "󰕥"; fg = "#7f849c"; }
            { name = "*.sha512"; text = "󰕥"; fg = "#7f849c"; }
            { name = "*.sig"; text = "λ"; fg = "#fab387"; }
            { name = "*.signature"; text = "λ"; fg = "#fab387"; }
            { name = "*.skp"; text = "󰻫"; fg = "#a6e3a1"; }
            { name = "*.sldasm"; text = "󰻫"; fg = "#a6e3a1"; }
            { name = "*.sldprt"; text = "󰻫"; fg = "#a6e3a1"; }
            { name = "*.slim"; text = ""; fg = "#fab387"; }
            { name = "*.sln"; text = ""; fg = "#6c7086"; }
            { name = "*.slvs"; text = "󰻫"; fg = "#a6e3a1"; }
            { name = "*.sml"; text = "λ"; fg = "#fab387"; }
            { name = "*.so"; text = ""; fg = "#f5e0dc"; }
            { name = "*.sol"; text = ""; fg = "#74c7ec"; }
            { name = "*.spec.js"; text = ""; fg = "#f9e2af"; }
            { name = "*.spec.jsx"; text = ""; fg = "#74c7ec"; }
            { name = "*.spec.ts"; text = ""; fg = "#74c7ec"; }
            { name = "*.spec.tsx"; text = ""; fg = "#585b70"; }
            { name = "*.sql"; text = ""; fg = "#f5e0dc"; }
            { name = "*.sqlite"; text = ""; fg = "#f5e0dc"; }
            { name = "*.sqlite3"; text = ""; fg = "#f5e0dc"; }
            { name = "*.srt"; text = "󰨖"; fg = "#f9e2af"; }
            { name = "*.ssa"; text = "󰨖"; fg = "#f9e2af"; }
            { name = "*.ste"; text = "󰻫"; fg = "#a6e3a1"; }
            { name = "*.step"; text = "󰻫"; fg = "#a6e3a1"; }
            { name = "*.stl"; text = "󰆧"; fg = "#7f849c"; }
            { name = "*.stp"; text = "󰻫"; fg = "#a6e3a1"; }
            { name = "*.strings"; text = ""; fg = "#74c7ec"; }
            { name = "*.styl"; text = ""; fg = "#a6e3a1"; }
            { name = "*.sub"; text = "󰨖"; fg = "#f9e2af"; }
            { name = "*.sublime"; text = ""; fg = "#fab387"; }
            { name = "*.suo"; text = ""; fg = "#6c7086"; }
            { name = "*.sv"; text = "󰍛"; fg = "#a6e3a1"; }
            { name = "*.svelte"; text = ""; fg = "#fab387"; }
            { name = "*.svg"; text = "󰜡"; fg = "#fab387"; }
            { name = "*.svh"; text = "󰍛"; fg = "#a6e3a1"; }
            { name = "*.swift"; text = ""; fg = "#fab387"; }
            { name = "*.t"; text = ""; fg = "#74c7ec"; }
            { name = "*.tbc"; text = "󰛓"; fg = "#585b70"; }
            { name = "*.tcl"; text = "󰛓"; fg = "#585b70"; }
            { name = "*.templ"; text = ""; fg = "#f9e2af"; }
            { name = "*.terminal"; text = ""; fg = "#a6e3a1"; }
            { name = "*.test.js"; text = ""; fg = "#f9e2af"; }
            { name = "*.test.jsx"; text = ""; fg = "#74c7ec"; }
            { name = "*.test.ts"; text = ""; fg = "#74c7ec"; }
            { name = "*.test.tsx"; text = ""; fg = "#585b70"; }
            { name = "*.tex"; text = ""; fg = "#45475a"; }
            { name = "*.tf"; text = ""; fg = "#585b70"; }
            { name = "*.tfvars"; text = ""; fg = "#585b70"; }
            { name = "*.tgz"; text = ""; fg = "#fab387"; }
            { name = "*.tmux"; text = ""; fg = "#a6e3a1"; }
            { name = "*.toml"; text = ""; fg = "#585b70"; }
            { name = "*.torrent"; text = ""; fg = "#94e2d5"; }
            { name = "*.tres"; text = ""; fg = "#7f849c"; }
            { name = "*.ts"; text = ""; fg = "#74c7ec"; }
            { name = "*.tscn"; text = ""; fg = "#7f849c"; }
            { name = "*.tsconfig"; text = ""; fg = "#fab387"; }
            { name = "*.tsx"; text = ""; fg = "#585b70"; }
            { name = "*.ttf"; text = ""; fg = "#f5e0dc"; }
            { name = "*.twig"; text = ""; fg = "#a6e3a1"; }
            { name = "*.txt"; text = "󰈙"; fg = "#a6e3a1"; }
            { name = "*.txz"; text = ""; fg = "#fab387"; }
            { name = "*.typoscript"; text = ""; fg = "#fab387"; }
            { name = "*.ui"; text = ""; fg = "#313244"; }
            { name = "*.v"; text = "󰍛"; fg = "#a6e3a1"; }
            { name = "*.vala"; text = ""; fg = "#585b70"; }
            { name = "*.vh"; text = "󰍛"; fg = "#a6e3a1"; }
            { name = "*.vhd"; text = "󰍛"; fg = "#a6e3a1"; }
            { name = "*.vhdl"; text = "󰍛"; fg = "#a6e3a1"; }
            { name = "*.vim"; text = ""; fg = "#a6e3a1"; }
            { name = "*.vsh"; text = ""; fg = "#7f849c"; }
            { name = "*.vsix"; text = ""; fg = "#6c7086"; }
            { name = "*.vue"; text = ""; fg = "#a6e3a1"; }
            { name = "*.wasm"; text = ""; fg = "#585b70"; }
            { name = "*.wav"; text = ""; fg = "#74c7ec"; }
            { name = "*.webm"; text = ""; fg = "#fab387"; }
            { name = "*.webmanifest"; text = ""; fg = "#f9e2af"; }
            { name = "*.webp"; text = ""; fg = "#7f849c"; }
            { name = "*.webpack"; text = "󰜫"; fg = "#74c7ec"; }
            { name = "*.wma"; text = ""; fg = "#74c7ec"; }
            { name = "*.woff"; text = ""; fg = "#f5e0dc"; }
            { name = "*.woff2"; text = ""; fg = "#f5e0dc"; }
            { name = "*.wrl"; text = "󰆧"; fg = "#7f849c"; }
            { name = "*.wrz"; text = "󰆧"; fg = "#7f849c"; }
            { name = "*.x"; text = ""; fg = "#89b4fa"; }
            { name = "*.xaml"; text = "󰙳"; fg = "#585b70"; }
            { name = "*.xcf"; text = ""; fg = "#585b70"; }
            { name = "*.xcplayground"; text = ""; fg = "#fab387"; }
            { name = "*.xcstrings"; text = ""; fg = "#74c7ec"; }
            { name = "*.xls"; text = "󰈛"; fg = "#585b70"; }
            { name = "*.xlsx"; text = "󰈛"; fg = "#585b70"; }
            { name = "*.xm"; text = ""; fg = "#74c7ec"; }
            { name = "*.xml"; text = "󰗀"; fg = "#fab387"; }
            { name = "*.xpi"; text = ""; fg = "#fab387"; }
            { name = "*.xul"; text = ""; fg = "#fab387"; }
            { name = "*.xz"; text = ""; fg = "#fab387"; }
            { name = "*.yaml"; text = ""; fg = "#7f849c"; }
            { name = "*.yml"; text = ""; fg = "#7f849c"; }
            { name = "*.zig"; text = ""; fg = "#fab387"; }
            { name = "*.zip"; text = ""; fg = "#fab387"; }
            { name = "*.zsh"; text = ""; fg = "#a6e3a1"; }
            { name = "*.zst"; text = ""; fg = "#fab387"; }
            { name = "*.🔥"; text = ""; fg = "#fab387"; }
          ];
        };
      };
    };
  };
}
