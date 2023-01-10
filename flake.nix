{
  description = "Embedded Controller command-line tool for the Framework laptop";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    framework-ectool = {
      url = "github:DHowett/framework-ec";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, framework-ectool }:
    {
      overlays.default =
        (
          final: prev: {
            framework-ectool = prev.callPackage ./default.nix {
              pkgs = prev;
              inherit framework-ectool;
            };
          }
        );
    } // (
      flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
          };
        in
        {
          packages = rec {
            framework-ectool = pkgs.framework-ectool;
            default = framework-ectool;
          };
        })
    );
}
