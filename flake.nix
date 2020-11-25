{
  description = "Flake packaging pre-build julia binaries";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";

  outputs = { self, nixpkgs }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      julia_15 = pkgs.callPackage ./julia_15.nix { };
    in
    {
      packages.x86_64-linux = {
        inherit julia_15;
        julia = self.packages.x86_64-linux.julia_15;
      };

      lib = {
        buildJulia15Depot = pkgs.callPackage ./julia-depot.nix { inherit julia_15; };
      };

      apps.x86_64-linux.julia = {
        type = "app";
        program = "${self.defaultPackage.x86_64-linux}/bin/julia";
      };

      defaultApp.x86_64-linux = self.apps.x86_64-linux.julia;
      defaultPackage.x86_64-linux = self.packages.x86_64-linux.julia;
    };
}
