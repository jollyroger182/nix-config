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

    authentication = ''
      host all all 127.0.0.1/32 trust
      host all all ::1/128      trust
    '';
  };
}
