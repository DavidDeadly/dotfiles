{ pkgs, ... }:
{
  home.pointerCursor = {
    name = "Catppuccin-Mocha-Sky-Cursors";
    package = pkgs.catppuccin-cursors.mochaSky;
  };

  gtk = {
    enable = true;
    theme = {
      package = import ./gtk-theme.nix { inherit pkgs; };
      name = "Infinity-GTK";
    };

    iconTheme = {
      package = import ./icons-theme.nix { inherit pkgs; };
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
}
