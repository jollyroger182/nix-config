# gnome + gdm
{ ... }:

{
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Keymap for the graphical session.
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Touchpad support is enabled by default by most desktop managers.
  # services.libinput.enable = true;

  # services.printing.enable = true; # CUPS
}
