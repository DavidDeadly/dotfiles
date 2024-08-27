{ pkgs, ... }:
pkgs.stdenvNoCC.mkDerivation rec {
  name = "candy-icons-master";

  src = pkgs.fetchurl {
    url = "https://github.com/EliverLara/candy-icons/archive/refs/heads/master.zip";
    sha256 = "1zqnawcwslcknsa7f8winjcxy2490xax2grh56jz9cpnyd6dm20h";
  };

  nativeBuildInputs = [ pkgs.gtk3 ];
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/icons
    ${pkgs.unzip}/bin/unzip $src -d $out/share/icons
    gtk-update-icon-cache $out/share/icons/${name}
  '';
}

