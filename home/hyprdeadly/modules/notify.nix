{ ... }:
{
  services.mako = {
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
}
