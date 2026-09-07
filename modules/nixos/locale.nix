# Time zone, internationalisation and console keymap.
{ lib, ... }:

{
  time.timeZone = lib.mkDefault "America/New_York";
  services.automatic-timezoned.enable = true;

  # nixpkgs' geoclue2 doesn't set an ip method which breaks it
  environment.etc."geoclue/geoclue.conf".text = lib.mkAfter ''

    [ip]
    enable=true
    method=ichnaea
  '';

  # GNOME sets enableDemoAgent = false because it ships gnome-shell as the
  # geoclue agent, which also drops geoclue-demo-agent from the whitelist — but
  # automatic-timezoned starts that demo agent for its own use regardless.
  services.geoclue2.whitelistedAgents = [
    "gnome-shell"
    "io.elementary.desktop.agent-geoclue2"
    "geoclue-demo-agent"
  ];

  i18n.defaultLocale = "en_US.UTF-8";

  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };
}
