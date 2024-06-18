{ ... }:
{
  programs = {
    lazygit.enable = true;
    gh.enable = true;

    git = {
      enable = true;
      userName = "DavidDeadly";
      userEmail = "jdrueda513@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
        push.autoSetupRemote = true;
        # testing
        merge.conflictstyle = "diff3";
      };
    };
  };
}
