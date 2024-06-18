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

  # wayland.windowManager.hyprland = {
  #   enable = true;
  #   package = pkgs.hyprland;
  #   xwayland.enable = true;
  #   systemd.enable = true;

  #   settings = {
  #   };
  # };
}
