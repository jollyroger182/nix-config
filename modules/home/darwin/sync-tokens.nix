# push the decrypted tokens into Data Jar on iOS, via a Shortcut.
{ config, pkgs, ... }:

let
  sync-tokens = pkgs.writeShellApplication {
    name = "sync-tokens";
    runtimeInputs = [ pkgs.jq ];
    text = ''
      shortcut="''${1:-Sync Tokens to Data Jar}"
      dir="${config.sops.defaultSymlinkPath}"

      if [ ! -d "$dir" ]; then
        echo "sync-tokens: no decrypted secrets at $dir" >&2
        exit 1
      fi

      # plaintext touches disk here; 0600 in $TMPDIR, removed on exit
      payload="$(mktemp -t sync-tokens)"
      chmod 600 "$payload"
      trap 'rm -f "$payload"' EXIT

      for f in "$dir"/*; do
        [ -f "$f" ] || continue
        jq -n --arg k "$(basename "$f")" --rawfile v "$f" \
          '{ ($k): ($v | sub("\n+$"; "")) }'
      done | jq -s 'add // {}' > "$payload"

      /usr/bin/shortcuts run "$shortcut" --input-path "$payload"
      echo "sync-tokens: sent $(jq -r 'keys | join(", ")' "$payload") to '$shortcut'"
    '';
  };
in
{
  home.packages = [ sync-tokens ];
}
