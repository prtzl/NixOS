{ stdenv
, pkgs
, nvd
}:

let
  #script = pkgs.writeShellScriptBin { name = "dummy"; text = builtins.readFile ./nixos-update.sh; };
  script = pkgs.writeShellScriptBin "echo hello, lemon";
in
stdenv.mkDerivation {
  name = "nixos-update";
  buildInputs = [ script ];
}
