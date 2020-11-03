{
  description = "Flake packaging pre-build julia binaries";

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux =
      with nixpkgs.legacyPackages.x86_64-linux;  rec {

        julia_15 = callPackage ./julia_15.nix {};

        julia = julia_15;

    };

    defaultPackage.x86_64-linux = self.packages.x86_64-linux.julia;

  };
}
