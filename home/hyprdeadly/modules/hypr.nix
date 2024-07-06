{ pkgs, pkgs-unstable, inputs, config, ... }:
{
  home.packages = with pkgs-unstable; [
    hyprpicker # color picker
    hyprcursor # cursor theme manager
    swww # wallpaper-daemon
    pyprland # hyprland plugin manager
  ];

  xdg.configFile."hypr/pyprland.toml".source = ../../../.config/hypr/pyprland.toml;

  home.sessionVariables = {
    SWWW_TRANSITION_FPS = 60;
    SWWW_TRANSITION = "any";
    SWWW_TRANSITION_DURATION = 4;
  };

  services.hypridle = {
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

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        grace = 10;
        hide_cursor = true;
        ignore_empty_input = true;
      };

      background = {
        path = "${../../../images/wallpapers/mountain-view.png}";
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
        path = "${../../../images/me.jpeg}";
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

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = pkgs-unstable.hyprland;
    systemd = {
      enable = true;
      variables = [ "--all" ];
    };

    settings = {
      "$scripts" = "${../../../.config/hypr/scripts}";
      "$mainMod" = "SUPER";
      "$layout" = "master";
      "$terminal" = "foot";
      "$fileManager" = "thunar";
      "$browser" = "google-chrome";

      monitor = [
        ",preferred,auto,auto"
        "eDP-1,1920x1080@144,auto,1"
        "HDMI-A-1,1920x1080@60,auto,1"
      ];

      workspace = [
        "name:Shell, monitor:eDP-1, default:true"
        "name:Web, monitor:HDMI-A-1, on-created-empty:$browser-stable --enable-wayland-ime"
        # Add some style to the "exposed" workspace
        "special:exposed,gapsout:60,gapsin:30,bordersize:5,border:true,shadow:false"
      ];

      exec-once = [
        "fcitx5 -d"
        "pypr"
        "mako"
        "ianny"
        "foot --server"
        "swww-daemon"
        "nm-applet --indicator"
        "copyq --start-server"
        "eww open bar"
        "$scripts/toggle_layout.sh true"
        "/usr/lib/xfce-polkit/xfce-polkit"
      ];

      xwayland = {
        force_zero_scaling = true;
      };

      env = [
        "QT_QPA_PLATFORMTHEME,qt6ct "
        "ELECTRON_OZONE_PLATFORM_HINT,wayland"
        "XCURSOR_SIZE,38"
        "XCURSOR_THEME,catppuccin-mocha-sky-cursors"
        "HYPRCURSOR_THEME,catppuccin-mocha-sky-cursors"
        "HYPRCURSOR_SIZE,38"
        "HYPR_DEFAULT_LAYOUT,$layout"
        "WALLPAPERS,${config.home.homeDirectory}/.dotfiles/images/wallpapers/"
      ];

      input = {
        kb_layout = "latam";
        kb_variant = "";
        kb_model = "";
        kb_options = "ctrl:swapcaps";
        kb_rules = "";

        follow_mouse = 1;
        sensitivity = 0;

        touchpad = {
          natural_scroll = true;
        };
      };

      general = {
        gaps_in = 10;
        gaps_out = 30;
        border_size = 3;
        layout = "$layout";
        "col.active_border " = "rgb(94e2d5) rgb(24273A) rgb(24273A) rgb(94e2d5) 45deg";
        "col.inactive_border" = "rgb(24273A) rgb(24273A) rgb(24273A) rgb(24273A) 45deg";

        resize_on_border = true;
        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;
      };

      decoration = {
        rounding = 10;
        shadow_ignore_window = true;
        drop_shadow = true;
        "col.shadow" = "rgba(cba6f7ee)";

        blur = {
          enabled = true;
          size = 8;
          passes = 1;
          new_optimizations = true;
          ignore_opacity = true;
          noise = 0.0117;
          contrast = 1.3;
          vibrancy = 0.1696;
          brightness = 1;
          xray = true;
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "easeOutExpo, 0.16, 1, 0.3, 1"
          "linear, 0.0, 0.0, 1.0, 1.0"
        ];

        animation = [
          "windowsIn, 1, 8, easeOutExpo, popin"
          "windowsOut, 1, 8, easeOutExpo, popin"

          "workspaces, 1, 8, easeOutExpo, slidefade 10%"

          "border, 1, 10, default"
          "borderangle, 1, 100, linear, loop"

          "fade, 1, 8, default"
        ];
      };

      misc = {
        vfr = true;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        force_default_wallpaper = -1; # Set to 0 or 1 to disable the anime mascot wallpapers
      };

      dwindle = {
        pseudotile = true; # enable pseudotiling on dwindle
        preserve_split = true;
      };

      master = {
        new_status = "slave";
      };

      gestures = {
        workspace_swipe = true;
      };

      windowrulev2 = [
        "opacity 0.8 0.7, initialTitle:^($terminal)$"

        "float, class:^(thunar)$"
        "float, class:^(pavucontrol)$"
        "move onscreen cursor -50% -50%, class:^(pavucontrol)$"
        "size 30% 40%, class:^(pavucontrol)$"
        "dimaround, class:^(pavucontrol)$"

        # "float, class:^()$, title:^()$"
        # "size 20 20, class:^()$, title:^()$"
        # "move onscreen 1487 123, class:^()$, title:^()$"

        # vivaldi windowrules
        # "float, class:^(vivaldi-stable)$, title:^(Vivaldi Setting)(.*)$"
        # "opacity 1.0 override, class:^(vivaldi-stable)$, title:^(Vivaldi Setting)(.*)$"
        # "size 50% 70%, class:^(vivaldi-stable)$, title:^(Vivaldi Setting)(.*)$"

        "opacity 0.9 0.8, class:^($browser)$"
        "float, class:^($browser)$, title:^(DevTools)(.*)$"
        "size 40% 50%, class:^($browser)$, title:^(DevTools)(.*)$"
        "move onscreen cursor -50% -50%, class:^($browser)$, title:^(DevTools)(.*)$"

        "float, class:(copyq)"
        "move onscreen cursor -50% -50%,class:(copyq)"
        "size 30% 40%, class:(copyq)"
        "dimaround, class:(copyq)"

        "float, class:(gtk-tray)"
        "move onscreen cursor -50% -50%,class:(gtk-tray)"
        "size 5% 5%, class:(gtk-tray)"
        "dimaround, class:(gtk-tray)"
      ];

      "$woomer" = "${inputs.woomer.packages.${pkgs.system}.default}/bin/woomer";
      "$grim" = "${pkgs.grim}/bin/grim";
      "$slurp" = "${pkgs.slurp}/bin/slurp";
      "$swappy" = "${pkgs.swappy}/bin/swappy";
      "$pngquant" = "${pkgs.pngquant}/bin/pngquant";
      "$fd" = "${pkgs.fd}/bin/fd";

      bind = [
        "$mainMod, Q, exec, $terminalclient"
        "$mainMod SHIFT, Q, exec, $terminal"
        "$mainMod SHIFT, X, killactive,"

        # System
        "$mainMod, code:47, exec, wlogout -b 5 -c 0 -r 0 --protocol layer-shell"
        "$mainMod, code:73, exec, brightnessctl s 10%-"
        "$mainMod, code:74, exec, brightnessctl s 10%+"
        "$mainMod SHIFT, M, exit, "

        # Utilities
        "$mainMod, E, exec, $fileManager"
        "$mainMod, S, exec, ~/sources/stray/target/debug/gtk-tray"
        "$mainMod, SPACE, exec, fuzzel"
        "$mainMod SHIFT, E, exec, bemoji"
        # launch zsh dev shells declare in ~/.dotfiles/shells/ with fuzzel
        ''$mainMod, D, exec, $terminal ${ pkgs.writeScript "launch-devshell" ''
            nix develop /home/daviddeadly/.dotfiles/#"$(${pkgs.fd}/bin/fd . ~/.dotfiles/shells/ -e nix -x basename {/.} | fuzzel --dmenu)" -c zsh
        ''}''

        '', Print, exec, $grim -g "$($slurp)" - | $swappy -f - -o - | $pngquant - | wl-copy''
        "$mainMod, Print, exec, $grim - | $swappy -f - -o - | $pngquant - | wl-copy"

        "$mainMod, V, exec, copyq toggle"
        "$mainMod, C, exec, hyprpicker | wl-copy"

        "$mainMod CTRL, Z, exec, $woomer"
        "$mainMod ALT, SPACE, exec, swww img $($scripts/select_wallpaper.sh)"

        #pypr plugins binds
        "$mainMod, W, exec, pypr wall next"
        "$mainMod SHIFT, W, exec, pypr wall clear"
        "$mainMod , Z, exec, pypr zoom ++0.5"
        "$mainMod SHIFT, Z, exec, pypr zoom"
        "$mainMod, B, exec, pypr expose"

        "$mainMod, T, togglefloating,"
        "$mainMod, F, fullscreen,"
        "$mainMod, O, toggleopaque,"

        # Dwindle
        "$mainMod, P, pseudo,"
        "$mainMod, S, togglesplit,"

        # Master

        # toggle layouts
        "$mainMod, G, exec, $scripts/toggle_layout.sh"

        # Move focus with mainMod + vim keys
        "$mainMod, H, movefocus, l"
        "$mainMod, L, movefocus, r"
        "$mainMod, K, movefocus, u"
        "$mainMod, J, movefocus, d"

        "$mainMod SHIFT, H, movewindow, l"
        "$mainMod SHIFT, L, movewindow, r"
        "$mainMod SHIFT, K, movewindow, u"
        "$mainMod SHIFT, J, movewindow, d"

        # Switch workspaces with mainMod + workspace
        "$mainMod, 1, workspace, name:Shell"
        "$mainMod, 2, workspace, name:Web"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"

        # Move window to workspace
        "$mainMod SHIFT, 1, movetoworkspace, name:Shell"
        "$mainMod SHIFT, 2, movetoworkspace, name:Web"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"

        # Move window to workspace without switching
        "$mainMod CTRL SHIFT, 1, movetoworkspacesilent, name:Shell"
        "$mainMod CTRL SHIFT, 2, movetoworkspacesilent, name:Web"
        "$mainMod CTRL SHIFT, 3, movetoworkspacesilent, 3"
        "$mainMod CTRL SHIFT, 4, movetoworkspacesilent, 4"

        # Scroll through existing workspaces with mainMod + scroll
        "$mainMod CTRL, K, workspace, e+1"
        "$mainMod CTRL, J, workspace, e-1"

        # will switch to a submap Resize
        "$mainMod, R, submap, Resize"
      ];

      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };

    extraConfig = ''
      submap = Resize
      # sets repeatable binds for resizing the active window
      binde = , L, resizeactive, 20 0
      binde = , H, resizeactive, -20 0
      binde = , K, resizeactive, 0 -20
      binde = , J, resizeactive, 0 20

      # use reset to go back to the global submap
      bind = $mainMod, R, submap, reset 

      # will reset the submap
      submap = reset
    '';
  };
}
