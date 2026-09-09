{ ... }:

{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "prohibit-password";
    };
  };

  users.users.jolly = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINSwBwIadrTlBexzP/o9TPdt7k/gU69Bye5FkfMj86aZ jolly@Nico"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILmX/cNjOgEpsqwxB6XEBoA4IqonAjmPf8dS+zzoIk5i jolly@mira"
    ];
  };
}
