self: super: {
  hidrd = super.hidrd.overrideAttrs (old: {
    patches = [
      (self.writeText "fix-hex-array.patch" ''
        --- a/lib/util/hex.c
        +++ b/lib/util/hex.c
        @@
        -    static const char   map[16] = "0123456789ABCDEF";
        +    static const char   map[17] = "0123456789ABCDEF";
      '')
    ];
  });
