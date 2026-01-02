final: prev: {
  hidrd = prev.hidrd.overrideAttrs (old: {
    NIX_CFLAGS_COMPILE =
      (old.NIX_CFLAGS_COMPILE or "") + " -Wno-error=unterminated-string-initialization";
  });
}
