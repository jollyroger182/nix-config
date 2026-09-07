# tailscale config
{ ... }:

{
  services.tailscale = {
    enable = true;

    # allow using exit nodes and subnet routes
    useRoutingFeatures = "client";

    openFirewall = true;

    extraSetFlags = [
      "--accept-routes"
    ];
  };

  networking.firewall.trustedInterfaces = [ "tailscale0" ];
}
