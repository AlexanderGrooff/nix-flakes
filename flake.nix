{
  description = "Alex Python env";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs";

    # Access older Python versions
    nixpkgs-python.url = "github:cachix/nixpkgs-python";
  };

  outputs =
    { self
    , flake-utils
    , nixpkgs
    , nixpkgs-python
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      # Define constants
      pyVersion = "3.7";
      venvDir = "./.venv";

      overlays = [
        (self: super: {
          python = nixpkgs-python.packages.${system}.${pyVersion};
        })
      ];

      pkgs = import nixpkgs { inherit overlays system; };
    in
    {
      devShells.default = pkgs.mkShell {
        inherit venvDir;
        # Define system packages to be present
        buildInputs = with pkgs; [
            python
            virtualenv
            libmysqlclient
        ];

        # This is to expose the venv in PYTHONPATH
        shellHook = ''
            # Create the venv
            test -e "$PWD/${venvDir}" || virtualenv --python ${pkgs.python}/bin/python "$PWD/${venvDir}"
            source "$PWD/${venvDir}/bin/activate"
        '';
      };
    });
}
