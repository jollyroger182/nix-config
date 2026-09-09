{ pkgs, lib, ... }:

{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_18;

    initdbArgs = lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
      "-U"
      "jolly"
    ];

    ensureUsers = lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      {
        name = "jolly";
        ensureClauses.superuser = true;
      }
    ];
  };
}
