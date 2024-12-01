{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    devenv.url = "github:cachix/devenv";
  };

  outputs =
    inputs@{ flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.devenv.flakeModule ];
      systems = nixpkgs.lib.systems.flakeExposed;

      perSystem =
        { lib, pkgs, ... }:
        {
          # Per-system attributes can be defined here. The self' and inputs'
          # module parameters provide easy access to attributes of the same
          # system.
          devenv.shells.default = {
            # https://devenv.sh/reference/options/
            dotenv.disableHint = true;

            languages.python.enable = true;
            languages.python.package = pkgs.python311;
            packages = with pkgs.python311Packages; [
              h5py
              ipython
              jupyter
              keras
              matplotlib
              nbformat
              numpy
              opencv4
              # (opencv4.override 
              #   { enableGtk3 = true; }
              # )
              pandas
              pillow
              pip
              seaborn
              scipy
              scikit-learn
              (tensorflow.override {
                # sse42Support = true;
                # avx2Support = true;
                # fmaSupport = true;
              })
              torch
              torchvision
            ];

          };
        };
    };
}
