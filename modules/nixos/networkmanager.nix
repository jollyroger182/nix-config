# Networking. Configure connections interactively with nmcli or nmtui.
{ ... }:

{
  networking.networkmanager.enable = true;

  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # The firewall is enabled by default; open ports here.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
}
