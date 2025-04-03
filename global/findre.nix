# Include this pacakge with homes and systems.
# If it's system, install it and don't include it in home.
# If it's a non-nixos home build, include it.

{ pkgs, lib, systemArgs, homeArgs, ... }:

let
  findre = pkgs.writeShellApplication {
    name = "findre";
    runtimeInputs = with pkgs; [ fd ripgrep ];
    text = builtins.readFile ./findre.sh;
  };
in lib.mkMerge [
  (if (systemArgs ? isSystem && systemArgs.isSystem) then ({
    environment.systemPackages = [ findre ];
  }) else
    { })
  (if (homeArgs ? notNixos && homeArgs.notNixos) then ({
    home.packages = [ findre ];
  }) else
    { })
]
