{ pkgs, pkgs-unstable, ... }:
{
  programs = {
    vscode = {
      enable = true;
      package = pkgs-unstable.vscode;
    };

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      withNodeJs = true;
      package = pkgs-unstable.neovim-unwrapped;

      extraPackages = with pkgs; [
        # python
        nodePackages.pyright
        (
          python3.withPackages (ps: with ps; [
            black
            isort
          ])
        )

        # lua
        pkgs-unstable.lua-language-server
        selene
        stylua

        # nix
        statix
        nixpkgs-fmt
        pkgs-unstable.nil

        # web
        eslint_d
        tailwindcss-language-server
        nodePackages.prettier
        # nodePackages.eslint
        nodePackages.typescript-language-server
        nodePackages.vscode-html-languageserver-bin
        nodePackages.volar

        # Go
        go
        gopls
        golangci-lint
        delve

        # Shell scripting
        shfmt
        shellcheck
        beautysh

        # C, C++
        clang
        clang-tools
        cppcheck

        # extras
        nodePackages.cspell
        nodePackages.vscode-langservers-extracted

        # telescope deps
        ripgrep
        fd
        fzf
      ];
    };
  };
}
