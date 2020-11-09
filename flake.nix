{
  description = "Flake packaging pre-build julia binaries";

  outputs = { self, nixpkgs }: {

    packages =
      with nixpkgs.legacyPackages.x86_64-linux;  rec {

        x86_64-linux.julia_15 = callPackage ./julia_15.nix {};

        x86_64-linux.julia = self.packages.x86_64-linux.julia_15;


    };

    lib.buildJulia15Package = 
      with nixpkgs.legacyPackages.x86_64-linux; 
      callPackage ./build-julis-15-package.nix { inherit (self.packages.x86_64-linux) julia_15; };


    apps.x86_64-linux.julia = {
      type = "app";
      program = "${self.defaultPackage.x86_64-linux}/bin/julia";
    };

    defaultApp.x86_64-linux = self.apps.x86_64-linux.julia;

    defaultPackage.x86_64-linux = self.packages.x86_64-linux.julia;

  };
}
