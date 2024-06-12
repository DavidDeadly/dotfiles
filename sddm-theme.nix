{ pkgs }:
let 
  imageName = "anime-girl-headphones";
  imageLink = "https://github.com/DavidDeadly/dotfiles/blob/main/images/${imageName}.jpg?raw=true";
  
  image = pkgs.fetchurl {
    url = imageLink;
    sha256 = "1y547pfqc8x3ahn57dalxal7bgha6p5mqv272kpj51yi8xmjcvnc";
  };
in
pkgs.stdenv.mkDerivation {
  name = "sddm-theme";
  src = pkgs.fetchFromGitHub {
    owner = "Kangie";
    repo = "sddm-sugar-candy";
    rev = "a1fae5159c8f7e44f0d8de124b14bae583edb5b8";
    sha256 = "18wsl2p9zdq2jdmvxl4r56lir530n73z9skgd7dssgq18lipnrx7";
  };
  installPhase = ''
    mkdir -p $out
    cp -r ./* $out/
    cp -r ${image} $out/Backgrounds/${imageName}.jpg
    sed -i "s/Mountain/${imageName}/" $out/theme.conf
    sed -i "s/#fb884f/#10C8EC/" $out/theme.conf
  '';
}
