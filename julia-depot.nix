{ lib
, stdenv
, glibc
, curl
, cacert
, breakpointHook
, makeWrapper
, patchelf
, julia_15
}:
{ name ? "julia-depot"
, projectToml
, manifestToml
, outputHash
, extraLibs ? [ ]
, _persistent ? false
, _persistent_home ? "/tmp/julia15-home"
}:
stdenv.mkDerivation rec {
  inherit name outputHash;

  buildInputs = [
    julia_15
    curl
    breakpointHook
    makeWrapper
    patchelf
  ];

  srcs = [ projectToml manifestToml ];
  dontUnpack = true;
  outputHashMode = "recursive";
  outputHashAlgo = "sha256";

  SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  LD_LIBRARY_PATH = lib.makeLibraryPath extraLibs;

  shellHook = ''
    export HOME=${_persistent_home}
    export JULIA_DEPOT_PATH=$HOME/depot
    echo JULIA_DEPOT_PATH $JULIA_DEPOT_PATH

    mkdir -p $JULIA_DEPOT_PATH/environments/v1.5 
    chmod -R ug+w $JULIA_DEPOT_PATH/environments/v1.5

    makeWrapper ${glibc.bin}/bin/ldconfig ${_persistent_home}/bin/ldconfig \
      --add-flags "-C ${_persistent_home}/ld.so.cache"
    export PATH="${_persistent_home}/bin:$PATH";
    ldconfig -f /dev/null

    cd $HOME
  '';

  preBuildPhases = if _persistent then [ "shellHook" ] else [ ];

  buildPhase = ''
    echo LD_LIBRARY_PATH $LD_LIBRARY_PATH

    mkdir -p depot/environments/v1.5
    cp ${projectToml} depot/environments/v1.5/Project.toml
    cp ${manifestToml} depot/environments/v1.5/Manifest.toml

    export JULIA_DEPOT_PATH=depot

    julia -e 'import Pkg; Pkg.instantiate(); Pkg.precompile()'
  '';

  installPhase = ''
    mkdir -p $out/depot
    cp -R depot/compiled depot/packages $out/depot/
  '';
}
