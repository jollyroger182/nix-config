# safari "add to dock" web apps
{
  lib,
  pkgs,
  ...
}:

let
  # a stable uuid per web app. safari uses a random v4; any 8-4-4-4-12 hex string
  # works, so derive one from the url to keep it out of the config
  mkUUID =
    url:
    let
      h = lib.toUpper (builtins.substring 0 32 (builtins.hashString "sha256" url));
      part = start: len: builtins.substring start len h;
    in
    "${part 0 8}-${part 8 4}-${part 12 4}-${part 16 4}-${part 20 12}";

  mkWebApp =
    {
      name,
      url,
      # safari's own uuid, when the app already exists on this machine: reusing
      # it keeps the container that holds its login session
      uuid ? mkUUID url,
      icon,
      # extra web app manifest keys, e.g. short_name or theme_color
      manifest ? { },
      # "Touch" for an apple-touch-icon, "Favicon" when safari fell back
      iconKind ? "Touch",
      manifestURL ? null,
    }:
    let
      info = {
        CFBundleIconFile = "ApplicationIcon";
        CFBundleIdentifier = "com.apple.Safari.WebApp.${uuid}";
        CFBundleInfoDictionaryVersion = "6.0";
        CFBundleName = name;
        CFBundlePackageType = "AAPL";
        CFBundleShortVersionString = "1.0";
        CFBundleSupportedPlatforms = [ "MacOSX" ];
        CFBundleURLTypes = [
          {
            CFBundleURLSchemes = [ "x-webkit-app-launch" ];
            LSHandlerRank = "None";
          }
        ];
        CFBundleVersion = "1";
        LSMinimumSystemVersion = "14.0";
        LSTemplateApplication = true;
        LSTemplateApplicationParameters = {
          CFBundleIdentifier = "com.apple.Safari.WebApp";
          TemplateAppUUID = uuid;
          defaultarguments = true;
          teamIdentifier = "0000000000";
        };
        Manifest = {
          start_url = url;
        }
        // manifest;
        WKManifestIconKind = iconKind;
        WKPushBundleMetadata.manifestId = url;
      }
      // lib.optionalAttrs (manifestURL != null) { WKManifestURL = manifestURL; };
    in
    {
      inherit uuid;

      # real files, not store symlinks: codesign rejects a bundle whose
      # Info.plist is a symlink
      bundle =
        pkgs.runCommand "webapp-${lib.toLower name}"
          {
            nativeBuildInputs = [ pkgs.python3 ];
            infoJSON = builtins.toJSON info;
            passAsFile = [ "infoJSON" ];
          }
          ''
            mkdir -p "$out/Contents/Resources"
            cp ${icon} "$out/Contents/Resources/ApplicationIcon.icns"

            # plistlib, not lib.generators.toPlist: launch services checks the
            # bundle against a hash it recorded when safari created the web app, so
            # the file has to match apple's canonical formatting byte for byte
            python3 -c 'import json, plistlib, sys
            with open(sys.argv[1]) as f:
                info = json.load(f)
            with open(sys.argv[2], "wb") as f:
                plistlib.dump(info, f)' "$infoJSONPath" "$out/Contents/Info.plist"
          '';
    };

  apps = {
    Trello = mkWebApp {
      name = "Trello";
      uuid = "391C012C-9D80-469D-96A7-55DD73EDB8A6";
      url = "https://trello.com/b/1NBUSolt/ysws-haven";
      icon = ./webapps/trello.icns;
      manifest = {
        name = "YSWS - Haven | Trello";
        short_name = "Trello";
      };
    };

    Fillout = mkWebApp {
      name = "Fillout";
      uuid = "EF291FA1-AAFD-45E1-BA0E-C9E98391583C";
      url = "https://build.fillout.com/home";
      icon = ./webapps/fillout.icns;
      iconKind = "Favicon";
      manifest = {
        name = "Zite | Home";
        short_name = "Fillout";
      };
    };
  };
  # launch services keeps one record per web app in a data vault, keyed by uuid,
  # and refuses to launch a bundle whose signature does not match the recorded
  # hash (kLSTemplateApplicationSignatureFailureErr) or that it has no record of
  # at all (kLSTemplateApplicationSignatureNotFoundErr). safari writes these when
  # you "add to dock"; nothing stops us writing them ourselves
  registerWebApp = pkgs.writeText "register-web-app.py" ''
    import binascii
    import os
    import plistlib
    import subprocess
    import sys

    uuid, name, app = sys.argv[1:4]

    # the recorded hash is just the bundle's ad-hoc code signature cdhash
    signature = subprocess.run(
        ["/usr/bin/codesign", "-dvvv", app],
        capture_output=True,
        text=True,
    ).stderr
    cdhash = next(
        (l.split("=", 1)[1].strip() for l in signature.splitlines() if l.startswith("CDHash=")),
        None,
    )
    if cdhash is None:
        sys.exit(f"register-web-app: {app} is unsigned")

    record = {
        "bundleIdentifier": f"com.apple.Safari.WebApp.{uuid}",
        "name": name,
        "proxyHostBundleIdentifier": "com.apple.Safari.WebApp",
        "signing-identifier": f"com.apple.Safari.WebApp.{uuid}",
        "teamIdentifier": "0000000000",
        "uniquehash": binascii.unhexlify(cdhash),
        "url": f"file://{app}/",
        "uuid": uuid,
        # safari stamps its own version here; it is not checked at launch
        "version": ["1141.1", 100],
    }

    vault = os.path.expanduser(
        "~/Library/Application Support/com.apple.LaunchServicesTemplateApp.dv/HashesV1"
    )
    path = os.path.join(vault, f"{uuid}.plist")
    if os.path.exists(path):
        with open(path, "rb") as f:
            if plistlib.load(f) == record:
                sys.exit(0)

    os.makedirs(vault, exist_ok=True)
    with open(path, "wb") as f:
        plistlib.dump(record, f)
  '';
