{ pkgs, ... }:
pkgs.stdenvNoCC.mkDerivation rec {
  name = "candy-icons-master";

  src = pkgs.fetchurl {
    url = "https://github.com/EliverLara/candy-icons/archive/refs/heads/master.zip";
    sha256 = "1a8vrlj4mrgsf1s7l4s08b9kllcwm0bkwib0hjc97c4pm7lmgfx8";
  };

  nativeBuildInputs = [ pkgs.gtk3 ];
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/icons
    ${pkgs.unzip}/bin/unzip $src -d $out/share/icons
    gtk-update-icon-cache $out/share/icons/${name}
  '';
}

