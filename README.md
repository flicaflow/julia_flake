# Julia Flake

This flake provides the julia programming environment and a builder for packaging julia programs.

## Using julia

Make sure nix is installed with [flake](https://nixos.wiki/wiki/Flakes) support. You can drop into a nix shell with julia installed just with
```
nix shell github:flicaflow/julia_flake#julia
```



## Building Julia Packages

Following snipped builds a julia program:

```
buildJulia15Package rec { 
  name = "hello-${version}";
  version = "0.1.0";
  dependencyHash =  "sha256-SPSrDNcB0H9fY+T1xEG1NYIrJIV1SU3dr2hQ5aPJcV0=";
  entry = "main.jl";
  src = ./.;
  execName = "hello1";
}
```

Prerequisite for this is that Manifest.toml and Project.toml are present in the root of src.
Leave the dependencyHash attribute empty initially and paste in the correct hash after the build fails.
A demo application using can be found [here](https://github.com/flicaflow/julia_flake_demo/).