in
{
  home.activation.safariWebApps = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    stamps="$HOME/.local/state/home-manager/webapps"
    vault="$HOME/Library/Application Support/com.apple.LaunchServicesTemplateApp.dv/HashesV1"
    run mkdir -p $VERBOSE_ARG "$HOME/Applications" "$stamps"

    installWebApp() {
      name="$1"
      uuid="$2"
      src="$3"
      dest="$HOME/Applications/$name.app"
      stamp="$stamps/$name"

      # the store path changes iff the bundle's contents do, so leave an
      # up-to-date app alone -- replacing it churns launch services
      if [ ! -d "$dest" ] || [ "$(cat "$stamp" 2>/dev/null)" != "$uuid $src" ]; then
        run rm -rf $VERBOSE_ARG "$dest"
        run cp -R $VERBOSE_ARG "$src" "$dest"
        run chmod -R u+w "$dest"
        run /usr/bin/codesign --force --sign - "$dest"
        run --quiet tee "$stamp" <<< "$uuid $src"
      fi

      # cheap and idempotent: rewrites the record only when it is missing or
      # stale, so it also repairs a vault someone else has clobbered
      run ${pkgs.python3}/bin/python3 ${registerWebApp} "$uuid" "$name" "$dest"
    }

    # an app dropped from this file leaves a bundle, a stamp and a vault record
    # behind, so take them all back out again
    pruneWebApps() {
      for stamp in "$stamps"/*; do
        [ -e "$stamp" ] || continue
        name="$(basename "$stamp")"

        case " $* " in
          *" $name "*) continue ;;
        esac

        run rm -rf $VERBOSE_ARG "$HOME/Applications/$name.app"
        run rm -f $VERBOSE_ARG "$vault/$(cut -d' ' -f1 "$stamp").plist"
        run rm -f $VERBOSE_ARG "$stamp"
      done
    }

    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (
        name: app: "installWebApp ${lib.escapeShellArg name} ${app.uuid} ${app.bundle}"
      ) apps
    )}

    pruneWebApps ${lib.concatMapStringsSep " " lib.escapeShellArg (lib.attrNames apps)}
  '';
}
