{ runCommand, lib, stdenv, julia_15, curl, cacert,  writeShellScript, coreutils, ... }:
{name, src, entry, dependencyHash, execName, ... }: let
  depot = stdenv.mkDerivation rec {
    name = "julia_depot";

    buildInputs = [ julia_15 curl ];
    inherit src;
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash =  dependencyHash;

    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

    buildPhase = ''
      mkdir depot
      export JULIA_DEPOT_PATH=depot/

      julia -e "import Pkg; Pkg.activate(\".\"); Pkg.instantiate(); Pkg.precompile()"

      mkdir -p depot/environments/v1.5
      cp Manifest.toml depot/environments/v1.5/
      cp Project.toml depot/environments/v1.5/

      rm -r depot/registries

    '';

    installPhase = ''
      mkdir -p $out/
      cp -R depot/ $out/depot
    '';

  };

  filesEqual = f1: f2: let
      a = runCommand "compare-mainfests" {} ''
        cmp ${f1} ${f2} > $out || true
      '';
      file = builtins.readFile a;
    in file == "";

in   

  assert (lib.assertMsg (
    filesEqual "${depot}/depot/environments/v1.5/Manifest.toml" "${src}/Manifest.toml") 
    "buildJuila15Package: Manifest has changed, update dependencyHash");

stdenv.mkDerivation rec {
  inherit name src;


  exec = writeShellScript execName ''
    DEPOT=$(${coreutils}/bin/mktemp -d)
    export JULIA_DEPOT_PATH="$DEPOT/depot"
    echo Depot path is $DEPOT
    cp -R ${depot}/* $DEPOT/depot
    chmod -R +w $DEPOT
    exec ${julia_15}/bin/julia --project="${src}" ${src}/${entry} $@
  '';

  buildPhase = ''
    :
  '';

  installPhase = ''
    mkdir -p $out/bin

    cp ${exec} $out/bin/${execName}


  '';

}
