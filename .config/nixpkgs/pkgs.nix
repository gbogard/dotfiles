rec {
  metals_overlay = self: super: {
    metals = super.metals.overrideAttrs (old: rec {
      version = "0.10.3";
      deps = self.stdenv.mkDerivation {
        name = "${old.pname}-deps-${version}";
        buildCommand = ''
          export COURSIER_CACHE=$(pwd)
          ${self.coursier}/bin/coursier fetch org.scalameta:metals_2.12:${version} \
            -r bintray:scalacenter/releases \
            -r sonatype:snapshots > deps
          mkdir -p $out/share/java
          cp -n $(< deps) $out/share/java/
        '';
        outputHashMode = "recursive";
        outputHashAlgo = "sha256";
        outputHash = "1psmsiwd3xlbrvkdvr2zgs2b66kw8w2jvvqa399g7jhixh2fpbx4";
      };
      buildInputs = [ self.jdk deps ];
    });
  };
  moz_overlay = import (builtins.fetchTarball {
    url = "https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz";
    sha256 = "1zybp62zz0h077zm2zmqs2wcg3whg6jqaah9hcl1gv4x8af4zhs6";
  });
  neovim_overlay = import (builtins.fetchTarball {
    url = "https://github.com/nix-community/neovim-nightly-overlay/archive/57f49436ec18c7a3f883b8ba3bcfc5ce558c28fa.tar.gz";
    sha256 = "1ij0lapzp4c7d6q21j15p9qybrm5ndb6ljhy15p8zirdfh581b9s";
  });
  pkgs =
    (import
      (builtins.fetchTarball {
        name = "nixos-20.09";
        url = "https://github.com/NixOS/nixpkgs/archive/20.09.tar.gz";
        sha256 = "1wg61h4gndm3vcprdcg7rc4s1v3jkm5xd7lw8r2f67w502y94gcy";
      })
      { overlays = [ moz_overlay neovim_overlay ]; });
  unstable =
    import
      (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/d0bb138fbc33b23dd19155fa218f61eed3cb685f.tar.gz";
        sha256 = "0dym3kg1wwl2npp3l3z7q8mk269kib0yphky2zb16ph42gbyly7l";
      })
      { overlays = [ neovim_overlay metals_overlay ]; };
}
