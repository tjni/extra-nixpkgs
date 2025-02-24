# SPDX-FileCopyrightText: 2025 Theodore Ni <dev@ted.bio>
# SPDX-License-Identifier: MIT

#
# Modeled after https://github.com/eadwu/flakes/blob/rolling/pkgs/vscode-insiders/default.nix
#
{
  lib,
  stdenv,
  fetchurl,
  vscode,
}:
let
  vscode-unwrapped = vscode.unwrapped or vscode;
  vscode-insiders-base = vscode-unwrapped.override {
    isInsiders = true;
  };
  sources = lib.importJSON ./sources.json;
  ext = if stdenv.hostPlatform.isDarwin then "zip" else "tar.gz";
in
vscode-insiders-base.overrideAttrs (_: {
  pname = "vscode-insiders";

  src = fetchurl {
    # supplying the extension tells fetchurl how to unpack the archive
    name = "vscode-insiders.${ext}";
    inherit (sources.${stdenv.hostPlatform.system}) hash url;
  };
})
