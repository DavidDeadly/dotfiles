{ pkgs, ... }:
pkgs.stdenvNoCC.mkDerivation rec {
  name = "candy-icons-master";

  src = pkgs.fetchurl {
    url = "https://github.com/EliverLara/candy-icons/archive/refs/heads/master.zip";
    sha256 = "06vhgkh1aihp04sdqd3qm5447d9pzmxmjy0mg8nk3xsqs260z4xk";
  };

  nativeBuildInputs = [ pkgs.gtk3 ];
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/icons
    ${pkgs.unzip}/bin/unzip $src -d $out/share/icons
    gtk-update-icon-cache $out/share/icons/${name}
  '';
}

