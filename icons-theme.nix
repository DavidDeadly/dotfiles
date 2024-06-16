{ pkgs, ... }:
pkgs.stdenvNoCC.mkDerivation rec {
  name = "vivid-glasy-dark";

  src = pkgs.fetchFromGitHub {
    owner = "L4ki";
    repo = "Vivid-Plasma-Themes";
    rev = "40e8caeeb0591146155225a3a4c385d501658248";
    sha256 = "02zr7rm9mhnm9wbgk0p3cyymlb3yyxrvyxk8n78v0wyjx54mpf5v";
  };

  nativeBuildInputs = [ pkgs.gtk3 ];

  dontUnpack = true;
  dontDropIconThemeCache = true;
  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -r $src/Vivid\ Icons\ Themes/Vivid-Glassy-Dark-Icons $out/share/icons/${name}
    gtk-update-icon-cache $out/share/icons/${name}

    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "Icon pack from Vivid Plasma Themes For Plasma Desktop";
    homepage = "https://github.com/L4ki/Vivid-Plasma-Themes";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
  };
}
