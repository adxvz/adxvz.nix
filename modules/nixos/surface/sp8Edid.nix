{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.edidCustom;
in
{
  options.modules.edidCustom = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable a custom EDID firmware package.";
    };
  };

  config = mkIf cfg.enable {
    hardware.display.edid.packages = [
      (pkgs.runCommand "edid-custom" { } ''
                mkdir -p "$out/lib/firmware/edid"
                base64 -d > "$out/lib/firmware/edid/SP8vrr120.bin" <<'EOF'
        AP///////wAw5LEGoSQYAAAfAQSlGxJ4A+9wp1FMqCYOT1MAAAABAQEBAQEBAQEBAQEBAQEBAAAA
        /QAeePDwSAEKICAgICAgAAAA/gBMR0RfTVAxLjBfCiAgAAAA/gBMUDEyOVdUMjEyMTY2AQEBAQEB
        AQEBAQEBAQEBAQEBAQdwEy4AAAMBFH8VAQg/C08AB4AfAH8HTwBBAAcAAwEUfxUBCD8LTwAHgB8A
        fwcfCEEABwDFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAkA==
        EOF
      '')
    ];
  };
}
