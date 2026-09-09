# nixpkgs overlays
{ lib, ... }:

{
  nixpkgs.overlays = [
    # anki-mac-helper takes its version from anki (26.08), but the wheel's
    # metadata says 0.1.1, so pythonMetadataCheckPhase fails the build
    (
      final: prev:
      lib.optionalAttrs prev.stdenv.hostPlatform.isDarwin {
        anki = prev.anki.override (_: {
          python3Packages = prev.python3Packages.overrideScope (
            _: pyPrev: {
              anki-mac-helper = pyPrev.anki-mac-helper.overrideAttrs (_: {
                version = "0.1.1";
                __intentionallyOverridingVersion = true;
              });
            }
          );
        });
      }
    )
  ];
}
