{ pkgs, ... }:
{

  home.packages = with pkgs; [
    bemoji
  ];

  programs = {
    fuzzel = {
      enable = true;
      settings = {
        main = {
          dpi-aware = "yes";
          icon-theme = "candy-icons-master";
          font = "CaskaydiaCove NFM:weight=bold:size=13";
          line-height = 15;
          fields = "name,generic,comment,categories,filename,keywords";
          terminal = "foot -e";
          prompt = ''"❯  "'';
          layer = "overlay";
        };

        colors = {
          background = "1e1e2edd";
          text = "cdd6f4ff";
          match = "f38ba8ff";
          selection = "585b70ff";
          selection-match = "f38ba8ff";
          selection-text = "cdd6f4ff";
          border = "b4befeff";
        };

        border = {
          radius = 10;
        };

        dmenu = {
          exit-immediately-if-empty = "yes";
        };
      };
    };
  };
}
