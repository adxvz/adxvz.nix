self: super:
let
  patch = builtins.readFile ./fix-hex.patch;
in
{
  hidrd = super.hidrd.overrideAttrs (old: rec {
    patches = old.patches or [ ] ++ [
      self.writeText
      "fix-hidrd-hex.patch"
      patch
    ];
  });
}
