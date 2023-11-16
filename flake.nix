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
      venvDir = "./.venv";

      overlays = [
        (self: super: {
          python37 = nixpkgs-python.packages.${system}."3.7";
          python38 = nixpkgs-python.packages.${system}."3.8";
          python39 = nixpkgs-python.packages.${system}."3.9";
          python311 = nixpkgs-python.packages.${system}."3.11";
        })
      ];

      pkgs = import nixpkgs { inherit overlays system; };
    in
    {
      devShells = {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            virtualenv
            libmysqlclient
          ];
        };

        python37 = pkgs.mkShell {
          buildInputs = with pkgs; [
            virtualenv
            libmysqlclient
            python37
          ];
          shellHook = ''
              # Create the venv
              test -e "$PWD/${venvDir}" || virtualenv --python ${pkgs.python37}/bin/python "$PWD/${venvDir}"
              source "$PWD/${venvDir}/bin/activate"
          '';
        };
        
        python38 = pkgs.mkShell {
          buildInputs = with pkgs; [
            virtualenv
            libmysqlclient
            python38
          ];
          shellHook = ''
              # Create the venv
              test -e "$PWD/${venvDir}" || virtualenv --python ${pkgs.python38}/bin/python "$PWD/${venvDir}"
              source "$PWD/${venvDir}/bin/activate"
          '';
        };

        python39 = pkgs.mkShell {
          buildInputs = with pkgs; [
            virtualenv
            libmysqlclient
            python39
          ];
          shellHook = ''
              # Create the venv
              test -e "$PWD/${venvDir}" || virtualenv --python ${pkgs.python39}/bin/python "$PWD/${venvDir}"
              source "$PWD/${venvDir}/bin/activate"
          '';
        };

        python311 = pkgs.mkShell {
          buildInputs = with pkgs; [
            virtualenv
            libmysqlclient
            python311
          ];
          shellHook = ''
              # Create the venv
              test -e "$PWD/${venvDir}" || virtualenv --python ${pkgs.python311}/bin/python "$PWD/${venvDir}"
              source "$PWD/${venvDir}/bin/activate"
          '';
        };

        rust = pkgs.mkShell {
          buildInputs = with pkgs; [
            cargo
            rustc
            gdb
            openssl
          ];
        };

        go = pkgs.mkShell {
          buildInputs = with pkgs; [
            go
            gotools # Go tools like goimports, godoc, and others
            delve   # Go debugger
            cobra-cli   # Go CLI tool generator
            golangci-lint
            pre-commit
            goreleaser
          ];
        };
      };
    });
}
