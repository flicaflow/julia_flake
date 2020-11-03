{
  description = "A very basic flake";

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux =
      with nixpkgs.legacyPackages.x86_64-linux;  rec {

        julia_15 = stdenv.mkDerivation rec {
          pname = "julia";
          version = "1.5.2";

          buildInputs = [ patchelf ];

          src = fetchTarball {
            url = "https://julialang-s3.julialang.org/bin/linux/x64/1.5/julia-${version}-linux-x86_64.tar.gz";
            sha256 = "0k3bpw8v07b70z50dyvjgz5wc58bnvw505lfcssczmhpfqd5zj49";
          };

          buildPhase = ''
            ls
          '';

          installPhase = ''
            mkdir -p $out
            cp -R . $out
            chmod -R +x $out/bin
            ls -l $out
          '';

          fixupPhase = ''
            patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/bin/julia
          '';
        };

        julia = julia_15;

    };

    defaultPackage.x86_64-linux = self.packages.x86_64-linux.julia;

  };
}
