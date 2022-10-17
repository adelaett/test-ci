{
  inputs = {
    flake-utils.url = github:numtide/flake-utils;
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
  };

  outputs = {nixpkgs, flake-utils, ...}:
    let
      systems = [ "x86_64-linux" ];
    in flake-utils.lib.eachSystem systems (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
        rec {
          packages = {
            python3.pkgs.jupyterlab = pkgs.python3.pkgs.jupyterlab;
            default = packages.python3.pkgs.jupyterlab;
          };
          devShell = pkgs.mkShell {
            inputsFrom = [packages.default];
            buildInputs = [
              pkgs.inotify-tools
            ];
          };
          hydraJobs = {
            main_package=packages.default;
            dev_shell=devShell;
          };
        }
    );
}
