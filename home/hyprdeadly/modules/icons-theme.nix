{ pkgs, ... }:
pkgs.stdenvNoCC.mkDerivation rec {
  name = "candy-icons-master";

  src = pkgs.fetchurl {
    url = "https://github.com/EliverLara/candy-icons/archive/refs/heads/master.zip";
    sha256 = "05kfs5vyprz0cb32bjfir6j3aclrbcsb0c22y3iisq8cy0a45ngm";
  };

  nativeBuildInputs = [ pkgs.gtk3 ];
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/icons
    ${pkgs.unzip}/bin/unzip $src -d $out/share/icons
    gtk-update-icon-cache $out/share/icons/${name}
  '';
}

