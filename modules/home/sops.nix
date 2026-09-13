# sops-nix: tokens encrypted in-repo, decrypted per-user at activation
{
  config,
  pkgs,
  sops-nix,
  ...
}:

{
  imports = [ sops-nix.homeManagerModules.sops ];

  sops = {
    # this path is the *ciphertext*
    defaultSopsFile = ../../secrets/tokens.yaml;

    # keep this a string: a bare path would copy the private key to the nix store!
    age.sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];

    # every name here must exist as a top-level key in secrets/tokens.yaml
    secrets = {
      slack-xoxb = { };
      slack-xoxp = { };
      github = { };
    };
  };

  # `secret slack-xoxp` prints one token
  programs.bash.initExtra = ''
    export SOPS_AGE_KEY_CMD="${pkgs.ssh-to-age}/bin/ssh-to-age -private-key -i ${config.home.homeDirectory}/.ssh/id_ed25519"

    secret() {
      local dir=${config.sops.defaultSymlinkPath}
      if [ $# -ne 1 ] || [ ! -f "$dir/$1" ]; then
        echo "usage: secret <name>" >&2
        echo "available: $(ls "$dir" 2>/dev/null | tr '\n' ' ')" >&2
        return 2
      fi
      cat "$dir/$1"
    }
  '';

  home.sessionVariables.SOPS_AGE_KEY_CMD = "${pkgs.ssh-to-age}/bin/ssh-to-age -private-key -i ${config.home.homeDirectory}/.ssh/id_ed25519";

  home.packages = with pkgs; [
    sops
    ssh-to-age
  ];
}
