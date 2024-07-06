{ pkgs, ... }:
{
  home.pointerCursor = {
    gtk.enable = true;

    name = "catppuccin-mocha-sky-cursors";
    package = pkgs.catppuccin-cursors.mochaSky;
  };

  gtk = {
    enable = true;

    font = {
      name = "Sans";
      size = 11;
    };

    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Teal-Darkest-Solid";
    };

    iconTheme = {
      package = import ./icons-theme.nix { inherit pkgs; };
      name = "candy-icons-master";
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
}
