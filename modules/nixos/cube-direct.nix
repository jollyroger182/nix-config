# direct connection to cube via ethernet:
#
# nmcli connection up cube-direct
# ip neigh show dev enp131s0
# ssh cube@10.42.0.<n>
#
# or ipv6 link-local:
#
# ping -6 -c3 ff02::1%enp131s0
# ssh cube@fe80::6618:114a:7a7b:ea9d%enp131s0
{ ... }:

{
  networking.networkmanager.ensureProfiles.profiles.cube-direct = {
    connection = {
      id = "cube-direct";
      type = "ethernet";
      interface-name = "enp131s0";
      autoconnect = false;
    };

    ipv4.method = "shared";

    ipv6.method = "link-local";
  };
}
