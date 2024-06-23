{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    bun
    deno
    nodejs
    nodePackages_latest.pnpm
  ];

  shellHook = ''
    echo "Javascript Dev Env Ready!" | ${pkgs.lolcat}/bin/lolcat
  '';
}
