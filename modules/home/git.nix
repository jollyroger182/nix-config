# git + gh
{ ... }:

{
  programs.git = {
    enable = true;
    lfs.enable = true;

    settings = {
      user.name = "jollyroger182";
      user.email = "hello@jollyy.dev";
      pull.rebase = true;
      init.defaultBranch = "main";
    };

    ignores = [
      "*~"
      "*.swp"
      "tmp_*"
      ".DS_Store"
      ".direnv/*"
    ];
  };

  programs.gh.enable = true;
}
