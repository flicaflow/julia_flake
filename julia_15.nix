{stdenv, patchelf, ...}:
stdenv.mkDerivation rec {
  pname = "julia";
  version = "1.5.3";

  buildInputs = [ patchelf ];

  src = fetchTarball {
    url = "https://julialang-s3.julialang.org/bin/linux/x64/1.5/julia-${version}-linux-x86_64.tar.gz";
    sha256 = "1yc60dl39sa0rbiaj2v7vf79j0c9zd93h1mwcahq99w44c81k3q6";
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
}
