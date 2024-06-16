{ pkgs, ... }:
pkgs.stdenvNoCC.mkDerivation rec {
  name = "infinity-gtk-theme";

  src = pkgs.fetchFromGitHub {
    name = name;
    owner = "L4ki";
    repo = "Infinity-Plasma-Themes";
    rev = "0e1cf575a2865583ccf9a2e11235c71f814eeffd";
    sha256 = "05m7ic2lvxji0sc35k3jvw25b9kniv5885g9k6kagnz5rp35yyfs";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes
    cp -a $src/Infinity-GTK/* $out/share/themes

    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "GTK theme from Vivid Plasma Themes For Plasma Desktop";
    homepage = "https://github.com/L4ki/Vivid-Plasma-Themes";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
  };
}
