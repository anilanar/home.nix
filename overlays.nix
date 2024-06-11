final: prev: {
  openssh = prev.openssh.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./patch/openssh.patch ];
    doCheck = false;
  });

  gnome = prev.gnome.overrideScope' (
    gfinal: gprev: {
      gnome-keyring = gprev.gnome-keyring.overrideAttrs (oldAttrs: {
        configureFlags = oldAttrs.configureFlags or [ ] ++ [ "--disable-ssh-agent" ];
      });
    }
  );
}
