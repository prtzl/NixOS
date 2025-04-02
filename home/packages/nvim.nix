{ pkgs, ... }:

let mynvim = pkgs.nvimnix.packages.${pkgs.system}.default;
in {
  # My fancy pantsy portable nvimnix does not bring it's own programs, so keep this here for now
  # home.packages = [ mynvim ];
  programs.nvimnix.enable = true;
}
