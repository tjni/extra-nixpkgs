# SPDX-FileCopyrightText: 2025 Theodore Ni <dev@ted.bio>
# SPDX-License-Identifier: MIT
{
  description = "vscode-insiders";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      allSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems =
        f:
        nixpkgs.lib.genAttrs allSystems (
          system:
          f {
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
          }
        );
    in
    {
      packages = forAllSystems (
        { pkgs }:
        {
          default = pkgs.callPackage ./package.nix { };
        }
      );
    };
}
