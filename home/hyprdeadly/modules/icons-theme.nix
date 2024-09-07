{ pkgs, ... }:
pkgs.stdenvNoCC.mkDerivation rec {
  name = "candy-icons-master";

  src = pkgs.fetchurl {
    url = "https://github.com/EliverLara/candy-icons/archive/refs/heads/master.zip";
    sha256 = "1xhm6csrq86k4mxmpjddlyp3q353rg0w4scxhx49fx1yawlaqlnq";
  };

  nativeBuildInputs = [ pkgs.gtk3 ];
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/icons
    ${pkgs.unzip}/bin/unzip $src -d $out/share/icons
    gtk-update-icon-cache $out/share/icons/${name}
  '';
}

