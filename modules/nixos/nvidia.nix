# nvidia dgpu (GB206 / RTX 5060 laptop) + intel igpu prime offload
{ config, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # GB20x is only supported by the open kernel modules.
    open = true;

    modesetting.enable = true;
    nvidiaSettings = true;

    # let the dGPU drop to D3cold when nothing is offloaded to it
    powerManagement.enable = true;
    powerManagement.finegrained = true;

    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true; # provides the `nvidia-offload` wrapper

      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:2:0:0";
    };
  };
}
