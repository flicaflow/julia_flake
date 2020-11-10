# Julia Flake

This flake provides the julia programming environment and a builder for packaging julia programs.

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
