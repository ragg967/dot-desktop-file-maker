{
  description = "Project development environment/Project name";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          gum
          shellcheck
          bash-language-server
          shfmt
        ];

        shellHook = ''
          export PROJECT_ROOT=$(pwd)
          echo "Development environment loaded!"
        '';
      };
    };
}
