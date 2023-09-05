final: prev: {
  openssh = prev.openssh.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./patch/openssh.patch ];
    doCheck = false;
  });
}
