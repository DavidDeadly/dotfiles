{ ... }:
{
  xdg.configFile."wlogout/icons".source = ../../../.config/wlogout/icons;

  programs.wlogout = {
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
}
