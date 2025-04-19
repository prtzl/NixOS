{ lib, configName, pkgs, ... }:

let
  # Load base configs, we'll add device specific configs to these
  baseconfig = (builtins.fromJSON (builtins.readFile ./dotfiles/waybar/config));
  basestyle = builtins.readFile ./dotfiles/waybar/style.css;

  # DISKS
  disks = {
    nixbox = [ "/" "/storage" ];
    nixtop = [ "/" ];
  };

  makeDisks = path: index: {
    "disk#${builtins.toString index}" = {
      interval = 5;
      format = "${builtins.toString index}⛃ {percentage_used}%";
      path = "${path}";
    };
  };

  selectedDisks = disks.${configName};

  makeDiskConfigNames = configs:
    lib.lists.imap1 (index: name: "disk#${builtins.toString index}") configs;
  diskConfigNames = makeDiskConfigNames selectedDisks;

  makeDiskConfigs = configs:
    lib.lists.imap1 (index: name: makeDisks name index) configs;
  diskConfigs =
    lib.foldl' (acc: x: acc // x) { } (makeDiskConfigs selectedDisks);

  diskStyle = builtins.concatStringsSep ''
    ,
  '' diskConfigNames + ''
    {
      color: #b58900;
      background: #1a1a1a;
      padding: 0 0.5rem;
      margin: 0 0.2rem;
    }
  '';

  ## INTERFACES
  interfaces = {
    nixbox = [ "enp9s0" ];
    nixtop = [ "enp0s31f6" "wlp61s0" ];
  };

  makeInterface = name: index: {
    "network#${builtins.toString index}" = {
      interface = "${name}";
      format = "{ifname}";
      format-wifi = "{essid} ({signalStrength}%) ";
      format-ethernet = "{ifname} ";
      format-disconnected = "";
      tooltip-format = "{ifname}";
      tooltip-format-wifi = "{essid} ({signalStrength}%) ";
      tooltip-format-ethernet = "{ifname} ";
      tooltip-format-disconnected = "Disconnected";
      max-length = 50;
      on-click = "nm-connection-editor";
    };
  };

  # selectedInterfaces = interfaces.nixtop; # for testing
  selectedInterfaces = interfaces.${configName};

  # Create list of network interfaces
  makeNetworkConfigNames = configs:
    lib.lists.imap1 (index: name: "network#${builtins.toString index}") configs;
  networkConfigNames = makeNetworkConfigNames selectedInterfaces;

  # Create css block for styling network interfaces
  networkStyle = builtins.concatStringsSep ''
    ,
  '' networkConfigNames + ''
    {
      background: #1a1a1a;
      padding: 0 0.5rem;
      margin: 0 0.2rem;
    }
  '';

  # Create attrset of network config option blocks
  makeNetworkConfigs = configs:
    lib.lists.imap1 (index: name: makeInterface name index) configs;
  networkConfigs =
    lib.foldl' (acc: x: acc // x) { } (makeNetworkConfigs selectedInterfaces);

  ## Output configs

  # Append network interfaces before last element (audio)
  modules-right = let
    original = baseconfig.modules-right;
    beforeLast = lib.lists.take (lib.lists.length original - 1) original;
    last = lib.lists.last original;
  in beforeLast ++ diskConfigNames ++ networkConfigNames ++ [ last ];

  # Write new config and style
  config = baseconfig // {
    modules-right = modules-right;
  } // networkConfigs // diskConfigs;
  style = basestyle + networkStyle + diskStyle;

in {
  programs.waybar = {
    enable = true;
    package = pkgs.unstable.waybar;
    systemd.enable = true;
    settings = [ config ];
    style = style;
  };
}
