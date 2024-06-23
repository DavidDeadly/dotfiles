{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    go
  ];

  shellHook = ''
    echo "Go Dev Env Ready!" | ${pkgs.lolcat}/bin/lolcat
  '';
}

