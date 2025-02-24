{ pkgs, ... }:

{
  packages = [ pkgs.nushell ];

  scripts.update.exec = ''
    nu update.nu
  '';
}
