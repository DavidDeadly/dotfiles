{ pkgs, ... }:
{
  home.packages = with pkgs; [
    hyprpicker # color picker
    hyprcursor # cursor theme manager
  ];

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
        path = "${../../../images/mountain-view.png}";
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
    package = pkgs.hyprland;
    xwayland.enable = true;
    systemd = {
      enable = true;
      variables = [ "--all" ];
    };

    settings = {
      "$scripts" = "${../../../.config/hypr/scripts}";
      "$mainMod" = "SUPER";
      "$layout" = "master";
      "$terminal" = "kitty";
      "$fileManager" = "thunar";
      "$menu" = "wofi --show drun";

      monitor = [
        ",preferred,auto,auto"
        "eDP-1,1920x1080@144,auto,1"
        "HDMI-A-1,1920x1080@60,auto,1"
      ];

      workspace = [
        "name:Shell, monitor:eDP-1, default:true"
        "name:Web, monitor:HDMI-A-1, on-created-empty:vivaldi"
      ];

      exec-once = [
        "mako"
        "ianny"
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
        "XCURSOR_THEME,Catppuccin-Mocha-Sky-Cursors"
        "HYPRCURSOR_THEME,Catppuccin-Mocha-Sky-Cursors"
        "HYPRCURSOR_SIZE,38"
        "HYPR_DEFAULT_LAYOUT,$layout"
        "WALLPAPERS,/home/daviddeadly/Wallpapers"
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
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        layout = "$layout";
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        resize_on_border = true;
        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;
      };

      decoration = {
        rounding = 10;
        shadow_ignore_window = true;
        drop_shadow = true;
        shadow_range = 20;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";

        blur = {
          enabled = true;
          size = 3;
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
          "myBezier, 0.05, 0.9, 0.1, 1.05"
        ];

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 8, default"
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
        new_is_master = true;
      };

      gestures = {
        workspace_swipe = true;
      };

      windowrule = [
        "float,^(thunar)$"
        "float, ^(pavucontrol)$"
        "move onscreen cursor -50% -50%, ^(pavucontrol)$"
        "size 30% 40%, ^(pavucontrol)$"
        "dimaround, ^(pavucontrol)$"
        "opacity 0.8 override 0.5, ^(kitty)$"
      ];

      windowrulev2 = [
        "float, class:^()$, title:^()$"
        "size 20 20, class:^()$, title:^()$"
        "move onscreen 1361 131, class:^()$, title:^()$"

        "opacity 0.9 0.8, class:^(vivaldi-stable)$"
        "float, class:^(vivaldi-stable)$, title:^(Vivaldi Setting)(.*)$"
        "opacity 1.0 override, class:^(vivaldi-stable)$, title:^(Vivaldi Setting)(.*)$"
        "size 50% 70%, class:^(vivaldi-stable)$, title:^(Vivaldi Setting)(.*)$"
        "float, class:^(vivaldi-stable)$, title:^(Developer Tools)(.*)$"
        "size 40% 50%, class:^(vivaldi-stable)$, title:^(Developer Tools)(.*)$"
        "move onscreen cursor -50% -50%, class:^(vivaldi-stable)$, title:^(Developer Tools)(.*)$"

        "float, class:(copyq)"
        "move onscreen cursor -50% -50%,class:(copyq)"
        "size 30% 40%, class:(copyq)"
        "dimaround, class:(copyq)"

        "float, class:(gtk-tray)"
        "move onscreen cursor -50% -50%,class:(gtk-tray)"
        "size 5% 5%, class:(gtk-tray)"
        "dimaround, class:(gtk-tray)"
      ];

      bind = [
        "$mainMod, Q, exec, kitty"
        "$mainMod SHIFT, X, killactive,"

        # System
        "$mainMod, code:47, exec, $scripts/wlogout_launcher.sh"
        "$mainMod, code:73, exec, brightnessctl s 10%-"
        "$mainMod, code:74, exec, brightnessctl s 10%+"
        "$mainMod SHIFT, M, exit, "

        # Utilities
        "$mainMod, E, exec, $fileManager"
        "$mainMod, V, exec, copyq toggle"
        "$mainMod, S, exec, ~/sources/stray/target/debug/gtk-tray"
        "$mainMod, C, exec, hyprpicker | wl-copy"
        "$mainMod, SPACE, exec, wofi --show drun"
        ''$mainMod, W, exec, $scripts/swww_set.sh $($scripts/random_wallpaper.sh)''



        "$mainMod, T, togglefloating,"
        "$mainMod, F, fullscreen,"
        "$mainMod, O, toggleopaque,"

        # Dwindle
        "$mainMod, P, pseudo, # dwindle"
        "$mainMod, S, togglesplit, # dwindle"

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
