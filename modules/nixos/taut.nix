# https://github.com/jeremy46231/taut - package rolling-release appimage
{ pkgs, ... }:

let
  pname = "taut";
  version = "2.6.1";

  src = pkgs.fetchurl {
    url = "https://github.com/jeremy46231/taut/releases/download/latest/taut-linux.AppImage";
    hash = "sha256-+f47y/f5mHfplLl9czTH+LJVtbIACzu5lgJJu+5VCQg=";
  };

  contents = pkgs.appimageTools.extractType2 { inherit pname version src; };

  taut = pkgs.appimageTools.wrapType2 {
    inherit pname version src;

    extraPkgs = ps: [ ps.slack ];

    extraInstallCommands = ''
      install -Dm444 ${contents}/taut.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/taut.desktop \
        --replace-fail 'Exec=AppRun' 'Exec=taut'

      install -Dm444 ${contents}/usr/share/icons/hicolor/1024x1024/apps/taut.png \
        -t $out/share/icons/hicolor/1024x1024/apps
    '';

    meta = {
      description = "Client mod for Slack";
      homepage = "https://github.com/jeremy46231/taut";
      platforms = [ "x86_64-linux" ];
      mainProgram = "taut";
    };
  };
in
{
  environment.systemPackages = [ taut ];
}
